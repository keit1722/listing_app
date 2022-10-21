announcements_data = [
  {
    title: 'システムメンテナンスのお知らせ',
    body:
      "平素は、当サービスをご利用いただき、誠にありがとうございます。\r\n下記の日程においてシステムのメンテナンスを実施いたします。\r\n\r\nメンテナンス期間中はホームページ内が一時的に正しく表示されない場合がございますので、ご了承ください。\r\n\r\n【システムメンテナンス期間】\r\n来月1日00:00～3:00まで\r\n\r\n※システムのメンテナンス時間については前後する場合がございます。予めご了承ください。\r\nお客さまにはご迷惑をおかけいたしますが、ご理解いただきますようお願いいたします。"
  },
  {
    title: '公式Facebookページ開始のお知らせ',
    body:
      "当サービスでは、昨日より公式Facebookページを公開しましたのでお知らせします。\r\nFacebookでは、色々な話題や商品情報などを、タイムリーに発信していきます。\r\n\r\n今後Facebookを活用して、皆様との交流を深めていきたいと考えております。\r\nぜひ「いいね」を押して公式Facebookページをご覧ください。"
  },
  {
    title: '新年のご挨拶',
    body:
      "あけましておめでとうございます。\r\n\r\n旧年中は格別のご厚情を賜り、厚く御礼を申し上げます。\r\n本年も、更なるサービスの向上に努めて参りますので、\r\nより一層のご支援、お引き立てを賜りますようよろしくお願い申し上げます。\r\n\r\n これまでにたくさんのお客様と出会い、多くの方々に私たちの商品をご愛用いただけるよう\r\n従業員一同心より御礼申し上げます。\r\n\r\n本年もどうぞよろしくお願い致します。"
  }
]

poster_id = User.admin.first.id

announcements_data.size.times do |index|
  Announcement.create(
    title: announcements_data[index][:title],
    body: announcements_data[index][:body],
    poster_id:,
    status: :published,
    published_before: true
  )
end
