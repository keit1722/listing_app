require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      shop = build(:shop, name: nil)
      shop.valid?
      expect(shop.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:shop, name: 'サンプルアクティビティ')
      shop = build(:shop, name: 'サンプルアクティビティ')
      shop.valid?
      expect(shop.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      shop = build(:shop, address: nil)
      shop.valid?
      expect(shop.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      shop = build(:shop, lat: nil)
      shop.valid?
      expect(shop.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it '経度は必須であること' do
      shop = build(:shop, lng: nil)
      shop.valid?
      expect(shop.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it 'スラッグは必須であること' do
      shop = build(:shop, slug: nil)
      shop.valid?
      expect(shop.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:shop, slug: 'sample-slug')
      shop = build(:shop, slug: 'sample-slug')
      shop.valid?
      expect(shop.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      shop = build(:shop, slug: 'sample_slug')
      shop.valid?
      expect(shop.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      shop = build(:shop, slug: 'SAMPLE-SLUG')
      shop.valid?
      expect(shop.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      shop = build(:shop, slug: 'サンプルスラッグ')
      shop.valid?
      expect(shop.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      shop = build(:shop, slug: 'sample-slug-1')
      expect(shop).to be_valid
    end

    it '説明は必須であること' do
      shop = build(:shop, description: nil)
      shop.valid?
      expect(shop.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      shop = build(:shop, main_image: nil)
      shop.valid?
      expect(shop.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      shop = build(:shop, images: nil)
      expect(shop).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_category' do
      let(:souvenir) { create(:shop_category_souvenir) }
      let(:sports) { create(:shop_category_sports_shop) }
      let(:shop_souvenir) { create(:shop, shop_categories: [souvenir]) }
      let(:shop_sports) { create(:shop, shop_categories: [sports]) }

      it do
        expect(
          described_class.search_with_category([souvenir.id, sports.id])
        ).to eq [shop_souvenir, shop_sports]
      end

      it do
        expect(described_class.search_with_category([souvenir.id])).to eq [
          shop_souvenir
        ]
      end
    end

    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:shop_uchiyama) { create(:shop, districts: [uchiyama]) }
      let(:shop_sano) { create(:shop, districts: [sano]) }

      it do
        expect(
          described_class.search_with_district([uchiyama.id, sano.id])
        ).to eq [shop_uchiyama, shop_sano]
      end

      it do
        expect(described_class.search_with_district([uchiyama.id])).to eq [
          shop_uchiyama
        ]
      end
    end

    describe 'keyword_contain' do
      let!(:shop_a) do
        create(:shop, name: 'ショップサンプル_A', description: 'コンビニです')
      end
      let!(:shop_b) do
        create(
          :shop,
          name: 'ショップサンプル_B',
          description: 'Aランク食品を取り扱うスーパーです'
        )
      end

      it do
        expect(described_class.keyword_contain('shops', 'コンビニ')).to eq [
          shop_a
        ]
      end

      it do
        expect(described_class.keyword_contain('shops', 'スーパー')).to eq [
          shop_b
        ]
      end

      it do
        expect(
          described_class.keyword_contain('shops', 'A').order('id')
        ).to eq [shop_a, shop_b]
      end

      it do
        expect(
          described_class
            .keyword_contain('shops', 'ショップサンプル')
            .order('id')
        ).to eq [shop_a, shop_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: shops
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
#  index_shops_on_name             (name) UNIQUE
#  index_shops_on_organization_id  (organization_id)
#  index_shops_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
