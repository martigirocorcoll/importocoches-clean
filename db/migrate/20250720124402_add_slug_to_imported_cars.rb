class AddSlugToImportedCars < ActiveRecord::Migration[6.1]
  def change
    add_column :imported_cars, :slug, :string
    add_index :imported_cars, :slug
  end
end
