require 'rails_helper'

RSpec.describe HotSpring, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      hot_spring = build(:hot_spring, name: nil)
      hot_spring.valid?
      expect(hot_spring.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:hot_spring, name: 'サンプルアクティビティ')
      hot_spring = build(:hot_spring, name: 'サンプルアクティビティ')
      hot_spring.valid?
      expect(hot_spring.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      hot_spring = build(:hot_spring, address: nil)
      hot_spring.valid?
      expect(hot_spring.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      hot_spring = build(:hot_spring, lat: nil)
      hot_spring.valid?
      expect(hot_spring.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it '経度は必須であること' do
      hot_spring = build(:hot_spring, lng: nil)
      hot_spring.valid?
      expect(hot_spring.errors.full_messages).to include(
        '地図にピンを設置してください'
      )
    end

    it 'スラッグは必須であること' do
      hot_spring = build(:hot_spring, slug: nil)
      hot_spring.valid?
      expect(hot_spring.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:hot_spring, slug: 'sample-slug')
      hot_spring = build(:hot_spring, slug: 'sample-slug')
      hot_spring.valid?
      expect(hot_spring.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      hot_spring = build(:hot_spring, slug: 'sample_slug')
      hot_spring.valid?
      expect(hot_spring.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      hot_spring = build(:hot_spring, slug: 'SAMPLE-SLUG')
      hot_spring.valid?
      expect(hot_spring.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      hot_spring = build(:hot_spring, slug: 'サンプルスラッグ')
      hot_spring.valid?
      expect(hot_spring.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      hot_spring = build(:hot_spring, slug: 'sample-slug-1')
      expect(hot_spring).to be_valid
    end

    it '説明は必須であること' do
      hot_spring = build(:hot_spring, description: nil)
      hot_spring.valid?
      expect(hot_spring.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      hot_spring = build(:hot_spring, main_image: nil)
      hot_spring.valid?
      expect(hot_spring.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      hot_spring = build(:hot_spring, images: nil)
      expect(hot_spring).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:hot_spring_uchiyama) { create(:hot_spring, districts: [uchiyama]) }
      let(:hot_spring_sano) { create(:hot_spring, districts: [sano]) }

      it do
        expect(
          described_class.search_with_district([uchiyama.id, sano.id])
        ).to eq [hot_spring_uchiyama, hot_spring_sano]
      end

      it do
        expect(described_class.search_with_district([uchiyama.id])).to eq [
          hot_spring_uchiyama
        ]
      end
    end

    describe 'keyword_contain' do
      let!(:hot_spring_a) do
        create(
          :hot_spring,
          name: '温泉サンプル_A',
          description: 'リラックスできます'
        )
      end
      let!(:hot_spring_b) do
        create(
          :hot_spring,
          name: '温泉サンプル_B',
          description: 'Aランクのお湯です'
        )
      end

      it do
        expect(
          described_class.keyword_contain('hot_springs', 'リラックス')
        ).to eq [hot_spring_a]
      end

      it do
        expect(described_class.keyword_contain('hot_springs', 'お湯')).to eq [
          hot_spring_b
        ]
      end

      it do
        expect(
          described_class.keyword_contain('hot_springs', 'A').order('id')
        ).to eq [hot_spring_a, hot_spring_b]
      end

      it do
        expect(
          described_class
            .keyword_contain('hot_springs', '温泉サンプル')
            .order('id')
        ).to eq [hot_spring_a, hot_spring_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: hot_springs
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
#  index_hot_springs_on_name             (name) UNIQUE
#  index_hot_springs_on_organization_id  (organization_id)
#  index_hot_springs_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
