require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:photo_spot_a) do
    create(:photo_spot, organization: organization_a, districts: [district])
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:photo_spot_b) do
    create(:photo_spot, organization: organization_b, districts: [district])
  end

  before do
    driven_by(:rack_test)
    login_as user_a
  end

  describe 'フォトスポット一覧表示' do
    it '自分のフォトスポットだけが表示されること' do
      visit organization_photo_spots_path(organization_a)
      expect(page).to have_content photo_spot_a.name
      expect(page).not_to have_content photo_spot_b.name
    end
  end

  describe 'フォトスポット詳細表示' do
    it '自分のフォトスポットは表示される' do
      visit organization_photo_spot_path(organization_a, photo_spot_a)
      expect(page).to have_current_path organization_photo_spot_path(
        organization_a,
        photo_spot_a
      )
    end

    it '自分のフォトスポット以外は表示されない' do
      expect do
        visit organization_photo_spot_path(organization_b, photo_spot_b)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'フォトスポット新規登録' do
    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_photo_spot_path(organization_a)
        expect(page).to have_current_path new_organization_photo_spot_path(
          organization_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        expect do
          visit new_organization_photo_spot_path(organization_b)
        end.to raise_error(NoMethodError)
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_photo_spot_path(organization_a)

        fill_in 'フォトスポットの名前', with: 'サンプルフォトスポットの名前'
        select '内山', from: '地区'
        fill_in '住所', with: 'サンプルフォトスポット住所'
        fill_in 'スラッグ', with: 'sample-photo-spot'
        fill_in 'フォトスポットの紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'

        find(
          '#photo_spot_create_form_photo_spot_attributes_lat',
          visible: false
        ).set '36.6959303'
        find(
          '#photo_spot_create_form_photo_spot_attributes_lng',
          visible: false
        ).set '137.8638005'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')

        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルフォトスポットの名前'
        expect(page).to have_content 'サンプルフォトスポット住所'
      end
    end
  end

  describe 'フォトスポット情報編集' do
    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_photo_spot_path(organization_a, photo_spot_a)
        expect(page).to have_current_path edit_organization_photo_spot_path(
          organization_a,
          photo_spot_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        expect do
          visit edit_organization_photo_spot_path(organization_b, photo_spot_b)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_photo_spot_path(organization_a, photo_spot_a)

        fill_in 'フォトスポットの名前', with: '更新サンプルフォトスポットの名前'
        select '佐野', from: '地区'
        fill_in '住所', with: '更新サンプルフォトスポット住所'
        fill_in 'フォトスポットの紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

        find(
          '#photo_spot_update_form_photo_spot_attributes_lat',
          visible: false
        ).set '36.6981800'
        find(
          '#photo_spot_update_form_photo_spot_attributes_lng',
          visible: false
        ).set '137.8618500'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')

        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプルフォトスポットの名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプルフォトスポット住所'
        expect(
          page
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      end
    end
  end
end
