require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      restaurant = build(:restaurant, name: nil)
      restaurant.valid?
      expect(restaurant.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:restaurant, name: 'サンプルアクティビティ')
      restaurant = build(:restaurant, name: 'サンプルアクティビティ')
      restaurant.valid?
      expect(restaurant.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      restaurant = build(:restaurant, address: nil)
      restaurant.valid?
      expect(restaurant.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      restaurant = build(:restaurant, lat: nil)
      restaurant.valid?
      expect(restaurant.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it '経度は必須であること' do
      restaurant = build(:restaurant, lng: nil)
      restaurant.valid?
      expect(restaurant.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it 'スラッグは必須であること' do
      restaurant = build(:restaurant, slug: nil)
      restaurant.valid?
      expect(restaurant.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:restaurant, slug: 'sample-slug')
      restaurant = build(:restaurant, slug: 'sample-slug')
      restaurant.valid?
      expect(restaurant.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      restaurant = build(:restaurant, slug: 'sample_slug')
      restaurant.valid?
      expect(restaurant.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      restaurant = build(:restaurant, slug: 'SAMPLE-SLUG')
      restaurant.valid?
      expect(restaurant.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      restaurant = build(:restaurant, slug: 'サンプルスラッグ')
      restaurant.valid?
      expect(restaurant.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      restaurant = build(:restaurant, slug: 'sample-slug-1')
      expect(restaurant).to be_valid
    end

    it '説明は必須であること' do
      restaurant = build(:restaurant, description: nil)
      restaurant.valid?
      expect(restaurant.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      restaurant = build(:restaurant, main_image: nil)
      restaurant.valid?
      expect(restaurant.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      restaurant = build(:restaurant, images: nil)
      expect(restaurant).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_category' do
      let(:japanese_food) { create(:restaurant_category_japanese_food) }
      let(:chinese_food) { create(:restaurant_category_chinese_food) }
      let(:restaurant_japanese) do
        create(:restaurant, restaurant_categories: [japanese_food])
      end
      let(:restaurant_chinese) do
        create(:restaurant, restaurant_categories: [chinese_food])
      end

      it do
        expect(
          described_class.search_with_category(
            [japanese_food.id, chinese_food.id]
          )
        ).to eq [restaurant_japanese, restaurant_chinese]
      end

      it do
        expect(described_class.search_with_category([japanese_food.id])).to eq [
          restaurant_japanese
        ]
      end
    end

    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:restaurant_uchiyama) { create(:restaurant, districts: [uchiyama]) }
      let(:restaurant_sano) { create(:restaurant, districts: [sano]) }

      it do
        expect(
          described_class.search_with_district([uchiyama.id, sano.id])
        ).to eq [restaurant_uchiyama, restaurant_sano]
      end

      it do
        expect(described_class.search_with_district([uchiyama.id])).to eq [
          restaurant_uchiyama
        ]
      end
    end

    describe 'keyword_contain' do
      let!(:restaurant_a) do
        create(
          :restaurant,
          name: '飲食店サンプル_A',
          description: 'フランス料理屋です'
        )
      end
      let!(:restaurant_b) do
        create(
          :restaurant,
          name: '飲食店サンプル_B',
          description: 'Aランク牛を提供します'
        )
      end

      it do
        expect(
          described_class.keyword_contain('restaurants', 'フランス')
        ).to eq [restaurant_a]
      end

      it do
        expect(described_class.keyword_contain('restaurants', '提供')).to eq [
          restaurant_b
        ]
      end

      it do
        expect(
          described_class.keyword_contain('restaurants', 'A').order('id')
        ).to eq [restaurant_a, restaurant_b]
      end

      it do
        expect(
          described_class
            .keyword_contain('restaurants', '飲食店サンプル')
            .order('id')
        ).to eq [restaurant_a, restaurant_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: restaurants
#
#  id              :bigint           not null, primary key
#  address         :string           not null
#  description     :text             not null
#  lat             :float            not null
#  lng             :float            not null
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#
# Indexes
#
#  index_restaurants_on_name             (name) UNIQUE
#  index_restaurants_on_organization_id  (organization_id)
#  index_restaurants_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
