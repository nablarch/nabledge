# POST再送信防止ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/post_resubmit_prevent_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/post/PostResubmitPreventHandler.html)

## ハンドラクラス名

POSTで受け付けたリクエストに対して、リダイレクトを使用し再度リクエストを受け付けなおす処理を行うハンドラ。ブラウザ上のリロード処理などによる誤操作による意図しないPOSTリクエストの再送を防ぐ目的で使用する。

> **重要**: 新規プロジェクトでの使用は推奨しない。

**クラス名**: `PostResubmitPreventHandler`

ハンドラの動作:
1. POST再送信防止対象（POSTかつリクエストパラメータに`POST_RESUBMIT_PREVENT_PARAM`が含まれる）の場合: リクエストパラメータをセッションに保存してリダイレクト先にリダイレクトする（`n:form`タグの`preventPostResubmit="true"`設定で`POST_RESUBMIT_PREVENT_PARAM`が自動付与される）。
2. POST再送信防止によるGETリクエストの場合: セッションからリクエストパラメータを復元してセッションから削除する。セッションにパラメータが存在しない場合は再送信として所定のエラー画面を表示する。

<details>
<summary>keywords</summary>

PostResubmitPreventHandler, nablarch.fw.web.post.PostResubmitPreventHandler, POST_RESUBMIT_PREVENT_PARAM, preventPostResubmit, POST再送信防止, リダイレクト処理, セッション保存

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール依存関係

</details>

## 制約

> **重要**: 大量のPOSTリクエスト送信時にPOST情報がセッションに蓄積してメモリを圧迫する。連続POSTによるDoS攻撃に対して脆弱。代替手段として業務アクションでリダイレクトのレスポンスを返すことを検討すること。

**配置順序**: :ref:`nablarch_tag_handler` より前に配置すること。カスタムタグ制御ハンドラによる暗号化パラメータの復元前にリダイレクトを行う必要があるため。

<details>
<summary>keywords</summary>

nablarch_tag_handler, ハンドラ配置順序, DoS攻撃脆弱性, セッションメモリ圧迫, 配置制約, POST情報

</details>

## ポスト再送信防止の使用方法

1. 本ハンドラをハンドラキューに設定する。
2. JSPの`n:form`タグの`preventPostResubmit`属性を`true`に設定する。

<details>
<summary>keywords</summary>

preventPostResubmit, n:formタグ, ハンドラキュー設定, POST再送信防止使用方法

</details>

## リクエスト先と遷移先パスのマッピングを行う

リクエストIDの前方一致で遷移先パスをマッピングする。複数のキーがマッチした場合、最も文字数が長いキーに対応するパスが選択される。

**プロパティ**: `forwardPathMapping`（Map型）

```xml
<component name="postResubmitPreventHandler"
    class="nablarch.fw.web.post.PostResubmitPreventHandler">
  <property name="forwardPathMapping">
    <map>
      <entry key="/"  value="redirect:///action/error/index" />
      <entry key="/action/func1/" value="redirect:///action/error/index2" />
      <entry key="/action/func2/" value="/error.jsp" />
    </map>
  </property>
</component>
```

例: リクエストID「/action/func1/index」は`/`と`/action/func1/`の両方にマッチするが、より長いキー`/action/func1/`に対応する`redirect:///action/error/index2`が選択される。

<details>
<summary>keywords</summary>

forwardPathMapping, 前方一致マッピング, リダイレクト先設定, 最長一致, 遷移先パス設定

</details>
