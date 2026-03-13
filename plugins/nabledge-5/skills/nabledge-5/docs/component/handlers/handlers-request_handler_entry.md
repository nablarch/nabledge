# リクエストハンドラエントリ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/request_handler_entry.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/RequestHandlerEntry.html)

## ハンドラクラス名

特定のリクエストパスのみ委譲先ハンドラを呼び出す特殊なハンドラ。ハンドラを修正することなく、特定URLのみハンドラ処理を行う機能を実現できる。

主な用途:
- [resource_mapping](handlers-resource_mapping.md) を使用した静的コンテンツの一括ダウンロード
- [database_connection_management_handler](handlers-database_connection_management_handler.md) や [transaction_management_handler](handlers-transaction_management_handler.md) と組み合わせ、特定URLのみ使用するDB接続を変える

処理内容: リクエストパスがマッチするか判定し、対象であれば委譲先ハンドラを呼び出す。

**クラス名**: `nablarch.fw.RequestHandlerEntry`

<details>
<summary>keywords</summary>

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, リクエストハンドラエントリ, 特定URLのみハンドラ実行, 静的コンテンツダウンロード, DB接続切り替え

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, モジュール依存関係, com.nablarch.framework

</details>

## 制約

なし

<details>
<summary>keywords</summary>

制約なし, 制約

</details>

## 本ハンドラの使用例

`requestPattern` プロパティ（処理対象リクエストパス）と `handler` プロパティ（委譲先ハンドラ）を設定する。

[resource_mapping](handlers-resource_mapping.md) を使用してJPEGファイルの静的コンテンツをダウンロードする設定例:

```xml
<component name="imgMapping"
           class="nablarch.fw.web.handler.ResourceMapping">
  <property name="baseUri" value="/"/>
  <property name="basePath" value="servlet:///"/>
</component>

<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">

  <property name="handlerQueue">
    <list>

      <component class="nablarch.fw.handler.GlobalErrorHandler"/>
      <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler"/>
      <component class="nablarch.common.io.FileRecordWriterDisposeHandler" />
      <component class="nablarch.fw.web.handler.HttpResponseHandler"/>

      <!-- 拡張子が ".jpg" である静的JPGファイルのダウンロードを行う設定 -->
      <component class="nablarch.fw.RequestHandlerEntry">
        <property name="requestPattern" value="//*.jpg"/>
        <property name="handler" ref="imgMapping"/>
      </component>

      <!-- "*.jpg" で終わるJPEGファイルのダウンロード以外のリクエストでは以下のハンドラが呼ばれる -->
      <component-ref name="multipartHandler"/>
      <component-ref name="sessionStoreHandler" />
```

<details>
<summary>keywords</summary>

requestPattern, handler, ResourceMapping, nablarch.fw.web.handler.ResourceMapping, 静的コンテンツ設定例, JPEGファイルダウンロード

</details>

## リクエストパターン指定のバリエーション

`requestPattern` プロパティにはGlob式に似た書式で指定できる。

**ワイルドカード `*` の動作** (`*` は `/` と `.` にはマッチしない):

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/` | `/` | 呼ばれる |
| `/` | `/index.jsp` | 呼ばれない |
| `/*` | `/` | 呼ばれる |
| `/*` | `/app` | 呼ばれる |
| `/*` | `/app/` | 呼ばれない |
| `/*` | `/index.jsp` | 呼ばれない |
| `/app/*.jsp` | `/app/index.jsp` | 呼ばれる |
| `/app/*.jsp` | `/app/admin` | 呼ばれない |
| `/app/*/test` | `/app/admin/test` | 呼ばれる |
| `/app/*/test` | `/app/test/` | 呼ばれない |

**前方一致 `//` の動作** (末尾の `/` を `//` と重ねると、それ以前の文字列で前方一致):

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/app//` | `/` | 呼ばれない |
| `/app//` | `/app/` | 呼ばれる |
| `/app//` | `/app/admin/` | 呼ばれる |
| `/app//` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.html` | 呼ばれない |

<details>
<summary>keywords</summary>

requestPattern, ワイルドカード, Glob式, 前方一致, リクエストパターン指定, //

</details>
