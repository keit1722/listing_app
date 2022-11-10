require 'rails_helper'

RSpec.describe SkiArea, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      ski_area = build(:ski_area, name: nil)
      ski_area.valid?
      expect(ski_area.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:ski_area, name: 'サンプルアクティビティ')
      ski_area = build(:ski_area, name: 'サンプルアクティビティ')
      ski_area.valid?
      expect(ski_area.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      ski_area = build(:ski_area, address: nil)
      ski_area.valid?
      expect(ski_area.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      ski_area = build(:ski_area, lat: nil)
      ski_area.valid?
      expect(ski_area.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it '経度は必須であること' do
      ski_area = build(:ski_area, lng: nil)
      ski_area.valid?
      expect(ski_area.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it 'スラッグは必須であること' do
      ski_area = build(:ski_area, slug: nil)
      ski_area.valid?
      expect(ski_area.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:ski_area, slug: 'sample-slug')
      ski_area = build(:ski_area, slug: 'sample-slug')
      ski_area.valid?
      expect(ski_area.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      ski_area = build(:ski_area, slug: 'sample_slug')
      ski_area.valid?
      expect(ski_area.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      ski_area = build(:ski_area, slug: 'SAMPLE-SLUG')
      ski_area.valid?
      expect(ski_area.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      ski_area = build(:ski_area, slug: 'サンプルスラッグ')
      ski_area.valid?
      expect(ski_area.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      ski_area = build(:ski_area, slug: 'sample-slug-1')
      expect(ski_area).to be_valid
    end

    it '説明は必須であること' do
      ski_area = build(:ski_area, description: nil)
      ski_area.valid?
      expect(ski_area.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      ski_area = build(:ski_area, main_image: nil)
      ski_area.valid?
      expect(ski_area.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      ski_area = build(:ski_area, images: nil)
      expect(ski_area).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:ski_area_uchiyama) { create(:ski_area, districts: [uchiyama]) }
      let(:ski_area_sano) { create(:ski_area, districts: [sano]) }

      it do
        expect(
          described_class
            .search_with_district([uchiyama.id, sano.id])
            .where(id: [ski_area_uchiyama.id, ski_area_sano.id]),
        ).to eq [ski_area_uchiyama, ski_area_sano]
      end

      it do
        expect(described_class.search_with_district([uchiyama.id])).to eq [
          ski_area_uchiyama
        ]
      end
    end

    describe 'keyword_contain' do
      let!(:ski_area_a) do
        create(
          :ski_area,
          name: 'スキー場サンプル_A',
          description: '12月から営業します'
        )
      end
      let!(:ski_area_b) do
        create(
          :ski_area,
          name: 'スキー場サンプル_B',
          description: 'A〜Cコースまでが上級コースです'
        )
      end

      it do
        expect(described_class.keyword_contain('ski_areas', '12月')).to eq [
          ski_area_a
        ]
      end

      it do
        expect(described_class.keyword_contain('ski_areas', '上級')).to eq [
          ski_area_b
        ]
      end

      it do
        expect(
          described_class.keyword_contain('ski_areas', 'A').order('id')
        ).to eq [ski_area_a, ski_area_b]
      end

      it do
        expect(
          described_class
            .keyword_contain('ski_areas', 'スキー場サンプル')
            .order('id')
        ).to eq [ski_area_a, ski_area_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: ski_areas
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
#  index_ski_areas_on_name             (name) UNIQUE
#  index_ski_areas_on_organization_id  (organization_id)
#  index_ski_areas_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
