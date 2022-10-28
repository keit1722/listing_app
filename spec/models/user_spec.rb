require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '名字は必須であること' do
      user = build(:general_user, last_name: nil)
      user.valid?
      expect(user.errors[:last_name]).to include('を入力してください')
    end

    it '名前は必須であること' do
      user = build(:general_user, first_name: nil)
      user.valid?
      expect(user.errors[:first_name]).to include('を入力してください')
    end

    it 'メールアドレスは必須であること' do
      user = build(:general_user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
      expect(user.errors[:email]).to include('は不正な値です')
    end

    it 'メールアドレスは一意であること' do
      user = create(:general_user)
      same_email_user = build(:general_user, email: user.email)
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end

    it 'パスワードは6文字以上であること' do
      user =
        build(:general_user, password: '12345', password_confirmation: '12345')
      user.valid?
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
  end

  describe 'インスタンスメソッド' do
    let(:organization) { create(:organization) }
    let(:user) do
      create(:business_user, :activated, organizations: [organization])
    end

    it 'resign' do
      user.resign(organization)
      expect(user.organizations).to be_empty
    end

    it 'create_incoming_email_model' do
      other_user = create(:general_user)
      expect(other_user.incoming_email).to be_present
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  access_count_to_reset_password_page :integer          default(0)
#  activation_state                    :string
#  activation_token                    :string
#  activation_token_expires_at         :datetime
#  crypted_password                    :string
#  email                               :string           not null
#  first_name                          :string           not null
#  last_name                           :string           not null
#  public_uid                          :string
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string
#  reset_password_token_expires_at     :datetime
#  role                                :integer          default("general"), not null
#  salt                                :string
#  username                            :string           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
# Indexes
#
#  index_users_on_activation_token      (activation_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_public_uid            (public_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token)
#
