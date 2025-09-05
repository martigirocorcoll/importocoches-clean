class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout :choose_layout
  before_action :set_fuels, only: [:home]
  before_action :models_collection, only: [:home]
  before_action :set_api_counter
  before_action :set_contact
  before_action :set_bmw, only: [:i8, :serie1, :serie3, :serie4, :serie5, :x1, :x5, :x6, :xm]
  before_action :set_mercedes, only: [:a, :cla, :gla, :g, :glb, :glc, :amggt, :s, :v]
  before_action :set_audi, only: [:a1, :a3, :a4, :q2, :q3, :q5, :q8, :rs6, :r8]
  before_action :set_porsche, only: [:macan, :cayenne, :panamera, :cayman, :boxster, :carrera, :taycan]
  before_action :set_vw, only: [:polo, :golf, :tiguan, :touareg, :california, :tcross, :troc]
  before_action :set_mini, only: [:cooper, :clubman, :countryman]
  before_action :set_cupra, only: [:ateca, :formentor, :leon, :born]
  before_action :set_tesla, only: [:models, :model3, :modely, :modelx]
  before_action :set_lambo, only: [:aventador, :countach, :huracan, :urus]


  def sitemap
    # redirect_to "https://s3-eu-west-1.amazonaws.com/importocotxesitemap/sitemap.xml.gz"
    redirect_to 'https://importocotxesitemap.s3.amazonaws.com/sitemap.xml.gz'

  end

  def home
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @contact = Contact.new
  end

  def meta_campaign
    @contact = Contact.new
    render layout: 'landing'
  end


  def original_home
  end

  def dashboard
    if params[:filters].nil?
      @preu_neto = 0
      @garantia = 0
    else
      @preu_neto = params[:filters][:preu_neto].to_i
      @garantia = params[:filters][:garantia].to_i
    end
    @tasas = 650
    @transporte = 1200
    @igi = @preu_neto * 0.045
    @banco = @preu_neto * 0.004389
    if (0.05 * @preu_neto * 1.19 * 1.045).to_i < 1200
      @beneficio = 1200
    else
      @beneficio = (0.05 * @preu_neto * 1.19 * 1.045).to_i
    end
    @garan = 650 * @garantia

    @preu_and = @preu_neto + @igi + @tasas + @transporte + @banco + @beneficio + @garan
    @params_present = params[:filters].nil?
  end
  
  def dashboard_transport
    # This will render the transport authorization form
  end

  def marca
    render 'pages/marca'
  end

  def show_brand
    brand_slug = params[:brand_slug]
    
    unless BrandConfiguration.valid_brand_slug?(brand_slug)
      raise ActionController::RoutingError, 'Not Found'
    end
    
    @brand_config = BrandConfiguration.get_brand_by_slug(brand_slug)
    @brand_name = @brand_config[:display_name]
    @brand_models = @brand_config[:models]
    @contact = Contact.new
    
    # Set variables for existing templates
    set_brand_variables(@brand_config[:name])
    
    render "pages/#{brand_slug.split('-').first}/index"
  end

  def show_model
    brand_slug = params[:brand_slug]
    model_slug = params[:model_slug]
    
    unless BrandConfiguration.valid_brand_slug?(brand_slug)
      raise ActionController::RoutingError, 'Not Found'
    end
    
    unless BrandConfiguration.valid_model_slug?(brand_slug, model_slug)
      raise ActionController::RoutingError, 'Not Found'
    end
    
    @brand_config = BrandConfiguration.get_brand_by_slug(brand_slug)
    @model_config = BrandConfiguration.get_model_by_slug(brand_slug, model_slug)
    @contact = Contact.new
    
    # Set legacy variables for compatibility
    @marca = @brand_config[:display_name]
    
    # Get cached data or show message that cache is being built
    cached_data = SeoCacheService.get_cached_data(@brand_config[:name], model_slug)
    
    if cached_data
      @model = cached_data[:model]
      @modell = cached_data[:modell] 
      @endpoint = cached_data[:endpoint]
      @ads = cached_data[:ads]
      @cached_at = cached_data[:cached_at]
      @ads_count = cached_data[:ads_count]
    else
      # No cache available - show message and log for cache refresh
      @model = @model_config[:display_name]
      @modell = @model_config[:api_name]
      @ads = []
      @cache_missing = true
      
      Rails.logger.warn "⚠️ Cache missing for #{@brand_config[:name]}/#{model_slug} - needs refresh"
    end
    
    # Log API call for bot detection (but not making actual API call)
    Llamada.create!(
      endpoint: @endpoint || "cached_model_page",
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      referer: request.referer,
      session_id: session.id,
      request_method: request.method,
      user: current_user
    )
    
    # Use unified model template
    render "shared/model_page"
  end

  # /////////////////////////////////////////////cotxes seo pages//////////////////////////////////////
  # bmw
    def bmw
      render 'pages/bmw/index'
    end

    def serie1
      @model = "Serie 1"
      @modell = "1__BMW_ER_SERIES"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      
      # Log API call for bot detection
      Llamada.create!(
        endpoint: @endpoint,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        referer: request.referer,
        session_id: session.id,
        request_method: request.method,
        user: current_user
      )
      
      render 'pages/bmw/serie1'
    end

    def serie3
      @model = "Serie 3"
      @modell = "3__BMW_ER_SERIES"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/serie3'
    end

      def serie4
      @model = "Serie 4"
      @modell = "4__BMW_ER_SERIES"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/serie4'
    end

      def serie5
      @model = "Serie 5"
      @modell = "5__BMW_ER_SERIES"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/serie5'
    end

      def x1
      @model = "x1"
      @modell = "x1"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/x1'
    end

      def x5
      @model = "x5"
      @modell = "x5"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/x5'
    end

      def x6
      @model = "x6"
      @modell = "x6"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/x6'
    end

    def xm
      @model = "xm"
      @modell = "xm"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/xm'
    end

    def i8
      @model = "i8"
      @modell = "i8"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/BMW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/bmw/i8'
    end
  # out bmw

  # mercedes
    def mercedes
      render 'pages/mercedes/index'
    end

    def a
      @model = "A"
      @modell = "A-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/ma'
    end

    def cla
      @model = "CLA"
      @modell = "CLA-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/cla'
    end

      def gla
      @model = "GLA"
      @modell = "GLA-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/gla'
    end

      def g
      @model = "G"
      @modell = "G-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/mg'
    end

      def glb
      @model = "GLB"
      @modell = "GLB-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/glb'
    end

      def glc
      @model = "GLC"
      @modell = "GLC-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/glc'
    end

      def amggt
      @model = "AMG GT"
      @modell = "GT-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/amggt'
    end

    def s
      @model = "S"
      @modell = "S-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/ms'
    end

    def v
      @model = "V"
      @modell = "V-Klasse"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/mercedes-benz/modelgroups/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mercedes/mv'
    end
  # out mercedes

  # audi
    def audi
      render 'pages/audi/index'
    end

    def a1
      @model = "A1"
      @modell = "A1"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/a1'
    end

    def a3
      @model = "A3"
      @modell = "A3"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/a3'
    end

    def a4
      @model = "A4"
      @modell = "A4"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/a4'
    end

    def q2
      @model = "Q2"
      @modell = "Q2"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/q2'
    end

    def q3
      @model = "Q3"
      @modell = "Q3"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/q3'
    end

    def q5
      @model = "Q5"
      @modell = "Q5"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/q5'
    end

    def q8
      @model = "Q8"
      @modell = "Q8"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/q8'
    end

    def rs6
      @model = "RS6"
      @modell = "RS6"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/rs6'
    end

    def r8
      @model = "R8"
      @modell = "R8"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/AUDI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/audi/r8'
    end
  # out audi

  # porsche
    def porsche
      render 'pages/porsche/index'
    end

    def macan
      @model = "MACAN"
      @modell = "MACAN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/macan'
    end

    def cayenne
      @model = "CAYENNE"
      @modell = "CAYENNE"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/cayenne'
    end

    def panamera
      @model = "PANAMERA"
      @modell = "PANAMERA"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/panamera'
    end

    def cayman
      @model = "CAYMAN"
      @modell = "CAYMAN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/cayman'
    end

    def boxster
      @model = "BOXSTER"
      @modell = "BOXSTER"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/boxster'
    end

    def carrera
      @model = "992"
      @modell = "992"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/carrera'
    end

    def taycan
      @model = "TAYCAN"
      @modell = "TAYCAN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/PORSCHE/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/porsche/taycan'
    end
  # out porsche

  # volkswagen
    def volkswagen
      render 'pages/volkswagen/index'
    end

    def polo
      @model = "Polo"
      @modell = "POLO"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/polo'
    end

    def golf
      @model = "Golf"
      @modell = "GOLF"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/golf'
    end

    def california
      @model = "California"
      @modell = "T6 CALIFORNIA"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/california'
    end

    def tcross
      @model = "T-Cross"
      @modell = "T-CROSS"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/tcross'
    end

    def troc
      @model = "T-Roc"
      @modell = "T-ROC"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/troc'
    end

    def tiguan
      @model = "Tiguan"
      @modell = "TIGUAN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/tiguan'
    end

    def touareg
      @model = "TOUAREG"
      @modell = "Touareg"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/VW/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/volkswagen/touareg'
    end
  # out volkswagen

  # mini
    def mini
      render 'pages/mini/index'
    end

    def cooper
      @model = "Cooper"
      @modell = "COOPER"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/MINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mini/cooper'
    end

    def clubman
      @model = "Clubman"
      @modell = "COOPER_CLUBMAN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/MINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mini/clubman'
    end

    def countryman
      @model = "Countryman"
      @modell = "COOPER_COUNTRYMAN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/MINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/mini/countryman'
    end
  # out mini

  # cupra
    def cupra
      render 'pages/cupra/index'
    end

    def ateca
      @model = "Ateca"
      @modell = "ATECA"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/CUPRA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/cupra/ateca'
    end

    def formentor
      @model = "Formentor"
      @modell = "FORMENTOR"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/CUPRA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/cupra/formentor'
    end

    def leon
      @model = "Leon"
      @modell = "LEON"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/CUPRA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/cupra/leon'
    end

    def born
      @model = "Born"
      @modell = "BORN"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/CUPRA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/cupra/born'
    end
  # out cupra

  # tesla
    def tesla
      render 'pages/tesla/index'
    end

    def model3
      @model = "Model 3"
      @modell = "Model 3"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/TESLA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/tesla/model3'
    end

    def models
      @model = "Model S"
      @modell = "Model S"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/TESLA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/tesla/models'
    end

    def modely
      @model = "Model Y"
      @modell = "Model Y"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/TESLA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/tesla/modely'
    end

    def modelx
      @model = "Model X"
      @modell = "Model X"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/TESLA/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/tesla/modelx'
    end
  # out tesla

  # lambo
    def lamborghini
      render 'pages/lamborghini/index'
    end

    def aventador
      @model = "Aventador"
      @modell = "Aventador"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/LAMBORGHINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/lamborghini/aventador'
    end

    def countach
      @model = "Countach"
      @modell = "Countach"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/LAMBORGHINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/lamborghini/countach'
    end

    def huracan
      @model = "Huracan"
      @modell = "Huracan"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/LAMBORGHINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/lamborghini/huracan'
    end

    def urus
      @model = "Urus"
      @modell = "Urus"
      @endpoint = "https://services.mobile.de/search-api/search?vatable=1&&classification=refdata/classes/Car/makes/LAMBORGHINI/models/#{@modell.upcase}&damageUnrepaired=0&firstRegistrationDate.min=2019-01"
      doc = ApiCaller.new(@endpoint).call
      @ads = doc.xpath('//ad:ad')
      render 'pages/lamborghini/urus'
    end
  # out lambo
    # --........//////////////////////////////////cotxes//////////////////////////////////////

  def about
  end

  def privacy_policy
  end

  def cookie_policy
  end

  def aviso_legal
  end

  def autorizaciotransport
    @nom_conductor = params[:filters][:nom_conductor]
    @id_conductor = params[:filters][:id_conductor]
    @placa_camio = params[:filters][:placa_camio]
    @dades_contacte = params[:filters][:dades_contacte]
    @marca_model = params[:filters][:marca_model]
    @bastidor = params[:filters][:bastidor]
    @direccio_recollida = params[:filters][:direccio_recollida]
    @contacte_recollida = params[:filters][:contacte_recollida]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "autoritzacio",
        template: "pages/autorizaciotransport.html.erb",
        encoding: 'utf8',
        header: { font_name: "Arial"}
      end
    end
  end


  def set_api_counter
    if session[:api_counter].nil?
      session[:api_counter] = 0
    end
  end

  def set_fuels
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
  end

  def models_collection
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "BYD",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end

  def set_bmw
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "BMW"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_mercedes
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "MERCEDES-BENZ"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_audi
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "AUDI"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_porsche
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "PORSCHE"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_vw
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "VW"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_mini
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "MINI"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_cupra
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "CUPRA"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_tesla
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "TESLA"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end
  def set_lambo
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = "LAMBORGHINI"
    @contact = Contact.new
    @fuel_list =
      [
        "Gasolina",
        "Diésel",
        "Gas de automoción",
        "Gas natural",
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Hidrógeno",
        "Etanol (FFV,E85, etc.)",
        "Híbrido (diésel/eléctrico",
        "Otro"
      ]
    @makes =
      [
        "Abarth",
        "Aixam",
        "Alfa Romeo",
        "Audi",
        "Aston Martin",
        "Bentley",
        "BMW",
        "Bugatti",
        "Citroen",
        "Cupra",
        "Corvette",
        "Dacia",
        "DS",
        "Ferrari",
        "Fiat",
        "Ford",
        "Genesis",
        "Honda",
        "Hyundai",
        "Isuzu",
        "Iveco",
        "Jaguar",
        "Jeep",
        "Kia",
        "Koenigsegg",
        "KTM",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lync and Co",
        "Lotus",
        "Maserati",
        "Maxus",
        "Maybach",
        "Mazda",
        "McLaren",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nissan",
        "Opel",
        "Pagani",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo"
      ]
  end

  private

  def choose_layout
    case action_name
    when 'dashboard', 'dashboard_transport'
      'dashboard'
    when 'importar_espana'
      'importar_espana'
    else
      'application'
    end
  end

  def set_contact
    @contact = Contact.new
  end

  def set_brand_variables(brand_name)
    @models = JSON.parse(File.read('lib/marca_model.json'))
    @marca = brand_name
    @fuel_list = [
      "Gasolina", "Diésel", "Gas de automoción", "Gas natural", "Eléctrico",
      "Híbrido (gasolina/eléctrico)", "Hidrógeno", "Etanol (FFV,E85, etc.)",
      "Híbrido (diésel/eléctrico", "Otro"
    ]
    @makes = [
      "Abarth", "Aixam", "Alfa Romeo", "Audi", "Aston Martin", "Bentley", "BMW",
      "Bugatti", "Citroen", "Cupra", "Corvette", "Dacia", "DS", "Ferrari", "Fiat",
      "Ford", "Genesis", "Honda", "Hyundai", "Isuzu", "Iveco", "Jaguar", "Jeep",
      "Kia", "Koenigsegg", "KTM", "Lamborghini", "Land Rover", "Lexus", "Lync and Co",
      "Lotus", "Maserati", "Maxus", "Maybach", "Mazda", "McLaren", "Mercedes-Benz",
      "MG", "Mini", "Mitsubishi", "Nissan", "Opel", "Pagani", "Peugeot", "Polestar",
      "Porsche", "Renault", "Rolls Royce", "Seat", "Skoda", "Smart", "Ssangyong",
      "Subaru", "Suzuki", "Tesla", "Toyota", "VW", "Volvo"
    ]
  end

  def get_model_template_name(brand_name, model_slug)
    # Map model slugs to template names for existing views
    case brand_name
    when 'bmw'
      case model_slug
      when 'serie-1' then 'serie1'
      when 'serie-3' then 'serie3'
      when 'serie-4' then 'serie4'
      when 'serie-5' then 'serie5'
      else model_slug
      end
    when 'mercedes'
      case model_slug
      when 'a' then 'ma'
      when 'g' then 'mg'
      when 's' then 'ms'
      when 'v' then 'mv'
      else model_slug
      end
    when 'tesla'
      case model_slug
      when 'model-s' then 'models'
      when 'model-3' then 'model3'
      when 'model-y' then 'modely'
      when 'model-x' then 'modelx'
      else model_slug
      end
    when 'volkswagen'
      case model_slug
      when 't-cross' then 'tcross'
      when 't-roc' then 'troc'
      else model_slug
      end
    else
      model_slug
    end
  end

  def importar_espana
    @contact = Contact.new
  end
end
