namespace :storage do
  desc "Populate storage with unlinked documents"
  task upload_unlinked_documents: :environment do
    region_name = ENV['REGION_NAME']

    files_dir = Rails.root.join("db", "data", "unlinked_documents")

    Dir.each_child(files_dir) do |document|
      puts "processing document #{document}..."

      number, type, _ = document.split(".")
      date = number[4, 4]
      doc = Document.create!(title: "#{number}.pdf", document_type: type, region_name: region_name, date: date)
      doc.file.attach(
        io: File.open("#{files_dir}/#{document}"),
        filename: "#{number}.pdf",
        content_type: "application/pdf"
      )

      puts "done"
    end
  end
end
