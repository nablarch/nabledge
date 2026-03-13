# 携帯端末アクセスハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/keitai_access_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/KeitaiAccessHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.KeitaiAccessHandler`

<details>
<summary>keywords</summary>

KeitaiAccessHandler, nablarch.fw.web.handler.KeitaiAccessHandler, 携帯端末アクセスハンドラ, ハンドラクラス名

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

nablarch-fw-web, com.nablarch.framework, モジュール, Maven依存関係

</details>

## 制約

- [http_response_handler](handlers-http_response_handler.md) より後ろに配置すること: JSPへのフォワード処理を行う [http_response_handler](handlers-http_response_handler.md) より後に配置する必要がある。
- [thread_context_handler](handlers-thread_context_handler.md) より前に配置すること: URIを使用する [thread_context_handler](handlers-thread_context_handler.md) より前に配置する必要がある。

<details>
<summary>keywords</summary>

http_response_handler, thread_context_handler, ハンドラ配置順序, 配置制約

</details>

## JavaScript出力が抑制されるタグ

携帯端末アクセスハンドラを使用したURLにアクセスした際、以下のNablarchタグライブラリが通常出力するJavaScriptは一切出力されない。

- [n:form タグ](../libraries/libraries-tag_reference.md)
- [n:script タグ](../libraries/libraries-tag_reference.md)
- [サブミット関連のタグ](../libraries/libraries-tag_reference.md)

> **重要**: 以下のタグは元々想定していた機能が実現できないため使用できない。
> - [n:submitLink タグ](../libraries/libraries-tag_reference.md)
>
> n:submitLink タグの代替として n:a タグを使用すること。リクエストパラメータはGETメソッドのパラメータで送信する必要がある。

<details>
<summary>keywords</summary>

JavaScript抑制, n:form, n:script, n:submitLink, n:a, タグライブラリ, JavaScript出力無効

</details>

## URLの関連付け

携帯端末アクセスハンドラを適用した場合、通常NablarchでJavaScriptで行っているformのURI属性の書き換えがサーバサイドで実施される。

1. JSP表示時: n:submit、n:button のinputタグのname属性を `nablarch_uri_override_<JSP上のname属性>|<サブミット先のURI>` に設定する。n:formタグは単純にHTMLの`<form>`タグを出力する（ボタン押下時は`<form>`タグに記載したURLに押下ボタンのname属性が送られる）。
2. formサブミット時: KeitaiAccessHandlerが押下ボタンのname属性（`nablarch_uri_override_`から始まる文字列）からURI属性を取得し、リクエストパラメータのキー `nablarch_submit` に取得したURI属性を設定する。以降、クライアントからのリクエスト時にボタンに対応するURIが指定された場合と同じ動作をする。

<details>
<summary>keywords</summary>

KeitaiAccessHandler, nablarch_uri_override, nablarch_submit, フォームサブミット, URI属性書き換え, URLディスパッチ, サーバサイドURI解決

</details>
