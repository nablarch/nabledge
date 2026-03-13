# リソースマッピングハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/resource_mapping.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/ResourceMapping.html)

## ハンドラクラス名

本ハンドラは、業務アクションを経由せずにレスポンスを返却する機能を提供する。本機能は、静的リソースをNablarchのハンドラを経由してダウンロードする際に使用する。

**クラス名**: `nablarch.fw.web.handler.ResourceMapping`

> **重要**: 本ハンドラを使用して静的リソースをダウンロードする方法には、「ログが大量に出力される」、「大量アクセスがあるサーバでアプリケーションサーバの負荷が大きい」といったデメリットがある。静的リソースはウェブコンテナまたはウェブサーバの機能でダウンロードし、本ハンドラは認可チェックが必要なコンテンツなど、他のハンドラを経由する必要のあるコンテンツにのみ使用すること。

> **重要**: 本ハンドラは主に [request_handler_entry](handlers-request_handler_entry.md) と組み合わせて「特定の拡張子の場合に静的リソースをダウンロードする」機能の実現に使用する。使用例は [リクエストハンドラエントリの使用例](handlers-request_handler_entry.md) を参照。

本ハンドラは後続のハンドラを呼び出さない。

<details>
<summary>keywords</summary>

ResourceMapping, nablarch.fw.web.handler.ResourceMapping, リソースマッピングハンドラ, 静的リソースダウンロード, 認可チェック, 後続ハンドラを呼び出さない, 業務アクションを経由せずにレスポンスを返却

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

- [forwarding_handler](handlers-forwarding_handler.md) より後に配置すること: 本ハンドラは `forward://` スキームを使用するため。
- [http_response_handler](handlers-http_response_handler.md) より後に配置すること: 本ハンドラは `servlet://`、`file://`、`classpath://` スキームを使用し、エラー発生時は404(Not Found)応答を返すため。

<details>
<summary>keywords</summary>

forwarding_handler, http_response_handler, ハンドラ配置順序, forward://スキーム, servlet://スキーム, file://スキーム, classpath://スキーム

</details>

## 静的リソースのダウンロード

`baseUri` と `basePath` の2つのプロパティを設定する。

```xml
<component name="imgMapping"
           class="nablarch.fw.web.handler.ResourceMapping">
  <property name="baseUri" value="/"/>
  <property name="basePath" value="servlet:///"/>
</component>
```

| プロパティ名 | 説明 |
|---|---|
| baseUri | 処理対象のURL。マッチしない場合は404(NotFound)を返す。 |
| basePath | baseUriにマッチした場合のレスポンスのベースURL。スキーマ省略時は `servlet://` スキーマが使用される。 |

> **重要**: 上記設定のハンドラを単純にハンドラキューに入れると、サーバに送られたすべてのURLが静的リソースとして処理され、本ハンドラ以降のハンドラがすべて実行されなくなる。[request_handler_entry](handlers-request_handler_entry.md) と組み合わせて使用すること（[request_handler_entry_usage](handlers-request_handler_entry.md) 参照）。

<details>
<summary>keywords</summary>

baseUri, basePath, request_handler_entry, 静的リソース設定, ResourceMappingプロパティ, 404 NotFound, servlet://スキーマ

</details>
