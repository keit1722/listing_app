users = [
  {
    last_name: '山田',
    first_name: '太郎',
    username: 'ゲストユーザー',
    email: 'guest@example.com',
    role: :general
  },
  {
    last_name: '佐藤',
    first_name: '次郎',
    username: 'アドミンユーザー',
    email: 'admin@example.com',
    role: :admin
  },
  {
    last_name: '鈴木',
    first_name: '三郎',
    username: 'ビジネスユーザー',
    email: 'business@example.com',
    role: :business
  }
]

users.each_with_index do |user, _index|
  created_user =
    User.create(
      last_name: user[:last_name],
      first_name: user[:first_name],
      username: user[:username],
      email: user[:email],
      role: user[:role],
      password: 'password',
      password_confirmation: 'password'
    )
  created_user.activate!
end

4.times do
  user =
    User.create(
      last_name: Faker::Name.unique.last_name,
      first_name: Faker::Name.unique.first_name,
      username: Faker::Internet.unique.user_name,
      email: Faker::Internet.unique.safe_email,
      password: 'password',
      password_confirmation: 'password',
      role: :business
    )
  user.activate!
end
