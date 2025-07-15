require "csv"

namespace :storage do
  desc "Populate storage with documents from CSV and files (PDF or JPG) using streaming"
  task populate: :environment do
    region_name = ENV['REGION_NAME']
    document_type = ENV['DOCUMENT_TYPE']

    working_dir_path = Rails.root.join("db", "data", region_name)
    csv_path = working_dir_path.join("documents_list.csv")
    files_dir = working_dir_path.join("files")

    puts "Starting document population task..."
    puts "CSV path: #{csv_path}"
    puts "Files directory: #{files_dir}"

    grouped = Hash.new { |h, k| h[k] = [] }
    row_count = 0
    skipped_rows = 0

    puts "Reading CSV in streaming mode..."
    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
      row_count += 1
      code = row[:code].to_s.strip
      location = row[:location].to_s.strip
      number = row[:number].to_s.strip

      if code.empty? || location.empty? || number.empty?
        skipped_rows += 1
        puts "  [Skipped] Row #{row_count} has missing code, location, or number"
        next
      end

      grouped[number] << code
    end
    puts "Finished reading CSV (#{row_count} rows, #{skipped_rows} skipped)"
    puts "Total document groups found: #{grouped.keys.count}"

    puts "\nStarting database population..."
    success_count = 0
    error_count = 0
    missing_file_count = 0

    grouped.each do |number, codes_array|
      puts "\nProcessing document ##{number}..."

      begin
        file_path = Dir.glob("#{files_dir}/**/*#{number}*.{pdf,jpg,jpeg}", File::FNM_CASEFOLD).first

        unless file_path && File.exist?(file_path)
          puts "  [Warning] No file found for number #{number}, skipping"
          missing_file_count += 1
          next
        end

        extension = File.extname(file_path).downcase
        content_type = case extension
                       when ".pdf" then "application/pdf"
                       when ".jpg", ".jpeg" then "image/jpeg"
                       else
                         puts "  [Warning] Unsupported file type: #{extension}, skipping"
                         missing_file_count += 1
                         next
                       end

        codes = codes_array.uniq.map do |value|
          code_record = Code.find_or_create_by!(value: value)
          puts "    Associated code: #{code_record.value}"
          code_record
        end

        document = Document.create!(title: "#{number}#{extension}")
        puts "  Created document record: #{document.title}"

        document.file.attach(
          io: File.open(file_path),
          filename: "#{number}#{extension}",
          content_type: content_type
        )
        puts "  Attached file: #{File.basename(file_path)} (#{content_type})"

        document.codes << codes
        puts "  Linked #{codes.size} code(s) to document"

        success_count += 1
      rescue => e
        error_count += 1
        puts "  [Error] Failed to process document ##{number}: #{e.message}"
      end
    end

    puts "\n--- Summary ---"
    puts "Documents processed:     #{grouped.keys.size}"
    puts "Successfully saved:      #{success_count}"
    puts "Skipped (no file):       #{missing_file_count}"
    puts "Failed with errors:      #{error_count}"
    puts "CSV rows skipped:        #{skipped_rows}"
    puts "Done."
  end
end