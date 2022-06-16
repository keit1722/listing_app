class SearchRestaurantsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string
  attribute :category_ids, array: :integer

  def search
    scope = Restaurant.distinct

    scope = scope.search_with_category(category_ids_to_integer)

    scope =
      splited_keywords
        .map { |splited_keyword| scope.keyword_contain(splited_keyword) }
        .inject { |result, scp| result.or(scp) } if keyword.present?
    scope
  end

  private

  def splited_keywords
    keyword.split(/[[:blank:]]+/)
  end

  def category_ids_to_integer
    if category_ids.include?('all')
      RestaurantCategory.ids
    else
      category_ids.map(&:to_i)
    end
  end
end
