require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '名字は必須であること' do
      user = build(:user, last_name: nil)
      user.valid?
      expect(user.errors[:last_name]).to include('を入力してください')
    end

    it '名前は必須であること' do
      user = build(:user, first_name: nil)
      user.valid?
      expect(user.errors[:first_name]).to include('を入力してください')
    end

    it 'ユーザーネームは必須であること' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'ユーザーネームは一意であること' do
      user = create(:user)
      same_name_user = build(:user, username: user.username)
      same_name_user.valid?
      expect(same_name_user.errors[:username]).to include('はすでに存在します')
    end

    it 'メールアドレスは必須であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
      expect(user.errors[:email]).to include('は不正な値です')
    end

    it 'メールアドレスは一意であること' do
      user = create(:user)
      same_email_user = build(:user, email: user.email)
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end
  end
end
