class AddUserIdToLlamadas < ActiveRecord::Migration[6.1]
  def change
    # Allow null for existing records and anonymous users
    add_reference :llamadas, :user, null: true, foreign_key: true
    # Index is automatically created by add_reference
  end
end
