# This task populates the storage with documents using data from a CSV file.
#
# Prerequisites:
# - The file `db/data/documents_list.csv` must exist.
# - The CSV must contain `:code`, `:location`, and `:number` columns.
# - Files referenced in the CSV must exist in the `db/data/files` directory.
# - Each file should be a PDF named like `<number>*.pdf`.
# - Related models: Document, Code

require "csv"

namespace :storage do
  desc "Populate storage with documents from CSV and files"
  task populate: :environment do
    working_dir_path = Rails.root.join("db", "data")
    csv_path = Rails.root.join(working_dir_path, "documents_list.csv")
    files_dir = "#{working_dir_path}/files"

    puts "Reading from #{csv_path}..."
    data = CSV.read(csv_path, headers: true, header_converters: :symbol)
    puts "done"

    puts "Filtering uncomplete data..."
    filtered = data.reject { |row| row[:code].to_s.strip.empty? || row[:location].to_s.strip.empty? }
    puts "done"

    puts "Grouping data..."
    grouped = filtered.group_by { |row| row[:number].to_s.strip }
    puts "done"

    puts "Organizing data..."
    organized = grouped.transform_values do |entries|
      {
        codes: entries.map { |e| e[:code].to_s.strip }.uniq,
      }
    end
    puts "done"

    puts "Populating database..."
    organized.each do |number, value|
      ActiveRecord::Base.transaction do
        file = Dir.glob("#{files_dir}/*#{number}*.pdf").first

        codes = value[:codes].map do |value|
          Code.find_or_create_by!(value: value)
        end

        document = Document.create!(title: "#{number}.pdf")
        document.file.attach(io: File.open("#{file}"), filename: "#{number}.pdf", content_type: "application/pdf")
        document.codes << codes
      end
    end
    puts "done"

  end

end
