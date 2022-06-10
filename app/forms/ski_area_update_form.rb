class SkiAreaUpdateForm
  include ActiveModel::Model

  attr_accessor :ski_area, :opening_hours, :district_id

  validates :district_id, presence: true

  def initialize(ski_area, params = {})
    @ski_area = ski_area

    self.district_id = @ski_area.district_ids
    self.opening_hours = @ski_area.opening_hours.early

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

  def update
    build_asscociations

    return false unless valid?

    ActiveRecord::Base.transaction do
      ski_area.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_asscociations
    @ski_area.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [@ski_area.valid?, opening_hours.map(&:valid?).all?].all?
  end
end
