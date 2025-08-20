namespace :storage do
  desc "Populate storage with floor plans"
  task upload_floor_plans: :environment do
    files_dir = Rails.root.join("db", "data", "floor_plans")

    documents_data = []
    Dir.each_child(files_dir) do |plan|
      documents_data << {title: "#{plan}", document_type: "plan", region_name: "yerevan", file: {io: File.open("#{files_dir}/#{plan}"), filename: plan, content_type: "application/pdf"}}
    end

    code = Code.find_by(value: "01-007-0571-0001-149")

    code.documents << Document.create!(documents_data)
  end
end
