# Nablarchカスタムタグ制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/nablarch_tag_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/tag/CustomTagConfig.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/NablarchTagHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.web.handler.NablarchTagHandler`

:ref:`tag` に必要な以下のリクエスト処理を行う:

1. カスタムタグのデフォルト値をJSPで参照できるよう、`CustomTagConfig` をリクエストスコープに設定
2. :ref:`hidden暗号化<tag-hidden_encryption>` の改竄チェックと復号処理
3. :ref:`チェックボックスのチェックなしに対する値<tag-checkbox_off_value>` をリクエストに設定
4. :ref:`ボタン又はリンク毎のパラメータ追加<tag-submit_change_parameter>` のためリクエストにパラメータを追加
5. [http_access_log](../libraries/libraries-http_access_log.md) のリクエストパラメータを出力
6. :ref:`複合キーを扱える<tag-composite_key>` ようにするため複合キーを復元

> **補足**: GETリクエストの場合、hiddenパラメータに関連する処理は行わず、複合キーの復元処理のみ行う（:ref:`tag-using_get` 参照）。

<details>
<summary>keywords</summary>

NablarchTagHandler, nablarch.common.web.handler.NablarchTagHandler, CustomTagConfig, nablarch.common.web.tag.CustomTagConfig, カスタムタグ制御, hidden暗号化, チェックボックス, 複合キー復元, リクエスト処理

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web-tag, com.nablarch.framework, モジュール, 依存関係, Maven

</details>

## 制約

- [multipart_handler](handlers-multipart_handler.md) より後ろに設定すること。リクエストパラメータにアクセスするため。
- :ref:`hidden暗号化<tag-hidden_encryption>` 使用時は、[thread_context_handler](handlers-thread_context_handler.md) より後ろに設定すること。スレッドコンテキストからリクエストIDを取得するため。

<details>
<summary>keywords</summary>

ハンドラ順序, multipart_handler, thread_context_handler, 設定順序制約, hidden暗号化, リクエストID

</details>

## 復号に失敗(改竄エラー、セッション無効化エラー)した場合のエラーページを設定する

:ref:`hidden暗号化<tag-hidden_encryption>` の復号処理は以下2ケースで失敗する:

- 暗号化データが改竄された場合（改竄エラー）
- セッションから復号に使う鍵を取得できない場合（セッション無効化エラー）

`NablarchTagHandler` の設定でエラーページとステータスコードを指定できる。`sessionExpirePath` を省略した場合は改竄エラー時の設定が使用される。

```xml
<component name="nablarchTagHandler"
           class="nablarch.common.web.handler.NablarchTagHandler">
  <!-- 改竄エラー発生時 -->
  <property name="path" value="/TAMPERING-DETECTED.jsp" />
  <property name="statusCode" value="400" />
  <!-- セッション無効化エラー発生時（省略時は改竄エラー設定が使用される） -->
  <property name="sessionExpirePath" value="/SESSION-EXPIRED.jsp" />
  <property name="sessionExpireStatusCode" value="400" />
</component>
```

<details>
<summary>keywords</summary>

改竄エラー, セッション無効化エラー, 復号失敗, エラーページ設定, path, statusCode, sessionExpirePath, sessionExpireStatusCode, NablarchTagHandler

</details>
