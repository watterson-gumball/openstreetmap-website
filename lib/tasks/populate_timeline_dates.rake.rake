namespace :osm do
  desc "Set dates for all OSM rows where it's NULL"
  task populate_timeline_dates: :environment do
    timeline_date = ENV['DATE']
    raise "DATE is required" unless timeline_date

    tables = %w[
      changesets
      changeset_tags
      current_nodes
      current_node_tags
      current_relation_members
      current_relations
      current_relation_tags
      current_way_nodes
      current_ways
      current_way_tags
      nodes
      relation_members
      relations
      relation_tags
      users
      way_nodes
      ways
      way_tags
    ]

    tables.each do |table|
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = table
        self.inheritance_column = :_type_disabled
      end

      unless klass.column_names.include?("timeline_date")
        puts "Skipping #{table}, no 'timeline_date' column"
        next
      end

      updated_rows = klass.where(timeline_date: nil).update_all(timeline_date: timeline_date)
      puts "#{updated_rows} rows updated in #{table}"
    end

    puts "dates set to #{timeline_date}"
  end
end