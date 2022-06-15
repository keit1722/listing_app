class ApplicationDecorator < Draper::Decorator
  def format_description
    ActionController::Base.helpers.safe_join(
      object.description.split("\n"),
      ActionController::Base.helpers.tag(:br)
    )
  end
end
