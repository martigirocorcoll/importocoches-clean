
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
    get '/marca/lamborghini-espana', to: 'pages#show_brand', brand_slug: 'lamborghini-espana', as: "marca_lamborghini_andorra"
    
    # Keep model route aliases for backward compatibility
    get '/marca/bmw-espana/serie-1', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-1', as: "serie1"
    get '/marca/bmw-espana/i8', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'i8', as: "i8"
    get '/marca/bmw-espana/serie-3', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-3', as: "serie3"
    get '/marca/bmw-espana/serie-4', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-4', as: "serie4"
    get '/marca/bmw-espana/serie-5', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'serie-5', as: "serie5"
    get '/marca/bmw-espana/x1', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'x1', as: "x1"
    get '/marca/bmw-espana/x5', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'x5', as: "x5"
    get '/marca/bmw-espana/x6', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'x6', as: "x6"
    get '/marca/bmw-espana/xm', to: 'pages#show_model', brand_slug: 'bmw-espana', model_slug: 'xm', as: "xm"
    get '/marca/mercedes-espana/a', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'a', as: "ma"
    get '/marca/mercedes-espana/cla', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'cla', as: "cla"
    get '/marca/mercedes-espana/gla', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'gla', as: "gla"
    get '/marca/mercedes-espana/g', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'g', as: "mg"
    get '/marca/mercedes-espana/glb', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'glb', as: "glb"
    get '/marca/mercedes-espana/glc', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'glc', as: "glc"
    get '/marca/mercedes-espana/amg-gt', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'amg-gt', as: "amggt"
    get '/marca/mercedes-espana/s', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 's', as: "ms"
    get '/marca/mercedes-espana/v', to: 'pages#show_model', brand_slug: 'mercedes-espana', model_slug: 'v', as: "mv"
    get '/marca/audi-espana/a1', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'a1', as: "a1"
    get '/marca/audi-espana/a3', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'a3', as: "a3"
    get '/marca/audi-espana/a4', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'a4', as: "a4"
    get '/marca/audi-espana/q2', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q2', as: "q2"
    get '/marca/audi-espana/q3', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q3', as: "q3"
    get '/marca/audi-espana/q5', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q5', as: "q5"
    get '/marca/audi-espana/q8', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'q8', as: "q8"
    get '/marca/audi-espana/rs6', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'rs6', as: "rs6"
    get '/marca/audi-espana/r8', to: 'pages#show_model', brand_slug: 'audi-espana', model_slug: 'r8', as: "r8"
    get '/marca/porsche-espana/macan', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'macan', as: "macan"
    get '/marca/porsche-espana/panamera', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'panamera', as: "panamera"
    get '/marca/porsche-espana/cayenne', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'cayenne', as: "cayenne"
    get '/marca/porsche-espana/boxster', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'boxster', as: "boxster"
    get '/marca/porsche-espana/cayman', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'cayman', as: "cayman"
    get '/marca/porsche-espana/carrera', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'carrera', as: "carrera"
    get '/marca/porsche-espana/taycan', to: 'pages#show_model', brand_slug: 'porsche-espana', model_slug: 'taycan', as: "taycan"
    get '/marca/volkswagen-espana/polo', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'polo', as: "polo"
    get '/marca/volkswagen-espana/golf', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'golf', as: "golf"
    get '/marca/volkswagen-espana/t-cross', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 't-cross', as: "tcross"
    get '/marca/volkswagen-espana/tiguan', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'tiguan', as: "tiguan"
    get '/marca/volkswagen-espana/t-roc', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 't-roc', as: "troc"
    get '/marca/volkswagen-espana/touareg', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'touareg', as: "touareg"
    get '/marca/volkswagen-espana/california', to: 'pages#show_model', brand_slug: 'volkswagen-espana', model_slug: 'california', as: "california"
    get '/marca/mini-espana/cooper', to: 'pages#show_model', brand_slug: 'mini-espana', model_slug: 'cooper', as: "cooper"
    get '/marca/mini-espana/clubman', to: 'pages#show_model', brand_slug: 'mini-espana', model_slug: 'clubman', as: "clubman"
    get '/marca/mini-espana/countryman', to: 'pages#show_model', brand_slug: 'mini-espana', model_slug: 'countryman', as: "countryman"
    get '/marca/cupra-espana/ateca', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'ateca', as: "ateca"
    get '/marca/cupra-espana/formentor', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'formentor', as: "formentor"
    get '/marca/cupra-espana/leon', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'leon', as: "leon"
    get '/marca/cupra-espana/born', to: 'pages#show_model', brand_slug: 'cupra-espana', model_slug: 'born', as: "born"
    get '/marca/tesla-espana/model-s', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-s', as: "models"
    get '/marca/tesla-espana/model-3', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-3', as: "model3"
    get '/marca/tesla-espana/model-y', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-y', as: "modely"
    get '/marca/tesla-espana/model-x', to: 'pages#show_model', brand_slug: 'tesla-espana', model_slug: 'model-x', as: "modelx"
    get '/marca/lamborghini-espana/aventador', to: 'pages#show_model', brand_slug: 'lamborghini-espana', model_slug: 'aventador', as: "aventador"
    get '/marca/lamborghini-espana/countach', to: 'pages#show_model', brand_slug: 'lamborghini-espana', model_slug: 'countach', as: "countach"
    get '/marca/lamborghini-espana/huracan', to: 'pages#show_model', brand_slug: 'lamborghini-espana', model_slug: 'huracan', as: "huracan"
    get '/marca/lamborghini-espana/urus', to: 'pages#show_model', brand_slug: 'lamborghini-espana', model_slug: 'urus', as: "urus"


  end
  # Dynamic sitemaps
  get '/sitemap.xml', to: 'sitemaps#index', defaults: { format: 'xml' }
  get '/sitemap_main.xml', to: 'sitemaps#main', defaults: { format: 'xml' }
  get '/sitemap_:locale.xml', to: 'sitemaps#show', defaults: { format: 'xml' }, constraints: { locale: /es|fr|en|cat|ru|de|nl/ }
  
  # Legacy redirects for old S3 sitemaps (keep for SEO)
  get '/sitemap', to: redirect('/sitemap.xml')
  get '/sitemap1', to: redirect('/sitemap_main.xml')
end
