require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:ski_area_a) do
    create(:ski_area, organization: organization_a, districts: [district])
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:ski_area_b) do
    create(:ski_area, organization: organization_b, districts: [district])
  end

  before do
    driven_by(:rack_test)
    login_as user_a
  end

  describe 'スキー場一覧表示' do
    it '自分のスキー場だけが表示されること' do
      visit organization_ski_areas_path(organization_a)
      expect(page).to have_content ski_area_a.name
      expect(page).not_to have_content ski_area_b.name
    end
  end

  describe 'スキー場詳細表示' do
    it '自分のスキー場は表示される' do
      visit organization_ski_area_path(organization_a, ski_area_a)
      expect(page).to have_current_path organization_ski_area_path(
        organization_a,
        ski_area_a
      )
    end

    it '自分のスキー場以外は表示されない' do
      expect do
        visit organization_ski_area_path(organization_b, ski_area_b)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'スキー場新規登録' do
    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_ski_area_path(organization_a)
        expect(page).to have_current_path new_organization_ski_area_path(
          organization_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        expect do
          visit new_organization_ski_area_path(organization_b)
        end.to raise_error(NoMethodError)
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_ski_area_path(organization_a)

        fill_in 'スキー場の名前', with: 'サンプルスキー場の名前'
        select '内山', from: '地区'
        fill_in '住所', with: 'サンプルスキー場住所'
        fill_in 'スラッグ', with: 'sample-ski-area'
        fill_in 'スキー場の紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'

        find(
          '#ski_area_create_form_ski_area_attributes_lat',
          visible: false
        ).set '36.6959303'
        find(
          '#ski_area_create_form_ski_area_attributes_lng',
          visible: false
        ).set '137.8638005'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')

        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルスキー場の名前'
        expect(page).to have_content 'サンプルスキー場住所'
      end
    end
  end

  describe 'スキー場情報編集' do
    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_ski_area_path(organization_a, ski_area_a)
        expect(page).to have_current_path edit_organization_ski_area_path(
          organization_a,
          ski_area_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        expect do
          visit edit_organization_ski_area_path(organization_b, ski_area_b)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_ski_area_path(organization_a, ski_area_a)

        fill_in 'スキー場の名前', with: '更新サンプルスキー場の名前'
        select '佐野', from: '地区'
        fill_in '住所', with: '更新サンプルスキー場住所'
        fill_in 'スキー場の紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

        find(
          '#ski_area_update_form_ski_area_attributes_lat',
          visible: false
        ).set '36.6981800'
        find(
          '#ski_area_update_form_ski_area_attributes_lng',
          visible: false
        ).set '137.8618500'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')

        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプルスキー場の名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプルスキー場住所'
        expect(
          page
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      end
    end
  end
end
