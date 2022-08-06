require 'rails_helper'

RSpec.describe OrganizationInvitation, type: :model do
  let(:business_user) { create(:business_user, :activated) }
  let(:general_user) { create(:general_user, :activated) }
  let(:organization) { create(:organization, users: [business_user]) }

  describe 'バリデーション' do
    it 'メールアドレスは必須であること' do
      organization_invitation =
        build(:organization_invitation, email: nil, organization: organization)
      organization_invitation.valid?
      expect(organization_invitation.errors[:email]).to include(
        'を入力してください'
      )
    end

    it '既に組織に所属しているユーザは招待できないこと' do
      another_business_user = create(:business_user, :activated)
      organization.users << another_business_user
      organization_invitation =
        build(
          :organization_invitation,
          email: another_business_user.email,
          organization: organization
        )
      organization_invitation.valid?
      expect(organization_invitation.errors[:email]).to include(
        'を利用しているユーザーは既にメンバーです。'
      )
    end
  end

  describe 'インスタンスメソッド' do
    let(:organization_invitation) do
      create(
        :organization_invitation,
        organization: organization,
        inviter_id: business_user.id,
        email: general_user.email
      )
    end

    describe 'create_notice' do
      context 'メールアドレスを持つユーザが見つからない場合' do
        it '通知を送らないこと' do
          failed_organization_invitation =
            create(
              :organization_invitation,
              organization: organization,
              inviter_id: business_user.id,
              email: Faker::Internet.unique.email
            )
          expect(failed_organization_invitation.create_notice).to be_nil
        end
      end

      context 'メールアドレスを持つユーザが見つかる場合' do
        it '通知を送ること' do
          expect { organization_invitation.create_notice }.to change(
            Notice,
            :count
          ).by(1).and have_enqueued_mail(NoticeMailer, :organization_invitation)
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: organization_invitations
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  expires_at      :datetime         not null
#  status          :integer          default("untouched"), not null
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  inviter_id      :integer          not null
#  organization_id :bigint
#
# Indexes
#
#  index_organization_invitations_on_organization_id  (organization_id)
#  index_organization_invitations_on_token            (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
