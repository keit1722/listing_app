module ReservationLinkable
  extend ActiveSupport::Concern

  included do
    has_one :reservation_link, as: :reservation_linkable, dependent: :destroy
  end
end
