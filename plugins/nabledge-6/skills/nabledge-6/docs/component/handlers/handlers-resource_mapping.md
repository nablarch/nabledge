# リソースマッピングハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/resource_mapping.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/ResourceMapping.html)

## ハンドラクラス名

**クラス名**: `ResourceMapping`

<details>
<summary>keywords</summary>

nablarch.fw.web.handler.ResourceMapping, ResourceMapping, リソースマッピングハンドラ, ハンドラクラス名

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

nablarch-fw-web, com.nablarch.framework, Mavenモジュール, 依存関係

</details>

## 制約

- :ref:`forwarding_handler` よりも後に配置すること: `forward://` スキームを使用するため。
- :ref:`http_response_handler` よりも後に配置すること: `servlet://`、`file://`、`classpath://` スキームの使用と、エラー時の404(Not Found)応答処理のため。

<details>
<summary>keywords</summary>

forwarding_handler, http_response_handler, forward://, servlet://, file://, classpath://, ハンドラ配置順序, 制約

</details>

## 静的リソースのダウンロード

> **重要**: ログが大量に出力される、高負荷サーバでアプリケーションサーバの負荷が大きいといったデメリットがある。認可チェック等、他のハンドラを経由する必要があるコンテンツのみに使用すること。一般的な静的リソースはウェブコンテナ/ウェブサーバの機能でダウンロードすること。

> **重要**: 主に :ref:`request_handler_entry` と組み合わせて「特定の拡張子の場合に静的リソースをダウンロードする」機能の実現に使用する。使用例は :ref:`リクエストハンドラエントリの使用例 <request_handler_entry_usage>` を参照。

本ハンドラは後続のハンドラを呼び出さない。

`baseUri` と `basePath` の2つのプロパティを設定する:

| プロパティ名 | 説明 |
|---|---|
| baseUri | 処理対象のURL。マッチしない場合はHTTPステータス404(NotFound)を返す |
| basePath | baseUriにマッチした場合のレスポンスのベースURL。スキーマ省略時は `servlet://` が使用される |

```xml
<component name="imgMapping"
           class="nablarch.fw.web.handler.ResourceMapping">
  <property name="baseUri" value="/"/>
  <property name="basePath" value="servlet:///"/>
</component>
```

> **重要**: 本ハンドラを単独でハンドラキューに追加すると、すべてのURLが静的リソースとして処理される（本ハンドラ以降のすべてのハンドラが実行されなくなる）。:ref:`request_handler_entry` と組み合わせて使用すること。

<details>
<summary>keywords</summary>

baseUri, basePath, request_handler_entry, 静的リソースダウンロード, 認可チェック, ResourceMapping設定, 後続ハンドラ呼び出しなし

</details>
