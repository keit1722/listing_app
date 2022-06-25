module Postable
  extend ActiveSupport::Concern

  included { has_many :posts, as: :postable, dependent: :destroy }
end
