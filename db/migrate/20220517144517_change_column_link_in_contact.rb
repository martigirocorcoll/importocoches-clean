class ChangeColumnLinkInContact < ActiveRecord::Migration[6.1]
  def change
    rename_column :contacts, :car_id, :mobile_link
    add_column :contacts, :price, :string
  end
end
