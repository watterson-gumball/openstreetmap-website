# == Schema Information
#
# Table name: current_node_tags
#
#  node_id   :bigint           not null, primary key
#  k         :string           default(""), not null, primary key
#  v         :string           default(""), not null
#  region_id :bigint
#
# Indexes
#
#  index_current_node_tags_on_region_id  (region_id)
#
# Foreign Keys
#
#  current_node_tags_id_fkey  (node_id => current_nodes.id)
#  fk_rails_...               (region_id => regions.id) ON DELETE => cascade
#

class NodeTag < ApplicationRecord
  self.table_name = "current_node_tags"

  belongs_to :node

  validates :node, :associated => true
  validates :k, :v, :allow_blank => true, :length => { :maximum => 255 }, :characters => true
  validates :k, :uniqueness => { :scope => :node_id }
end
