# POST再送信防止ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/post_resubmit_prevent_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/post/PostResubmitPreventHandler.html)

## ハンドラクラス名

> **重要**: 新規プロジェクトにおける本ハンドラの使用は推奨しない。

> **重要**: 大量のPOSTリクエスト送信時にPOST情報がセッションに蓄積されメモリを圧迫する。POSTリクエスト連続送信によるDOS攻撃に対して脆弱。代替として、業務アクションでリダイレクトのレスポンスを返す方式を検討すること。

POSTで受け付けたリクエストに対してリダイレクトを使用し再送信防止を行うハンドラ。ブラウザ上のリロード処理などによる誤操作による意図しないPOSTリクエストの再送を防ぐ目的で使用する。

**処理**:
1. POSTリクエストかつリクエストパラメータに `POST_RESUBMIT_PREVENT_PARAM` が含まれる場合: リクエストパラメータをセッションに保存してリダイレクト先にリダイレクト（n:formタグの `preventPostResubmit` が `true` に設定されると `POST_RESUBMIT_PREVENT_PARAM` が自動設定される）
2. POST再送信防止によるGETリクエストの場合: セッションのリクエストパラメータを復元してセッションから削除。セッションにパラメータが存在しない場合は所定のエラー画面を表示

**クラス**: `nablarch.fw.web.post.PostResubmitPreventHandler`

<details>
<summary>keywords</summary>

PostResubmitPreventHandler, nablarch.fw.web.post.PostResubmitPreventHandler, POST再送信防止, POST_RESUBMIT_PREVENT_PARAM, preventPostResubmit, リダイレクト, セッション保存, DOS攻撃, ブラウザリロード, 誤操作

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

**[nablarch_tag_handler](handlers-nablarch_tag_handler.md) より前に配置すること**: カスタムタグ制御ハンドラで暗号化パラメータを戻す前にリダイレクトを行う必要があるため、本ハンドラは [nablarch_tag_handler](handlers-nablarch_tag_handler.md) より前に配置する必要がある。

<details>
<summary>keywords</summary>

nablarch_tag_handler, ハンドラ配置順序, カスタムタグ制御ハンドラ, 暗号化パラメータ, 制約

</details>

## ポスト再送信防止の使用方法

本ハンドラをハンドラキューに設定したうえで、JSPファイル中のn:formタグの `preventPostResubmit` 属性を `true` に設定することで使用できる。

<details>
<summary>keywords</summary>

preventPostResubmit, n:formタグ, ハンドラキュー設定, JSP設定, ポスト再送信防止

</details>

## リクエスト先と遷移先パスのマッピングを行う

`forwardPathMapping` プロパティで、リダイレクト後のGETリクエストが複数回送信された場合の遷移先パスのマッピングを設定する。リクエストIDの前方一致でマッピングし、複数のキーがマッチした場合は最も文字数が長いキーに対応するパスが選択される。

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

例えば、リクエストID `/action/func1/index` は `/` と `/action/func1/` の両方に前方一致するが、より長いキー `/action/func1/` が優先され、`redirect:///action/error/index2` が選択される。

<details>
<summary>keywords</summary>

forwardPathMapping, リクエストIDマッピング, 前方一致, リダイレクト先設定

</details>
