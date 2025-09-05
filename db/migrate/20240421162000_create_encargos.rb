class CreateEncargos < ActiveRecord::Migration[6.1]
  def change
    create_table :encargos do |t|
      t.string :nombre
      t.string :fpago_coche
      t.string :frecogida
      t.string :fentrada_and
      t.string :fcobro_iva
      t.string :contacto
      t.string :cantidad_iva
      t.string :direccion_recog
      t.string :comentario

      t.timestamps
    end
  end
end
