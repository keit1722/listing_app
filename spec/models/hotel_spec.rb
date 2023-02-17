require 'rails_helper'

RSpec.describe Hotel, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      hotel = build(:hotel, name: nil)
      hotel.valid?
      expect(hotel.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:hotel, name: 'サンプルアクティビティ')
      hotel = build(:hotel, name: 'サンプルアクティビティ')
      hotel.valid?
      expect(hotel.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      hotel = build(:hotel, address: nil)
      hotel.valid?
      expect(hotel.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      hotel = build(:hotel, lat: nil)
      hotel.valid?
      expect(hotel.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it '経度は必須であること' do
      hotel = build(:hotel, lng: nil)
      hotel.valid?
      expect(hotel.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it 'スラッグは必須であること' do
      hotel = build(:hotel, slug: nil)
      hotel.valid?
      expect(hotel.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:hotel, slug: 'sample-slug')
      hotel = build(:hotel, slug: 'sample-slug')
      hotel.valid?
      expect(hotel.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      hotel = build(:hotel, slug: 'sample_slug')
      hotel.valid?
      expect(hotel.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      hotel = build(:hotel, slug: 'SAMPLE-SLUG')
      hotel.valid?
      expect(hotel.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      hotel = build(:hotel, slug: 'サンプルスラッグ')
      hotel.valid?
      expect(hotel.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      hotel = build(:hotel, slug: 'sample-slug-1')
      expect(hotel).to be_valid
    end

    it '説明は必須であること' do
      hotel = build(:hotel, description: nil)
      hotel.valid?
      expect(hotel.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      hotel = build(:hotel, main_image: nil)
      hotel.valid?
      expect(hotel.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      hotel = build(:hotel, images: nil)
      expect(hotel).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:hotel_uchiyama) { create(:hotel, districts: [uchiyama]) }
      let(:hotel_sano) { create(:hotel, districts: [sano]) }

      it do
        expect(
          described_class
            .search_with_district([uchiyama.id, sano.id])
            .where(id: [hotel_uchiyama.id, hotel_sano.id])
        ).to eq [hotel_uchiyama, hotel_sano]
      end

      it do
        expect(described_class.search_with_district([uchiyama.id])).to eq [
          hotel_uchiyama
        ]
      end
    end

    describe 'keyword_contain' do
      let!(:hotel_a) do
        create(:hotel, name: 'ホテルサンプル_A', description: '送迎付きです')
      end
      let!(:hotel_b) do
        create(
          :hotel,
          name: 'ホテルサンプル_B',
          description: 'Aランクの宿泊施設です'
        )
      end

      it do
        expect(described_class.keyword_contain('hotels', '送迎')).to eq [
          hotel_a
        ]
      end

      it do
        expect(described_class.keyword_contain('hotels', '宿泊')).to eq [
          hotel_b
        ]
      end

      it do
        expect(
          described_class.keyword_contain('hotels', 'A').order('id')
        ).to eq [hotel_a, hotel_b]
      end

      it do
        expect(
          described_class
            .keyword_contain('hotels', 'ホテルサンプル')
            .order('id')
        ).to eq [hotel_a, hotel_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: hotels
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
#  index_hotels_on_name             (name) UNIQUE
#  index_hotels_on_organization_id  (organization_id)
#  index_hotels_on_slug             (slug) UNIQUE
#
