class SeoCacheService
  CACHE_KEY_PREFIX = 'seo_cache'
  CACHE_EXPIRY = 1.month

  def self.get_cached_data(brand_name, model_slug)
    cache_key = build_cache_key(brand_name, model_slug)
    Rails.logger.debug "🔍 Reading cache key: #{cache_key}"
    cached_data = Rails.cache.read(cache_key)
    
    if cached_data
      # Recreate ads from stored data with proper namespace context
      # Create a wrapper document with all the necessary namespaces
      wrapper_xml = <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <search:search-result 
          xmlns:error="http://services.mobile.de/schema/common/error-1.0" 
          xmlns:financing="http://services.mobile.de/schema/common/financing-1.0" 
          xmlns:ad="http://services.mobile.de/schema/ad" 
          xmlns:resource="http://services.mobile.de/schema/resource" 
          xmlns:search="http://services.mobile.de/schema/search" 
          xmlns:seller="http://services.mobile.de/schema/seller" 
          xmlns:leasing="http://services.mobile.de/schema/common/leasing-1.0" 
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          #{cached_data[:ads_data].map { |ad_data| ad_data[:xml] }.join}
        </search:search-result>
      XML
      
      wrapper_doc = Nokogiri::XML(wrapper_xml)
      ads = wrapper_doc.xpath('//ad:ad')
      
      {
        model: cached_data[:model],
        modell: cached_data[:modell],
        endpoint: cached_data[:endpoint],
        ads: ads,
        cached_at: cached_data[:cached_at],
        ads_count: cached_data[:ads_count]
      }
    end
  end

  def self.set_cached_data(brand_name, model_slug, data)
    cache_key = build_cache_key(brand_name, model_slug)
    Rails.logger.debug "💾 Writing cache key: #{cache_key}"
    
    # Convert each ad element to hash for reliable storage/retrieval
    ads_data = data[:ads].map do |ad|
      {
        xml: ad.to_s,
        attributes: ad.attributes.transform_values(&:value)
      }
    end
    
    cached_data = {
      model: data[:model],
      modell: data[:modell],
      endpoint: data[:endpoint],
      ads_data: ads_data,
      cached_at: Time.current,
      ads_count: data[:ads].length
    }
    
    Rails.cache.write(cache_key, cached_data, expires_in: CACHE_EXPIRY)
  end

  def self.refresh_cache_for_model(brand_slug, model_slug)
    brand_config = BrandConfiguration.get_brand_by_slug(brand_slug)
    return false unless brand_config
    
    model_config = BrandConfiguration.get_model_by_slug(brand_slug, model_slug)
    return false unless model_config
    
    begin
      endpoint = build_endpoint(brand_config, model_config)
      
      doc = ApiCaller.new(endpoint).call
      ads = doc.xpath('//ad:ad').first(10)  # Limit to first 10 cars only
      
      data = {
        model: model_config[:display_name],
        modell: model_config[:api_name],
        endpoint: endpoint,
        ads: ads
      }
      
      set_cached_data(brand_config[:name], model_slug, data)
      
      Rails.logger.info "✅ SEO Cache refreshed: #{brand_config[:name]}/#{model_slug} (#{ads.length} ads)"
      
      {
        success: true,
        brand: brand_config[:display_name],
        model: model_config[:display_name],
        ads_count: ads.length
      }
      
    rescue StandardError => e
      Rails.logger.error "❌ SEO Cache failed: #{brand_config[:name]}/#{model_slug} - #{e.message}"
      
      {
        success: false,
        brand: brand_config[:display_name],
        model: model_config[:display_name],
        error: e.message
      }
    end
  end

  def self.refresh_cache_for_brand(brand_slug)
    brand_config = BrandConfiguration.get_brand_by_slug(brand_slug)
    return [] unless brand_config
    
    results = []
    
    brand_config[:models].each do |model_key, model_config|
      result = refresh_cache_for_model(brand_slug, model_config[:slug])
      results << result if result
    end
    
    results
  end

  def self.refresh_all_caches
    results = []
    
    BrandConfiguration.all_brands.each do |brand_config|
      brand_results = refresh_cache_for_brand(brand_config[:slug])
      results.concat(brand_results)
    end
    
    results
  end

  def self.clear_cache(brand_name = nil, model_slug = nil)
    if brand_name && model_slug
      cache_key = build_cache_key(brand_name, model_slug)
      Rails.cache.delete(cache_key)
    elsif brand_name
      pattern = "#{CACHE_KEY_PREFIX}:#{brand_name.upcase}:*"
      clear_cache_pattern(pattern)
    else
      pattern = "#{CACHE_KEY_PREFIX}:*"
      clear_cache_pattern(pattern)
    end
  end

  def self.cache_status
    status = {}
    
    BrandConfiguration.all_brands.each do |brand_config|
      brand_name = brand_config[:name]
      status[brand_name] = {}
      
      brand_config[:models].each do |model_key, model_config|
        cache_key = build_cache_key(brand_name, model_config[:slug])
        cached_data = Rails.cache.read(cache_key)
        
        status[brand_name][model_config[:slug]] = {
          cached: cached_data.present?,
          cached_at: cached_data&.dig(:cached_at),
          ads_count: cached_data&.dig(:ads_count) || 0,
          expires_at: cached_data ? cached_data[:cached_at] + CACHE_EXPIRY : nil
        }
      end
    end
    
    status
  end

  def self.cache_summary
    total_models = 0
    cached_models = 0
    total_ads = 0
    
    BrandConfiguration.all_brands.each do |brand_config|
      brand_config[:models].each do |model_key, model_config|
        total_models += 1
        
        cache_key = build_cache_key(brand_config[:name], model_config[:slug])
        cached_data = Rails.cache.read(cache_key)
        
        if cached_data
          cached_models += 1
          total_ads += cached_data[:ads_count] || 0
        end
      end
    end
    
    {
      total_models: total_models,
      cached_models: cached_models,
      cache_coverage: total_models > 0 ? (cached_models.to_f / total_models * 100).round(1) : 0,
      total_ads: total_ads,
      cache_expiry: CACHE_EXPIRY
    }
  end

  private

  def self.build_cache_key(brand_name, model_slug)
    "#{CACHE_KEY_PREFIX}:#{brand_name.upcase}:#{model_slug.upcase}"
  end

  def self.build_endpoint(brand_config, model_config)
    base_url = "https://services.mobile.de/search-api/search?vatable=1"

    if model_config[:type] == 'modelgroup'
      classification = "classification=refdata/classes/Car/makes/#{brand_config[:api_name]}/modelgroups/#{model_config[:api_name].upcase}"
    else
      classification = "classification=refdata/classes/Car/makes/#{brand_config[:api_name]}/models/#{model_config[:api_name].upcase}"
    end

    # Add hybrid and electric fuel filters
    fuel_filters = "&fuel=ELECTRIC&fuel=HYBRID_PETROL&fuel=HYBRID_DIESEL&fuel=PLUGIN_HYBRID"

    "#{base_url}&#{classification}&damageUnrepaired=0&firstRegistrationDate.min=2019-01#{fuel_filters}"
  end

  def self.clear_cache_pattern(pattern)
    if Rails.cache.respond_to?(:delete_matched)
      Rails.cache.delete_matched(pattern)
    else
      Rails.logger.warn "Cache store doesn't support pattern deletion"
    end
  end
end