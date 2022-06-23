module Districtable
  extend ActiveSupport::Concern

  included do
    has_many :district_mappings, as: :districtable, dependent: :destroy
    has_many :districts, through: :district_mappings
  end
end
