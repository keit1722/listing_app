shops_information = [
  {
    name: 'スキーレンタルレモネード',
    description:
      '”誰もが、スキーを！”をモットーに低価格、高品質のレンタルを目指しているスキーレンタルレモネードです。団体様も、家族連れも、おまかせください。事前予約でお宿まで無料配達致します。細かな事もぜひご相談くださいませ。',
    category: 'レンタルショップ',
    main_image: 'shop-image-01.jpg',
  },
  {
    name: 'みやげ屋',
    description:
      '長野県のお土産はすべて当店で揃います！ご試食も用意しておりますので、ごゆっくりと買い物をお楽しみください。',
    category: 'お土産',
    main_image: 'shop-image-02.jpg',
  },
  {
    name: 'おやき白馬堂',
    description:
      '長野県名物のおやきを製造・販売しています。焼きおやきから蒸しおやきまで様々ご用意しています！是非一度お立ち寄りくださいませ。',
    category: 'お土産',
    main_image: 'shop-image-03.jpg',
  },
  {
    name: 'シックスイレブン',
    description:
      '朝6時から夜11時まで営業しているコンビニエンスストアです。旅行で足りないものがあればいつでもご利用ください。',
    category: 'コンビニ',
    main_image: 'shop-image-04.jpg',
  },
  {
    name: '薬局白馬',
    description:
      '全国各地の処方箋を受付いたします。ジェネリック薬品もご紹介しますよ。',
    category: '薬局',
    main_image: 'shop-image-05.jpg',
  },
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    shop_attributes = {
      name: shops_information[index][:name],
      description: shops_information[index][:description],
      lat: Faker::Number.between(from: 36.652929, to: 36.730255),
      lng: Faker::Number.between(from: 137.797967, to: 137.886880),
      address:
        "長野県北安曇郡白馬村#{Faker::Address.unique.city} #{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 3)}",
      slug: Faker::Internet.unique.domain_word,
    }

    district_id = District.all[rand(District.all.size)].id.to_s
    opening_hours_attributes = {
      '0': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'monday',
        closed: false,
      },
      '1': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'tuesday',
        closed: false,
      },
      '2': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'wednesday',
        closed: false,
      },
      '3': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'thursday',
        closed: false,
      },
      '4': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'friday',
        closed: false,
      },
      '5': {
        start_time_hour: '00',
        start_time_minute: '00',
        end_time_hour: '00',
        end_time_minute: '00',
        day: 'saturday',
        closed: true,
      },
      '6': {
        start_time_hour: '00',
        start_time_minute: '00',
        end_time_hour: '00',
        end_time_minute: '00',
        day: 'sunday',
        closed: true,
      },
      '7': {
        start_time_hour: '00',
        start_time_minute: '00',
        end_time_hour: '00',
        end_time_minute: '00',
        day: 'holiday',
        closed: true,
      },
    }
    reservation_link_attributes = { link: 'https://google.com' }

    shop_category_ids = [
      ShopCategory.find_by(name: shops_information[index][:category]).id.to_s,
    ]

    page_show_attributes = { reservation_link: true, opening_hours: true }

    shop_create_form =
      ShopCreateForm.new(
        organization,
        {
          district_id: district_id,
          shop_attributes: shop_attributes,
          opening_hours_attributes: opening_hours_attributes,
          reservation_link_attributes: reservation_link_attributes,
          shop_category_ids: shop_category_ids,
          page_show_attributes: page_show_attributes,
        },
      )

    shop_create_form.shop.main_image.attach(
      io:
        File.open(
          Rails.root.join(
            "app/assets/images/#{shops_information[index][:main_image]}",
          ),
        ),
      filename: shops_information[index][:main_image],
    )

    shop_create_form.shop.images.attach(
      [
        io: File.open(Rails.root.join('app/assets/images/shop-image.jpg')),
        filename: 'hotel-image.jpg',
      ],
      [
        io: File.open(Rails.root.join('app/assets/images/shop-image-00.jpg')),
        filename: 'shop-image-00.jpg',
      ],
    )

    shop_create_form.save
  end
