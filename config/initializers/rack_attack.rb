# Skip Rack::Attack in development environment
return unless Rails.env.production?

class Rack::Attack
  # Configure Cache (use Rails cache or Redis)
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Block suspicious requests for /cars endpoints immediately
  # This stops the bot patterns we identified
  
  # 1. Rate limit search requests - max 20 per hour per IP
  throttle('cars/search', limit: 20, period: 1.hour) do |req|
    if req.path.start_with?('/cars') && req.post?
      req.ip
    end
  end

  # 2. Rate limit car detail views - max 30 per hour per IP  
  throttle('car/show', limit: 30, period: 1.hour) do |req|
    if req.path == '/car'
      req.ip
    end
  end

  # 3. Rate limit pagination - max 50 per hour per IP
  throttle('car/pages', limit: 50, period: 1.hour) do |req|
    if req.path == '/car-page'
      req.ip
    end
  end

  # 4. Prevent same car spam (like the bot viewing car 419727082 repeatedly)
  throttle('same-car-spam', limit: 5, period: 30.minutes) do |req|
    if req.path == '/car' && req.params['id']
      "#{req.ip}:#{req.params['id']}"
    end
  end

  # 5. Rate limit WhatsApp clicks - max 5 per hour per IP
  throttle('whatsapp/clicks', limit: 5, period: 1.hour) do |req|
    if req.path.start_with?('/whatsapp/')
      req.ip
    end
  end

  # 6. Global rate limit - max 100 requests per hour per IP
  throttle('req/ip', limit: 100, period: 1.hour) do |req|
    req.ip
  end

  # 7. Block IPs that hit rate limits too often
  blocklist('mark-as-banned') do |req|
    # Mark IPs as banned if they've been throttled 3+ times
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 3, findtime: 10.minutes, bantime: 1.hour) do
      # Return true if IP should be banned
      Rails.cache.read("#{req.ip}:throttled") || 0 > 2
    end
  end

  # 8. Whitelist specific admin user (marti@gmail.com)
  safelist('admin-user') do |req|
    # Check if user is signed in and is the admin user
    if req.env['warden']&.user&.email == 'marti@gmail.com'
      true
    end
  end

  # 9. Whitelist other registered users (bypass rate limits)
  safelist('logged-in-users') do |req|
    req.session[:user_signed_in] == true
  end

  # Custom response when throttled - show contact form
  self.throttled_responder = lambda do |env|
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    
    # Load the custom HTML template
    template_path = Rails.root.join('app', 'views', 'shared', 'rate_limit.html.erb')
    html_content = File.read(template_path)
    
    [
      429,
      {
        'Content-Type' => 'text/html; charset=utf-8',
        'Retry-After' => retry_after.to_s
      },
      [html_content]
    ]
  end

  # Log blocked requests
  ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, payload|
    Rails.logger.info "[Rack::Attack] #{payload[:request].env['rack.attack.match_type']} #{payload[:request].ip} #{payload[:request].path}"
  end
end