namespace :osm do
  desc "Set region_id for all OSM rows where it's NULL"
  task populate_region_ids: :environment do
    region_name = ENV['REGION_NAME']
    raise "REGION_NAME is required" unless region_name

    region_id = Region.find_by!(name: region_name).id

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
      puts "Updating #{table} for region #{region_name}..."
      result = ActiveRecord::Base.connection.execute <<~SQL
        UPDATE #{table}
        SET region_id = #{region_id}
        WHERE region_id IS NULL;
      SQL
      puts "#{result.cmd_tuples} rows updated in #{table}" if result.respond_to?(:cmd_tuples)
    end

    puts "region_id set to #{region_id} for region #{region_name}"
  end
end
