hot_springs_information = [
  {
    name: '白馬温泉',
    description: '創業100年の白馬温泉です。天然温泉をお楽しみください。',
    main_image: 'hot-spring-image-01.jpg'
  },
  {
    name: 'HAKUBA物語',
    description:
      '白馬の歴史を感じられる湯処です。水着を着て楽しめるブースもご用意しています。',
    main_image: 'hot-spring-image-02.jpg'
  },
  {
    name: '天然の湯',
    description:
      '当宿では源泉掛け流しの湯をお楽しみいただけます。大正ロマンの雰囲気感じる癒しの空間でゆっくりとしたひと時をお過ごしください。',
    main_image: 'hot-spring-image-03.jpg'
  },
  {
    name: 'スーパー銭湯',
    description:
      'ナノ炭酸泉、ジェットバス、サウナなど9つのお風呂を完備した室内大浴場と、庭園を眺めながらリゾート感覚を味わえる5つの露天風呂をお楽しみください。',
    main_image: 'hot-spring-image-04.jpg'
  },
  {
    name: '岩盤浴美々',
    description:
      'デトックス効果・アンチエイジング効果が期待できる“ロウリュウエンターテイメント”を1日9回実施しているな岩盤浴をご用意。岩盤浴後は天井より舞い降る雪を眺めながら、火照った体を優しくクールダウンできます。',
    main_image: 'hot-spring-image-05.jpg'
  }
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    hot_spring_attributes = {
      name: hot_springs_information[index][:name],
      description: hot_springs_information[index][:description],
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

    hot_spring_create_form =
      HotSpringCreateForm.new(
        organization,
        {
          district_id:,
          hot_spring_attributes:,
          opening_hours_attributes:,
          reservation_link_attributes:,
          page_show_attributes:
        }
      )

    hot_spring_create_form.hot_spring.main_image.attach(
      io:
        Rails.root.join(
          "app/assets/images/#{hot_springs_information[index][:main_image]}"
        ).open,
      filename: hot_springs_information[index][:main_image]
    )

    hot_spring_create_form.hot_spring.images.attach(
      [
        io:
          Rails.root.join('app/assets/images/hot-spring-image.jpg').open,
        filename: 'hot-spring-image.jpg'
      ],
      [
        io:
          Rails.root.join('app/assets/images/hot-spring-image-00.jpg').open,
        filename: 'hot-spring-image-00.jpg'
      ]
    )

    hot_spring_create_form.save
  end
