namespace :seo_cache do
  desc "Refresh all SEO caches"
  task refresh_all: :environment do
    puts "🚀 Starting SEO cache refresh..."
    
    results = SeoCacheService.refresh_all_caches
    
    successful = results.count { |r| r[:success] }
    failed = results.count { |r| !r[:success] }
    total_ads = results.sum { |r| r[:ads_count] || 0 }
    
    puts "✅ Cache refresh completed:"
    puts "   - Successful: #{successful}"
    puts "   - Failed: #{failed}"
    puts "   - Total ads cached: #{total_ads}"
    
    if failed > 0
      puts "❌ Failed refreshes:"
      results.select { |r| !r[:success] }.each do |result|
        puts "   - #{result[:brand]} #{result[:model]}: #{result[:error]}"
      end
    end
  end
  
  desc "Clear all SEO caches"
  task clear: :environment do
    puts "🗑️ Clearing all SEO caches..."
    SeoCacheService.clear_cache
    puts "✅ All caches cleared"
  end
  
  desc "Show cache status"
  task status: :environment do
    puts "📊 SEO Cache Status:"
    summary = SeoCacheService.cache_summary
    
    puts "   - Total models: #{summary[:total_models]}"
    puts "   - Cached models: #{summary[:cached_models]}"
    puts "   - Cache coverage: #{summary[:cache_coverage]}%"
    puts "   - Total ads: #{summary[:total_ads]}"
    puts "   - Cache expiry: #{summary[:cache_expiry]}"
  end
  
  desc "Refresh cache for specific brand"
  task :refresh_brand, [:brand_slug] => :environment do |t, args|
    brand_slug = args[:brand_slug]
    
    unless brand_slug
      puts "❌ Usage: rake seo_cache:refresh_brand[bmw-andorra]"
      exit 1
    end
    
    puts "🚀 Refreshing cache for #{brand_slug}..."
    results = SeoCacheService.refresh_cache_for_brand(brand_slug)
    
    if results.empty?
      puts "❌ Brand not found: #{brand_slug}"
    else
      successful = results.count { |r| r[:success] }
      total_ads = results.sum { |r| r[:ads_count] || 0 }
      puts "✅ Refreshed #{successful} models with #{total_ads} total ads"
    end
  end
end