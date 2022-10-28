# listing app

## Feature

### バックエンド言語

- Ruby 3.1.2
- Rails 6.1.7

### フロントエンド言語

- CSS
- JavaScript

### データベース

- PostgreSQL
- Redis

### アプリケーションサーバ

- Puma

### デプロイ

- [Heroku](https://jp.heroku.com/home)

### メール送信

- [SendGrid](https://sendgrid.com/)

### ユーザー承認

- [Sorcery](https://github.com/Sorcery/sorcery)

### Decorator

- [draper](https://github.com/drapergem/draper)

### アップロード

- ActiveStorage

### ストレージ

- [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide//Welcome.html)

### バックグラウンドジョブ

- [Sidekiq](https://github.com/mperham/sidekiq)

### コード解析

- [RuboCop](https://github.com/rubocop/rubocop)
- [Bullet](https://github.com/flyerhzm/bullet)

### テスト

- [RSpec](https://github.com/rspec/rspec-rails)

### CI

- [GitHub Actions](https://docs.github.com/en/actions)

## Project initiation

#### リモートリポジトリをローカルにクローン

```
$ git clone git@github.com:keit1722/listing_app.git
```

### Gemインストール

```
$ bundle install --path vendor/bundle
```

### Redis立ち上げ

```
$ redis-server
```

### データベース作成

```
$ bundle exec rails db:create
```

### データベースにテーブルを作成（Ridgepoleを利用）

```
$ bundle exec rake ridgepole:apply
```

### seedデータを反映

```
$ bundle exec rails db:seed
```

### Railsサーバ立ち上げ

```
$ bundle exec rails s
```

## Environment variable

### 環境変数には以下の情報を設定

```
domain: <本番環境でアプリ公開時の独自ドメイン>
basic_auth:
  user: <Basic認証で利用するユーザ名>
  password: <Basic認証で利用するパスワード>
google_maps:
  api_key: <GoogleマップのAPI key>
google_oauth:
  client_id: <Google Oauthのclient ID>
  client_secret: <Google Oauthのclient secret>
aws:
  access_key_id: <AWSのaccess key ID>
  secret_access_key: <AWSのsecret access key>
email:
  sender: <独自ドメインメールの送信元メールアドレス>
```
