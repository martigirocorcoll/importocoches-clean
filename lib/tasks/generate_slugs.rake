namespace :imported_cars do
  desc "Generate slugs for existing imported cars"
  task generate_slugs: :environment do
    puts "Starting slug generation for existing imported cars..."
    
    # Contar registros totales y sin slug
    total_count = ImportedCar.count
    without_slug_count = ImportedCar.where(slug: [nil, ""]).count
    
    puts "Total imported cars: #{total_count}"
    puts "Records without slug: #{without_slug_count}"
    
    if without_slug_count == 0
      puts "All records already have slugs. Nothing to do."
      exit
    end
    
    # Procesar registros sin slug
    updated_count = 0
    skipped_count = 0
    
    ImportedCar.where(slug: [nil, ""]).find_each do |car|
      if car.brand.present? && car.model.present?
        begin
          # Usar update_column para evitar callbacks y validaciones
          base_slug = "#{car.brand.downcase}-#{car.model.downcase}".parameterize
          
          # Verificar duplicados y añadir número si es necesario
          counter = 1
          new_slug = base_slug
          
          while ImportedCar.where(slug: new_slug).where.not(id: car.id).exists?
            new_slug = "#{base_slug}-#{counter}"
            counter += 1
          end
          
          car.update_column(:slug, new_slug)
          updated_count += 1
          puts "✓ Updated car ##{car.id}: #{car.brand} #{car.model} -> #{new_slug}"
        rescue => e
          puts "✗ Error updating car ##{car.id}: #{e.message}"
          skipped_count += 1
        end
      else
        puts "✗ Skipping car ##{car.id}: missing brand or model (brand: '#{car.brand}', model: '#{car.model}')"
        skipped_count += 1
      end
    end
    
    puts "\n" + "="*50
    puts "SUMMARY:"
    puts "Total records processed: #{without_slug_count}"
    puts "Successfully updated: #{updated_count}"
    puts "Skipped/Error: #{skipped_count}"
    puts "="*50
    
    # Verificar resultados
    remaining_without_slug = ImportedCar.where(slug: [nil, ""]).count
    if remaining_without_slug == 0
      puts "✅ SUCCESS: All imported cars now have slugs!"
    else
      puts "⚠️  WARNING: #{remaining_without_slug} records still without slugs."
    end
  end

  desc "Verify all imported cars have unique slugs"
  task verify_slugs: :environment do
    puts "Verifying slug uniqueness..."
    
    # Buscar duplicados
    duplicate_slugs = ImportedCar.group(:slug).having('count(*) > 1').count
    
    if duplicate_slugs.empty?
      puts "✅ All slugs are unique!"
    else
      puts "⚠️  Found duplicate slugs:"
      duplicate_slugs.each do |slug, count|
        puts "  - '#{slug}': #{count} records"
        ImportedCar.where(slug: slug).each do |car|
          puts "    * ID #{car.id}: #{car.brand} #{car.model}"
        end
      end
    end
    
    # Buscar registros sin slug
    without_slug = ImportedCar.where(slug: [nil, ""]).count
    if without_slug > 0
      puts "⚠️  Found #{without_slug} records without slug"
    end
    
    puts "Total records: #{ImportedCar.count}"
    puts "Records with slug: #{ImportedCar.where.not(slug: [nil, ""]).count}"
  end
end