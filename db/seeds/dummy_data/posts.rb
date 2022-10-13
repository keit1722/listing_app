posts_data = [
  {
    title: '来月の営業時間について',
    body:
      "来月の営業時間を一部変更させていただきます。\r\n変更後の営業時間は以下になります。\r\n\r\n＝＝＝＝＝＝＝＝＝＝\r\n月曜日：9:00 ~ 17:00\r\n火曜日：9:00 ~ 17:00\r\n水曜日：9:00 ~ 17:00\r\n木曜日：9:00 ~ 17:00\r\n金曜日：9:00 ~ 17:00\r\n＝＝＝＝＝＝＝＝＝＝\r\n\r\n土曜日・日曜日、祝日については変更はありません。",
  },
  {
    title: 'セルフレジ導入のお知らせ',
    body:
      "お世話になっております。\r\nこの度、感染症拡大防止、レジでの待ち時間を短縮するためにセルフレジを導入いたします。\r\n\r\nお客様ご自身でお支払いの操作をいただき、スタッフとの接触を減らすことで感染症拡大防止に寄与します。\r\n\r\nご不明な点がございましたら、お気軽に近くのスタッフにお声がけください。\r\n通常のレジは今まで通りご利用いただけます。",
  },
  {
    title: '新年のご挨拶',
    body:
      "あけましておめでとうございます。\r\n\r\n旧年中は格別のご厚情を賜り、厚く御礼を申し上げます。\r\n本年も、更なるサービスの向上に努めて参りますので、\r\nより一層のご支援、お引き立てを賜りますようよろしくお願い申し上げます。\r\n\r\n これまでにたくさんのお客様と出会い、多くの方々に私たちの商品をご愛用いただけるよう\r\n従業員一同心より御礼申し上げます。\r\n\r\n本年もどうぞよろしくお願い致します。",
  },
  {
    title: 'キャッシュレス決済のお知らせ',
    body:
      "日頃より当店をご利用いただき、誠にありがとうございます。\r\n\r\n来月1日より、キャッシュレスでのお支払いが可能になりました。\r\nこれまでの決済方法と比べて頂き、ご検討の上ご利用いただければと思います。\r\n\r\nキャッシュレス決済サービスにつきまして詳しい内容は現地スタッフへのご確認をよろしくお願いいたします。\r\n\r\n皆さまのご来店をお待ちしています。",
  },
  {
    title: '店舗リニューアルのお知らせ',
    body:
      "日頃より、ご愛顧いただき、誠にありがとうございます。\r\nさて、来月1日、この度新店舗として生まれ変わりました。\r\nリニューアルオープンができましたのも、ひとえに皆様方のお引き立てと一同感謝申し上げます。\r\n\r\n今後、皆様から愛される店舗づくりに邁進していく所存です。\r\n皆様のご来店を 心よりお待ち申し上げております。",
  },
]

models = %w[Restaurant Hotel Activity HotSpring SkiArea Shop]

models.each do |model|
  model
    .constantize
    .limit(5)
    .each do |instance|
      posts_data.size.times do |index|
        instance.posts.create(
          title: posts_data[index][:title],
          body: posts_data[index][:body],
          status: :published,
          published_before: true,
        )
      end
    end
end