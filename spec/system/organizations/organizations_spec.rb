require 'rails_helper'

RSpec.describe '組織CRUD機能', type: :system do
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }

  before { driven_by(:rack_test) }

  describe '組織新規登録' do
    context 'ビジネスユーザーではない場合' do
      before { login }

      it '登録フォームに進めないこと' do
        visit new_organization_path
        expect(page).to have_current_path root_path
        expect(page).to have_content 'ビジネスユーザー専用の機能です'
      end
    end

    context 'ビジネスユーザーの場合' do
      before { login_as user_a }

      it '登録フォームに進めること' do
        visit new_organization_path
        expect(page).to have_current_path new_organization_path
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
      expect { visit organization_path organization_b }.to raise_error(
        ActiveRecord::RecordNotFound
      )
    end
  end

  describe '組織編集画面表示' do
    before { login_as user_a }

    it '自分の組織は表示される' do
      visit edit_organization_path organization_a
      expect(page).to have_current_path edit_organization_path organization_a
    end

    it '自分の組織以外は表示されないこと' do
      expect { visit edit_organization_path organization_b }.to raise_error(
        ActiveRecord::RecordNotFound
      )
    end
  end
end
