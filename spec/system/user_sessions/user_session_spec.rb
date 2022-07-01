require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  let(:user) { create(:general_user) }

  describe 'ログイン' do
    context '認証情報が正しい場合' do
      it 'ログインできること' do
        user.activate!
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        click_button 'ログイン'
        expect(page).to have_current_path root_path
        expect(page).to have_content 'ログインしました'
      end
    end

    context '認証情報に誤りがある場合' do
      it 'ログインできないこと' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '1234'
        click_button 'ログイン'
        expect(page).to have_current_path login_path
        expect(page).to have_content 'ログインできませんでした'
      end
    end
  end

  describe 'ログアウト' do
    before { login }

    it 'ログアウトできること' do
      find('div.user-menu').click
      click_link 'ログアウト'
      expect(page).to have_current_path root_path
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
