restaurants_information = [
  {
    name: 'Trattoria HAKUBA',
    description:
      'イタリア郷土料理を洗練された雰囲気で楽しめるトラットリアです。白馬豚・地場野菜など白馬の地産地消を豊富なワインと共に楽しめます。',
    category: '洋食',
    main_image: 'restaurant-image-01.jpg'
  },
  {
    name: 'そば処信州',
    description:
      "山野草を見ながら、この道40年の職人が打ち上げる本格手打ちそばをご賞味ください。信州安曇野にお越しの際は、お気軽にお立ち寄りください。\r\n大自然が生んだ当店こだわりの蕎麦の味をお試し下さい。",
    category: 'そば',
    main_image: 'restaurant-image-02.jpg'
  },
  {
    name: 'NAGANO Craft',
    description:
      "民家カフェ ほっこりは、築100年以上の古民家を改装して立ち上げました。この建物に使われている木々は、時間が経つごとに古くなるのではなく、より風合いの良さが増していきます。\r\n初めて来たのに、暖かく、どこか懐かしい。そんな気分になっていただけることでしょう。\r\n歴史とぬくもりあるこの空間で、人との関わり合いの温かさを感じていただければ幸いです。",
    category: 'バー',
    main_image: 'restaurant-image-03.jpg'
  },
  {
    name: '古民家カフェほっこり',
    description:
      '岩岳スキー場まで徒歩圏内の民宿です。美味しい食事と暖かさでおもてなしいたします。美しい自然と懐かしい風景が待っています。',
    category: 'カフェ',
    main_image: 'restaurant-image-04.jpg'
  },
  {
    name: '居酒屋こいこい',
    description:
      'みなさまに居心地良く過ごしてもらえるような、おもてなしを心掛けております。清潔なベッドと温かいお食事をご用意してお待ちしておりますので、観光、登山、スキーなどの拠点としてご利用ください。',
    category: '居酒屋',
    main_image: 'restaurant-image-05.jpg'
  }
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    restaurant_attributes = {
      name: restaurants_information[index][:name],
      description: restaurants_information[index][:description],
      lat: Faker::Number.between(from: 36.652929, to: 36.730255),
      lng: Faker::Number.between(from: 137.797967, to: 137.886880),
      address:
        "長野県北安曇郡白馬村#{Faker::Address.unique.city} #{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 3)}",
      slug: Faker::Internet.unique.domain_word
    }

    district_id = District.all[rand(District.all.size)].id.to_s
    opening_hours_attributes = {
      '0': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'monday',
        closed: false
      },
      '1': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'tuesday',
        closed: false
      },
      '2': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'wednesday',
        closed: false
      },
      '3': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'thursday',
        closed: false
      },
      '4': {
        start_time_hour: '9',
        start_time_minute: '00',
        end_time_hour: '17',
        end_time_minute: '00',
        day: 'friday',
        closed: false
      },
      '5': {
        start_time_hour: '00',
        start_time_minute: '00',
        end_time_hour: '00',
        end_time_minute: '00',
        day: 'saturday',
        closed: true
      },
      '6': {
        start_time_hour: '00',
        start_time_minute: '00',
        end_time_hour: '00',
        end_time_minute: '00',
        day: 'sunday',
        closed: true
      },
      '7': {
        start_time_hour: '00',
        start_time_minute: '00',
        end_time_hour: '00',
        end_time_minute: '00',
        day: 'holiday',
        closed: true
      }
    }
    reservation_link_attributes = { link: 'https://google.com' }

    restaurant_category_ids = [
      RestaurantCategory
        .find_by(name: restaurants_information[index][:category])
        .id
        .to_s
    ]

    page_show_attributes = { reservation_link: true, opening_hours: true }

    restaurant_create_form =
      RestaurantCreateForm.new(
        organization,
        {
          district_id: district_id,
          restaurant_attributes: restaurant_attributes,
          opening_hours_attributes: opening_hours_attributes,
          reservation_link_attributes: reservation_link_attributes,
          restaurant_category_ids: restaurant_category_ids,
          page_show_attributes: page_show_attributes
        }
      )

    restaurant_create_form.restaurant.main_image.attach(
      io:
        Rails.root.join(
          "app/assets/images/#{restaurants_information[index][:main_image]}"
        ).open,
      filename: restaurants_information[index][:main_image]
    )

    restaurant_create_form.restaurant.images.attach(
      [
        io:
          Rails.root.join('app/assets/images/restaurant-image.jpg').open,
        filename: 'hotel-image.jpg'
      ],
      [
        io:
          Rails.root.join('app/assets/images/restaurant-image-00.jpg').open,
        filename: 'restaurant-image-00.jpg'
      ]
    )

    restaurant_create_form.save
  end
