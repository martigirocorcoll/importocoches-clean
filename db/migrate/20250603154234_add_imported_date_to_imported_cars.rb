class AddImportedDateToImportedCars < ActiveRecord::Migration[6.1]
  def change
    add_column :imported_cars, :imported_date, :date
  end
end
