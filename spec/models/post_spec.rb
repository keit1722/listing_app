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
    let!(:post_a) { create(:post_published, postable: restaurant) }
    let!(:post_b) { create(:post_published, postable: restaurant) }
    let!(:post_c) { create(:post_published, postable: restaurant) }

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
    let!(:post_a) { create(:post_published, postable: restaurant) }
    let!(:post_b) { create(:post_published, postable: restaurant) }
    let!(:post_c) { create(:post_published, postable: restaurant) }

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

    describe 'create_notices' do
      let(:user_a) { create(:general_user, :activated) }
      let(:user_b) { create(:general_user, :activated) }
      let(:user_c) { create(:general_user, :activated) }
      let(:post) { create(:post_published, postable: restaurant) }

      around { |example| perform_enqueued_jobs(&example) }

      before do
        user_a.bookmark(restaurant)
        user_b.bookmark(restaurant)
        user_b.incoming_email.update(post: false)
        ActionMailer::Base.deliveries.clear
        post.create_notices('新しく投稿をしました')
      end

      it 'お気に入り登録しているユーザにのみ投稿した通知が送られる' do
        expect(user_a.notices).to exist
        expect(user_b.notices).to exist
        expect(user_c.notices).to be_empty
      end

      it 'お気に入り登録して、なおかつ投稿のメール通知をオンにしているユーザにのみメール送信がおこなわれる' do
        mails = ActionMailer::Base.deliveries
        recievers =
          User.joins(:incoming_email).where(incoming_email: { post: true })

        expect(mails.size).to eq(recievers.size)
        expect(mails.first.to.first).to eq(user_a.email)
      end
    end
  end
end

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  postable_type    :string
#  published_before :boolean          default(FALSE), not null
#  status           :integer          not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  postable_id      :bigint
#
# Indexes
#
#  index_posts_on_postable_type_and_postable_id  (postable_type,postable_id)
#
