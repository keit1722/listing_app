class SearchRestaurantsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string

  def search
    scope = Restaurant.distinct
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
end
