class AddTimelineDateToNodes < ActiveRecord::Migration[8.0]
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
      add_column table, :timeline_date, :string unless column_exists?(table, :timeline_date)
    end

    TABLES.each do |table|
      add_index table, :timeline_date, algorithm: :concurrently unless index_exists?(table, :timeline_date)
    end
  end

  def down
    TABLES.each do |table|
      if index_exists?(table, :timeline_date)
        remove_index table, :timeline_date
      end
    end

    TABLES.each do |table|
      if column_exists?(table, :timeline_date)
        remove_column table, :timeline_date
      end
    end
  end
end
