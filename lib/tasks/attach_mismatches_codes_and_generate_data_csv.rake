require "csv"

namespace :osm do
  desc "Attach mismatch codes to documents"
  task attach_mismatches_codes_and_generate_data_csv: :environment do
    region_name = ENV['REGION_NAME']

    mismatch_working_dir_path = Rails.root.join("db", "data", "code_mismatches", region_name)
    mismatch_csv_path = Rails.root.join(mismatch_working_dir_path, "code_mismatche_list.csv")
    puts "mismatch CSV path: #{mismatch_csv_path}"

    documents_working_dir_path = Rails.root.join("db", "data", region_name)
    documents_csv_path = Rails.root.join(documents_working_dir_path, "documents_list.csv")
    puts "documents CSV path: #{documents_csv_path}"

    nwe_csv_file_path = Rails.root.join(mismatch_working_dir_path, "missing.gen.csv")
    puts "new documents CSV path: #{nwe_csv_file_path}"

    puts "========================================="

    puts "Reading mismatch CSV..."
    mismatches = []

    CSV.foreach(mismatch_csv_path, headers: true, header_converters: :symbol) do |row|
      mismatches << [row[:on_row].to_s.strip, row[:current_in_use].to_s.strip]
    end

    puts "======================================"
    mismatches.each {|k, v| puts "k : #{k}, v : #{v}"}
    puts "======================================"

    # codes_to_search = mismatches.map { |row| [row[:on_row].to_s.strip, row[:current_in_use].to_s.strip] }

    documents_row_count = 0
    documents_skipped_rows = 0
    document_match_count = 0

    output_headers = ['code', 'location', 'number']

    ActiveRecord::Base.transaction do
      puts "Creating new documents CSV from mismatches and documents data in streaming mode..."
      CSV.open(nwe_csv_file_path, 'w') do |csv_out|
        csv_out << output_headers

        CSV.foreach(documents_csv_path, headers: true, header_converters: :symbol) do |row|
          mismatches.each do |on_row, current_in_use|
            # puts "1, #{row[:code].to_s.strip}, 2, #{on_row}"
            if row[:code].to_s.strip == on_row
              parent_code = Code.find_by(value: current_in_use)
              child_code = Code.find_or_create_by!(value: on_row, current_in_use: parent_code)
              location = row[:location]
              number = row[:number]

              csv_out << [current_in_use, location, number]
            end
          end
        end
      end
    end

    puts "\n--- Summary ---"
    puts "Mismatches processed:    #{mismatches.size}"
  end
end
