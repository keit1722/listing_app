class NoticeDecorator < ApplicationDecorator
  delegate_all

  def format_created_at
    object.created_at.strftime('%Y/%m/%d')
  end
end
