require 'rails_helper'

RSpec.describe 'ショップ', type: :system do
  let!(:shop_category) { create(:shop_category_souvenir) }
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user, :activated) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:shop_a) do
    create(
      :shop,
      organization: organization_a,
      shop_categories: [shop_category],
      districts: [district]
    )
  end
  let!(:user_b) { create(:business_user, :activated) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:shop_b) do
    create(
      :shop,
      organization: organization_b,
      shop_categories: [shop_category],
      districts: [district]
    )
  end
  let(:district_c) { create(:district_meitetsu) }
  let(:shop_category_b) { create(:shop_category_sports_shop) }

  describe 'ショップ一覧表示' do
    it 'マイページに自分のショップだけが表示されること' do
      business_login_as user_a
      visit organization_shops_path(organization_a)
      expect(page).to have_content shop_a.name
      expect(page).not_to have_content shop_b.name
    end

    it '公開ページにはすべてのショップが表示されること' do
      visit shops_path
      expect(page).to have_content shop_a.name
      expect(page).to have_content shop_b.name
    end
  end

  describe 'ショップ詳細表示' do
    before { business_login_as user_a }

    it 'マイページに自分のショップは表示されること' do
      visit organization_shop_path(organization_a, shop_a)
      expect(page).to have_current_path organization_shop_path(
        organization_a,
        shop_a
      )
    end

    it 'マイページには自分のショップ以外は表示されないこと' do
      Capybara.raise_server_errors = false
      visit organization_shop_path(organization_b, shop_b)
      expect(page).to have_content 'ActiveRecord::RecordNotFound'
    end
  end

  describe 'ショップ新規登録' do
    before { business_login_as user_a }

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
        Capybara.raise_server_errors = false
        visit new_organization_shop_path(organization_b)
        expect(page).to have_content 'NoMethodError'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_shop_path(organization_a)
        fill_in '名称', with: 'サンプルショップ店名'
        find_by_id('shop_create_form_district_id_chosen').click
        find(
          '#shop_create_form_district_id_chosen .active-result',
          text: '内山'
        ).click
        fill_in '住所', with: 'サンプルショップ住所'
        fill_in 'スラッグ', with: 'sample-shop'
        fill_in '紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
        find_by_id('map-location-registration').click
        page.execute_script "$('input#shop_create_form_shop_attributes_main_image').css('opacity','1')"
        attach_file('メイン画像', Rails.root.join('spec/fixtures/fixture.png'))
        find_by_id('shop_create_form_shop_category_ids_chosen').click
        find(
          '#shop_create_form_shop_category_ids_chosen .active-result',
          text: 'お土産'
        ).click
        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプルショップ店名'
        expect(page).to have_content 'サンプルショップ住所'
      end
    end
  end

  describe 'ショップ情報編集' do
    before { business_login_as user_a }

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
        Capybara.raise_server_errors = false
        visit edit_organization_shop_path(organization_b, shop_b)

        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:shop_category_sports_shop)
        create(:district_sano)
        visit edit_organization_shop_path(organization_a, shop_a)
        fill_in '名称', with: '更新サンプルショップ店名'
        find_by_id('shop_update_form_district_id_chosen').click
        find(
          '#shop_update_form_district_id_chosen .active-result',
          text: '佐野'
        ).click
        fill_in '住所', with: '更新サンプルショップ住所'
        fill_in '紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        find_by_id('map-location-registration').click
        page.execute_script "$('input#shop_update_form_shop_attributes_main_image').css('opacity','1')"
        attach_file('メイン画像', Rails.root.join('spec/fixtures/fixture.png'))
        find_by_id('shop_update_form_shop_category_ids_chosen').click
        find(
          '#shop_update_form_shop_category_ids_chosen .active-result',
          text: 'スポーツショップ'
        ).click
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

  describe '公開ページショップ一覧での検索' do
    let!(:shop_c) do
      create(
        :shop,
        organization: organization_a,
        shop_categories: [shop_category_b],
        districts: [district_c]
      )
    end

    before { visit shops_path }

    it '検索キーワードと一致する名前のものだけが表示されること' do
      fill_in 'q_keyword', with: shop_a.name
      click_button '検索'
      expect(page).to have_content shop_a.name
      expect(page).not_to have_content shop_b.name
      expect(page).not_to have_content shop_c.name
    end

    it 'チェックしたエリアと一致する名前のものだけが表示されること' do
      click_on 'エリア'
      find('.panel-dropdown.active label', text: 'さのさか').click
      find('.panel-dropdown.active .panel-apply', text: '決定').click
      click_button '検索'

      expect(page).to have_content shop_a.name
      expect(page).to have_content shop_b.name
      expect(page).not_to have_content shop_c.name
    end

    it 'チェックしたカテゴリと一致する名前のものだけが表示されること' do
      click_on 'カテゴリー'
      find('.panel-dropdown.active label', text: 'お土産').click
      find('.panel-dropdown.active .panel-apply', text: '決定').click
      click_button '検索'

      expect(page).to have_content shop_a.name
      expect(page).to have_content shop_b.name
      expect(page).not_to have_content shop_c.name
    end
  end

  describe 'トップページでの検索' do
    let!(:shop_c) do
      create(
        :shop,
        organization: organization_a,
        shop_categories: [shop_category_b],
        districts: [district_c]
      )
    end

    before { visit root_path }

    context '検索ワード・エリア・カテゴリー（ショップ）を指定した場合' do
      it '指定された検索ワード・エリア・カテゴリーの一覧が表示されること' do
        fill_in 'q_keyword', with: shop_a.name
        find_by_id('q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find_by_id('q_category_chosen').click
        find('#q_category_chosen .active-result', text: 'ショップ').click
        click_button '検索'

        expect(page).to have_content shop_a.name
        expect(page).not_to have_content shop_b.name
        expect(page).not_to have_content shop_c.name
      end
    end

    context 'カテゴリー（ショップ）だけを指定した場合' do
      it '全てのショップの一覧が表示される' do
        find_by_id('q_category_chosen').click
        find('#q_category_chosen .active-result', text: 'ショップ').click
        click_button '検索'

        expect(page).to have_content shop_a.name
        expect(page).to have_content shop_b.name
        expect(page).to have_content shop_c.name
      end
    end

    context 'エリアとカテゴリー（ショップ）だけを指定した場合' do
      it '指定したエリアに所属しているショップの一覧が表示される' do
        find_by_id('q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        find_by_id('q_category_chosen').click
        find('#q_category_chosen .active-result', text: 'ショップ').click
        click_button '検索'

        expect(page).to have_content shop_a.name
        expect(page).to have_content shop_b.name
        expect(page).not_to have_content shop_c.name
      end
    end

    context 'カテゴリーを指定しない場合' do
      it '検索結果が表示されないこと' do
        fill_in 'q_keyword', with: shop_a.name
        find_by_id('q_area_chosen').click
        find('#q_area_chosen .active-result', text: 'さのさか').click
        click_button '検索'

        expect(page).to have_content 'カテゴリーを選択した上で検索してください'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe 'お気に入り' do
    before { business_login_as user_a }

    it 'お気に入り登録ができること' do
      visit shop_path(shop_a)
      expect do
        find('.like-button', text: 'お気に入りに登録').click
        expect(page).to have_content 'お気に入りに登録済み'
      end.to change(user_a.bookmarks, :count).by(1)
    end

    it 'お気に入り登録を取り消せること' do
      user_a.bookmark(shop_a)
      visit shop_path(shop_a)
      expect do
        find('.like-button', text: 'お気に入りに登録済み').click
        expect(page).to have_content 'お気に入りに登録'
      end.to change(user_a.bookmarks, :count).by(-1)
    end

    context 'お気に入り登録をした場合' do
      it 'お気に入り登録したショップのみマイページに表示されること' do
        user_a.bookmark(shop_a)
        visit mypage_bookmarks_path
        expect(page).to have_content shop_a.name
        expect(page).not_to have_content shop_b.name
      end
    end

    context 'ひとつもお気に入り登録をしていない場合' do
      it 'マイページにはなにも表示されないこと' do
        visit mypage_bookmarks_path
        expect(page).to have_content 'お気に入り登録はありません'
        expect(page).not_to have_content shop_a.name
        expect(page).not_to have_content shop_b.name
      end
    end
  end

  describe '投稿の新規作成' do
    before { business_login_as user_a }

    context '自分の所属組織のものであれば' do
      it '投稿の新規作成ページが表示されること' do
        visit new_organization_shop_post_path(organization_a, shop_a)
        expect(page).to have_content '新規投稿作成'
      end
    end

    context '自分の所属組織のものでなければ' do
      it '投稿の新規作成ページが表示されなずにエラーになる' do
        Capybara.raise_server_errors = false
        visit new_organization_shop_post_path(organization_b, shop_b)
        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_shop_post_path(organization_a, shop_a)
        fill_in 'タイトル', with: 'サンプル投稿名'
        fill_in '内容', with: 'サンプル投稿内容'
        page.execute_script "$('input#post_image').css('opacity','1')"
        attach_file('画像', Rails.root.join('spec/fixtures/fixture.png'))
        click_button '投稿'

        expect(page).to have_content '投稿しました'
        expect(page).to have_content 'サンプル投稿名'
      end
    end
  end

  describe '投稿の詳細表示' do
    let(:post_a) { create(:post_published, postable: shop_a) }
    let(:post_b) { create(:post_published, postable: shop_b) }

    before { business_login_as user_a }

    context '自分の所属組織のものであれば' do
      it '投稿詳細ページが表示される' do
        visit organization_shop_post_path(organization_a, shop_a, post_a)
        expect(page).to have_content post_a.title
        expect(page).to have_content post_a.body
      end
    end

    context '自分の所属組織のものでなければ' do
      it '投稿詳細ページが表示されずにエラーになる' do
        Capybara.raise_server_errors = false
        visit organization_shop_post_path(organization_b, shop_b, post_b)
        expect(page).to have_content 'ActiveRecord::RecordNotFound'
      end
    end
  end

  describe '投稿情報更新' do
    let(:post_a) { create(:post_published, postable: shop_a) }

    context '入力情報が正しい場合' do
      it '情報更新できること' do
        business_login_as user_a
        visit edit_organization_shop_post_path(organization_a, shop_a, post_a)
        fill_in 'タイトル', with: '更新サンプル投稿名'
        fill_in '内容', with: '更新サンプル投稿内容'
        page.execute_script "$('input#post_image').css('opacity','1')"
        attach_file('画像', Rails.root.join('spec/fixtures/fixture.png'))
        click_button '更新'

        expect(page).to have_content '内容を更新しました'
        expect(page).to have_content '更新サンプル投稿名'
      end
    end
  end

  describe '投稿情報編集' do
    let!(:post_a) { create(:post_published, postable: shop_a) }
    let!(:post_b) { create(:post_published, postable: shop_b) }

    it '自分の組織の投稿のみ表示される' do
      business_login_as user_a
      visit organization_shop_posts_path(organization_a, shop_a)
      expect(page).to have_content post_a.title
      expect(page).not_to have_content post_b.title
    end
  end

  describe '投稿削除' do
    let(:post_a) { create(:post_published, postable: shop_a) }

    it '投稿を削除できること' do
      business_login_as user_a
      visit organization_shop_post_path(organization_a, shop_a, post_a)

      expect do
        find('a.button', text: '削除').click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '削除しました'
      end.to change(shop_a.posts, :count).by(-1)
    end
  end

  describe '投稿の表示' do
    let!(:post_a) { create(:post_published, postable: shop_a) }
    let!(:post_b) { create(:post_draft, postable: shop_a) }
    let!(:post_c) { create(:post_published, postable: shop_a) }

    it 'ショップの詳細ページに公開の投稿のみが表示されている' do
      visit shop_path(shop_a)
      expect(page).to have_content post_a.title
      expect(page).not_to have_content post_b.title
      expect(page).to have_content post_c.title
    end

    it 'ショップの投稿一覧ページに公開の投稿のみが表示されている' do
      visit shop_posts_path(shop_a)
      expect(page).to have_content post_a.title
      expect(page).not_to have_content post_b.title
      expect(page).to have_content post_c.title
    end

    it '下書きの投稿はエラーになり表示されない' do
      Capybara.raise_server_errors = false
      visit shop_post_path(shop_a, post_b)
      expect(page).to have_content 'ActiveRecord::RecordNotFound'
    end

    it '投稿の詳細ページには下書きではない次の投稿名が表示されてクリックできる' do
      visit shop_post_path(shop_a, post_a)
      find('li.next-post a', text: post_c.title).click
      expect(page).to have_content post_c.title
    end

    it '投稿の詳細ページには下書きではない前の投稿名が表示されてクリックできる' do
      visit shop_post_path(shop_a, post_c)
      find('li.prev-post a', text: post_a.title).click
      expect(page).to have_content post_a.title
    end
  end
end
