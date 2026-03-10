# ホットデプロイハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/hot_deploy_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/hotdeploy/HotDeployHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.hotdeploy.HotDeployHandler`

開発環境専用のハンドラ。リクエストごとにクラスを再ロードし、アプリケーションサーバ再起動なしにアクションクラス・フォームクラスの変更を即座に反映する。

> **重要**: クラス再ロードによりレスポンス速度の低下につながる可能性があるため、**本番環境では絶対に使用してはならない。**

> **重要**: リクエスト単体テスト時には本ハンドラを使用しないこと（テストが正常に動作しない可能性がある）。

> **補足**: 本ハンドラを使用する場合は、サーバのホットデプロイ機能を無効化すること。

<details>
<summary>keywords</summary>

HotDeployHandler, nablarch.fw.hotdeploy.HotDeployHandler, ホットデプロイ, クラス再ロード, 開発環境専用, 本番環境禁止, リクエスト単体テスト

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-hotdeploy</artifactId>
</dependency>
```

**制約**: なし。

<details>
<summary>keywords</summary>

nablarch-fw-web-hotdeploy, com.nablarch.framework, モジュール, Maven依存関係, 制約, ホットデプロイハンドラ制約

</details>

## ホットデプロイ対象のパッケージを指定する

ホットデプロイ対象パッケージは `targetPackages` プロパティに設定する。

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

> **重要**: エンティティクラスはホットデプロイ対象にしてはならない。理由: (1) リクエストごとに対象パッケージ内の全クラスが再ロードされるためレスポンス速度の低下につながる恐れがある (2) リクエストごとにクラスローダが変わるため、`:ref:session_store` を使用した場合などでエンティティクラスのキャストに失敗する場合がある。

<details>
<summary>keywords</summary>

targetPackages, ホットデプロイ対象パッケージ, エンティティクラス除外, クラスローダ, session_store, キャスト失敗

</details>
