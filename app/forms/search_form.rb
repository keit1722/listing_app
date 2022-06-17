class SearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string
  attribute :area_groups, array: :integer
  attribute :model, :string

  def search
    scope = model.classify.safe_constantize.distinct

    scope = scope.search_with_district(area_groups_to_district_ids)

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

  def area_groups_to_district_ids
    if area_groups.include?('all')
      District.ids
    else
      selected_area_groups =
        area_groups.map do |selected_area_group|
          Constants::AREA_GROUPS.select do |area_group|
            area_group[:area] == selected_area_group
          end
        end.flatten
      selected_districts =
        selected_area_groups.map do |selected_area_group|
          selected_area_group[:grouped]
        end.flatten
      District.where(name: selected_districts).pluck(:id)
    end
  end
end
