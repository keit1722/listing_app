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
      districts: [district],
    )
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:restaurant_b) do
    create(
      :restaurant,
      organization: organization_b,
      restaurant_categories: [restaurant_category],
      districts: [district],
    )
  end
  let(:district_c) { create(:district_meitetsu) }
  let(:restaurant_category_b) { create(:restaurant_category_chinese_food) }

  describe '飲食店一覧表示' do
    it 'マイページに自分の飲食店だけが表示されること' do
      login_as user_a
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
    before { login_as user_a }

    it 'マイページに自分の飲食店は表示される' do
      visit organization_restaurant_path(organization_a, restaurant_a)
      expect(page).to have_current_path organization_restaurant_path(
                          organization_a,
                          restaurant_a,
                        )
    end

    it 'マイページには自分の飲食店以外は表示されない' do
      Capybara.raise_server_errors = false
      visit organization_restaurant_path(organization_b, restaurant_b)
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end

  describe '飲食店新規登録' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_restaurant_path(organization_a)
        expect(page).to have_current_path new_organization_restaurant_path(
                            organization_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit new_organization_restaurant_path(organization_b)
        assert_text 'NoMethodError'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_restaurant_path(organization_a)
        fill_in '店名', with: 'サンプル飲食店店名'
        find('#restaurant_create_form_district_id_chosen').click
        find(
          '#restaurant_create_form_district_id_chosen .active-result',
          text: '内山',
        ).click
        fill_in '住所', with: 'サンプル飲食店住所'
        fill_in 'スラッグ', with: 'sample-restaurant'
        fill_in '店の紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        find('#restaurant_create_form_restaurant_category_ids_chosen').click
        find(
          '#restaurant_create_form_restaurant_category_ids_chosen .active-result',
          text: '和食',
        ).click
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
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_restaurant_path(organization_a, restaurant_a)
        expect(page).to have_current_path edit_organization_restaurant_path(
                            organization_a,
                            restaurant_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit edit_organization_restaurant_path(organization_b, restaurant_b)
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:restaurant_category_chinese_food)
        create(:district_sano)
        visit edit_organization_restaurant_path(organization_a, restaurant_a)
        fill_in '店名', with: '更新サンプル飲食店店名'
        find('#restaurant_update_form_district_id_chosen').click
        find(
          '#restaurant_update_form_district_id_chosen .active-result',
          text: '佐野',
        ).click
        fill_in '住所', with: '更新サンプル飲食店住所'
        fill_in '店の紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        find('#restaurant_update_form_restaurant_category_ids_chosen').click
        find(
          '#restaurant_update_form_restaurant_category_ids_chosen .active-result',
          text: '中華',
        ).click
        fill_in 'restaurant_update_form_reservation_link_attributes_link',
                with: 'https://yahoo.com'
        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプル飲食店店名'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプル飲食店住所'
        expect(
          page,
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        expect(page).to have_content '中華'
        expect(page).to have_content 'https://yahoo.com'
      end
    end
  end

  describe '公開ページ飲食店一覧での検索' do
    let!(:restaurant_c) do
      create(
        :restaurant,
        organization: organization_a,
        restaurant_categories: [restaurant_category_b],
        districts: [district_c],
      )
    end

    before { visit restaurants_path }

    it '検索キーワードと一致する名前のものだけが表示されること' do
      fill_in 'q_keyword', with: restaurant_a.name
      click_button '検索'
      expect(page).to have_content restaurant_a.name
      expect(page).not_to have_content restaurant_b.name
      expect(page).not_to have_content restaurant_c.name
    end

    it 'チェックしたエリアと一致する名前のものだけが表示されること' do
      click_on 'エリア'
      find('.panel-dropdown.active label', text: 'さのさか').click
      find('.panel-dropdown.active .panel-apply', text: '決定').click
      click_button '検索'

      expect(page).to have_content restaurant_a.name
      expect(page).to have_content restaurant_b.name
      expect(page).not_to have_content restaurant_c.name
    end

    it 'チェックしたカテゴリと一致する名前のものだけが表示されること' do
      click_on 'カテゴリー'
      find('.panel-dropdown.active label', text: '和食').click
      find('.panel-dropdown.active .panel-apply', text: '決定').click
      click_button '検索'

      expect(page).to have_content restaurant_a.name
      expect(page).to have_content restaurant_b.name
      expect(page).not_to have_content restaurant_c.name
    end
  end

  describe 'トップページでの検索' do
    let!(:restaurant_c) do
      create(
        :restaurant,
        organization: organization_a,
        restaurant_categories: [restaurant_category_b],
        districts: [district_c],
      )
    end

    before { visit root_path }

    context '検索ワード・エリア・カテゴリー（飲食店）を指定した場合' do
      it '指定された検索ワード・エリア・カテゴリーの一覧が表示されること' do
        fill_in 'q_keyword', with: restaurant_a.name
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: '飲食店').click
        click_button '検索'

        expect(page).to have_content restaurant_a.name
        expect(page).not_to have_content restaurant_b.name
        expect(page).not_to have_content restaurant_c.name
      end
    end

    context 'カテゴリー（飲食店）だけを指定した場合' do
      it '全ての飲食店の一覧が表示される' do
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: '飲食店').click
        click_button '検索'

        expect(page).to have_content restaurant_a.name
        expect(page).to have_content restaurant_b.name
        expect(page).to have_content restaurant_c.name
      end
    end

    context 'エリアとカテゴリー（飲食店）だけを指定した場合' do
      it '指定したエリアに所属している飲食店の一覧が表示される' do
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find('#q_category_chosen').click
        find('#q_category_chosen .active-result', text: '飲食店').click
        click_button '検索'

        expect(page).to have_content restaurant_a.name
        expect(page).to have_content restaurant_b.name
        expect(page).not_to have_content restaurant_c.name
      end
    end

    context 'カテゴリーを指定しない場合' do
      it '検索結果が表示されないこと' do
        fill_in 'q_keyword', with: restaurant_a.name
        find('#q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        click_button '検索'

        expect(page).to have_content 'カテゴリーを選択した上で検索してください'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe 'お気に入り' do
    before { login_as user_a }

    it 'お気に入り登録ができること' do
      visit restaurant_path(restaurant_a)
      expect do
        find('.like-button', text: 'お気に入りに登録').click
        expect(page).to have_content 'お気に入りに登録済み'
      end.to change(user_a.bookmarks, :count).by(1)
    end

    it 'お気に入り登録を取り消せること' do
      user_a.bookmark(restaurant_a)
      visit restaurant_path(restaurant_a)
      expect do
        find('.like-button', text: 'お気に入りに登録済み').click
        expect(page).to have_content 'お気に入りに登録'
      end.to change(user_a.bookmarks, :count).by(-1)
    end

    context 'お気に入り登録をした場合' do
      it 'お気に入り登録した飲食店のみマイページに表示されること' do
        user_a.bookmark(restaurant_a)
        visit mypage_bookmarks_path
        expect(page).to have_content restaurant_a.name
        expect(page).not_to have_content restaurant_b.name
      end
    end

    context 'ひとつもお気に入り登録をしていない場合' do
      it 'マイページにはなにも表示されないこと' do
        visit mypage_bookmarks_path
        expect(page).to have_content 'お気に入り登録はありません'
        expect(page).not_to have_content restaurant_a.name
        expect(page).not_to have_content restaurant_b.name
      end
    end
  end

  describe '投稿の新規作成' do
    before { login_as user_a }

    context '自分の所属組織のものであれば' do
      it '投稿の新規作成ページが表示されること' do
        visit new_organization_restaurant_post_path(
                organization_a,
                restaurant_a,
              )
        expect(page).to have_content '新規投稿作成'
      end
    end

    context '自分の所属組織のものでなければ' do
      it '投稿の新規作成ページが表示されなずにエラーになる' do
        Capybara.raise_server_errors = false
        visit new_organization_restaurant_post_path(
                organization_b,
                restaurant_b,
              )
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_restaurant_post_path(
                organization_a,
                restaurant_a,
              )
        fill_in 'タイトル', with: 'サンプル投稿名'
        fill_in '内容', with: 'サンプル投稿内容'
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        find('#post_status_chosen').click
        find('#post_status_chosen .active-result', text: '公開').click
        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプル投稿名'
      end
    end
  end

  describe '投稿の詳細表示' do
    let(:post_a) { create(:post_published, postable: restaurant_a) }
    let(:post_b) { create(:post_published, postable: restaurant_b) }
    before { login_as user_a }

    context '自分の所属組織のものであれば' do
      it '投稿詳細ページが表示される' do
        visit organization_restaurant_post_path(
                organization_a,
                restaurant_a,
                post_a,
              )
        expect(page).to have_content post_a.title
        expect(page).to have_content post_a.body
      end
    end

    context '自分の所属組織のものであれば' do
      it '投稿詳細ページが表示される' do
        Capybara.raise_server_errors = false
        visit organization_restaurant_post_path(
                organization_b,
                restaurant_b,
                post_b,
              )
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end
  end

  describe '投稿情報編集' do
    let(:post_a) { create(:post_published, postable: restaurant_a) }

    context '入力情報が正しい場合' do
      it '情報更新できること' do
        login_as user_a
        visit edit_organization_restaurant_post_path(
                organization_a,
                restaurant_a,
                post_a,
              )
        fill_in 'タイトル', with: '更新サンプル投稿名'
        fill_in '内容', with: '更新サンプル投稿内容'
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        find('#post_status_chosen').click
        find('#post_status_chosen .active-result', text: '下書き').click
        click_button '更新する'

        expect(page).to have_content '更新しました'
        expect(page).to have_content '更新サンプル投稿名'
      end
    end
  end

  describe '投稿情報編集' do
    let!(:post_a) { create(:post_published, postable: restaurant_a) }
    let!(:post_b) { create(:post_published, postable: restaurant_b) }

    context 'a context' do
      it '自分の組織の投稿のみ表示される' do
        login_as user_a
        visit organization_restaurant_posts_path(organization_a, restaurant_a)
        expect(page).to have_content post_a.title
        expect(page).not_to have_content post_b.title
      end
    end
  end

  describe '投稿削除' do
    let(:post_a) { create(:post_published, postable: restaurant_a) }

    it '投稿を削除できること' do
      login_as user_a
      visit organization_restaurant_post_path(
              organization_a,
              restaurant_a,
              post_a,
            )

      expect do
        find('a.button', text: '削除').click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '削除しました'
      end.to change(restaurant_a.posts, :count).by(-1)
    end
  end
end
