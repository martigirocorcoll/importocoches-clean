class AddLocaleToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :locale, :string
  end
end
