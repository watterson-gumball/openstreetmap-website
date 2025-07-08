# == Schema Information
#
# Table name: current_way_tags
#
#  way_id    :bigint           not null, primary key
#  k         :string           default(""), not null, primary key
#  v         :string           default(""), not null
#  region_id :bigint
#
# Indexes
#
#  index_current_way_tags_on_region_id  (region_id)
#
# Foreign Keys
#
#  current_way_tags_id_fkey  (way_id => current_ways.id)
#  fk_rails_...              (region_id => regions.id) ON DELETE => cascade
#

class WayTag < ApplicationRecord
  self.table_name = "current_way_tags"

  belongs_to :way

  validates :way, :associated => true
  validates :k, :v, :allow_blank => true, :length => { :maximum => 255 }, :characters => true
  validates :k, :uniqueness => { :scope => :way_id }
end
