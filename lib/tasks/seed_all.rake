namespace :db do
  desc "Run all seeds including OSM data"
  task seed_all: :environment do
    puts "[SEED_ALL] running db:seed..."
    Rake::Task["db:seed"].invoke
    puts "[SEED_ALL] db:seed complete"

    puts "task"
    cmd = [
      "osmosis",
      "-verbose",
      "--rx", "#{Rails.root.join("merged.2008.12.osm")}",
      "--write-apidb",
      "host=db",
      "database=openstreetmap",
      "user=openstreetmap",
      "validateSchemaVersion=no"
    ]

    puts "[RAKE] Running Osmosis..."
    success = system(*cmd)

    if success
      puts "[RAKE] Osmosis completed successfully."
    else
      raise "[RAKE] Osmosis failed. Please check the Docker and PBF setup."
    end
  end
end
