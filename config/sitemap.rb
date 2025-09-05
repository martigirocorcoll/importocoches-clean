require 'fog-aws'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.importocotxe.ad"
SitemapGenerator::Sitemap.public_path = 'tmp/sitemap'

# Where you want your sitemap.xml.gz file to be uploaded.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
fog_provider: 'AWS',
fog_directory: "importocotxesitemap",
fog_region: "eu-west-3"
)

# The full path to your bucket
SitemapGenerator::Sitemap.sitemaps_host = "https://importocotxesitemap.s3.amazonaws.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
    add marca_path, :priority => 0.9, :changefreq => 'weekly'
    add marca_bmw_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add serie1_path, :priority => 0.7, :changefreq => 'weekly'
    add serie3_path, :priority => 0.7, :changefreq => 'weekly'
    add serie4_path, :priority => 0.7, :changefreq => 'weekly'
    add serie5_path, :priority => 0.7, :changefreq => 'weekly'
    add x1_path, :priority => 0.7, :changefreq => 'weekly'
    add x5_path, :priority => 0.7, :changefreq => 'weekly'
    add x6_path, :priority => 0.7, :changefreq => 'weekly'
    add xm_path, :priority => 0.7, :changefreq => 'weekly'
    add i8_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_mercedes_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add ma_path, :priority => 0.7, :changefreq => 'weekly'
    add cla_path, :priority => 0.7, :changefreq => 'weekly'
    add gla_path, :priority => 0.7, :changefreq => 'weekly'
    add mg_path, :priority => 0.7, :changefreq => 'weekly'
    add glc_path, :priority => 0.7, :changefreq => 'weekly'
    add glb_path, :priority => 0.7, :changefreq => 'weekly'
    add amggt_path, :priority => 0.7, :changefreq => 'weekly'
    add ms_path, :priority => 0.7, :changefreq => 'weekly'
    add mv_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_audi_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add a1_path, :priority => 0.7, :changefreq => 'weekly'
    add a3_path, :priority => 0.7, :changefreq => 'weekly'
    add a4_path, :priority => 0.7, :changefreq => 'weekly'
    add q2_path, :priority => 0.7, :changefreq => 'weekly'
    add q3_path, :priority => 0.7, :changefreq => 'weekly'
    add q5_path, :priority => 0.7, :changefreq => 'weekly'
    add q8_path, :priority => 0.7, :changefreq => 'weekly'
    add rs6_path, :priority => 0.7, :changefreq => 'weekly'
    add r8_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_porsche_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add macan_path, :priority => 0.7, :changefreq => 'weekly'
    add panamera_path, :priority => 0.7, :changefreq => 'weekly'
    add cayenne_path, :priority => 0.7, :changefreq => 'weekly'
    add cayman_path, :priority => 0.7, :changefreq => 'weekly'
    add boxster_path, :priority => 0.7, :changefreq => 'weekly'
    add carrera_path, :priority => 0.7, :changefreq => 'weekly'
    add taycan_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_volkswagen_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add polo_path, :priority => 0.7, :changefreq => 'weekly'
    add golf_path, :priority => 0.7, :changefreq => 'weekly'
    add tcross_path, :priority => 0.7, :changefreq => 'weekly'
    add troc_path, :priority => 0.7, :changefreq => 'weekly'
    add tiguan_path, :priority => 0.7, :changefreq => 'weekly'
    add touareg_path, :priority => 0.7, :changefreq => 'weekly'
    add california_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_cupra_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add ateca_path, :priority => 0.7, :changefreq => 'weekly'
    add born_path, :priority => 0.7, :changefreq => 'weekly'
    add leon_path, :priority => 0.7, :changefreq => 'weekly'
    add formentor_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_mini_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add cooper_path, :priority => 0.7, :changefreq => 'weekly'
    add clubman_path, :priority => 0.7, :changefreq => 'weekly'
    add countryman_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_tesla_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add models_path, :priority => 0.7, :changefreq => 'weekly'
    add model3_path, :priority => 0.7, :changefreq => 'weekly'
    add modely_path, :priority => 0.7, :changefreq => 'weekly'
    add modelx_path, :priority => 0.7, :changefreq => 'weekly'
    add marca_lamborghini_andorra_path, :priority => 0.8, :changefreq => 'weekly'
    add countach_path, :priority => 0.7, :changefreq => 'weekly'
    add aventador_path, :priority => 0.7, :changefreq => 'weekly'
    add huracan_path, :priority => 0.7, :changefreq => 'weekly'
    add urus_path, :priority => 0.7, :changefreq => 'weekly'
  #
    add articles_path, :priority => 0.9, :changefreq => 'daily'
  #
  # Add all articles:
  #
    Article.find_each do |article|
      add article_path(article), :lastmod => article.updated_at, :priority => 0.8
    end
end
