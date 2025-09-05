class RemoveRealImageUrlsFromImportedCars < ActiveRecord::Migration[6.1]
  def change
    remove_column :imported_cars, :real_image_urls, :text
  end
end
