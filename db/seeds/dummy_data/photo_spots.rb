photo_spots_information = [
  {
    name: '白馬城',
    description: '長野県白馬村にある日本の城です。',
    main_image: 'photo-spot-image-01.jpg'
  },
  {
    name: '青空ブランコ',
    description: '青空を背に、ブランコを楽しんでいる様子を写真に収められます。',
    main_image: 'photo-spot-image-02.jpg'
  },
  {
    name: '小白馬駅',
    description:
      '長野県白馬村ある小さな駅。その駅から見える絶景は、言葉では表せないほどです。大自然を感じられるのはもちろん、マイナスイオンがたっぷり含まれた空気はあなたの心も体も癒します。',
    main_image: 'photo-spot-image-03.jpg'
  },
  {
    name: '長野タワー',
    description:
      '日本で3番目の高さを誇る長野タワー。夜にはライトアップされるので幻想的な雰囲気になります。',
    main_image: 'photo-spot-image-04.jpg'
  },
  {
    name: '信州湖',
    description:
      '天気のいい日には、池の水面に大迫力の白馬三山（白馬岳・杓子岳・白馬鑓ヶ岳）が映り込むのですが、鏡のように反射する山々は鮮やかでキレイです。',
    main_image: 'photo-spot-image-05.jpg'
  }
]

Organization
  .limit(5)
  .each_with_index do |organization, index|
    photo_spot_attributes = {
      name: photo_spots_information[index][:name],
      description: photo_spots_information[index][:description],
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

    photo_spot_create_form =
      PhotoSpotCreateForm.new(
        organization,
        {
          district_id:,
          photo_spot_attributes:,
          opening_hours_attributes:,
          reservation_link_attributes:,
          page_show_attributes:
        }
      )

    photo_spot_create_form.photo_spot.main_image.attach(
      io:
        Rails.root.join(
          "app/assets/images/#{photo_spots_information[index][:main_image]}"
        ).open,
      filename: photo_spots_information[index][:main_image]
    )

    photo_spot_create_form.photo_spot.images.attach(
      [
        io:
          Rails.root.join('app/assets/images/photo-spot-image.jpg').open,
        filename: 'photo-spot-image.jpg'
      ],
      [
        io:
          Rails.root.join('app/assets/images/photo-spot-image-00.jpg').open,
        filename: 'photo-spot-image-00.jpg'
      ]
    )

    photo_spot_create_form.save
  end
