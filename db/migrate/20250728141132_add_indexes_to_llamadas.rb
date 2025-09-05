class AddIndexesToLlamadas < ActiveRecord::Migration[6.1]
  def change
    # Most important index - for date filtering (created_at queries)
    add_index :llamadas, :created_at, name: 'index_llamadas_on_created_at'
    
    # For IP analysis and suspicious activity detection
    add_index :llamadas, :ip_address, name: 'index_llamadas_on_ip_address'
    
    # For bot detection queries on user_agent
    add_index :llamadas, :user_agent, name: 'index_llamadas_on_user_agent'
    
    # For request method filtering
    add_index :llamadas, :request_method, name: 'index_llamadas_on_request_method'
    
    # Composite index for common combined queries (date + IP analysis)
    add_index :llamadas, [:created_at, :ip_address], name: 'index_llamadas_on_created_at_and_ip'
    
    # For referer analysis (bot detection)
    add_index :llamadas, :referer, name: 'index_llamadas_on_referer'
    
    # For session-based analysis
    add_index :llamadas, :session_id, name: 'index_llamadas_on_session_id'
  end
end
