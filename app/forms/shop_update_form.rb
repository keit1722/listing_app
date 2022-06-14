class ShopUpdateForm
  include ActiveModel::Model

  attr_accessor :shop, :opening_hours, :district_id, :shop_category_ids

  validates :district_id, presence: true
  validates :shop_category_ids, presence: true

  def initialize(shop, params = {})
    @shop = shop

    self.district_id = @shop.district_ids
    self.shop_category_ids = @shop.shop_category_ids
    self.opening_hours = @shop.opening_hours.early

    super params
  end

  def shop_attributes=(attributes)
    @shop.assign_attributes(attributes)
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
      shop.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    @shop.district_ids = district_id.to_i unless district_id.empty?
    @shop.shop_category_ids = shop_category_ids.reject(&:empty?)&.map(&:to_i)
  end

  def valid?
    super
    [@shop.valid?, opening_hours.map(&:valid?).all?].all?
  end
end
