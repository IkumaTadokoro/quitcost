# quitcost

![image](https://user-images.githubusercontent.com/61409641/161408130-22cdf06a-7a3b-4470-a648-18bf8b6a2b79.png)

quitcostは**無職になったら**『**どんな**』個人負担が『**いくら**』増えるのかを簡単に知ることができるサービスです。

「転職のためにしばらく無職になる予定だけど、保険とか税金とか、何をいくら払えばいいかわからない！！」

quitcostを使えば、年齢や住所、昨年の年収を回答することで、無職後に負担になる「税金」「保険」「年金」の料金を一括で知ることができます。

## 機能概要

![image](https://user-images.githubusercontent.com/61409641/161371308-b8ccce3d-5318-4069-ba8a-fc40b1537afc.png)

- ユーザーはいくつかの質問に回答することで、無職期間にかかる「国民健康料」「国民年金」「住民税」の金額を計算することができます。
- 管理者は計算に必要な「国民健康料の料率」と「国民年金保険料の料率」を一覧・登録・更新・削除することができます。

### スクリーンショット

**ユーザー画面**

<img width="1680" alt="CleanShot 2022-04-02 at 16 09 54@2x" src="https://user-images.githubusercontent.com/61409641/161371512-c5fc44b4-defe-476d-8b60-fbb3f395f35e.png">

<img width="1680" alt="CleanShot 2022-04-02 at 16 11 01@2x" src="https://user-images.githubusercontent.com/61409641/161371555-386b0479-7630-4a68-9d33-dfd12a457ce7.png">

![CleanShot 2022-04-02 at 16 11 53@2x](https://user-images.githubusercontent.com/61409641/161371571-1935cf06-e68d-4338-9a4e-83118caa6612.png)


**管理者画面**

<img width="1680" alt="CleanShot 2022-04-02 at 16 13 10@2x" src="https://user-images.githubusercontent.com/61409641/161371624-d58524b6-8ba9-4ff2-84d2-05a031caa641.png">

<img width="1680" alt="CleanShot 2022-04-02 at 16 13 31@2x" src="https://user-images.githubusercontent.com/61409641/161371656-e5a73535-18dc-4623-a5c2-81465a415a9b.png">

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
