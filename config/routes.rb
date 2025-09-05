
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
  
  get '/privacy_policy', to: 'pages#privacy_policy'
  get '/cookie_policy', to: 'pages#cookie_policy'
  get '/aviso_legal', to: 'pages#aviso_legal'
  scope '(:locale)', locale: /es|fr|en|cat|ru|de|nl/ do
    # Contracts routes
    resources :contracts, only: [:new]
    get '/contract_pdf', to: 'contracts#generate_pdf'
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
    get '/importar-coche-espana', to: 'pages#importar_espana'
    get '/us', to: 'pages#nosaltres'
    get '/marca', to: 'pages#marca'
    get '/faqs', to: 'pages#faqs'
    # Dynamic brand and model routes
    get '/marca/:brand_slug', to: 'pages#show_brand', as: "brand"
    get '/marca/:brand_slug/:model_slug', to: 'pages#show_model', as: "brand_model"
    
    # Keep existing route aliases for backward compatibility
    get '/marca/bmw-andorra', to: 'pages#show_brand', brand_slug: 'bmw-andorra', as: "marca_bmw_andorra"
    get '/marca/mercedes-andorra', to: 'pages#show_brand', brand_slug: 'mercedes-andorra', as: "marca_mercedes_andorra"
    get '/marca/audi-andorra', to: 'pages#show_brand', brand_slug: 'audi-andorra', as: "marca_audi_andorra"
    get '/marca/porsche-andorra', to: 'pages#show_brand', brand_slug: 'porsche-andorra', as: "marca_porsche_andorra"
    get '/marca/volkswagen-andorra', to: 'pages#show_brand', brand_slug: 'volkswagen-andorra', as: "marca_volkswagen_andorra"
    get '/marca/mini-andorra', to: 'pages#show_brand', brand_slug: 'mini-andorra', as: "marca_mini_andorra"
    get '/marca/cupra-andorra', to: 'pages#show_brand', brand_slug: 'cupra-andorra', as: "marca_cupra_andorra"
    get '/marca/tesla-andorra', to: 'pages#show_brand', brand_slug: 'tesla-andorra', as: "marca_tesla_andorra"
    get '/marca/lamborghini-andorra', to: 'pages#show_brand', brand_slug: 'lamborghini-andorra', as: "marca_lamborghini_andorra"
    
    # Keep model route aliases for backward compatibility
    get '/marca/bmw-andorra/serie-1', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'serie-1', as: "serie1"
    get '/marca/bmw-andorra/i8', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'i8', as: "i8"
    get '/marca/bmw-andorra/serie-3', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'serie-3', as: "serie3"
    get '/marca/bmw-andorra/serie-4', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'serie-4', as: "serie4"
    get '/marca/bmw-andorra/serie-5', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'serie-5', as: "serie5"
    get '/marca/bmw-andorra/x1', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'x1', as: "x1"
    get '/marca/bmw-andorra/x5', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'x5', as: "x5"
    get '/marca/bmw-andorra/x6', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'x6', as: "x6"
    get '/marca/bmw-andorra/xm', to: 'pages#show_model', brand_slug: 'bmw-andorra', model_slug: 'xm', as: "xm"
    get '/marca/mercedes-andorra/a', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'a', as: "ma"
    get '/marca/mercedes-andorra/cla', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'cla', as: "cla"
    get '/marca/mercedes-andorra/gla', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'gla', as: "gla"
    get '/marca/mercedes-andorra/g', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'g', as: "mg"
    get '/marca/mercedes-andorra/glb', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'glb', as: "glb"
    get '/marca/mercedes-andorra/glc', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'glc', as: "glc"
    get '/marca/mercedes-andorra/amg-gt', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'amg-gt', as: "amggt"
    get '/marca/mercedes-andorra/s', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 's', as: "ms"
    get '/marca/mercedes-andorra/v', to: 'pages#show_model', brand_slug: 'mercedes-andorra', model_slug: 'v', as: "mv"
    get '/marca/audi-andorra/a1', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'a1', as: "a1"
    get '/marca/audi-andorra/a3', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'a3', as: "a3"
    get '/marca/audi-andorra/a4', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'a4', as: "a4"
    get '/marca/audi-andorra/q2', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'q2', as: "q2"
    get '/marca/audi-andorra/q3', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'q3', as: "q3"
    get '/marca/audi-andorra/q5', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'q5', as: "q5"
    get '/marca/audi-andorra/q8', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'q8', as: "q8"
    get '/marca/audi-andorra/rs6', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'rs6', as: "rs6"
    get '/marca/audi-andorra/r8', to: 'pages#show_model', brand_slug: 'audi-andorra', model_slug: 'r8', as: "r8"
    get '/marca/porsche-andorra/macan', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'macan', as: "macan"
    get '/marca/porsche-andorra/panamera', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'panamera', as: "panamera"
    get '/marca/porsche-andorra/cayenne', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'cayenne', as: "cayenne"
    get '/marca/porsche-andorra/boxster', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'boxster', as: "boxster"
    get '/marca/porsche-andorra/cayman', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'cayman', as: "cayman"
    get '/marca/porsche-andorra/carrera', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'carrera', as: "carrera"
    get '/marca/porsche-andorra/taycan', to: 'pages#show_model', brand_slug: 'porsche-andorra', model_slug: 'taycan', as: "taycan"
    get '/marca/volkswagen-andorra/polo', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 'polo', as: "polo"
    get '/marca/volkswagen-andorra/golf', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 'golf', as: "golf"
    get '/marca/volkswagen-andorra/t-cross', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 't-cross', as: "tcross"
    get '/marca/volkswagen-andorra/tiguan', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 'tiguan', as: "tiguan"
    get '/marca/volkswagen-andorra/t-roc', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 't-roc', as: "troc"
    get '/marca/volkswagen-andorra/touareg', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 'touareg', as: "touareg"
    get '/marca/volkswagen-andorra/california', to: 'pages#show_model', brand_slug: 'volkswagen-andorra', model_slug: 'california', as: "california"
    get '/marca/mini-andorra/cooper', to: 'pages#show_model', brand_slug: 'mini-andorra', model_slug: 'cooper', as: "cooper"
    get '/marca/mini-andorra/clubman', to: 'pages#show_model', brand_slug: 'mini-andorra', model_slug: 'clubman', as: "clubman"
    get '/marca/mini-andorra/countryman', to: 'pages#show_model', brand_slug: 'mini-andorra', model_slug: 'countryman', as: "countryman"
    get '/marca/cupra-andorra/ateca', to: 'pages#show_model', brand_slug: 'cupra-andorra', model_slug: 'ateca', as: "ateca"
    get '/marca/cupra-andorra/formentor', to: 'pages#show_model', brand_slug: 'cupra-andorra', model_slug: 'formentor', as: "formentor"
    get '/marca/cupra-andorra/leon', to: 'pages#show_model', brand_slug: 'cupra-andorra', model_slug: 'leon', as: "leon"
    get '/marca/cupra-andorra/born', to: 'pages#show_model', brand_slug: 'cupra-andorra', model_slug: 'born', as: "born"
    get '/marca/tesla-andorra/model-s', to: 'pages#show_model', brand_slug: 'tesla-andorra', model_slug: 'model-s', as: "models"
    get '/marca/tesla-andorra/model-3', to: 'pages#show_model', brand_slug: 'tesla-andorra', model_slug: 'model-3', as: "model3"
    get '/marca/tesla-andorra/model-y', to: 'pages#show_model', brand_slug: 'tesla-andorra', model_slug: 'model-y', as: "modely"
    get '/marca/tesla-andorra/model-x', to: 'pages#show_model', brand_slug: 'tesla-andorra', model_slug: 'model-x', as: "modelx"
    get '/marca/lamborghini-andorra/aventador', to: 'pages#show_model', brand_slug: 'lamborghini-andorra', model_slug: 'aventador', as: "aventador"
    get '/marca/lamborghini-andorra/countach', to: 'pages#show_model', brand_slug: 'lamborghini-andorra', model_slug: 'countach', as: "countach"
    get '/marca/lamborghini-andorra/huracan', to: 'pages#show_model', brand_slug: 'lamborghini-andorra', model_slug: 'huracan', as: "huracan"
    get '/marca/lamborghini-andorra/urus', to: 'pages#show_model', brand_slug: 'lamborghini-andorra', model_slug: 'urus', as: "urus"


  end
  # Dynamic sitemaps
  get '/sitemap.xml', to: 'sitemaps#index', defaults: { format: 'xml' }
  get '/sitemap_main.xml', to: 'sitemaps#main', defaults: { format: 'xml' }
  get '/sitemap_:locale.xml', to: 'sitemaps#show', defaults: { format: 'xml' }, constraints: { locale: /es|fr|en|cat|ru|de|nl/ }
  
  # Legacy redirects for old S3 sitemaps (keep for SEO)
  get '/sitemap', to: redirect('/sitemap.xml')
  get '/sitemap1', to: redirect('/sitemap_main.xml')
end
