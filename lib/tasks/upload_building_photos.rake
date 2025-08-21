namespace :storage do
  desc "Upload building photos to storage"
  task upload_building_photos: :environment do
    files_dir = Rails.root.join("db", "data", "building_photos")

    code_attributes = {}

    Dir.each_child(files_dir) do |filename|
      match = filename.match(/(\d+(?:-\d+)+)/)
      code_value = match[1]

      document_attributes = {
        title: "#{filename}",
        document_type: "photo",
        region_name: "yerevan",
        file: {
          io: File.open("#{files_dir}/#{filename}"),
          filename: "#{filename}",
          content_type: "image/jpeg"
        }
      }

      (code_attributes[code_value] ||= []) << document_attributes
    end

    ActiveRecord::Base.transaction do
      code_attributes.each do |code_value, document_attributes|
        code = Code.find_by(value: code_value)
        puts code_value
        next unless code

        code.documents << Document.create!(document_attributes)
      end
    end
  end
end
