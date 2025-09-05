namespace :redis do
  desc "Show Redis memory usage and stats"
  task stats: :environment do
    if Rails.cache.class.name.include?('Redis')
      puts "📊 Redis Cache Statistics:"
      
      begin
        redis = Rails.cache.redis
        info = redis.info
        
        puts "   - Memory used: #{(info['used_memory'].to_f / 1024 / 1024).round(2)}MB"
        puts "   - Memory peak: #{(info['used_memory_peak'].to_f / 1024 / 1024).round(2)}MB"
        puts "   - Connected clients: #{info['connected_clients']}"
        puts "   - Total keys: #{redis.dbsize}"
        puts "   - Uptime: #{(info['uptime_in_seconds'].to_i / 3600).round(1)} hours"
        
        # Show cache-specific stats
        cache_keys = redis.keys("importocotxe_cache:*")
        puts "   - SEO cache keys: #{cache_keys.count}"
        
        if cache_keys.any?
          puts "\n🗂️ Cached models:"
          cache_keys.each do |key|
            ttl = redis.ttl(key)
            expires_in = ttl > 0 ? "#{(ttl / 86400).round(1)} days" : "no expiry"
            puts "   - #{key.gsub('importocotxe_cache:', '')} (expires in #{expires_in})"
          end
        end
        
      rescue => e
        puts "❌ Error connecting to Redis: #{e.message}"
      end
    else
      puts "⚠️ Redis cache not configured. Current cache: #{Rails.cache.class.name}"
    end
  end
  
  desc "Clear all Redis cache"
  task clear: :environment do
    if Rails.cache.class.name.include?('Redis')
      Rails.cache.clear
      puts "✅ Redis cache cleared"
    else  
      puts "⚠️ Redis cache not configured"
    end
  end
end