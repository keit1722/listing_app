require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:restaurant_category) { create(:restaurant_category_japanese_food) }
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:restaurant_a) do
    create(
      :restaurant,
      organization: organization_a,
      restaurant_categories: [restaurant_category],
      districts: [district]
    )
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:restaurant_b) do
    create(
      :restaurant,
      organization: organization_b,
      restaurant_categories: [restaurant_category],
      districts: [district]
    )
  end

  before do
    driven_by(:rack_test)
    login_as user_a
  end

  describe '飲食店一覧表示' do
    it 'マイページに自分の飲食店だけが表示されること' do
      visit organization_restaurants_path(organization_a)
      expect(page).to have_content restaurant_a.name
      expect(page).not_to have_content restaurant_b.name
    end

    it '公開ページにはすべての飲食店が表示されること' do
      visit restaurants_path
      expect(page).to have_content restaurant_a.name
      expect(page).to have_content restaurant_b.name
    end
  end

  describe '飲食店詳細表示' do
    it '自分の飲食店は表示される' do
      visit organization_restaurant_path(organization_a, restaurant_a)
      expect(page).to have_current_path organization_restaurant_path(
        organization_a,
        restaurant_a
      )
    end

    it '自分の飲食店以外は表示されない' do
      expect do
        visit organization_restaurant_path(organization_b, restaurant_b)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '飲食店新規登録' do
    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_restaurant_path(organization_a)
        expect(page).to have_current_path new_organization_restaurant_path(
          organization_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        expect do
          visit new_organization_restaurant_path(organization_b)
        end.to raise_error(NoMethodError)
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_restaurant_path(organization_a)

        fill_in '店名', with: 'サンプル飲食店店名'
        select '内山', from: '地区'
        fill_in '住所', with: 'サンプル飲食店住所'
        fill_in 'スラッグ', with: 'sample-restaurant'
        fill_in '店の紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'

        find(
          '#restaurant_create_form_restaurant_attributes_lat',
          visible: false
        ).set '36.6959303'
        find(
          '#restaurant_create_form_restaurant_attributes_lng',
          visible: false
        ).set '137.8638005'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')
        select '和食', from: 'カテゴリー'
        fill_in 'restaurant_create_form_reservation_link_attributes_link',
                with: 'https://google.com'

        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプル飲食店店名'
        expect(page).to have_content 'サンプル飲食店住所'
      end
    end
  end

  describe '飲食店情報編集' do
    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_restaurant_path(organization_a, restaurant_a)
        expect(page).to have_current_path edit_organization_restaurant_path(
          organization_a,
          restaurant_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        expect do
          visit edit_organization_restaurant_path(organization_b, restaurant_b)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:restaurant_category_chinese_food)
        create(:district_sano)
        visit edit_organization_restaurant_path(organization_a, restaurant_a)

        fill_in '店名', with: '更新サンプル飲食店店名'
        select '佐野', from: '地区'
        fill_in '住所', with: '更新サンプル飲食店住所'
        fill_in '店の紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

        find(
          '#restaurant_update_form_restaurant_attributes_lat',
          visible: false
        ).set '36.6981800'
        find(
          '#restaurant_update_form_restaurant_attributes_lng',
          visible: false
        ).set '137.8618500'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')
        select '中華', from: 'カテゴリー'
        fill_in 'restaurant_update_form_reservation_link_attributes_link',
                with: 'https://yahoo.com'

        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプル飲食店店名'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプル飲食店住所'
        expect(
          page
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        expect(page).to have_content '中華'
        expect(page).to have_content 'https://yahoo.com'
      end
    end
  end
end
