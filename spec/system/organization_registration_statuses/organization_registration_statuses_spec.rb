require 'rails_helper'

RSpec.describe '組織登録申請結果', type: :system do
  let(:general_user) { create(:general_user, :activated) }
  let(:pvsuwimvsuoitmucvyku_user) do
    create(:pvsuwimvsuoitmucvyku_user, :activated)
  end
  let!(:organization_registration) do
    create(:organization_registration, user: general_user)
  end

  before { pvsuwimvsuoitmucvyku_login_as pvsuwimvsuoitmucvyku_user }

  describe '登録申請結果回答' do
    context '未回答の申請の場合' do
      it '承認・否認の回答ができる' do
        visit pvsuwimvsuoitmucvyku_organization_registration_path(
                organization_registration,
              )
        expect(page).to have_selector '.button-accepted'
        expect(page).to have_selector '.button-rejected'
      end
    end

    context '回答済みの申請の場合' do
      before do
        visit pvsuwimvsuoitmucvyku_organization_registration_path(
                organization_registration,
              )
        click_on '承認'
        page.accept_confirm
      end

      it '承認・否認ができない' do
        visit pvsuwimvsuoitmucvyku_organization_registration_path(
                organization_registration,
              )
        expect(page).not_to have_selector '.button-accepted'
        expect(page).not_to have_selector '.button-rejected'
      end
    end
  end

  describe '登録申請の回答' do
    it '承認することができる' do
      visit pvsuwimvsuoitmucvyku_organization_registration_path(
              organization_registration,
            )
      expect do
        find('.button-accepted').click
        page.accept_confirm
        expect(page).to have_content '申請の回答を作成しました'
      end.to change(OrganizationRegistrationStatus, :count).by(1)
      expect(
        organization_registration.organization_registration_status.status,
      ).to eq 'accepted'
    end

    it '否認することができる' do
      visit pvsuwimvsuoitmucvyku_organization_registration_path(
              organization_registration,
            )
      expect do
        find('.button-rejected').click
        page.accept_confirm
        expect(page).to have_content '申請の回答を作成しました'
      end.to change(OrganizationRegistrationStatus, :count).by(1)
      expect(
        organization_registration.organization_registration_status.status,
      ).to eq 'rejected'
    end
  end
end
