class ShopCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :shop,
                :opening_hours,
                :district_id,
                :shop_category_ids,
                :reservation_link,
                :page_show

  validates :district_id, presence: true
  validates :shop_category_ids, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.shop = organization.shops.build if shop.blank?
    self.district_id = params[:district_id]
    self.shop_category_ids = params[:shop_category_ids]&.reject(&:empty?)
    self.reservation_link = ReservationLink.new if reservation_link.blank?
    self.page_show = PageShow.new if page_show.blank?
    return if opening_hours.present?

    self.opening_hours = Array.new(DAY_COUNT) { OpeningHour.new }
  end

  def shop_attributes=(attributes)
    self.shop = @organization.shops.build(attributes)
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

  def page_show_attributes=(attributes)
    self.page_show = PageShow.new(attributes)
  end

  def save
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
    shop.district_ids = district_id.to_i unless district_id.empty?
    shop.shop_category_ids = shop_category_ids.reject(&:empty?)&.map(&:to_i)
    reservation_link.reservation_linkable = shop
    page_show.page_showable = shop
    opening_hours.each { |opening_hour| opening_hour.opening_hourable = shop }
  end

  def valid?
    super
    [
      shop.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?
    ].all?
  end
end
