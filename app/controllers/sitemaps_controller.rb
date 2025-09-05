class SitemapsController < ApplicationController
  before_action :set_cache_headers
  skip_before_action :authenticate_user!, raise: false

  def index
    @sitemap_xml = Rails.cache.fetch('sitemap_index', expires_in: 1.week) do
      build_sitemap_index
    end

    respond_to do |format|
      format.xml { render xml: @sitemap_xml }
    end
  end

  def show
    locale = params[:locale]
    
    # Validate locale
    unless SitemapBuilder::SUPPORTED_LOCALES.include?(locale)
      head :not_found
      return
    end

    cache_key = "sitemap_#{locale}"
    @sitemap_xml = Rails.cache.fetch(cache_key, expires_in: 1.week) do
      generator = SitemapBuilder.new
      generator.generate_by_locale(locale)
    end

    respond_to do |format|
      format.xml { render xml: @sitemap_xml }
    end
  end

  def main
    cache_key = 'sitemap_main'
    @sitemap_xml = Rails.cache.fetch(cache_key, expires_in: 1.week) do
      generator = SitemapBuilder.new
      generator.generate
    end

    respond_to do |format|
      format.xml { render xml: @sitemap_xml }
    end
  end

  private

  def set_cache_headers
    expires_in 1.week, public: true
    response.headers['Content-Type'] = 'application/xml; charset=utf-8'
  end

  def build_sitemap_index
    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
    
    xml.sitemapindex(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
      # Main sitemap (all languages combined)
      xml.sitemap do
        xml.loc "#{request.protocol}#{request.host_with_port}/sitemap_main.xml"
        xml.lastmod Time.current.utc.strftime('%Y-%m-%dT%H:%M:%S+00:00')
      end

      # Individual language sitemaps
      SitemapBuilder::SUPPORTED_LOCALES.each do |locale|
        xml.sitemap do
          xml.loc "#{request.protocol}#{request.host_with_port}/sitemap_#{locale}.xml"
          xml.lastmod Time.current.utc.strftime('%Y-%m-%dT%H:%M:%S+00:00')
        end
      end
    end
  end
end