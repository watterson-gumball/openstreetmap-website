namespace :documents do
  desc "Rename .pdf and .jpg files to include folder name and move to a single directory"
  task move_and_rename_files: :environment do
    source_base = Rails.root.join("db", "data", "tmp")     # ← update this
    target_dir  = Rails.root.join("db", "data", "yerevan")     # ← update this


    puts "🔍 Scanning #{source_base} for .pdf and .jpg files..."

    Dir.glob("#{source_base}/**/*.{pdf,jpg}", File::FNM_CASEFOLD).each do |file_path|
      next unless File.file?(file_path)

      dirname  = File.basename(File.dirname(file_path))
      basename = File.basename(file_path, ".*")
      ext      = File.extname(file_path).downcase
      new_name = "#{basename}.#{dirname}#{ext}"
      new_path = File.join(target_dir, new_name)

      if File.exist?(new_path)
        puts "Skipping (already exists): #{new_name}"
        next
      end

      FileUtils.mv(file_path, new_path)
      puts "Moved: #{file_path} → #{new_path}"
    end

    puts "Done. All files moved to #{target_dir}"
  end
end