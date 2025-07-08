class AddRegionIdToOsmTables < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  TABLES = %w[
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

  def up
    TABLES.each do |table|
      add_column table, :region_id, :bigint unless column_exists?(table, :region_id)
    end

    TABLES.each do |table|
      add_index table, :region_id, algorithm: :concurrently unless index_exists?(table, :region_id)
    end

    TABLES.each do |table|
      unless foreign_key_exists?(table, :regions, column: :region_id)
        add_foreign_key table, :regions, column: :region_id, on_delete: :cascade, validate: false
      end
    end
  end

  def down
    TABLES.each do |table|
      if foreign_key_exists?(table, :regions, column: :region_id)
        remove_foreign_key table, column: :region_id
      end
    end

    TABLES.each do |table|
      if index_exists?(table, :region_id)
        remove_index table, :region_id
      end
    end

    TABLES.each do |table|
      if column_exists?(table, :region_id)
        remove_column table, :region_id
      end
    end
  end
end
