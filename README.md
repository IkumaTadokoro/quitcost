# quitcost

![image](https://user-images.githubusercontent.com/61409641/161411721-2c357460-910a-4674-854d-ff541f82963a.png)

quitcostは**無職になったら**『**どんな**』個人負担が『**いくら**』増えるのかを簡単に知ることができるサービスです。

「転職のためにしばらく無職になる予定だけど、保険とか税金とか、何をいくら払えばいいかわからない！！」

quitcostを使えば、年齢や住所、昨年の年収を回答することで、無職後に負担になる「税金」「保険」「年金」の料金を一括で知ることができます。

## 機能概要

![image](https://user-images.githubusercontent.com/61409641/161371308-b8ccce3d-5318-4069-ba8a-fc40b1537afc.png)

- ユーザーはいくつかの質問に回答することで、無職期間にかかる「国民健康保険料」「国民年金」「住民税」の金額を計算することができます。
- 管理者は計算に必要な「国民健康保険料の料率」と「国民年金保険料の料率」を一覧・登録・更新・削除することができます。

### スクリーンショット

**ユーザー画面**

<img width="1680" alt="CleanShot 2022-04-03 at 13 32 49@2x" src="https://user-images.githubusercontent.com/61409641/161411632-00f67e70-7b86-43c3-9dc8-f992cf23a9c7.png">

<img width="1680" alt="CleanShot 2022-04-03 at 13 33 58@2x" src="https://user-images.githubusercontent.com/61409641/161411655-60813464-3bfb-43eb-b172-091f0f9ad932.png">

![CleanShot 2022-04-03 at 13 34 35@2x](https://user-images.githubusercontent.com/61409641/161411664-ad81f69d-c792-4a49-b169-6e3ade20b99a.png)

**管理者画面**

<img width="1680" alt="CleanShot 2022-04-03 at 13 35 14@2x" src="https://user-images.githubusercontent.com/61409641/161411684-4f493103-d4da-4f7a-8854-cfce316794f0.png">

<img width="1680" alt="CleanShot 2022-04-03 at 13 35 36@2x" src="https://user-images.githubusercontent.com/61409641/161411698-7e2d06e5-0704-4e3c-8dbf-1fb79b261f11.png">

## 利用方法

### ユーザー

https://quitcost.herokuapp.com からご利用いただけます。


### 管理者

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
$ docker-compose exec web bash

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
2. 環境設定 -> セキュリティから「ネットワーク・クライアントからの接続を許可」にチェックを入れる（XQuartz.appの再起動が必要）
   ![image](https://user-images.githubusercontent.com/61409641/161372070-e4bbce84-08ec-44e3-ae76-1335878814d5.png)

3. コンテナ外で`bin/cyopen`を実行。Test Runnerが立ち上がります

## Lint

```bash
$ docker-compose exec web bash

# 以下コンテナ内で実行
$ bin/lint
```
