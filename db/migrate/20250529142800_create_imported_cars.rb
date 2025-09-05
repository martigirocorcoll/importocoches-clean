class CreateImportedCars < ActiveRecord::Migration[6.1]
  def change
    create_table :imported_cars do |t|
      t.string :brand
      t.string :model
      t.integer :year
      t.integer :mileage
      t.integer :horsepower
      t.string :fuel_type
      t.text :long_description_es
      t.text :long_description_en
      t.text :long_description_cat
      t.text :long_description_fr
      t.text :ad_image_urls
      t.text :real_image_urls
      t.text :video_urls

      t.timestamps
    end
  end
end
