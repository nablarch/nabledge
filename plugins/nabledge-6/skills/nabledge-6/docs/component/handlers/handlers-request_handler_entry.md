# リクエストハンドラエントリ

## ハンドラクラス名

特定のリクエストパスのみ委譲先のハンドラを呼び出す特殊なハンドラ。ハンドラを修正せずに「特定のURLのみハンドラの処理を行う」機能を実現できる。:ref:`resource_mapping` との組み合わせで静的コンテンツの一括ダウンロード、:ref:`database_connection_management_handler` や :ref:`transaction_management_handler` との組み合わせで特定URLのみDB接続を変える用途にも使用できる。

処理: リクエストパスがマッチするか判定し、対象であれば委譲先のハンドラを呼び出す。

**クラス名**: `nablarch.fw.RequestHandlerEntry`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

## 制約

なし。

## 本ハンドラの使用例

`requestPattern` プロパティに処理対象リクエストパスを、`handler` プロパティに委譲先ハンドラを設定する。

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
      <!--
        "*.jpg" で終わるJPEGファイルのダウンロード以外のリクエストでは、
        以下のハンドラの呼び出しが行われる
        -->
      <component-ref name="multipartHandler"/>
      <component-ref name="sessionStoreHandler" />
```

## リクエストパターン指定のバリエーション

`requestPattern` プロパティはGlob式に似た書式で設定する。`*` は `/` および `.` にはマッチしない。

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/` | `/` | 呼ばれる |
| `/` | `/index.jsp` | 呼ばれない |
| `/*` | `/` | 呼ばれる |
| `/*` | `/app` | 呼ばれる |
| `/*` | `/app/` | 呼ばれない（`*` は`/`にはマッチしない） |
| `/*` | `/index.jsp` | 呼ばれない（`*` は`.`にはマッチしない） |
| `/app/*.jsp` | `/app/index.jsp` | 呼ばれる |
| `/app/*.jsp` | `/app/admin` | 呼ばれない |
| `/app/*/test` | `/app/admin/test` | 呼ばれる |
| `/app/*/test` | `/app/test/` | 呼ばれない |

末尾の `/` が `//` と重ねられている場合、それ以前の文字列について前方一致すればマッチ成功と判定する。

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/app//` | `/` | 呼ばれない |
| `/app//` | `/app/` | 呼ばれる |
| `/app//` | `/app/admin/` | 呼ばれる |
| `/app//` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.html` | 呼ばれない（`*.jsp`がマッチしない） |
