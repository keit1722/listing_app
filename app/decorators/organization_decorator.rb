class OrganizationDecorator < ApplicationDecorator
  delegate_all

  def arranged_users
    object.users.map { |user| user.decorate.full_name }.join(' / ')
  end
end
