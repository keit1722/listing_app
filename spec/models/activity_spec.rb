require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'バリデーション' do
    it '名称は必須であること' do
      activity = build(:activity, name: nil)
      activity.valid?
      expect(activity.errors[:name]).to include('を入力してください')
    end

    it '名称は一意であること' do
      create(:activity, name: 'サンプルアクティビティ')
      activity = build(:activity, name: 'サンプルアクティビティ')
      activity.valid?
      expect(activity.errors[:name]).to include('はすでに存在します')
    end

    it '住所は必須であること' do
      activity = build(:activity, address: nil)
      activity.valid?
      expect(activity.errors[:address]).to include('を入力してください')
    end

    it '緯度は必須であること' do
      activity = build(:activity, lat: nil)
      activity.valid?
      expect(activity.errors.full_messages).to include(
        '地図にピンを設置してください',
      )
    end

    it '経度は必須であること' do
      activity = build(:activity, lng: nil)
      activity.valid?
      expect(activity.errors.full_messages).to include(
        '地図にピンを設置してください',
      )
    end

    it 'スラッグは必須であること' do
      activity = build(:activity, slug: nil)
      activity.valid?
      expect(activity.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      create(:activity, slug: 'sample-slug')
      activity = build(:activity, slug: 'sample-slug')
      activity.valid?
      expect(activity.errors[:slug]).to include('はすでに存在します')
    end

    it 'スラッグにはアンダーバー（_）が使用できないこと' do
      activity = build(:activity, slug: 'sample_slug')
      activity.valid?
      expect(activity.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグにはアルファベット大文字が使用できないこと' do
      activity = build(:activity, slug: 'SAMPLE-SLUG')
      activity.valid?
      expect(activity.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには日本語が使用できないこと' do
      activity = build(:activity, slug: 'サンプルスラッグ')
      activity.valid?
      expect(activity.errors[:slug]).to include('は不正な値です')
    end

    it 'スラッグには数字が使用できること' do
      activity = build(:activity, slug: 'sample-slug-1')
      expect(activity).to be_valid
    end

    it '説明は必須であること' do
      activity = build(:activity, description: nil)
      activity.valid?
      expect(activity.errors[:description]).to include('を入力してください')
    end

    it 'メイン画像は必須であること' do
      activity = build(:activity, main_image: nil)
      activity.valid?
      expect(activity.errors[:main_image]).to include('を入力してください')
    end

    it 'その他画像は必須ではないこと' do
      activity = build(:activity, images: nil)
      expect(activity).to be_valid
    end
  end

  describe 'スコープ' do
    describe 'search_with_district' do
      let(:uchiyama) { create(:district_uchiyama) }
      let(:sano) { create(:district_sano) }
      let(:activity_uchiyama) { create(:activity, districts: [uchiyama]) }
      let(:activity_sano) { create(:activity, districts: [sano]) }

      it do
        expect(
          described_class.search_with_district([uchiyama.id, sano.id]),
        ).to eq [activity_uchiyama, activity_sano]
      end

      it do
        expect(described_class.search_with_district([uchiyama.id])).to eq [
             activity_uchiyama,
           ]
      end
    end

    describe 'keyword_contain' do
      let!(:activity_a) do
        create(
          :activity,
          name: 'アクティビティサンプル_A',
          description: '雨天決行です',
        )
      end
      let!(:activity_b) do
        create(
          :activity,
          name: 'アクティビティサンプル_B',
          description: '山登り（ルートA）をガイドします',
        )
      end

      it { expect(described_class.keyword_contain('雨天')).to eq [activity_a] }

      it do
        expect(described_class.keyword_contain('ガイド')).to eq [activity_b]
      end

      it do
        expect(described_class.keyword_contain('A').order('id')).to eq [
             activity_a,
             activity_b,
           ]
      end

      it do
        expect(
          described_class.keyword_contain('アクティビティサンプル').order('id'),
        ).to eq [activity_a, activity_b]
      end
    end
  end
end

# == Schema Information
#
# Table name: activities
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
#  index_activities_on_name             (name) UNIQUE
#  index_activities_on_organization_id  (organization_id)
#  index_activities_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
