require "psych"

namespace :storage do
  desc "Populate storage with floor plans"
  task upload_floor_plans: :environment do
    # files_dir = Rails.root.join("db", "data", "floor_plans")

    # documents_data = []
    # Dir.each_child(files_dir) do |plan|
    #   documents_data << {title: "#{plan}", document_type: "plan", region_name: "yerevan", file: {io: File.open("#{files_dir}/#{plan}"), filename: plan, content_type: "application/pdf"}}
    # end

    # code = Code.find_by(value: "01-007-0571-0001-149")

    # code.documents << Document.create!(documents_data)

    mapping_file = Rails.root.join("db", "data", "_floor_plans", "floor_mapping.yml")

    File.open(mapping_file) do |f|
      YAML.load_stream(f) do |doc|
        doc.each do |code_value, data|
          code = Code.find_by(value: code_value)
          puts "code id #{code.id}"

          documents_data = []
          data["floors"].each_with_index do |f, i|
            path = Rails.root.join(f["file"])
            title = "n#{i + 1}_#{File.basename(path)}"

            documents_data << {title: title, document_type: "plan", region_name: "yerevan", file: {io: File.open("#{path}"), filename: title, content_type: "application/pdf"}}
          end
          code.documents << Document.create!(documents_data)
          puts "===="
        end
      end
    end
  end
end
