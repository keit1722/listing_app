class HotSpringUpdateForm
  include ActiveModel::Model

  attr_accessor :hot_spring, :opening_hours, :district_id

  validates :district_id, presence: true

  def initialize(hot_spring, params = {})
    @hot_spring = hot_spring

    self.district_id = @hot_spring.district_ids
    self.opening_hours = @hot_spring.opening_hours.early

    super params
  end

  def hot_spring_attributes=(attributes)
    @hot_spring.assign_attributes(attributes)
  end

  def opening_hours_attributes=(attributes)
    attributes.each do |k, attribute|
      opening_hours[k.to_i].assign_attributes(attribute)
    end
  end

  def update
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction do
      hot_spring.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    @hot_spring.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [@hot_spring.valid?, opening_hours.map(&:valid?).all?].all?
  end
end
