require 'rails_helper'

RSpec.describe 'お知らせ', type: :system do
  let(:user_admin) { create(:pvsuwimvsuoitmucvyku_user, :activated) }
  let(:user_business) { create(:business_user, :activated) }
  let(:user_general) { create(:general_user, :activated) }
  let!(:announcement_published) do
    create(:announcement_published, poster_id: user_admin.id)
  end
  let!(:announcement_draft) do
    create(:announcement_draft, poster_id: user_admin.id)
  end

  describe 'お知らせ作成ページ表示' do
    context '管理者の場合' do
      it 'ページを表示できる' do
        pvsuwimvsuoitmucvyku_login_as user_admin
        visit new_pvsuwimvsuoitmucvyku_announcement_path
        expect(
          page,
        ).to have_current_path new_pvsuwimvsuoitmucvyku_announcement_path
      end
    end

    context 'ビジネスユーザの場合' do
      it 'ページを表示できない' do
        pvsuwimvsuoitmucvyku_login_as user_business
        visit new_pvsuwimvsuoitmucvyku_announcement_path
        expect(page).to (
          have_current_path root_path
        ).and have_content '管理者専用の機能です'
      end
    end

    context '一般ユーザの場合' do
      it 'ページを表示できない' do
        pvsuwimvsuoitmucvyku_login_as user_general
        visit new_pvsuwimvsuoitmucvyku_announcement_path
        expect(page).to (
          have_current_path root_path
        ).and have_content '管理者専用の機能です'
      end
    end
  end

  describe 'お知らせの新規作成' do
    before { pvsuwimvsuoitmucvyku_login_as user_admin }

    context '入力が正しい場合' do
      it 'お知らせが作成される' do
        visit new_pvsuwimvsuoitmucvyku_announcement_path
        fill_in 'タイトル', with: 'サンプルタイトル'
        fill_in '内容', with: 'サンプル内容'
        find('#announcement_status_chosen').click
        find('#announcement_status_chosen .active-result', text: '公開').click
        click_button '登録する'

        expect(
          page,
        ).to have_current_path pvsuwimvsuoitmucvyku_announcements_path
        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルタイトル'
      end
    end
  end

  describe 'お知らせの編集' do
    before { pvsuwimvsuoitmucvyku_login_as user_admin }

    context '入力が正しい場合' do
      it 'お知らせが編集される' do
        visit edit_pvsuwimvsuoitmucvyku_announcement_path(
                announcement_published,
              )
        fill_in 'タイトル', with: 'サンプル編集後タイトル'
        fill_in '内容', with: 'サンプル編集後内容'
        find('#announcement_status_chosen').click
        find('#announcement_status_chosen .active-result', text: '公開').click
        click_button '更新する'

        expect(
          page,
        ).to have_current_path pvsuwimvsuoitmucvyku_announcement_path(
                            announcement_published,
                          )
        expect(page).to have_content '更新しました'
        expect(page).to have_content 'サンプル編集後タイトル'
      end
    end
  end

  describe '一覧ページ' do
    context '公開用の一覧ページの場合' do
      it '下書きのお知らせはページに表示されない' do
        visit announcements_path
        expect(page).to have_content announcement_published.title
        expect(page).not_to have_content announcement_draft.title
      end
    end

    context '管理者用の一覧ページの場合' do
      it '下書きのお知らせはページに表示される' do
        pvsuwimvsuoitmucvyku_login_as user_admin
        visit pvsuwimvsuoitmucvyku_announcements_path
        expect(page).to have_content announcement_published.title
        expect(page).to have_content announcement_draft.title
      end
    end
  end

  describe 'お知らせ詳細ページ' do
    context '公開済みのお知らせの場合' do
      it '詳細ページが表示される' do
        visit announcement_path(announcement_published)
        expect(page).to have_current_path announcement_path(
                            announcement_published,
                          )
      end
    end

    context '下書きのお知らせの場合' do
      it '詳細ページが表示されない' do
        Capybara.raise_server_errors = false
        visit announcement_path(announcement_draft)
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end
  end
end
