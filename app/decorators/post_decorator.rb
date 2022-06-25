class PostDecorator < ApplicationDecorator
  delegate_all

  def truncate_body(num)
    ActionController::Base.helpers.strip_tags(object.body).truncate(num)
  end

  def format_body
    ActionController::Base.helpers.safe_join(
      object.body.split("\n"),
      ActionController::Base.helpers.tag(:br)
    )
  end

  def format_created_at
    object.created_at.strftime('%Y/%m/%d %H:%M')
  end
end
