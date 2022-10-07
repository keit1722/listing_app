class SkiAreaUpdateForm
  include ActiveModel::Model

  attr_accessor :ski_area,
                :district_id,
                :reservation_link,
                :opening_hours,
                :page_show

  validates :district_id, presence: true

  def initialize(ski_area, params = {})
    @ski_area = ski_area

    self.district_id = @ski_area.district_ids
    self.reservation_link = @ski_area.reservation_link
    self.opening_hours = @ski_area.opening_hours.early
    self.page_show = @ski_area.page_show

    super params
  end

  def ski_area_attributes=(attributes)
    @ski_area.assign_attributes(attributes)
  end

  def opening_hours_attributes=(attributes)
    attributes.each do |k, attribute|
      opening_hours[k.to_i].assign_attributes(attribute)
    end
  end

  def reservation_link_attributes=(attributes)
    reservation_link.assign_attributes(attributes)
  end

  def page_show_attributes=(attributes)
    page_show.assign_attributes(attributes)
  end

  def update
    build_associations

    return false unless valid?

    ActiveRecord::Base.transaction do
      ski_area.save!
      reservation_link.save!
      page_show.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associations
    @ski_area.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [
      @ski_area.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?
    ].all?
  end
end
