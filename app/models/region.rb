# == Schema Information
#
# Table name: regions
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_regions_on_name  (name) UNIQUE
#
class Region < ApplicationRecord
  def self.default
    find_by!(name: "yerevan")
  end
end
