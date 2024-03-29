class ShopUpdateForm
  include ActiveModel::Model

  attr_accessor :shop,
                :opening_hours,
                :district_id,
                :shop_category_ids,
                :reservation_link,
                :page_show

  validates :district_id, presence: true
  validates :shop_category_ids, presence: true

  def initialize(shop, params = {})
    @shop = shop

    self.district_id = @shop.district_ids
    self.shop_category_ids = @shop.shop_category_ids
    self.reservation_link = @shop.reservation_link
    self.opening_hours = @shop.opening_hours.early
    self.page_show = @shop.page_show

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
      shop.save!
      reservation_link.save!
      page_show.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associations
    @shop.district_ids = district_id.to_i unless district_id.empty?
    @shop.shop_category_ids = shop_category_ids.reject(&:empty?)&.map(&:to_i)
  end

  def valid?
    super
    [
      @shop.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?
    ].all?
  end
end
