# == Schema Information
#
# Table name: current_relation_tags
#
#  relation_id   :bigint           not null, primary key
#  k             :string           default(""), not null, primary key
#  v             :string           default(""), not null
#  region_id     :bigint
#  timeline_date :string
#
# Indexes
#
#  index_current_relation_tags_on_region_id      (region_id)
#  index_current_relation_tags_on_timeline_date  (timeline_date)
#
# Foreign Keys
#
#  current_relation_tags_id_fkey  (relation_id => current_relations.id)
#  fk_rails_...                   (region_id => regions.id) ON DELETE => cascade
#

class RelationTag < ApplicationRecord
  self.table_name = "current_relation_tags"

  belongs_to :relation

  validates :relation, :associated => true
  validates :k, :v, :allow_blank => true, :length => { :maximum => 255 }, :characters => true
  validates :k, :uniqueness => { :scope => :relation_id }
end
