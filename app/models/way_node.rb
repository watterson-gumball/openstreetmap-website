# == Schema Information
#
# Table name: current_way_nodes
#
#  way_id        :bigint           not null, primary key
#  node_id       :bigint           not null
#  sequence_id   :bigint           not null, primary key
#  region_id     :bigint
#  timeline_date :string
#
# Indexes
#
#  current_way_nodes_node_idx                (node_id)
#  index_current_way_nodes_on_region_id      (region_id)
#  index_current_way_nodes_on_timeline_date  (timeline_date)
#
# Foreign Keys
#
#  current_way_nodes_id_fkey       (way_id => current_ways.id)
#  current_way_nodes_node_id_fkey  (node_id => current_nodes.id)
#  fk_rails_...                    (region_id => regions.id) ON DELETE => cascade
#

class WayNode < ApplicationRecord
  self.table_name = "current_way_nodes"

  belongs_to :way
  belongs_to :node
end
