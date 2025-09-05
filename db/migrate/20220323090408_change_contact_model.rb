class ChangeContactModel < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :email, "string"
    add_column :contacts, :phone, "string"
    add_column :contacts, :comment, "text"
    remove_column :contacts, :contact
  end
end
