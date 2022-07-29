class AnnouncementDecorator < ApplicationDecorator
  delegate_all

  def truncate_body(num)
    helpers.strip_tags(object.body).truncate(num)
  end

  def format_body
    helpers.safe_join(object.body.split("\n"), helpers.tag(:br))
  end
end
