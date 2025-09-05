require 'csv'

Price.destroy_all

CSV.foreach(Rails.root.join('lib/finalbase.csv')) do |row|
  Price.create!(
    {
      marca: row[0],
      modelo: row[1].downcase,
      año_matriculacion: row[2].to_i,
      factor_potencia: row[4].to_i,
      hacienda: row[5].to_i,
      co2: row[6].to_i
    }
  )
end

puts "#{Price.count} records in prices table saved!"
