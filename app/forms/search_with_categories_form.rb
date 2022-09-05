class SearchWithCategoriesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :keyword, :string
  attribute :category_ids, array: :integer
  attribute :area_groups, array: :integer
  attribute :model, :string

  def search
    scope = model.classify.safe_constantize.distinct

    scope = scope.search_with_category(category_ids_to_integer)

    scope = scope.search_with_district(area_groups_to_district_ids)

    if keyword.present?
      scope =
        splited_keywords
          .map do |splited_keyword|
            scope.keyword_contain(pluralized_model, splited_keyword)
          end
          .inject { |result, scp| result.or(scp) }
    end
    scope
  end

  private

  def pluralized_model
    model.pluralize
  end

  def splited_keywords
    keyword.split(/[[:blank:]]+/)
  end

  def category_ids_to_integer
    if category_ids.include?('all')
      "#{model}_categories".classify.safe_constantize.ids
    else
      category_ids.map(&:to_i)
    end
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
      selected_districts = selected_area_groups.pluck(:grouped).flatten
      District.where(name: selected_districts).pluck(:id)
    end
  end
end
