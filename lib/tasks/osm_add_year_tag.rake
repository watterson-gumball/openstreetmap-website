require "nokogiri"

namespace :osm do
  desc "Add from_date tag to all nodes, ways, and relations in an OSM file"
  task :add_from_date_tag, [:input_path, :from_date, :output_path] => :environment do |_, args|
    input_path  = args[:input_path]  || "input.osm"
    output_path = args[:output_path] || "output_with_from_date.osm"
    from_date   = args[:from_date]   || "2025"

    unless File.exist?(input_path)
      puts "File not found: #{input_path}"
      exit 1
    end

    puts "📖 Reading: #{input_path}"
    doc = Nokogiri::XML(File.read(input_path)) { |cfg| cfg.default_xml.noblanks }

    total_added = 0

    %w[node way relation].each do |element_type|
      count_added = 0

      doc.xpath("//#{element_type}").each do |element|
        next if element.at_xpath("tag[@k='from_date']")

        tag = Nokogiri::XML::Node.new("tag", doc)
        tag["k"] = "from_date"
        tag["v"] = from_date
        element.add_child(tag)

        count_added += 1
      end

      total_added += count_added
      puts "✅ Added from_date to #{count_added} #{element_type}(s)"
    end

    File.write(output_path, doc.to_xml(indent: 2))
    puts "💾 Wrote output with #{total_added} added tag(s) to: #{output_path}"
  end
end
