require 'rails_helper'

RSpec.describe 'CRUD機能', type: :system do
  let!(:district) { create(:district_uchiyama) }
  let!(:user_a) { create(:business_user) }
  let!(:organization_a) { create(:organization, users: [user_a]) }
  let!(:hot_spring_a) do
    create(:hot_spring, organization: organization_a, districts: [district])
  end
  let!(:user_b) { create(:business_user) }
  let!(:organization_b) { create(:organization, users: [user_b]) }
  let!(:hot_spring_b) do
    create(:hot_spring, organization: organization_b, districts: [district])
  end

  describe '温泉一覧表示' do
    it 'マイページに自分の温泉だけが表示されること' do
      login_as user_a
      visit organization_hot_springs_path(organization_a)
      expect(page).to have_content hot_spring_a.name
      expect(page).not_to have_content hot_spring_b.name
    end

    it '公開ページにはすべての温泉が表示されること' do
      visit hot_springs_path
      expect(page).to have_content hot_spring_a.name
      expect(page).to have_content hot_spring_b.name
    end
  end

  describe '温泉詳細表示' do
    before { login_as user_a }

    it 'マイページに自分の温泉は表示されること' do
      visit organization_hot_spring_path(organization_a, hot_spring_a)
      expect(page).to have_current_path organization_hot_spring_path(
                          organization_a,
                          hot_spring_a,
                        )
    end

    it 'マイページには自分の温泉以外は表示されないこと' do
      Capybara.raise_server_errors = false
      visit organization_hot_spring_path(organization_b, hot_spring_b)
      assert_text 'ActiveRecord::RecordNotFound'
    end
  end

  describe '温泉新規登録' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '登録フォームに進めること' do
        visit new_organization_hot_spring_path(organization_a)
        expect(page).to have_current_path new_organization_hot_spring_path(
                            organization_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '登録フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit new_organization_hot_spring_path(organization_b)
        assert_text 'NoMethodError'
      end
    end

    context '入力情報が正しい場合' do
      it '新規登録できること' do
        visit new_organization_hot_spring_path(organization_a)
        fill_in '温泉の名前', with: 'サンプル温泉の名前'
        find('#hot_spring_create_form_district_id_chosen').click
        find('.active-result').click
        fill_in '住所', with: 'サンプル温泉住所'
        fill_in 'スラッグ', with: 'sample-hot-spring'
        fill_in '温泉の紹介',
                with:
                  'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        click_button '登録する'

        expect(page).to have_content '作成しました'
        expect(page).to have_content 'サンプル温泉の名前'
        expect(page).to have_content 'サンプル温泉住所'
      end
    end
  end

  describe '温泉情報編集' do
    before { login_as user_a }

    context '自分の組織に関するものの場合' do
      it '編集フォームに進めること' do
        visit edit_organization_hot_spring_path(organization_a, hot_spring_a)
        expect(page).to have_current_path edit_organization_hot_spring_path(
                            organization_a,
                            hot_spring_a,
                          )
      end
    end

    context '自分の組織に関するものではない場合' do
      it '編集フォームに進めずエラーになること' do
        Capybara.raise_server_errors = false
        visit edit_organization_hot_spring_path(organization_b, hot_spring_b)
        assert_text 'ActiveRecord::RecordNotFound'
      end
    end

    context '入力情報が正しい場合' do
      it '情報更新ができること' do
        create(:district_sano)
        visit edit_organization_hot_spring_path(organization_a, hot_spring_a)
        fill_in '温泉の名前', with: '更新サンプル温泉の名前'
        find('#hot_spring_update_form_district_id_chosen').click
        page.all('.active-result')[1].click
        fill_in '住所', with: '更新サンプル温泉住所'
        fill_in '温泉の紹介',
                with:
                  'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        find('#map-location-registration').click
        attach_file '画像',
                    Rails.root.join('spec/fixtures/fixture.png'),
                    make_visible: true
        click_button '更新する'

        expect(page).to have_content '情報を更新しました'
        expect(page).to have_content '更新サンプル温泉の名前'
        expect(page).to have_content '佐野'
        expect(page).to have_content '更新サンプル温泉住所'
        expect(
          page,
        ).to have_content 'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      end
    end
  end
end
