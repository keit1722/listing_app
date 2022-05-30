# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  name       :string           not null
#  phone      :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_name  (name) UNIQUE
#  index_organizations_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'バリデーション' do
    it '会社名・屋号は必須であること' do
      organization = build(:organization, name: nil)
      organization.valid?
      expect(organization.errors[:name]).to include('を入力してください')
    end

    it '会社名・屋号は一意であること' do
      organization = create(:organization)
      same_name_organization = build(:organization, name: organization.name)
      same_name_organization.valid?
      expect(same_name_organization.errors[:name]).to include(
        'はすでに存在します',
      )
    end

    it '住所は必須であること' do
      organization = build(:organization, address: nil)
      organization.valid?
      expect(organization.errors[:address]).to include('を入力してください')
    end

    it '電話番号は必須であること' do
      organization = build(:organization, phone: nil)
      organization.valid?
      expect(organization.errors[:phone]).to include('を入力してください')
    end

    it '電話番号は10文字以上であること' do
      organization =
        build(:organization, phone: Faker::Number.number(digits: 9))
      organization.valid?
      expect(organization.errors[:phone]).to include(
        'は10文字以上で入力してください',
      )
    end

    it '電話番号は11文字以内であること' do
      organization =
        build(:organization, phone: Faker::Number.number(digits: 12))
      organization.valid?
      expect(organization.errors[:phone]).to include(
        'は11文字以内で入力してください',
      )
    end

    it '電話番号は数値であること' do
      organization =
        build(
          :organization,
          phone: Faker::PhoneNumber.phone_number.delete('-').tr('0-9', '０-９'),
        )
      organization.valid?
      expect(organization.errors[:phone]).to include('は数値で入力してください')
    end

    it 'スラッグは必須であること' do
      organization = build(:organization, slug: nil)
      organization.valid?
      expect(organization.errors[:slug]).to include('を入力してください')
    end

    it 'スラッグは一意であること' do
      organization = create(:organization)
      same_slug_organization = build(:organization, slug: organization.slug)
      same_slug_organization.valid?
      expect(same_slug_organization.errors[:slug]).to include(
        'はすでに存在します',
      )
    end
  end
end
