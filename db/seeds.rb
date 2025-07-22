# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "[SEED] Seeding languages..."
Language.load(Rails.root.join("config/languages.yml"))
puts "[SEED] Languages seeded."

puts "[SEED] Seeding regions..."
%w[yerevan gyumri].each do |region_name|
  Region.find_or_create_by!(name: region_name)
  puts "  - #{region_name} seeded."
end
puts "[SEED] Regions seeded."
