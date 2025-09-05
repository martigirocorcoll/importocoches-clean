class Llamada < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  # Bot detection methods
  def bot_user_agent?
    return false if user_agent.blank?
    
    bot_patterns = [
      /bot/i, /crawler/i, /spider/i, /scraper/i,
      /google/i, /bing/i, /yahoo/i, /facebook/i,
      /curl/i, /wget/i, /python/i, /java/i,
      /http/i, /fetch/i, /node/i, /ruby/i
    ]
    
    bot_patterns.any? { |pattern| user_agent.match?(pattern) }
  end

  def suspicious_frequency?
    # Check if same IP made more than 10 requests in last hour
    return false if ip_address.blank?
    
    recent_requests = Llamada.where(
      ip_address: ip_address,
      created_at: 1.hour.ago..Time.current
    ).count
    
    recent_requests > 10
  end

  def likely_bot?
    bot_user_agent? || 
    user_agent.blank? || 
    suspicious_frequency? ||
    (referer.blank? && request_method == 'POST')
  end

  # Class methods for analysis
  def self.bot_requests_today
    where(created_at: Date.current.all_day)
      .select(&:likely_bot?)
  end

  def self.top_ips_today
    where(created_at: Date.current.all_day)
      .group(:ip_address)
      .count
      .sort_by { |_, count| -count }
      .first(10)
  end

  def self.suspicious_ips
    where(created_at: Date.current.all_day)
      .group(:ip_address)
      .having('COUNT(*) > 20')
      .count
  end
end
