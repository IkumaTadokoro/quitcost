# quitcost

![image](https://user-images.githubusercontent.com/61409641/140843415-ff8d5d7c-3aa2-4128-9749-0d4528dc6e21.png)

`quitcost`は『どんな』個人負担が『いくら』増えるのかを簡単に知ることができるサービスです。

「転職のためにしばらく無職になる予定だけど、保険とか税金とか、何をいくら払えばいいかわからない！！」

`quitcost`を使えば、年齢や住所、昨年の年収を回答することで、無職後に負担になる「税金」「保険」「年金」の料金を一括で知ることができます。

## 機能概要

- ユーザーは「退職予定月・転職予定月・年齢・郵便番号・所得・社会保険料」を回答することで、退職〜次回転職までにかかる「国民健康料」「国民年金」「住民税」の総額および月別・料金別の金額を計算することができます。
- 管理者は計算に必要な「国民健康料の料率」と「国民年金保険料の料率」を一覧・登録・更新・削除することができます。

## URL

```
TOOD:
```

## 利用方法(管理者)

`/users/sign_in`にアクセスし、管理者としてログインすることで、各種レコードの変更ができます。

| key | value |
|--|-------|
| Eメール | quitcost@example.com |
| パスワード | quitcost |

## インストール

```bash
# コンテナを起動
$ docker-compose up -d
$ docker-compose exec web bash

# 以下コンテナ内で実行
$ bin/setup
$ bin/rails s
```

## テスト

### RSpec + Jest

```bash
# 以下コンテナ内で実行
$ bin/test
```

### Cypress

```bash
# CypressのDockerイメージを利用するため、コンテナ外で実行することに注意

$ bin/cypress
```

### Cypress Test Runnerを使用する

Dockerコンテナ上で起動しているCypressをクライアント、ローカル環境をXサーバーとしてTest Runnerを投影します。

1. [XQuartz](https://www.xquartz.org/)をインストール
2. コンテナ外で`bin/cyopen`を実行。Test Runnerが立ち上がります

## Lint

```bash
# 以下コンテナ内で実行
$ bin/lint
```
