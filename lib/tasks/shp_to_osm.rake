namespace :osm do
  desc "Convert shp files to osm using config/regions.yml"
  task shp_to_osm: :environment do
    config_path = Rails.root.join("config/regions.yml")
    config = YAML.load_file(config_path)

    config.each do |c|
      shp_dir = Rails.root.join(c["shp_dir"])
      osm_dir = Rails.root.join(c["osm_dir"])
      id_file = Rails.root.join(c["id_file"])

      c["dates_available"].each do |d|
        current_dir = Rails.root.join(shp_dir, "#{d}.d")

        puts shp_dir
        Dir.chdir(current_dir) do
          shp_files = Dir.glob("*.shp")

          shp_files.each do |f|
            puts f
            cmd = [
              "ogr2osm",
              "--add-timestamp",
              "--add-version",
              "--positive-id",
              "--idfile", "#{id_file}",
              "--saveid", "#{id_file}",
              "--gis-order",
              "-o", "#{File.basename(f, ".shp").downcase}.osm",
              f
            ]

            system(*cmd)
          end

          cmd = ["osmosis"]

          osm_files = Dir.glob("*.osm")

          osm_files.each do |f|
            cmd << "--rx"
            cmd << f
          end

          (osm_files.count -1).times { cmd << "--m" }

          cmd << "--wx"
          cmd << "#{osm_dir}/#{d}.osm"
        end
      end
    end
  end
end
