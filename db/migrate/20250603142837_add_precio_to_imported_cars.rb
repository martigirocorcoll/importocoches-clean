class AddPrecioToImportedCars < ActiveRecord::Migration[6.1]
  def change
    add_column :imported_cars, :precio, :integer
  end
end
