# Nablarchカスタムタグ制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/nablarch_tag_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/tag/CustomTagConfig.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/NablarchTagHandler.html)

## ハンドラクラス名

:ref:`tag` に必要なリクエスト処理を行うハンドラ。

以下の処理を行う：
1. `CustomTagConfig` をリクエストスコープに設定（カスタムタグのデフォルト値をJSPで参照可能にする）
2. :ref:`hidden暗号化<tag-hidden_encryption>` の改竄チェックと復号処理
3. チェックボックスのチェックなしに対応する値をリクエストに設定（:ref:`tag-checkbox_off_value` 対応）
4. ボタン又はリンク毎のパラメータ追加のためリクエストにパラメータを追加（:ref:`tag-submit_change_parameter` 対応）
5. [http_access_log](../libraries/libraries-http_access_log.md) のリクエストパラメータを出力
6. 複合キーの復元（:ref:`tag-composite_key` 対応）

> **補足**: GETリクエストの場合、hiddenパラメータ関連処理は行わず、複合キーの復元処理のみ行う。

**クラス**: `nablarch.common.web.handler.NablarchTagHandler`

<details>
<summary>keywords</summary>

NablarchTagHandler, CustomTagConfig, カスタムタグ制御ハンドラ, hidden暗号化, 複合キー復元, GETリクエスト, リクエストスコープ設定

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

nablarch-fw-web-tag, com.nablarch.framework, モジュール依存関係

</details>

## 制約

- [multipart_handler](handlers-multipart_handler.md) より後ろに設定すること（リクエストパラメータにアクセスするため）
- :ref:`hidden暗号化<tag-hidden_encryption>` 使用時は [thread_context_handler](handlers-thread_context_handler.md) より後ろに設定すること（スレッドコンテキストからリクエストIDを取得するため）

<details>
<summary>keywords</summary>

multipart_handler, thread_context_handler, ハンドラ設定順序, 制約, hidden暗号化使用時

</details>

## 復号に失敗(改竄エラー、セッション無効化エラー)した場合のエラーページを設定する

:ref:`hidden暗号化<tag-hidden_encryption>` の復号処理が失敗するケース：
1. 暗号化データが改竄された場合（改竄エラー）
2. セッションから復号鍵を取得できない場合（セッション無効化エラー）

`NablarchTagHandler` でエラーページとステータスコードを設定可能。`sessionExpirePath`/`sessionExpireStatusCode` を省略した場合は改竄エラーの設定が使用される。

```xml
<component name="nablarchTagHandler"
           class="nablarch.common.web.handler.NablarchTagHandler">
  <property name="path" value="/TAMPERING-DETECTED.jsp" />
  <property name="statusCode" value="400" />
  <property name="sessionExpirePath" value="/SESSION-EXPIRED.jsp" />
  <property name="sessionExpireStatusCode" value="400" />
</component>
```

<details>
<summary>keywords</summary>

NablarchTagHandler, 改竄エラー, セッション無効化エラー, エラーページ設定, path, statusCode, sessionExpirePath, sessionExpireStatusCode

</details>
