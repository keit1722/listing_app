#
# Table name: announcements
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  status     :integer          default("published"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poster_id  :integer          not null
#
require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe 'バリデーション' do
    it 'タイトルは必須であること' do
      announcement = build(:announcement, title: nil)
      announcement.valid?
      expect(announcement.errors[:title]).to include('を入力してください')
    end

    it '内容は必須であること' do
      announcement = build(:announcement, body: nil)
      announcement.valid?
      expect(announcement.errors[:body]).to include('を入力してください')
    end

    it 'ステータスは必須であること' do
      announcement = build(:announcement, status: nil)
      announcement.valid?
      expect(announcement.errors[:status]).to include('を入力してください')
    end
  end

  describe 'スコープ' do
    let(:user) { create(:pvsuwimvsuoitmucvyku_user, :activated) }
    let!(:announcement_a) { create(:announcement, poster_id: user.id) }
    let!(:announcement_b) { create(:announcement, poster_id: user.id) }
    let!(:announcement_c) { create(:announcement, poster_id: user.id) }

    describe 'ordered' do
      it do
        expect(described_class.ordered).to eq [
             announcement_c,
             announcement_b,
             announcement_a,
           ]
      end

      it do
        expect(described_class.ordered).not_to eq [
             announcement_a,
             announcement_b,
             announcement_c,
           ]
      end
    end

    describe 'recent' do
      it do
        expect(described_class.recent(2)).to eq [announcement_c, announcement_b]
      end

      it do
        expect(described_class.recent(3)).to eq [
             announcement_c,
             announcement_b,
             announcement_a,
           ]
      end
    end
  end

  describe 'インスタンスメソッド' do
    let(:user) { create(:pvsuwimvsuoitmucvyku_user, :activated) }
    let!(:announcement_a) { create(:announcement, poster_id: user.id) }
    let!(:announcement_b) { create(:announcement, poster_id: user.id) }
    let!(:announcement_c) { create(:announcement, poster_id: user.id) }

    describe 'previous' do
      context 'ひとつ前に作成されたオブジェクトがある場合' do
        it 'そのオブジェクトが特定される' do
          expect(announcement_b.previous).to eq announcement_a
        end
      end

      context 'ひとつ前に作成されたオブジェクトがない場合' do
        it 'nilが返ってくる' do
          expect(announcement_a.previous).to be_nil
        end
      end
    end

    describe 'next' do
      context 'ひとつ後に作成されたオブジェクトがある場合' do
        it 'そのオブジェクトが特定される' do
          expect(announcement_b.next).to eq announcement_c
        end
      end

      context 'ひとつ後に作成されたオブジェクトがない場合' do
        it 'nilが返ってくる' do
          expect(announcement_c.next).to be_nil
        end
      end
    end

    describe 'create_notice' do
      before do
        create(:general_user, :activated)
        create(:business_user, :activated)
      end

      context '作成した記事が公開用だった場合' do
        it '管理者以外に通知される' do
          expect do
            create(:announcement_published, poster_id: user.id).create_notices
          end.to change(Notice, :count).by(2).and have_enqueued_mail(
                                               NoticeMailer,
                                               :announcement,
                                             )
                                             .exactly(2)
                                             .times
        end
      end

      context '作成した記事が下書きだった場合' do
        it '誰にも通知されない' do
          expect do
            create(:announcement_draft, poster_id: user.id)
          end.not_to change(Notice, :count)
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: announcements
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  published_before :boolean          default(FALSE), not null
#  status           :integer          default("published"), not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  poster_id        :integer          not null
#
