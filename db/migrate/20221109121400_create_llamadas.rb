class CreateLlamadas < ActiveRecord::Migration[6.1]
  def change
    create_table :llamadas do |t|
      t.string :endpoint

      t.timestamps
    end
  end
end
