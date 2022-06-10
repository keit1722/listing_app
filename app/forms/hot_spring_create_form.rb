class HotSpringCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :hot_spring, :opening_hours, :district_id

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.hot_spring = organization.hot_springs.build unless hot_spring.present?
    self.district_id = params[:district_id]
    self.opening_hours =
      DAY_COUNT.times.map { OpeningHour.new } unless opening_hours.present?
  end

  def hot_spring_attributes=(attributes)
    self.hot_spring = @organization.hot_springs.build(attributes)
  end

  def opening_hours_attributes=(attributes)
    self.opening_hours =
      attributes.map do |_, opening_hours_attributes|
        OpeningHour.new(opening_hours_attributes)
      end
  end

  def save
    build_asscociations

    return false unless valid?

    ActiveRecord::Base.transaction do
      hot_spring.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_asscociations
    hot_spring.district_ids = district_id.to_i unless district_id.empty?
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = hot_spring
    end
  end

  def valid?
    super
    [hot_spring.valid?, opening_hours.map(&:valid?).all?].all?
  end
end
