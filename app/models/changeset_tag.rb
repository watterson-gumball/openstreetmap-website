# == Schema Information
#
# Table name: changeset_tags
#
#  changeset_id :bigint           not null, primary key
#  k            :string           default(""), not null, primary key
#  v            :string           default(""), not null
#  region_id    :bigint
#
# Indexes
#
#  index_changeset_tags_on_region_id  (region_id)
#
# Foreign Keys
#
#  changeset_tags_id_fkey  (changeset_id => changesets.id)
#  fk_rails_...            (region_id => regions.id) ON DELETE => cascade
#

class ChangesetTag < ApplicationRecord
  belongs_to :changeset

  validates :changeset, :associated => true
  validates :k, :v, :allow_blank => true, :length => { :maximum => 255 }, :characters => true
  validates :k, :uniqueness => { :scope => :changeset_id }
end
