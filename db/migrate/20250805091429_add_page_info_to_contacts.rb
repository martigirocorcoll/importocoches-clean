class AddPageInfoToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :page_url, :string
    add_column :contacts, :page_title, :string
    
    add_index :contacts, :page_url
  end
end
