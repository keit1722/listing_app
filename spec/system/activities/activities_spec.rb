require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:activity_a) do
    create(:activity, organization: organization_a, districts: [district])
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:activity_b) do
    create(:activity, organization: organization_b, districts: [district])
  end

  before do
    driven_by(:rack_test)
    login_as user_a
  end

  describe 'アクティビティ一覧表示' do
    it '自分のアクティビティだけが表示されること' do
      visit organization_activities_path(organization_a)
      expect(page).to have_content activity_a.name
      expect(page).not_to have_content activity_b.name
    end
  end

  describe 'アクティビティ詳細表示' do
    it '自分のアクティビティは表示される' do
      visit organization_activity_path(organization_a, activity_a)
      expect(page).to have_current_path organization_activity_path(
        organization_a,
        activity_a
      )
    end

    it '自分のアクティビティ以外は表示されない' do
      expect do
        visit organization_activity_path(organization_b, activity_b)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'アクティビティ新規登録' do
    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_activity_path(organization_a)
        expect(page).to have_current_path new_organization_activity_path(
          organization_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        expect do
          visit new_organization_activity_path(organization_b)
        end.to raise_error(NoMethodError)
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_activity_path(organization_a)

        fill_in 'アクティビティの名前', with: 'サンプルアクティビティの名前'
        select '内山', from: '地区'
        fill_in '住所', with: 'サンプルアクティビティ住所'
        fill_in 'スラッグ', with: 'sample-activity'
        fill_in 'アクティビティの紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'

        find(
          '#activity_create_form_activity_attributes_lat',
          visible: false
        ).set '36.6959303'
        find(
          '#activity_create_form_activity_attributes_lng',
          visible: false
        ).set '137.8638005'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')
        fill_in 'activity_create_form_reservation_link_attributes_link',
                with: 'https://google.com'

        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルアクティビティの名前'
        expect(page).to have_content 'サンプルアクティビティ住所'
      end
    end
  end

  describe 'アクティビティ情報編集' do
    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_activity_path(organization_a, activity_a)
        expect(page).to have_current_path edit_organization_activity_path(
          organization_a,
          activity_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        expect do
          visit edit_organization_activity_path(organization_b, activity_b)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_activity_path(organization_a, activity_a)

        fill_in 'アクティビティの名前', with: '更新サンプルアクティビティの名前'
        select '佐野', from: '地区'
        fill_in '住所', with: '更新サンプルアクティビティ住所'
        fill_in 'アクティビティの紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

        find(
          '#activity_update_form_activity_attributes_lat',
          visible: false
        ).set '36.6981800'
        find(
          '#activity_update_form_activity_attributes_lng',
          visible: false
        ).set '137.8618500'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')
        fill_in 'activity_update_form_reservation_link_attributes_link',
                with: 'https://yahoo.com'

        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプルアクティビティの名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプルアクティビティ住所'
        expect(
          page
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        expect(page).to have_content 'https://yahoo.com'
      end
    end
  end
end
