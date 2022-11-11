module OpeningHourableAssociation
  extend ActiveSupport::Concern

  included do
    has_many :opening_hours, as: :opening_hourable, dependent: :destroy
  end
end
