class SearchHomeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string
  attribute :area, :string
  attribute :category, :string

  def search
    scope = identified_model.distinct

    scope = scope.search_with_district(area_group_to_district_ids)

    scope =
      splited_keywords
        .map { |splited_keyword| scope.keyword_contain(splited_keyword) }
        .inject { |result, scp| result.or(scp) } if keyword.present?
    scope
  end

  private

  def identified_model
    category.classify.safe_constantize
  end

  def splited_keywords
    keyword.split(/[[:blank:]]+/)
  end

  def area_group_to_district_ids
    if area.empty?
      District.ids
    else
      selected_area =
        Constants::AREA_GROUPS.select { |area_group| area_group[:area] == area }
      selected_districts = selected_area.first[:grouped]
      District.where(name: selected_districts).pluck(:id)
    end
  end
end
