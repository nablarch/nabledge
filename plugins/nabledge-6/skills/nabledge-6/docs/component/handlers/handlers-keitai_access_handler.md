# 携帯端末アクセスハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/keitai_access_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/KeitaiAccessHandler.html)

## ハンドラクラス名

JavaScriptが動作しない環境（フィーチャーフォン等）でウェブアプリケーションを動作させるハンドラ。下記を実現する:

1. 画面で押されたボタンのボタン名から、想定されるURLにディスパッチ
2. JSP上にJavaScriptを出力しないよう変数を設定

**クラス名**: `KeitaiAccessHandler`

<details>
<summary>keywords</summary>

KeitaiAccessHandler, nablarch.fw.web.handler.KeitaiAccessHandler, 携帯端末アクセスハンドラ, フィーチャーフォン対応, JavaScript非対応環境

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

- :ref:`http_response_handler` より後ろに配置すること: JSPへのフォワード処理を行う :ref:`http_response_handler` より後に配置する必要がある。
- :ref:`thread_context_handler` より前に配置すること: URIを決定する処理があるため、URIを使用する :ref:`thread_context_handler` より前に配置する必要がある。

<details>
<summary>keywords</summary>

配置制約, http_response_handler, thread_context_handler, ハンドラ配置順序

</details>

## JavaScript出力が抑制されるタグ

携帯端末アクセスハンドラを使用したURLにアクセスした際、下記NablarchタグライブラリのJavaScript出力が抑制される:

- :ref:`n:form タグ <tag-form_tag>`
- :ref:`n:script タグ <tag-script_tag>`
- :ref:`サブミット関連のタグ <tag_reference_submit>`

> **重要**: 下記タグは機能が実現できないため使用不可。
> - :ref:`n:submitLink タグ <tag-submit_link_tag>`
>
> n:submitLink タグの代替として n:a タグを使用すること。リクエストパラメータはGETメソッドのパラメータで送信する必要がある。

<details>
<summary>keywords</summary>

JavaScript抑制, n:submitLink, n:a タグ, n:form タグ, n:script タグ, GETメソッド, タグライブラリ

</details>

## URLの関連付け

フォームのURI属性の書き換えをサーバサイドで実施する仕組み。

**JSP表示時**:

1. n:submit、n:button が出力するinputタグのname属性に `nablarch_uri_override_<JSP上のname属性>|<サブミット先のURI>` を設定
2. n:form タグはJavaScriptなしで単純に `<form>` タグを出力（ボタン押下時にformのaction URLに押下ボタンのname属性が送られる）

**フォームサブミット時**:

1. KeitaiAccessHandler が、押下ボタンのname属性（`nablarch_uri_override_` から始まる文字列）から元のURI属性を取得
2. リクエストパラメータに `nablarch_submit` キーで取得したURI属性を設定（JavaScriptで行うformのURI属性書き換えをサーバサイドで実施）
3. 後続処理に委譲する（以降、ボタンに対応するURIが指定された場合と同じ動作）

<details>
<summary>keywords</summary>

URL関連付け, nablarch_uri_override_, nablarch_submit, フォームサブミット, ボタンURI解決, サーバサイドURI書き換え

</details>
