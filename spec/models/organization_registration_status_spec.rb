require 'rails_helper'

RSpec.describe OrganizationRegistrationStatus, type: :model do
  let(:general_user) { create(:general_user, :activated) }
  let(:organization_registration) do
    create(:organization_registration, user: general_user)
  end

  describe 'バリデーション' do
    it 'statusが必要なこと' do
      organization_registration_status =
        build(
          :organization_registration_status,
          organization_registration:
        )
      organization_registration_status.valid?
      expect(organization_registration_status.errors[:status]).to include(
        'を入力してください'
      )
    end
  end
end

# == Schema Information
#
# Table name: organization_registration_statuses
#
#  id                           :bigint           not null, primary key
#  status                       :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  organization_registration_id :bigint
#
# Indexes
#
#  index_org_registration_statuses_on_org_registration_id  (organization_registration_id)
#
