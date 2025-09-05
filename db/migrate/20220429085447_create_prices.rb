class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.string :marca
      t.string :modelo
      t.integer :año_matriculacion
      t.integer :factor_potencia
      t.integer :hacienda
      t.integer :co2

      t.timestamps
    end
  end
end
