class ListingsDecorator < ApplicationDecorator
  def format_description
    helpers.safe_join(object.description.split("\n"), helpers.tag(:br))
  end
end
