namespace :db do
  desc "Seed default regions (e.g., yerevan, gyumri)"
  task seed_regions: :environment do
    regions = %w[yerevan gyumri]

    regions.each do |region_name|
      Region.find_or_create_by!(name: region_name)
      puts "Seeded #{region_name} region"
    end

    puts "done"
  end
end
