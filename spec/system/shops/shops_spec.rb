require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:shop_category) { create(:shop_category_souvenir) }
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:shop_a) do
    create(
      :shop,
      organization: organization_a,
      shop_categories: [shop_category],
      districts: [district]
    )
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:shop_b) do
    create(
      :shop,
      organization: organization_b,
      shop_categories: [shop_category],
      districts: [district]
    )
  end

  before do
    driven_by(:rack_test)
    login_as user_a
  end

  describe 'ショップ一覧表示' do
    it '自分のショップだけが表示されること' do
      visit organization_shops_path(organization_a)
      expect(page).to have_content shop_a.name
      expect(page).not_to have_content shop_b.name
    end
  end

  describe 'ショップ詳細表示' do
    it '自分のショップは表示される' do
      visit organization_shop_path(organization_a, shop_a)
      expect(page).to have_current_path organization_shop_path(
        organization_a,
        shop_a
      )
    end

    it '自分のショップ以外は表示されない' do
      expect do
        visit organization_shop_path(organization_b, shop_b)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'ショップ新規登録' do
    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_shop_path(organization_a)
        expect(page).to have_current_path new_organization_shop_path(
          organization_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        expect do
          visit new_organization_shop_path(organization_b)
        end.to raise_error(NoMethodError)
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_shop_path(organization_a)

        fill_in '店名', with: 'サンプルショップ店名'
        select '内山', from: '地区'
        fill_in '住所', with: 'サンプルショップ住所'
        fill_in 'スラッグ', with: 'sample-shop'
        fill_in 'ショップの紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'

        find(
          '#shop_create_form_shop_attributes_lat',
          visible: false
        ).set '36.6959303'
        find(
          '#shop_create_form_shop_attributes_lng',
          visible: false
        ).set '137.8638005'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')
        select 'お土産', from: 'カテゴリー'

        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルショップ店名'
        expect(page).to have_content 'サンプルショップ住所'
      end
    end
  end

  describe 'ショップ情報編集' do
    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_shop_path(organization_a, shop_a)
        expect(page).to have_current_path edit_organization_shop_path(
          organization_a,
          shop_a
        )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        expect do
          visit edit_organization_shop_path(organization_b, shop_b)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:shop_category_sports_shop)
        create(:district_sano)
        visit edit_organization_shop_path(organization_a, shop_a)

        fill_in '店名', with: '更新サンプルショップ店名'
        select '佐野', from: '地区'
        fill_in '住所', with: '更新サンプルショップ住所'
        fill_in 'ショップの紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

        find(
          '#shop_update_form_shop_attributes_lat',
          visible: false
        ).set '36.6981800'
        find(
          '#shop_update_form_shop_attributes_lng',
          visible: false
        ).set '137.8618500'
        attach_file '画像', Rails.root.join('spec/fixtures/fixture.png')
        select 'スポーツショップ', from: 'カテゴリー'

        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプルショップ店名'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプルショップ住所'
        expect(
          page
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        expect(page).to have_content 'スポーツショップ'
      end
    end
  end
end
