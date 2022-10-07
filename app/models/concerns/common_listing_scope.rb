module CommonListingScope
  extend ActiveSupport::Concern

  included do
    scope :search_with_district,
          lambda { |district_ids|
            joins(:districts).where(districts: { id: district_ids })
          }

    scope :keyword_contain,
          lambda { |model, keyword|
            where(
              [
                "description LIKE(?) OR #{model}.name LIKE(?)",
                "%#{keyword}%",
                "%#{keyword}%"
              ]
            )
          }
  end
end
