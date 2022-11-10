module PageShowableAssociation
  extend ActiveSupport::Concern

  included { has_one :page_show, as: :page_showable, dependent: :destroy }
end
