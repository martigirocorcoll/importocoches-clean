#!/usr/bin/env ruby
# Script para generar slugs en producción
# Uso: rails runner scripts/generate_production_slugs.rb

puts "🚀 Iniciando generación de slugs para imported_cars en producción..."
puts "Fecha: #{Time.current}"
puts "="*60

# Estadísticas iniciales
total_records = ImportedCar.count
records_without_slug = ImportedCar.where(slug: [nil, ""]).count

puts "📊 ESTADÍSTICAS INICIALES:"
puts "   Total de registros: #{total_records}"
puts "   Registros sin slug: #{records_without_slug}"
puts

if records_without_slug == 0
  puts "✅ Todos los registros ya tienen slug. No hay nada que hacer."
  exit
end

# Confirmar antes de proceder
puts "⚠️  IMPORTANTE: Este script modificará #{records_without_slug} registros."
puts "   ¿Continuar? (y/N): "

# En producción, comentar estas líneas y descomentar la siguiente para auto-proceder
# unless STDIN.gets.chomp.downcase == 'y'
#   puts "❌ Operación cancelada."
#   exit
# end
# Descomentar esta línea para auto-proceder en producción:
puts "✅ Procediendo automáticamente..."

puts
puts "🔧 PROCESANDO REGISTROS..."
puts

# Contadores
updated = 0
errors = 0
skipped = 0

# Procesar cada registro
ImportedCar.where(slug: [nil, ""]).find_each(batch_size: 100) do |car|
  begin
    # Verificar que tenga brand y model
    unless car.brand.present? && car.model.present?
      puts "⚠️  Saltando ID #{car.id}: faltan datos (brand: '#{car.brand}', model: '#{car.model}')"
      skipped += 1
      next
    end

    # Generar slug base
    base_slug = "#{car.brand.downcase}-#{car.model.downcase}".parameterize
    
    # Manejar duplicados
    final_slug = base_slug
    counter = 1
    
    while ImportedCar.where(slug: final_slug).where.not(id: car.id).exists?
      final_slug = "#{base_slug}-#{counter}"
      counter += 1
    end
    
    # Actualizar usando update_column para evitar callbacks
    car.update_column(:slug, final_slug)
    
    puts "✅ ID #{car.id}: #{car.brand} #{car.model} → '#{final_slug}'"
    updated += 1
    
  rescue => e
    puts "❌ Error en ID #{car.id}: #{e.message}"
    errors += 1
  end
end

puts
puts "="*60
puts "📈 RESUMEN DE LA OPERACIÓN:"
puts "   Registros actualizados: #{updated}"
puts "   Registros saltados: #{skipped}"
puts "   Errores: #{errors}"
puts

# Verificación final
final_without_slug = ImportedCar.where(slug: [nil, ""]).count
final_with_slug = ImportedCar.where.not(slug: [nil, ""]).count

puts "📊 ESTADÍSTICAS FINALES:"
puts "   Total de registros: #{ImportedCar.count}"
puts "   Con slug: #{final_with_slug}"
puts "   Sin slug: #{final_without_slug}"
puts

if final_without_slug == 0
  puts "🎉 ¡ÉXITO! Todos los imported_cars tienen slug único."
else
  puts "⚠️  Quedan #{final_without_slug} registros sin slug."
end

# Verificar unicidad
duplicate_count = ImportedCar.group(:slug).having('count(*) > 1').count.size
if duplicate_count > 0
  puts "⚠️  Advertencia: Se encontraron #{duplicate_count} slugs duplicados."
else
  puts "✅ Todos los slugs son únicos."
end

puts
puts "✅ Script completado en #{Time.current}"