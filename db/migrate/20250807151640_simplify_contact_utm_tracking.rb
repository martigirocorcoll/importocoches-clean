class SimplifyContactUtmTracking < ActiveRecord::Migration[6.1]
  def change
    # Add simple utm_params field
    add_column :contacts, :utm_params, :text
    
    # Remove complex attribution fields
    remove_column :contacts, :platform, :string
    remove_column :contacts, :traffic_type, :string
    remove_column :contacts, :campaign_name, :string
    remove_column :contacts, :keyword, :string
    remove_column :contacts, :creative_type, :string
    remove_column :contacts, :click_id, :string
    remove_column :contacts, :raw_utm_data, :text
  end
end