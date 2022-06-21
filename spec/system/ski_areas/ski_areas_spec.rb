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

  describe 'スキー場一覧表示' do
    it 'マイページに自分のスキー場だけが表示されること' do
      login_as user_a
      visit organization_ski_areas_path(organization_a)
      expect(page).to have_content ski_area_a.name
      expect(page).not_to have_content ski_area_b.name
    end

    it '公開ページにはすべてのスキー場が表示されること' do
      visit ski_areas_path
      expect(page).to have_content ski_area_a.name
      expect(page).to have_content ski_area_b.name
    end
  end

  describe 'スキー場詳細表示' do
    before { login_as user_a }

    it 'マイページに自分のスキー場は表示される' do
      visit organization_ski_area_path(organization_a, ski_area_a)
      expect(page).to have_current_path organization_ski_area_path(
                          organization_a,
                          ski_area_a,
                        )
    end

    it 'マイページには自分のスキー場以外は表示されない' do
      Capybara.raise_server_errors = false
      visit organization_ski_area_path(organization_b, ski_area_b)
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end

  describe 'スキー場新規登録' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_ski_area_path(organization_a)
        expect(page).to have_current_path new_organization_ski_area_path(
                            organization_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit new_organization_ski_area_path(organization_b)
        assert_text 'NoMethodError'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_ski_area_path(organization_a)
        fill_in 'スキー場の名前', with: 'サンプルスキー場の名前'
        find('#ski_area_create_form_district_id_chosen').click
        find('.active-result').click
        fill_in '住所', with: 'サンプルスキー場住所'
        fill_in 'スラッグ', with: 'sample-ski-area'
        fill_in 'スキー場の紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルスキー場の名前'
        expect(page).to have_content 'サンプルスキー場住所'
      end
    end
  end

  describe 'スキー場情報編集' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_ski_area_path(organization_a, ski_area_a)
        expect(page).to have_current_path edit_organization_ski_area_path(
                            organization_a,
                            ski_area_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit edit_organization_ski_area_path(organization_b, ski_area_b)
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_ski_area_path(organization_a, ski_area_a)
        fill_in 'スキー場の名前', with: '更新サンプルスキー場の名前'
        find('#ski_area_update_form_district_id_chosen').click
        page.all('.active-result')[1].click
        fill_in '住所', with: '更新サンプルスキー場住所'
        fill_in 'スキー場の紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true

        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプルスキー場の名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプルスキー場住所'
        expect(
          page,
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      end
    end
  end

  describe '公開ページ飲食店一覧での検索' do
    let(:district_c) { create(:district_meitetsu) }
    let!(:ski_area_c) do
      create(:ski_area, organization: organization_a, districts: [district_c])
    end

    before { visit ski_areas_path }

    it '検索キーワードと一致する名前のものだけが表示されること' do
      fill_in 'q_keyword', with: ski_area_a.name
      click_button '検索'
      expect(page).to have_content ski_area_a.name
      expect(page).not_to have_content ski_area_b.name
      expect(page).not_to have_content ski_area_c.name
    end

    it 'チェックしたエリアと一致する名前のものだけが表示されること' do
      click_on 'エリア'
      find("label[for='check-area-6']").click
      first('.panel-apply', visible: false).click
      click_button '検索'

      expect(page).to have_content ski_area_a.name
      expect(page).to have_content ski_area_b.name
      expect(page).not_to have_content ski_area_c.name
    end
  end
end
