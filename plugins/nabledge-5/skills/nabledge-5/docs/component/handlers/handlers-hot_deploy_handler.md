# ホットデプロイハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/hot_deploy_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/hotdeploy/HotDeployHandler.html)

## ハンドラクラス名

開発時にアプリケーションのホットデプロイを行うハンドラ。本ハンドラを使用することで、アプリケーションサーバを再起動することなくアクションクラスやフォームクラスの変更を即座に反映できる。それにより、ソースコードを修正するたびにアプリケーションサーバを再起動するといった手間を省き、効率よく作業を進めることができる。

**クラス名**: `nablarch.fw.hotdeploy.HotDeployHandler`

> **重要**: 本ハンドラはリクエスト毎にクラスの再ロードを行うため、レスポンス速度が低下する可能性がある。**開発環境での使用のみ想定しており、本番環境では絶対に使用してはならない。**

> **重要**: リクエスト単体テスト時には本ハンドラを使用しないこと（テストが正常に動作しない可能性がある）。

> **補足**: 本ハンドラを使用する場合は、サーバのホットデプロイ機能を無効化すること。

<details>
<summary>keywords</summary>

HotDeployHandler, nablarch.fw.hotdeploy.HotDeployHandler, ホットデプロイハンドラ, アクションクラス反映, フォームクラス反映, アプリケーションサーバ再起動不要, 開発環境専用, 本番環境禁止, クラスリロード, リクエスト単体テスト非対応

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-hotdeploy</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web-hotdeploy, com.nablarch.framework, Maven依存設定, モジュール

</details>

## 制約

HotDeployHandlerに対する制約はなし。

<details>
<summary>keywords</summary>

制約なし, HotDeployHandler制約

</details>

## ホットデプロイ対象のパッケージを指定する

`targetPackages` プロパティにホットデプロイ対象パッケージを設定する。

```xml
<component class="nablarch.fw.hotdeploy.HotDeployHandler">
  <property name="targetPackages">
    <list>
      <value>please.change.me.web.action</value>
      <value>please.change.me.web.form</value>
    </list>
  </property>
</component>
```

> **重要**: エンティティクラスはホットデプロイ対象にしてはならない。理由: (1) 頻繁に変更されないクラスも含まれレスポンス速度が低下する恐れがある (2) リクエスト毎にクラスローダが変わるため、`:ref:session_store` 使用時などでエンティティクラスのキャストに失敗する場合がある。

<details>
<summary>keywords</summary>

targetPackages, HotDeployHandler設定, ホットデプロイ対象パッケージ, エンティティクラス除外, session_store, クラスローダ, キャスト失敗

</details>
