puts 'Start inserting seed "ski_areas" ...'

ski_areas_information = [
  {
    name: '白馬スノーパーク',
    description:
      '日本最大級のスキー場。最大標高は約15,00mあり、山頂まではゴンドラは一本で到達できます。リフトの数も日本トップクラスです。',
    main_image: 'ski-area-image-01.jpg'
  },
  {
    name: '切久保スキー場',
    description:
      'ファミリー向けのスキー場。レストハウスやキッズエリアも充実しています。ファミリー向けとは言っても上級者向けのコースも複数あるのでお子様以外も充分お楽しみいただけます。',
    main_image: 'ski-area-image-02.jpg'
  },
  {
    name: '小谷スノーフィールド',
    description:
      '新雪やパウダースノーが好きな方に適したスキー場です。ゲレンデの面積がとても広いことや林間コースがとても人気です！雪が降った日はとても混み合いますので朝イチでのご利用がおすすめです！',
    main_image: 'ski-area-image-03.jpg'
  },
  {
    name: '神城ウィンターパーク',
    description:
      'ハーフパイプやビッグエアーなどのパーク設備に力を入れています！プロによる設計や整備を施されており常に世界基準に合わせられています。近年ではスノーボーダーだけではなく多くのフリースタイルスキーヤーにも人気のスキー場です！',
    main_image: 'ski-area-image-04.jpg'
  },
  {
    name: '北城高原スキー場',
    description:
      '上級者コースが充実したスキー場です。リフトの数は多くありませんがその分リフト一本が長く山頂までもリフト2本を使えば到着できます！他のスキー場では味わえない急斜面コースに人気があり腕試しにぜひ！',
    main_image: 'ski-area-image-05.jpg'
  }
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    ski_area_attributes = {
      name: ski_areas_information[index][:name],
      description: ski_areas_information[index][:description],
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

    ski_area_create_form =
      SkiAreaCreateForm.new(
        organization,
        {
          district_id:,
          ski_area_attributes:,
          opening_hours_attributes:,
          reservation_link_attributes:,
          page_show_attributes:
        }
      )

    ski_area_create_form.ski_area.main_image.attach(
      io:
        Rails.root.join(
          "app/assets/images/#{ski_areas_information[index][:main_image]}"
        ).open,
      filename: ski_areas_information[index][:main_image]
    )

    ski_area_create_form.ski_area.images.attach(
      [
        io: Rails.root.join('app/assets/images/ski-area-image.jpg').open,
        filename: 'ski-area-image.jpg'
      ],
      [
        io:
          Rails.root.join('app/assets/images/ski-area-image-00.jpg').open,
        filename: 'ski-area-image-00.jpg'
      ]
    )

    ski_area_create_form.save
    puts "\"#{ski_area_create_form.ski_area.name}\" has created!"
  end
