require 'rails_helper'

RSpec.describe OrganizationRegistration, type: :model do
  let(:general_user) { create(:general_user, :activated) }

  describe 'バリデーション' do
    it '組織名が必要なこと' do
      organization_registration =
        build(
          :organization_registration,
          organization_name: nil,
          user: general_user
        )
      organization_registration.valid?
      expect(organization_registration.errors[:organization_name]).to include(
        'を入力してください'
      )
    end

    it '住所が必要なこと' do
      organization_registration =
        build(
          :organization_registration,
          organization_address: nil,
          user: general_user
        )
      organization_registration.valid?
      expect(
        organization_registration.errors[:organization_address]
      ).to include('を入力してください')
    end

    it '電話番号が必要なこと' do
      organization_registration =
        build(
          :organization_registration,
          organization_phone: nil,
          user: general_user
        )
      organization_registration.valid?
      expect(organization_registration.errors[:organization_phone]).to include(
        'を入力してください'
      )
    end

    it '電話番号は半角数字であること' do
      organization_registration =
        build(
          :organization_registration,
          organization_phone: '０１２０００００００',
          user: general_user
        )
      organization_registration.valid?
      expect(organization_registration.errors[:organization_phone]).to include(
        'は数値で入力してください'
      )
    end

    it '電話番号はハイフンが不要であること' do
      organization_registration =
        build(
          :organization_registration,
          organization_phone: '0120-000-000',
          user: general_user
        )
      organization_registration.valid?
      expect(organization_registration.errors[:organization_phone]).to include(
        'は数値で入力してください'
      )
    end

    it '事業内容が必要なこと' do
      organization_registration =
        build(
          :organization_registration,
          business_detail: nil,
          user: general_user
        )
      organization_registration.valid?
      expect(organization_registration.errors[:business_detail]).to include(
        'を入力してください'
      )
    end

    it '登録済みの組織名は使えないこと' do
      business_user = create(:business_user, :activated)
      organization = create(:organization, users: [business_user])

      organization_registration =
        build(
          :organization_registration,
          organization_name: organization.name,
          user: general_user
        )
      organization_registration.valid?
      expect(organization_registration.errors[:organization_name]).to include(
        'は既に利用されています。別のものをご入力ください。'
      )
    end
  end

  describe 'スコープ' do
    describe 'accepted' do
      subject(:accepted) { described_class.accepted }

      let(:organization_registration_accepted_a) do
        create(:organization_registration, user: general_user)
      end
      let(:organization_registration_accepted_b) do
        create(:organization_registration, user: general_user)
      end
      let(:organization_registration_rejected) do
        create(:organization_registration, user: general_user)
      end

      it do
        create(
          :organization_registration_status_accepted,
          organization_registration: organization_registration_accepted_a
        )
        expect(accepted).to include organization_registration_accepted_a
      end

      it do
        create(
          :organization_registration_status_accepted,
          organization_registration: organization_registration_accepted_b
        )
        expect(accepted).to include organization_registration_accepted_b
      end

      it do
        create(
          :organization_registration_status_rejected,
          organization_registration: organization_registration_rejected
        )
        expect(accepted).not_to include organization_registration_rejected
      end
    end
  end

  describe 'インスタンスメソッド' do
    describe 'create_token' do
      context 'createアクションを行う場合' do
        it 'トークンが作成される' do
          organization_registration =
            create(:organization_registration, user: general_user)
          expect(organization_registration.token).not_to be_nil
        end
      end

      context 'createアクションを行わない場合' do
        it 'トークンは作成されない' do
          organization_registration =
            build(:organization_registration, user: general_user)
          expect(organization_registration.token).to be_nil
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: organization_registrations
#
#  id                   :bigint           not null, primary key
#  business_detail      :text             not null
#  organization_address :string           not null
#  organization_name    :string           not null
#  organization_phone   :string           not null
#  token                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint
#
# Indexes
#
#  index_organization_registrations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
