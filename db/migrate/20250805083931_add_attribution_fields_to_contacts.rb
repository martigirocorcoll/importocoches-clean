class AddAttributionFieldsToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :platform, :string
    add_column :contacts, :traffic_type, :string
    add_column :contacts, :campaign_name, :string
    add_column :contacts, :keyword, :string
    add_column :contacts, :creative_type, :string
    add_column :contacts, :click_id, :string
    add_column :contacts, :reference_number, :string
    add_column :contacts, :raw_utm_data, :text
    
    add_index :contacts, :reference_number, unique: true
    add_index :contacts, :platform
    add_index :contacts, :created_at
  end
end
