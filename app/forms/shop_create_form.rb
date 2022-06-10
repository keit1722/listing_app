class ShopCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :shop, :opening_hours, :district_id, :shop_category_ids

  validates :district_id, presence: true
  validates :shop_category_ids, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.shop = organization.shops.build unless shop.present?
    self.district_id = params[:district_id]
    self.shop_category_ids = params[:shop_category_ids]&.reject(&:empty?)
    self.opening_hours =
      DAY_COUNT.times.map { OpeningHour.new } unless opening_hours.present?
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

  def save
    build_asscociations

    return false unless valid?

    ActiveRecord::Base.transaction do
      shop.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_asscociations
    shop.district_ids = district_id.to_i unless district_id.empty?
    shop.shop_category_ids = shop_category_ids.reject(&:empty?)&.map(&:to_i)
    opening_hours.each { |opening_hour| opening_hour.opening_hourable = shop }
  end

  def valid?
    super
    [shop.valid?, opening_hours.map(&:valid?).all?].all?
  end
end
