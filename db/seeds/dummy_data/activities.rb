activities_information = [
  {
    name: 'マウンテンバイク体験',
    description:
      '爽やかな夏、白馬の山々をマウンテンバイクで下山してみませんか？素敵な体験をお楽しみください。',
    main_image: 'activity-image-01.jpg',
  },
  {
    name: '白馬マウンテン',
    description:
      '身体を動かしたくなったら白馬マウンテンへ。絶景や自然の中で体験する様々なアクティビティで、心身ともにリフレッシュができます。',
    main_image: 'activity-image-02.jpg',
  },
  {
    name: 'パラグライダー白馬',
    description:
      '青空に飛び出して、鳥になった気分を楽しめるパラグライダー体験。空を飛ぶ夢が叶うひとときをご体感ください！',
    main_image: 'activity-image-03.jpg',
  },
  {
    name: 'ラフティングGOGO',
    description:
      '白馬でラフティングならラフティングGOGOで！大自然で手軽にアドベンチャー体験が楽しめますよ。所要時間3時間の別世界、非日常を手軽に体験してみませんか!?',
    main_image: 'activity-image-04.jpg',
  },
  {
    name: '長野山麓ツアー',
    description:
      'トレッキングやラフティングなど、様々なアクティビティをご紹介しています。ぜひ一度ご相談ください。',
    main_image: 'activity-image-05.jpg',
  },
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    activity_attributes = {
      name: activities_information[index][:name],
      description: activities_information[index][:description],
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

    page_show_attributes = { reservation_link: true, opening_hours: true }

    activity_create_form =
      ActivityCreateForm.new(
        organization,
        {
          district_id: district_id,
          activity_attributes: activity_attributes,
          opening_hours_attributes: opening_hours_attributes,
          reservation_link_attributes: reservation_link_attributes,
          page_show_attributes: page_show_attributes,
        },
      )

    activity_create_form.activity.main_image.attach(
      io:
        File.open(
          Rails.root.join(
            "app/assets/images/#{activities_information[index][:main_image]}",
          ),
        ),
      filename: activities_information[index][:main_image],
    )

    activity_create_form.activity.images.attach(
      [
        io: File.open(Rails.root.join('app/assets/images/activity-image.jpg')),
        filename: 'activity-image.jpg',
      ],
      [
        io:
          File.open(Rails.root.join('app/assets/images/activity-image-00.jpg')),
        filename: 'activity-image-00.jpg',
      ],
    )

    activity_create_form.save
  end
