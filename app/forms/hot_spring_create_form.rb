class HotSpringCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :hot_spring, :opening_hours, :district_id, :reservation_link

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.hot_spring = organization.hot_springs.build if hot_spring.blank?
    self.district_id = params[:district_id]
    self.reservation_link = ReservationLink.new if reservation_link.blank?
    return if opening_hours.present?

    self.opening_hours = Array.new(DAY_COUNT) { OpeningHour.new }
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

  def reservation_link_attributes=(attributes)
    self.reservation_link = ReservationLink.new(attributes)
  end

  def save
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction do
      hot_spring.save!
      reservation_link.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    hot_spring.district_ids = district_id.to_i unless district_id.empty?
    reservation_link.reservation_linkable = hot_spring
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = hot_spring
    end
  end

  def valid?
    super
    [
      hot_spring.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
