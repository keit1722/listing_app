require 'rails_helper'

RSpec.describe PhotoSpot, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      photo_spot = build(:photo_spot, name: nil)
      photo_spot.valid?
      expect(photo_spot.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:photo_spot, name: 'サンプルアクティビティ')
      photo_spot = build(:photo_spot, name: 'サンプルアクティビティ')
      photo_spot.valid?
      expect(photo_spot.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      photo_spot = build(:photo_spot, address: nil)
      photo_spot.valid?
      expect(photo_spot.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      photo_spot = build(:photo_spot, lat: nil)
      photo_spot.valid?
      expect(photo_spot.errors.full_messages).to include(
        '地図にピンを設置してください',
      )
    end

    it '経度は必須であること' do
      photo_spot = build(:photo_spot, lng: nil)
      photo_spot.valid?
      expect(photo_spot.errors.full_messages).to include(
        '地図にピンを設置してください',
      )
    end

    it 'スラッグは必須であること' do
      photo_spot = build(:photo_spot, slug: nil)
      photo_spot.valid?
      expect(photo_spot.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:photo_spot, slug: 'sample-slug')
      photo_spot = build(:photo_spot, slug: 'sample-slug')
      photo_spot.valid?
      expect(photo_spot.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      photo_spot = build(:photo_spot, slug: 'sample_slug')
      photo_spot.valid?
      expect(photo_spot.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      photo_spot = build(:photo_spot, slug: 'SAMPLE-SLUG')
      photo_spot.valid?
      expect(photo_spot.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      photo_spot = build(:photo_spot, slug: 'サンプルスラッグ')
      photo_spot.valid?
      expect(photo_spot.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      photo_spot = build(:photo_spot, slug: 'sample-slug-1')
      expect(photo_spot).to be_valid
    end

    it '説明は必須であること' do
      photo_spot = build(:photo_spot, description: nil)
      photo_spot.valid?
      expect(photo_spot.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      photo_spot = build(:photo_spot, main_image: nil)
      photo_spot.valid?
      expect(photo_spot.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      photo_spot = build(:photo_spot, images: nil)
      expect(photo_spot).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:photo_spot_uchiyama) { create(:photo_spot, districts: [uchiyama]) }
      let(:photo_spot_sano) { create(:photo_spot, districts: [sano]) }

      it do
        expect(PhotoSpot.search_with_district([uchiyama.id, sano.id])).to eq [
             photo_spot_uchiyama,
             photo_spot_sano,
           ]
      end

      it do
        expect(PhotoSpot.search_with_district([uchiyama.id])).to eq [
             photo_spot_uchiyama,
           ]
      end
    end

    describe 'keyword_contain' do
      let!(:photo_spot_a) do
        create(
          :photo_spot,
          name: 'フォトスポットサンプル_A',
          description: '美しい山々',
        )
      end
      let!(:photo_spot_b) do
        create(
          :photo_spot,
          name: 'フォトスポットサンプル_B',
          description: 'Aランクの絶景です',
        )
      end

      it { expect(PhotoSpot.keyword_contain('山々')).to eq [photo_spot_a] }

      it { expect(PhotoSpot.keyword_contain('絶景')).to eq [photo_spot_b] }

      it do
        expect(PhotoSpot.keyword_contain('A').order('id')).to eq [
             photo_spot_a,
             photo_spot_b,
           ]
      end

      it do
        expect(
          PhotoSpot.keyword_contain('フォトスポットサンプル').order('id'),
        ).to eq [photo_spot_a, photo_spot_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: photo_spots
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
#  index_photo_spots_on_name             (name) UNIQUE
#  index_photo_spots_on_organization_id  (organization_id)
#  index_photo_spots_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
