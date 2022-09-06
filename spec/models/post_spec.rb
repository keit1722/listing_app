require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it 'タイトルは必要であること' do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include('を入力してください')
    end

    it '内容は必要であること' do
      post = build(:post, body: nil)
      post.valid?
      expect(post.errors[:body]).to include('を入力してください')
    end

    it 'ステータスは必要であること' do
      post = build(:post, status: nil)
      post.valid?
      expect(post.errors[:status]).to include('を入力してください')
    end
  end

  describe 'スコープ' do
    let(:restaurant) { create(:restaurant) }
    let!(:post_a) { create(:post, postable: restaurant) }
    let!(:post_b) { create(:post, postable: restaurant) }
    let!(:post_c) { create(:post, postable: restaurant) }

    describe 'ordered' do
      it { expect(described_class.ordered).to eq [post_c, post_b, post_a] }

      it { expect(described_class.ordered).not_to eq [post_a, post_b, post_c] }
    end

    describe 'recent' do
      it { expect(described_class.recent(2)).to eq [post_c, post_b] }

      it { expect(described_class.recent(3)).to eq [post_c, post_b, post_a] }
    end
  end

  describe 'インスタンスメソッド' do
    let(:restaurant) { create(:restaurant) }
    let!(:post_a) { create(:post, postable: restaurant) }
    let!(:post_b) { create(:post, postable: restaurant) }
    let!(:post_c) { create(:post, postable: restaurant) }

    describe 'previous' do
      context 'ひとつ前に作成されたオブジェクトがある場合' do
        it 'そのオブジェクトが特定される' do
          expect(post_b.previous).to eq post_a
        end
      end

      context 'ひとつ前に作成されたオブジェクトがない場合' do
        it 'nilが返ってくる' do
          expect(post_a.previous).to be_nil
        end
      end
    end

    describe 'next' do
      context 'ひとつ後に作成されたオブジェクトがある場合' do
        it 'そのオブジェクトが特定される' do
          expect(post_b.next).to eq post_c
        end
      end

      context 'ひとつ後に作成されたオブジェクトがない場合' do
        it 'nilが返ってくる' do
          expect(post_c.next).to be_nil
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  body          :text             not null
#  notice_title  :integer          default(1), not null
#  postable_type :string
#  status        :integer          not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_id   :bigint
#
# Indexes
#
#  index_posts_on_postable_type_and_postable_id  (postable_type,postable_id)
#
