json.extract! imported_car, :id, :brand, :model, :year, :mileage, :horsepower, :fuel_type, :long_description_es, :long_description_en, :long_description_cat, :long_description_fr, :ad_image_urls, :real_image_urls, :video_urls, :created_at, :updated_at
json.url imported_car_url(imported_car, format: :json)
