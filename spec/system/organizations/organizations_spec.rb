require 'rails_helper'

RSpec.describe '組織', type: :system do
  let!(:user_a) { create(:business_user, :activated) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:user_b) { create(:business_user, :activated) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let(:user_general) { create(:general_user, :activated) }

  describe '組織新規登録' do
    context 'ビジネスユーザーではない場合' do
      it '登録フォームに進めないこと' do
        login_as user_general
        visit new_organization_path
        expect(page).to have_current_path root_path
        expect(page).to have_content 'ビジネスユーザー専用の機能です'
      end
    end

    context 'ビジネスユーザーの場合' do
      it '登録フォームに進めること' do
        organization_registration =
          create(:organization_registration, user: user_a)
        create(
          :organization_registration_status_accepted,
          organization_registration: organization_registration
        )
        login_as user_a
        visit new_organization_path(token: organization_registration.token)
        expect(page).to have_current_path new_organization_path(
          token: organization_registration.token
        )
      end
    end
  end

  describe '組織一覧表示' do
    before { login_as user_a }

    it '自分の組織だけが表示されること' do
      visit organizations_path
      expect(page).to have_content organization_a.name
      expect(page).not_to have_content organization_b.name
    end
  end

  describe '組織詳細表示' do
    before { login_as user_a }

    it '自分の組織は表示される' do
      visit organization_path organization_a
      expect(page).to have_current_path organization_path organization_a
    end

    it '自分の組織以外は表示されない' do
      Capybara.raise_server_errors = false
      visit organization_path organization_b
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end

  describe '組織編集画面表示' do
    before { login_as user_a }

    it '自分の組織は表示される' do
      visit edit_organization_path organization_a
      expect(page).to have_current_path edit_organization_path organization_a
    end

    it '自分の組織以外は表示されないこと' do
      Capybara.raise_server_errors = false
      visit edit_organization_path organization_b
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end
end
