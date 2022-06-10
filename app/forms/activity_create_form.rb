class ActivityCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :activity, :opening_hours, :district_id, :reservation_link

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.activity = organization.activities.build unless activity.present?
    self.district_id = params[:district_id]
    self.reservation_link = ReservationLink.new unless reservation_link.present?
    self.opening_hours =
      DAY_COUNT.times.map { OpeningHour.new } unless opening_hours.present?
  end

  def activity_attributes=(attributes)
    self.activity = @organization.activities.build(attributes)
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
    build_asscociations

    return false unless valid?

    ActiveRecord::Base.transaction do
      activity.save!
      reservation_link.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_asscociations
    activity.district_ids = district_id.to_i unless district_id.empty?
    reservation_link.reservation_linkable = activity
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = activity
    end
  end

  def valid?
    super
    [
      activity.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
