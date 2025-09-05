class BrandConfiguration
  def self.brands_data
    @brands_data ||= YAML.load_file(Rails.root.join('config', 'brands.yml')).deep_symbolize_keys
  end

  def self.all_brands
    brands_data.values
  end

  def self.get_brand(brand_key)
    brands_data[brand_key.downcase.to_sym]
  end

  def self.get_brand_by_slug(brand_slug)
    brands_data.values.find { |brand| brand[:slug] == brand_slug }
  end

  def self.get_model_by_slug(brand_slug, model_slug)
    brand = get_brand_by_slug(brand_slug)
    return nil unless brand
    
    brand[:models].values.find { |model| model[:slug] == model_slug }
  end

  def self.valid_brand_slug?(brand_slug)
    brands_data.values.any? { |brand| brand[:slug] == brand_slug }
  end

  def self.valid_model_slug?(brand_slug, model_slug)
    brand = get_brand_by_slug(brand_slug)
    return false unless brand
    
    brand[:models].values.any? { |model| model[:slug] == model_slug }
  end

  def self.all_brand_slugs
    brands_data.values.map { |brand| brand[:slug] }
  end

  def self.all_model_slugs_for_brand(brand_slug)
    brand = get_brand_by_slug(brand_slug)
    return [] unless brand
    
    brand[:models].values.map { |model| model[:slug] }
  end

  def self.brand_models(brand_slug)
    brand = get_brand_by_slug(brand_slug)
    return [] unless brand
    
    brand[:models]
  end

  def self.reload!
    @brands_data = nil
    brands_data
  end
end