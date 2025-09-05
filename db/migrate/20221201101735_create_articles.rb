class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :titulo
      t.text :description

      t.timestamps
    end
  end
end
