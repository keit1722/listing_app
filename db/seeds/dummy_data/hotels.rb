hotels_information = [
  {
    name: '入山荘',
    description:
      '岩岳スキー場まで徒歩圏内の民宿です。美味しい食事と暖かさでおもてなしいたします。美しい自然と懐かしい風景が待っています。',
    main_image: 'hotel-image-01.jpg'
  },
  {
    name: 'ペンション白馬',
    description:
      'みなさまに居心地良く過ごしてもらえるような、おもてなしを心掛けております。清潔なベッドと温かいお食事をご用意してお待ちしておりますので、観光、登山、スキーなどの拠点としてご利用ください。',
    main_image: 'hotel-image-02.jpg'
  },
  {
    name: '民宿信州',
    description:
      '広い敷地を生かしてしいたけ狩りやバーベキュー、そして、すぐ近隣にもフルーツ狩りなどの体験ができる場所がたくさんあります。自家栽培の野菜や地の食材をふんだんに使った料理でお客様をお出迎えいたします。',
    main_image: 'hotel-image-03.jpg'
  },
  {
    name: 'ホテルニュー白馬',
    description:
      'レストランの窓から望む北アルプスの山々。温かみのある山小屋風のデザインでゆっくりとお食事をお楽しみいただけます。',
    main_image: 'hotel-image-04.jpg'
  },
  {
    name: 'ビジネスホテルHAKUBA',
    description:
      'ビジネスで白馬にお越しいただいた際には、是非とも当宿へご宿泊ください。リーズナブルで清潔な部屋とい美味しいお食事をたくさん用意してお待ちしております。',
    main_image: 'hotel-image-05.jpg'
  }
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    hotel_attributes = {
      name: hotels_information[index][:name],
      description: hotels_information[index][:description],
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

    page_show_attributes = { reservation_link: true, opening_hours: true }

    hotel_create_form =
      HotelCreateForm.new(
        organization,
        {
          district_id: district_id,
          hotel_attributes: hotel_attributes,
          opening_hours_attributes: opening_hours_attributes,
          reservation_link_attributes: reservation_link_attributes,
          page_show_attributes: page_show_attributes
        }
      )

    hotel_create_form.hotel.main_image.attach(
      io:
        Rails.root.join(
          "app/assets/images/#{hotels_information[index][:main_image]}"
        ).open,
      filename: hotels_information[index][:main_image]
    )

    hotel_create_form.hotel.images.attach(
      [
        io: Rails.root.join('app/assets/images/hotel-image.jpg').open,
        filename: 'hotel-image.jpg'
      ],
      [
        io: Rails.root.join('app/assets/images/hotel-image-00.jpg').open,
        filename: 'hotel-image-00.jpg'
      ]
    )

    hotel_create_form.save
  end
