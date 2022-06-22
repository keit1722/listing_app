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
  let(:district_c) { create(:district_meitetsu) }

  describe 'アクティビティ一覧表示' do
    it 'マイページに自分のアクティビティだけが表示されること' do
      login_as user_a
      visit organization_activities_path(organization_a)
      expect(page).to have_content activity_a.name
      expect(page).not_to have_content activity_b.name
    end

    it '公開ページにはすべてのアクティビティが表示されること' do
      visit activities_path
      expect(page).to have_content activity_a.name
      expect(page).to have_content activity_b.name
    end
  end

  describe 'アクティビティ詳細表示' do
    before { login_as user_a }

    it 'マイページに自分のアクティビティは表示されること' do
      visit organization_activity_path(organization_a, activity_a)
      expect(page).to have_current_path organization_activity_path(
                          organization_a,
                          activity_a,
                        )
    end

    it 'マイページには自分のアクティビティ以外は表示されないこと' do
      Capybara.raise_server_errors = false
      visit organization_activity_path(organization_b, activity_b)
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end

  describe 'アクティビティ新規登録' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_activity_path(organization_a)
        expect(page).to have_current_path new_organization_activity_path(
                            organization_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit new_organization_activity_path(organization_b)
        assert_text 'NoMethodError'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_activity_path(organization_a)
        fill_in 'アクティビティの名前', with: 'サンプルアクティビティの名前'
        find('#activity_create_form_district_id_chosen').click
        find(
          '#activity_create_form_district_id_chosen .active-result',
          text: '内山',
        ).click
        fill_in '住所', with: 'サンプルアクティビティ住所'
        fill_in 'スラッグ', with: 'sample-activity'
        fill_in 'アクティビティの紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
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
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_activity_path(organization_a, activity_a)
        expect(page).to have_current_path edit_organization_activity_path(
                            organization_a,
                            activity_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit edit_organization_activity_path(organization_b, activity_b)
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_activity_path(organization_a, activity_a)
        fill_in 'アクティビティの名前', with: '更新サンプルアクティビティの名前'
        find('#activity_update_form_district_id_chosen').click
        find(
          '#activity_update_form_district_id_chosen .active-result',
          text: '佐野',
        ).click
        fill_in '住所', with: '更新サンプルアクティビティ住所'
        fill_in 'アクティビティの紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        fill_in 'activity_update_form_reservation_link_attributes_link',
                with: 'https://yahoo.com'
        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプルアクティビティの名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプルアクティビティ住所'
        expect(
          page,
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        expect(page).to have_content 'https://yahoo.com'
      end
    end
  end

  describe '公開ページアクティビティ一覧での検索' do
    let!(:activity_c) do
      create(:activity, organization: organization_a, districts: [district_c])
    end

    before { visit activities_path }

    it '検索キーワードと一致する名前のものだけが表示されること' do
      fill_in 'q_keyword', with: activity_a.name
      click_button '検索'
      expect(page).to have_content activity_a.name
      expect(page).not_to have_content activity_b.name
      expect(page).not_to have_content activity_c.name
    end

    it 'チェックしたエリアと一致する名前のものだけが表示されること' do
      click_on 'エリア'
      find('.panel-dropdown.active label', text: 'さのさか').click
      find('.panel-dropdown.active .panel-apply', text: '決定').click
      click_button '検索'

      expect(page).to have_content activity_a.name
      expect(page).to have_content activity_b.name
      expect(page).not_to have_content activity_c.name
    end
  end

  describe 'トップページでの検索' do
    let!(:activity_c) do
      create(:activity, organization: organization_a, districts: [district_c])
    end

    before { visit root_path }

    context '検索ワード・エリア・カテゴリー（アクティビティ）を指定した場合' do
      it '指定された検索ワード・エリア・カテゴリーの一覧が表示されること' do
        fill_in 'q_keyword', with: activity_a.name
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: 'アクティビティ').click
        click_button '検索'

        expect(page).to have_content activity_a.name
        expect(page).not_to have_content activity_b.name
        expect(page).not_to have_content activity_c.name
      end
    end

    context 'カテゴリー（アクティビティ）だけを指定した場合' do
      it '全てのアクティビティの一覧が表示される' do
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: 'アクティビティ').click
        click_button '検索'

        expect(page).to have_content activity_a.name
        expect(page).to have_content activity_b.name
        expect(page).to have_content activity_c.name
      end
    end

    context 'エリアとカテゴリー（アクティビティ）だけを指定した場合' do
      it '指定したエリアに所属しているアクティビティの一覧が表示される' do
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: 'アクティビティ').click
        click_button '検索'

        expect(page).to have_content activity_a.name
        expect(page).to have_content activity_b.name
        expect(page).not_to have_content activity_c.name
      end
    end

    context 'カテゴリーを指定しない場合' do
      it '検索結果が表示されないこと' do
        fill_in 'q_keyword', with: activity_a.name
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        click_button '検索'

        expect(page).to have_content 'カテゴリーを選択した上で検索してください'
        expect(page).to have_current_path root_path
      end
    end
  end
end
