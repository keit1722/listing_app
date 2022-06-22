require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:hotel_a) do
    create(:hotel, organization: organization_a, districts: [district])
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:hotel_b) do
    create(:hotel, organization: organization_b, districts: [district])
  end
  let(:district_c) { create(:district_meitetsu) }

  describe '宿泊施設一覧表示' do
    it 'マイページに自分の宿泊施設だけが表示されること' do
      login_as user_a
      visit organization_hotels_path(organization_a)
      expect(page).to have_content hotel_a.name
      expect(page).not_to have_content hotel_b.name
    end

    it '公開ページにはすべての宿泊施設が表示されること' do
      visit hotels_path
      expect(page).to have_content hotel_a.name
      expect(page).to have_content hotel_b.name
    end
  end

  describe '宿泊施設詳細表示' do
    before { login_as user_a }

    it 'マイページに自分の宿泊施設は表示されること' do
      visit organization_hotel_path(organization_a, hotel_a)
      expect(page).to have_current_path organization_hotel_path(
                          organization_a,
                          hotel_a,
                        )
    end

    it 'マイページには自分の宿泊施設以外は表示されないこと' do
      Capybara.raise_server_errors = false
      visit organization_hotel_path(organization_b, hotel_b)
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end

  describe '宿泊施設新規登録' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_hotel_path(organization_a)
        expect(page).to have_current_path new_organization_hotel_path(
                            organization_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit new_organization_hotel_path(organization_b)
        assert_text 'NoMethodError'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_hotel_path(organization_a)
        fill_in '宿泊施設の名前', with: 'サンプル宿泊施設の名前'
        find('#hotel_create_form_district_id_chosen').click
        find(
          '#hotel_create_form_district_id_chosen .active-result',
          text: '内山',
        ).click
        fill_in '住所', with: 'サンプル宿泊施設住所'
        fill_in 'スラッグ', with: 'sample-hotel'
        fill_in '宿泊施設の紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        fill_in 'hotel_create_form_reservation_link_attributes_link',
                with: 'https://google.com'
        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプル宿泊施設の名前'
        expect(page).to have_content 'サンプル宿泊施設住所'
      end
    end
  end

  describe '宿泊施設情報編集' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_hotel_path(organization_a, hotel_a)
        expect(page).to have_current_path edit_organization_hotel_path(
                            organization_a,
                            hotel_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit edit_organization_hotel_path(organization_b, hotel_b)
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_hotel_path(organization_a, hotel_a)
        fill_in '宿泊施設の名前', with: '更新サンプル宿泊施設の名前'
        find('#hotel_update_form_district_id_chosen').click
        find(
          '#hotel_update_form_district_id_chosen .active-result',
          text: '佐野',
        ).click
        fill_in '住所', with: '更新サンプル宿泊施設住所'
        fill_in '宿泊施設の紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        fill_in 'hotel_update_form_reservation_link_attributes_link',
                with: 'https://yahoo.com'
        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプル宿泊施設の名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプル宿泊施設住所'
        expect(
          page,
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        expect(page).to have_content 'https://yahoo.com'
      end
    end
  end

  describe '公開ページ宿泊施設一覧での検索' do
    let!(:hotel_c) do
      create(:hotel, organization: organization_a, districts: [district_c])
    end

    before { visit hotels_path }

    it '検索キーワードと一致する名前のものだけが表示されること' do
      fill_in 'q_keyword', with: hotel_a.name
      click_button '検索'
      expect(page).to have_content hotel_a.name
      expect(page).not_to have_content hotel_b.name
      expect(page).not_to have_content hotel_c.name
    end

    it 'チェックしたエリアと一致する名前のものだけが表示されること' do
      click_on 'エリア'
      find('.panel-dropdown.active label', text: 'さのさか').click
      find('.panel-dropdown.active .panel-apply', text: '決定').click
      click_button '検索'

      expect(page).to have_content hotel_a.name
      expect(page).to have_content hotel_b.name
      expect(page).not_to have_content hotel_c.name
    end
  end

  describe 'トップページでの検索' do
    let!(:hotel_c) do
      create(:hotel, organization: organization_a, districts: [district_c])
    end

    before { visit root_path }

    context '検索ワード・エリア・カテゴリー（宿泊施設）を指定した場合' do
      it '指定された検索ワード・エリア・カテゴリーの一覧が表示されること' do
        fill_in 'q_keyword', with: hotel_a.name
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: '宿泊').click
        click_button '検索'

        expect(page).to have_content hotel_a.name
        expect(page).not_to have_content hotel_b.name
        expect(page).not_to have_content hotel_c.name
      end
    end

    context 'カテゴリー（宿泊施設）だけを指定した場合' do
      it '全ての宿泊施設の一覧が表示される' do
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: '宿泊').click
        click_button '検索'

        expect(page).to have_content hotel_a.name
        expect(page).to have_content hotel_b.name
        expect(page).to have_content hotel_c.name
      end
    end

    context 'エリアとカテゴリー（宿泊施設）だけを指定した場合' do
      it '指定したエリアに所属している宿泊施設の一覧が表示される' do
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: '宿泊').click
        click_button '検索'

        expect(page).to have_content hotel_a.name
        expect(page).to have_content hotel_b.name
        expect(page).not_to have_content hotel_c.name
      end
    end

    context 'カテゴリーを指定しない場合' do
      it '検索結果が表示されないこと' do
        fill_in 'q_keyword', with: hotel_a.name
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        click_button '検索'

        expect(page).to have_content 'カテゴリーを選択した上で検索してください'
        expect(page).to have_current_path root_path
      end
    end
  end
end
