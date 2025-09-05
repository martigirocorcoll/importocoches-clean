class AddBotDetectionFieldsToLlamadas < ActiveRecord::Migration[6.1]
  def change
    add_column :llamadas, :ip_address, :string
    add_column :llamadas, :user_agent, :text
    add_column :llamadas, :referer, :string
    add_column :llamadas, :session_id, :string
    add_column :llamadas, :country, :string
    add_column :llamadas, :request_method, :string
  end
end
