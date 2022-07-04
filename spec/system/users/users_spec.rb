require 'rails_helper'

RSpec.describe 'ユーザー', type: :system do
  let(:user) { create(:general_user, :activated) }

  context 'a context' do
    it 'パスワードを忘れた場合の処理をするとメールが送られること' do
      visit new_password_reset_path
      fill_in 'メールアドレス', with: user.email
      perform_enqueued_jobs { click_button '送信' }
      mail = ActionMailer::Base.deliveries.last

      expect(mail.to.first).to eq user.email
      expect(mail.subject).to eq 'パスワード再設定メール'
    end
  end
end
