class AddCarIdToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :car_id, "string"
  end
end
