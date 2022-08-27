require 'rails_helper'

RSpec.describe 'ユーザー', type: :system do
  let!(:general_user) { create(:general_user, :activated) }
  let(:pvsuwimvsuoitmucvyku_user) do
    create(:pvsuwimvsuoitmucvyku_user, :activated)
  end
  let(:business_user) { create(:business_user, :activated) }

  describe 'ユーザ一覧表示' do
    context '管理者の場合' do
      it 'ユーザ一覧ページが表示される' do
        pvsuwimvsuoitmucvyku_login_as pvsuwimvsuoitmucvyku_user
        visit pvsuwimvsuoitmucvyku_users_path
        expect(page).to have_content general_user.decorate.full_name
        expect(page).to have_content pvsuwimvsuoitmucvyku_user.decorate
                       .full_name
      end
    end

    context 'ビジネスユーザの場合' do
      it 'ユーザの一覧ページが表示されない' do
        pvsuwimvsuoitmucvyku_login_as business_user
        visit pvsuwimvsuoitmucvyku_users_path
        expect(page).to have_current_path root_path
        expect(page).to have_content '管理者専用の機能です'
      end
    end
  end

  describe 'ユーザー情報の詳細表示' do
    context '管理者の場合' do
      it '自分以外のユーザーの登録情報を表示できる' do
        pvsuwimvsuoitmucvyku_login_as pvsuwimvsuoitmucvyku_user
        visit pvsuwimvsuoitmucvyku_user_path(general_user)
        expect(page).to have_content general_user.last_name
        expect(page).to have_content general_user.first_name
        expect(page).to have_content general_user.username
        expect(page).to have_content general_user.email
        expect(page).to have_content general_user.role_i18n
      end
    end
  end

  describe 'パスワード再設定' do
    it 'パスワードを忘れた場合の処理をするとメールが送られること' do
      visit new_password_reset_path
      fill_in 'メールアドレス', with: general_user.email
      perform_enqueued_jobs { click_button '送信' }
      mail = ActionMailer::Base.deliveries.last

      expect(mail.to.first).to eq general_user.email
      expect(mail.subject).to eq 'パスワード再設定メール'
    end
  end
end
