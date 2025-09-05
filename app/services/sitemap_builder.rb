require 'builder'

class SitemapBuilder
  SUPPORTED_LOCALES = %w[es fr en cat ru de nl].freeze
  BASE_URL = 'https://importocotxe.ad'
  
  def initialize
    @urls = []
  end

  def generate
    add_static_pages
    add_brand_pages  
    add_imported_cars
    add_articles
    build_xml
  end

  def generate_by_locale(locale)
    @urls = []
    add_static_pages(locale)
    add_brand_pages(locale)
    add_imported_cars(locale)
    add_articles(locale)
    build_xml
  end

  private

  def add_static_pages(locale = nil)
    if locale
      add_localized_static_pages(locale)
    else
      SUPPORTED_LOCALES.each do |loc|
        add_localized_static_pages(loc)
      end
    end
  end

  def add_localized_static_pages(locale)
    static_pages = [
      { path: "/#{locale}", priority: 1.0, changefreq: 'daily' },
      { path: "/#{locale}/marca", priority: 0.9, changefreq: 'weekly' },
      { path: "/#{locale}/about", priority: 0.8, changefreq: 'monthly' },
      { path: "/#{locale}/us", priority: 0.8, changefreq: 'monthly' },
      { path: "/#{locale}/faqs", priority: 0.7, changefreq: 'monthly' },
      { path: "/#{locale}/cars", priority: 0.9, changefreq: 'daily' },
      { path: "/#{locale}/imported_cars", priority: 0.9, changefreq: 'daily' },
    ]

    static_pages.each do |page|
      add_url(page[:path], page[:priority], page[:changefreq])
    end
  end

  def add_brand_pages(locale = nil)
    if locale
      add_localized_brand_pages(locale)
    else
      SUPPORTED_LOCALES.each do |loc|
        add_localized_brand_pages(loc)
      end
    end
  end

  def add_localized_brand_pages(locale)
    # BMW pages
    bmw_models = %w[serie-1 i8 serie-3 serie-4 serie-5 x1 x5 x6 xm]
    add_url("/#{locale}/marca/bmw-andorra", 0.9, 'weekly')
    bmw_models.each do |model|
      add_url("/#{locale}/marca/bmw-andorra/#{model}", 0.8, 'weekly')
    end

    # Mercedes pages
    mercedes_models = %w[a cla gla g glb glc amg-gt s v]
    add_url("/#{locale}/marca/mercedes-andorra", 0.9, 'weekly')
    mercedes_models.each do |model|
      add_url("/#{locale}/marca/mercedes-andorra/#{model}", 0.8, 'weekly')
    end

    # Audi pages
    audi_models = %w[a1 a3 a4 q2 q3 q5 q8 rs6 r8]
    add_url("/#{locale}/marca/audi-andorra", 0.9, 'weekly')
    audi_models.each do |model|
      add_url("/#{locale}/marca/audi-andorra/#{model}", 0.8, 'weekly')
    end

    # Porsche pages
    porsche_models = %w[macan panamera cayenne boxster cayman carrera taycan]
    add_url("/#{locale}/marca/porsche-andorra", 0.9, 'weekly')
    porsche_models.each do |model|
      add_url("/#{locale}/marca/porsche-andorra/#{model}", 0.8, 'weekly')
    end

    # Volkswagen pages
    vw_models = %w[polo golf t-cross tiguan t-roc touareg california]
    add_url("/#{locale}/marca/volkswagen-andorra", 0.9, 'weekly')
    vw_models.each do |model|
      add_url("/#{locale}/marca/volkswagen-andorra/#{model}", 0.8, 'weekly')
    end

    # Mini pages
    mini_models = %w[cooper clubman countryman]
    add_url("/#{locale}/marca/mini-andorra", 0.9, 'weekly')
    mini_models.each do |model|
      add_url("/#{locale}/marca/mini-andorra/#{model}", 0.8, 'weekly')
    end

    # Cupra pages
    cupra_models = %w[ateca formentor leon born]
    add_url("/#{locale}/marca/cupra-andorra", 0.9, 'weekly')
    cupra_models.each do |model|
      add_url("/#{locale}/marca/cupra-andorra/#{model}", 0.8, 'weekly')
    end

    # Tesla pages
    tesla_models = %w[model-s model-3 model-y model-x]
    add_url("/#{locale}/marca/tesla-andorra", 0.9, 'weekly')
    tesla_models.each do |model|
      add_url("/#{locale}/marca/tesla-andorra/#{model}", 0.8, 'weekly')
    end

    # Lamborghini pages
    lambo_models = %w[aventador countach huracan urus]
    add_url("/#{locale}/marca/lamborghini-andorra", 0.9, 'weekly')
    lambo_models.each do |model|
      add_url("/#{locale}/marca/lamborghini-andorra/#{model}", 0.8, 'weekly')
    end
  end

  def add_imported_cars(locale = nil)
    ImportedCar.includes(:rich_text_long_description_es, :rich_text_long_description_en, 
                        :rich_text_long_description_cat, :rich_text_long_description_fr).find_each do |car|
      if locale
        add_imported_car_url(car, locale)
      else
        SUPPORTED_LOCALES.each do |loc|
          add_imported_car_url(car, loc)
        end
      end
    end
  end

  def add_imported_car_url(car, locale)
    return unless car.slug.present?
    
    path = "/#{locale}/imported_cars/#{car.slug}"
    priority = 0.8
    changefreq = 'weekly'
    lastmod = car.updated_at
    
    add_url(path, priority, changefreq, lastmod)
  end

  def add_articles(locale = nil)
    return unless defined?(Article) && Article.table_exists?
    
    if locale
      add_localized_articles(locale)
    else
      SUPPORTED_LOCALES.each do |loc|
        add_localized_articles(loc)
      end
    end
  rescue => e
    Rails.logger.warn "Could not add articles to sitemap: #{e.message}"
  end

  def add_localized_articles(locale)
    default = 'es'
    
    # Add articles index for each locale
    if locale == default
      add_url("/articles", 0.8, 'weekly')
    else
      add_url("/articles?locale=#{locale}", 0.8, 'weekly')
    end
    
    # Add individual articles only once (for default locale, no language versions)
    if locale == default
      Article.find_each do |article|
        add_article_url(article)
      end
    end
  end

  def add_article_url(article)
    path = "/articles/#{article.friendly_id || article.id}"
    priority = 0.7
    changefreq = 'monthly'
    lastmod = article.updated_at
    
    add_url(path, priority, changefreq, lastmod)
  end

  def add_article_url_with_locale(article, locale)
    path = "/articles/#{article.friendly_id || article.id}?locale=#{locale}"
    priority = 0.7
    changefreq = 'monthly'
    lastmod = article.updated_at
    
    add_url(path, priority, changefreq, lastmod)
  end

  def add_url(path, priority = 0.5, changefreq = 'monthly', lastmod = nil)
    @urls << {
      loc: "#{BASE_URL}#{path}",
      priority: priority,
      changefreq: changefreq,
      lastmod: lastmod || Time.current
    }
  end

  def build_xml
    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
    
    xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
      @urls.each do |url_data|
        xml.url do
          xml.loc url_data[:loc]
          xml.lastmod url_data[:lastmod].utc.strftime('%Y-%m-%dT%H:%M:%S+00:00')
          xml.changefreq url_data[:changefreq]
          xml.priority url_data[:priority]
        end
      end
    end
  end
end