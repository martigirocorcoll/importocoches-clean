namespace :sitemap do
  desc "Generate and display sitemap statistics"
  task stats: :environment do
    puts "🗺️  SITEMAP STATISTICS"
    puts "="*50
    
    generator = SitemapBuilder.new
    
    # Count URLs by type
    puts "📊 URL Counts:"
    puts "   Static pages: #{SitemapBuilder::SUPPORTED_LOCALES.count * 6} (6 pages × #{SitemapBuilder::SUPPORTED_LOCALES.count} locales)"
    puts "   Brand pages: #{SitemapBuilder::SUPPORTED_LOCALES.count * 58} (58 brand/model pages × #{SitemapBuilder::SUPPORTED_LOCALES.count} locales)"
    puts "   Imported cars: #{ImportedCar.count * SitemapBuilder::SUPPORTED_LOCALES.count} (#{ImportedCar.count} cars × #{SitemapBuilder::SUPPORTED_LOCALES.count} locales)"
    
    begin
      article_count = defined?(Article) && Article.table_exists? ? Article.count : 0
      puts "   Articles: #{article_count * SitemapBuilder::SUPPORTED_LOCALES.count} (#{article_count} articles × #{SitemapBuilder::SUPPORTED_LOCALES.count} locales)"
    rescue
      puts "   Articles: 0 (table not found)"
    end
    
    total_urls = (6 + 58 + ImportedCar.count) * SitemapBuilder::SUPPORTED_LOCALES.count
    puts "   Total URLs: #{total_urls}"
    
    puts "\n🌍 Supported Locales: #{SitemapBuilder::SUPPORTED_LOCALES.join(', ')}"
    puts "\n📝 Available Sitemaps:"
    puts "   Main index: /sitemap.xml"
    puts "   Combined: /sitemap_main.xml"
    SitemapBuilder::SUPPORTED_LOCALES.each do |locale|
      puts "   #{locale.upcase}: /sitemap_#{locale}.xml"
    end
    
    puts "\n✅ All sitemaps are dynamically generated and cached for 1 week"
  end

  desc "Clear sitemap cache"
  task clear_cache: :environment do
    puts "🧹 Clearing sitemap cache..."
    
    cache_keys = [
      'sitemap_index',
      'sitemap_main'
    ] + SitemapBuilder::SUPPORTED_LOCALES.map { |locale| "sitemap_#{locale}" }
    
    cleared_count = 0
    cache_keys.each do |key|
      if Rails.cache.delete(key)
        puts "   ✓ Cleared: #{key}"
        cleared_count += 1
      else
        puts "   - Not found: #{key}"
      end
    end
    
    puts "\n📊 Summary: #{cleared_count}/#{cache_keys.count} cache entries cleared"
    puts "   Next sitemap request will regenerate fresh content"
  end

  desc "Warm up sitemap cache"
  task warm_cache: :environment do
    puts "🔥 Warming up sitemap cache..."
    
    # Simulate request context for URL generation
    include Rails.application.routes.url_helpers
    
    generator = SitemapBuilder.new
    
    # Generate main sitemap
    print "   Generating main sitemap... "
    Rails.cache.fetch('sitemap_main', expires_in: 1.week) do
      generator.generate
    end
    puts "✓"
    
    # Generate individual locale sitemaps
    SitemapBuilder::SUPPORTED_LOCALES.each do |locale|
      print "   Generating #{locale} sitemap... "
      Rails.cache.fetch("sitemap_#{locale}", expires_in: 1.week) do
        generator.generate_by_locale(locale)
      end
      puts "✓"
    end
    
    puts "\n🎉 All sitemaps cached successfully!"
    puts "   Cache will expire in 1 week"
  end

  desc "Test sitemap generation (no caching)"
  task test: :environment do
    puts "🧪 Testing sitemap generation..."
    
    generator = SitemapBuilder.new
    
    # Test main sitemap
    print "   Testing main sitemap... "
    xml = generator.generate
    url_count = xml.scan(/<url>/).count
    puts "✓ (#{url_count} URLs)"
    
    # Test first locale
    locale = SitemapBuilder::SUPPORTED_LOCALES.first
    print "   Testing #{locale} sitemap... "
    xml = generator.generate_by_locale(locale)
    url_count = xml.scan(/<url>/).count
    puts "✓ (#{url_count} URLs)"
    
    puts "\n✅ All tests passed!"
  end

  desc "Full sitemap maintenance (clear cache + warm up)"
  task refresh: [:clear_cache, :warm_cache] do
    puts "\n🎯 Sitemap refresh completed!"
  end
end