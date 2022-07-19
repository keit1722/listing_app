require 'rails_helper'

RSpec.describe '組織登録申請', type: :system do
  let(:user) { create(:general_user, :activated) }

  before { login_as user }

  describe '登録申請' do
    context '入力情報が正しい場合' do
      it '申請できること' do
        visit new_mypage_organization_registration_path
        fill_in '会社名・屋号', with: 'サンプル株式会社'
        fill_in '住所', with: 'サンプル住所'
        fill_in '電話番号', with: '0120123456'
        fill_in '事業内容', with: 'サンプル事業内容'
        click_button '申請する'

        expect(
          page
        ).to have_content '組織登録の申請をしました。結果が出るまで今しばらくお待ちください。'
      end
    end

    context '入力情報が誤っている場合' do
      it '申請できないこと' do
        visit new_mypage_organization_registration_path
        fill_in '会社名・屋号', with: ''
        fill_in '住所', with: ''
        fill_in '電話番号', with: ''
        fill_in '事業内容', with: ''
        click_button '申請する'

        expect(page).to have_content '組織登録の申請ができませんでした'
      end
    end
  end

  describe '登録申請内容詳細' do
    let!(:organization_registration) do
      create(:organization_registration, user: user)
    end

    context '承認された申請の場合' do
      it '本登録へ進むことができる' do
        create(
          :organization_registration_status_accepted,
          organization_registration: organization_registration
        )
        visit mypage_organization_registration_path(organization_registration)
        expect(page).to have_content '本登録へ進む'
      end
    end

    context '否認された申請の場合' do
      it '本登録へ進むことができない' do
        create(
          :organization_registration_status_rejected,
          organization_registration: organization_registration
        )
        visit mypage_organization_registration_path(organization_registration)
        expect(page).not_to have_content '本登録へ進む'
      end
    end

    context '回答されていない申請の場合' do
      it '本登録へ進むことができない' do
        visit mypage_organization_registration_path(organization_registration)
        expect(page).not_to have_content '本登録へ進む'
      end
    end
  end
end
