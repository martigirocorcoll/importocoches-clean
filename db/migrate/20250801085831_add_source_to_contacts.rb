class AddSourceToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :source, :string
  end
end
