
Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :show]
  end
  resources :encargos
  get '/encargostotal', to: 'encargos#indextotal'
  resources :llamadas
  resources :articles
  resources :contacts, only: [:new, :create]
  devise_for :user
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  # Telephone completion routes
  get '/complete-telephone', to: 'telephone#show', as: 'complete_telephone'
  patch '/complete-telephone', to: 'telephone#update', as: 'telephone'
  
  # API limit reached routes
  get '/api-limit-reached', to: 'api_limit#show', as: 'api_limit_reached'
  post '/api-limit-contact', to: 'api_limit#contact_submitted', as: 'api_limit_contact'
  
  # WhatsApp attribution tracking
  get '/whatsapp/:source', to: 'whatsapp#redirect', as: 'whatsapp_redirect'
  
  # Dashboard routes
  get '/dashboard/transport', to: 'pages#dashboard_transport', as: 'dashboard_transport'
  get '/dashboard/attribution', to: 'attribution_search#show', as: 'dashboard_attribution'
  get '/dashboard/users', to: 'dashboard#users', as: 'dashboard_users'
  get '/dashboard/contacts', to: 'dashboard#contacts', as: 'dashboard_contacts'
  get '/dashboard/api-activity', to: 'dashboard#api_activity', as: 'dashboard_api_activity'
  get '/dashboard/llamadas', to: 'dashboard#llamadas', as: 'dashboard_llamadas'
  get '/dashboard/seo-cache', to: 'dashboard#seo_cache', as: 'dashboard_seo_cache'
  post '/dashboard/seo-cache/refresh', to: 'dashboard#refresh_seo_cache', as: 'refresh_dashboard_seo_cache'
  delete '/dashboard/seo-cache/clear', to: 'dashboard#clear_seo_cache', as: 'clear_dashboard_seo_cache'
  
  get '/privacy_policy', to: 'pages#privacy_policy'
  get '/cookie_policy', to: 'pages#cookie_policy'
  get '/aviso_legal', to: 'pages#aviso_legal'
  scope '(:locale)', locale: /es|fr|en|cat|ru|de|nl/ do
    # Contracts routes
    resources :contracts, only: [:new]
    get '/contract_pdf', to: 'contracts#generate_pdf'
    get '/contract_pdf_en', to: 'contracts#generate_pdf_en'
    root to: 'pages#home'
    get '/meta-campaign', to: 'pages#meta_campaign'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :imported_cars, param: :slug
    resources :cars, only: :index
    get '/car', to: 'cars#show'
    get '/carficha', to: 'cars#showficha'
    get '/car-page', to: 'cars#pages'
    get '/dashboard', to: 'pages#dashboard'
    get '/autoritzacio', to: 'pages#autorizaciotransport'
    get '/about', to: 'pages#funcionament'
    get '/us', to: 'pages#nosaltres'
    get '/marca', to: 'pages#marca'
    get '/faqs', to: 'pages#faqs'
    # Dynamic brand and model routes
    get '/marca/:brand_slug', to: 'pages#show_brand', as: "brand"
    get '/marca/:brand_slug/:model_slug', to: 'pages#show_model', as: "brand_model"
    
    # Keep existing route aliases for backward compatibility
    get '/marca/bmw-espana', to: 'pages#show_brand', brand_slug: 'bmw-espana', as: "marca_bmw_andorra"
    get '/marca/mercedes-espana', to: 'pages#show_brand', brand_slug: 'mercedes-espana', as: "marca_mercedes_andorra"
    get '/marca/audi-espana', to: 'pages#show_brand', brand_slug: 'audi-espana', as: "marca_audi_andorra"
    get '/marca/porsche-espana', to: 'pages#show_brand', brand_slug: 'porsche-espana', as: "marca_porsche_andorra"
    get '/marca/volkswagen-espana', to: 'pages#show_brand', brand_slug: 'volkswagen-espana', as: "marca_volkswagen_andorra"
    get '/marca/mini-espana', to: 'pages#show_brand', brand_slug: 'mini-espana', as: "marca_mini_andorra"
    get '/marca/cupra-espana', to: 'pages#show_brand', brand_slug: 'cupra-espana', as: "marca_cupra_andorra"
    get '/marca/tesla-espana', to: 'pages#show_brand', brand_slug: 'tesla-espana', as: "marca_tesla_andorra"
    get '/marca/byd-espana', to: 'pages#show_brand', brand_slug: 'byd-espana', as: "marca_byd_andorra"
    
    # BMW Models
    get '/marca/bmw-espana/serie-3', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-3', as: "serie3"
    get '/marca/bmw-espana/serie-5', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-5', as: "serie5"
    get '/marca/bmw-espana/serie-7', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-7', as: "serie7"
    get '/marca/bmw-espana/x1', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'x1', as: "x1"
    get '/marca/bmw-espana/x5', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'x5', as: "x5"
    get '/marca/bmw-espana/x6', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'x6', as: "x6"
    get '/marca/bmw-espana/i4', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'i4', as: "i4"
    get '/marca/bmw-espana/i8', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'i8', as: "i8"
    # Mercedes Models
    get '/marca/mercedes-espana/a', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'a', as: "ma"
    get '/marca/mercedes-espana/cla', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'cla', as: "cla"
    get '/marca/mercedes-espana/gla', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'gla', as: "gla"
    get '/marca/mercedes-espana/glc', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'glc', as: "glc"
    get '/marca/mercedes-espana/gle', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'gle', as: "gle"
    get '/marca/mercedes-espana/s', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 's', as: "ms"
    get '/marca/mercedes-espana/eqv', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'eqv', as: "eqv"

    # Audi Models
    get '/marca/audi-espana/a3', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'a3', as: "a3"
    get '/marca/audi-espana/a4', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'a4', as: "a4"
    get '/marca/audi-espana/q3', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q3', as: "q3"
    get '/marca/audi-espana/q4', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q4', as: "q4"
    get '/marca/audi-espana/q5', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q5', as: "q5"
    get '/marca/audi-espana/q6', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q6', as: "q6"
    get '/marca/audi-espana/q8', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q8', as: "q8"
    # Porsche Models
    get '/marca/porsche-espana/macan', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'macan', as: "macan"
    get '/marca/porsche-espana/cayenne', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'cayenne', as: "cayenne"
    get '/marca/porsche-espana/panamera', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'panamera', as: "panamera"
    get '/marca/porsche-espana/taycan', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'taycan', as: "taycan"

    # VW Models
    get '/marca/volkswagen-espana/polo', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'polo', as: "polo"
    get '/marca/volkswagen-espana/golf', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'golf', as: "golf"
    get '/marca/volkswagen-espana/tiguan', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'tiguan', as: "tiguan"
    get '/marca/volkswagen-espana/t7-california', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 't7-california', as: "t7california"
    get '/marca/volkswagen-espana/id3', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'id3', as: "id3"
    get '/marca/volkswagen-espana/touareg', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'touareg', as: "touareg"

    # Mini Models
    get '/marca/mini-espana/cooper', to: 'pages#show_model', brand_slug: 'mini-espana', model_slug: 'cooper', as: "cooper"
    get '/marca/mini-espana/aceman', to: 'pages#show_model', brand_slug: 'mini-espana', model_slug: 'aceman', as: "aceman"
    get '/marca/mini-espana/countryman', to: 'pages#show_model', brand_slug: 'mini-espana', model_slug: 'countryman', as: "countryman"

    # Cupra Models
    get '/marca/cupra-espana/tavascan', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'tavascan', as: "tavascan"
    get '/marca/cupra-espana/formentor', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'formentor', as: "formentor"
    get '/marca/cupra-espana/leon', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'leon', as: "leon"
    get '/marca/cupra-espana/born', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'born', as: "born"
    get '/marca/cupra-espana/terramar', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'terramar', as: "terramar"
    # Tesla Models
    get '/marca/tesla-espana/model-s', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-s', as: "models"
    get '/marca/tesla-espana/model-3', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-3', as: "model3"
    get '/marca/tesla-espana/model-y', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-y', as: "modely"
    get '/marca/tesla-espana/model-x', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-x', as: "modelx"

    # BYD Models
    get '/marca/byd-espana/seal', to: 'pages#show_model', brand_slug: 'byd-espana', model_slug: 'seal', as: "seal"
    get '/marca/byd-espana/atto-3', to: 'pages#show_model', brand_slug: 'byd-espana', model_slug: 'atto-3', as: "atto3"
    get '/marca/byd-espana/dolphin', to: 'pages#show_model', brand_slug: 'byd-espana', model_slug: 'dolphin', as: "dolphin"
    get '/marca/byd-espana/seal-u', to: 'pages#show_model', brand_slug: 'byd-espana', model_slug: 'seal-u', as: "sealu"


  end
  # Dynamic sitemaps
  get '/sitemap.xml', to: 'sitemaps#index', defaults: { format: 'xml' }
  get '/sitemap_main.xml', to: 'sitemaps#main', defaults: { format: 'xml' }
  get '/sitemap_:locale.xml', to: 'sitemaps#show', defaults: { format: 'xml' }, constraints: { locale: /es|fr|en|cat|ru|de|nl/ }
  
  # Legacy redirects for old S3 sitemaps (keep for SEO)
  get '/sitemap', to: redirect('/sitemap.xml')
  get '/sitemap1', to: redirect('/sitemap_main.xml')
end
