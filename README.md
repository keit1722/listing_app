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
