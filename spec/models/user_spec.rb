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
#  index_users_on_username              (username) UNIQUE
#
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

    it 'ユーザーネームは必須であること' do
      user = build(:general_user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'ユーザーネームは一意であること' do
      user = create(:general_user)
      same_name_user = build(:general_user, username: user.username)
      same_name_user.valid?
      expect(same_name_user.errors[:username]).to include('はすでに存在します')
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
  end

  describe 'スコープ' do
    describe 'not_admin' do
      let(:user_admin) { create(:admin_user, :activated) }
      let(:user_business) { create(:business_user, :activated) }
      let(:user_general) { create(:general_user, :activated) }

      it do
        expect(User.not_admin).not_to eq [
             user_admin,
             user_business,
             user_general,
           ]
      end
      it { expect(User.not_admin).to eq [user_business, user_general] }
    end
  end
end
