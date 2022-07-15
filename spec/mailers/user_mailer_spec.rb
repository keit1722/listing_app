require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'UserMailer' do
    let(:user_inactivated) { create(:general_user) }
    let(:activation_needed_email) do
      described_class.activation_needed_email(user_inactivated)
    end

    it 'アクティベーションメールが送られること' do
      expect(activation_needed_email.subject).to eq 'メールアドレス確認メール'
      expect(activation_needed_email.to).to eq [user_inactivated.email]
    end
  end
end
