class SkiAreaCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :ski_area, :opening_hours, :district_id

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.ski_area = organization.ski_areas.build unless ski_area.present?
    self.district_id = params[:district_id]
    self.opening_hours =
      DAY_COUNT.times.map { OpeningHour.new } unless opening_hours.present?
  end

  def ski_area_attributes=(attributes)
    self.ski_area = @organization.ski_areas.build(attributes)
  end

  def opening_hours_attributes=(attributes)
    self.opening_hours =
      attributes.map do |_, opening_hours_attributes|
        OpeningHour.new(opening_hours_attributes)
      end
  end

  def save
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction do
      ski_area.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    ski_area.district_ids = district_id.to_i unless district_id.empty?
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = ski_area
    end
  end

  def valid?
    super
    [ski_area.valid?, opening_hours.map(&:valid?).all?].all?
  end
end
