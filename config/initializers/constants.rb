module Constants
  AREA_GROUPS = [
    {
      area: 'iwatake',
      display: '岩岳',
      grouped: %w[どんぐり 新田 切久保 落倉],
    },
    {
      area: 'hakuba_station',
      display: '白馬駅',
      grouped: %w[八方口 深空 蕨平 白馬町 大出],
    },
    {
      area: 'happo',
      display: '八方',
      grouped: %w[山麓 和田野 エコーランド 八方 瑞穂 みそら野],
    },
    { area: 'goryu_47', display: '五竜 / 47', grouped: %w[飯森 飯田 めいてつ] },
    { area: 'sanosaka', display: 'さのさか', grouped: %w[沢渡 佐野 内山] },
    {
      area: 'other_hakuba',
      display: 'その他（白馬）',
      grouped: %w[堀之内 三日市場 嶺方 野平 青鬼 立の間 通 塩島 森上],
    },
    { area: 'tsugaike', display: '栂池', grouped: %w[千国] },
    {
      area: 'other_otari',
      display: 'その他（小谷）',
      grouped: %w[北小谷 中土],
    },
  ]
end
