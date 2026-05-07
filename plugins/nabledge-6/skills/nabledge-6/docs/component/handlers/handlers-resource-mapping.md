# リソースマッピングハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* 静的リソースのダウンロード

本ハンドラは、業務アクションを経由せずにレスポンスを返却する機能を提供する。
本機能は、静的リソースをNablarchのハンドラを経由してダウンロードする際に使用する。

> **Important:**
> 本ハンドラを使用して静的リソースをダウンロードする方法には、「ログが大量に出力される」、
> 「大量アクセスがあるサーバで、アプリケーションサーバの負荷が大きい」といったデメリットがある。

> このため、ハンドラを経由させる必要がない静的リソースのダウンロードについては、
> 本ハンドラの使用を推奨しない。
> 静的リソースについては、ウェブコンテナまたはウェブサーバの機能でダウンロードし、
> 本ハンドラを使用するのは「コンテンツのダウンロードに認可チェックを行う必要がある」など、
> 他のハンドラを経由する必要のあるコンテンツに限って使用すること。

本ハンドラでは、以下の処理を行う。

* 静的リソースをダウンロードするレスポンスを返す

> **Important:**
> 本ハンドラは主に、 [リクエストハンドラエントリ](../../component/handlers/handlers-request-handler-entry.md#リクエストハンドラエントリ) と組み合わせて 「特定の拡張子の場合に静的リソースを
> ダウンロードする」 機能の実現に使用する。

> この用途での使用例は [リクエストハンドラエントリの使用例](../../component/handlers/handlers-request-handler-entry.md#本ハンドラの使用例) を参照。

処理の流れは以下のとおり。
なお、図にある通り本ハンドラは後続のハンドラを呼び出さない。

![flow.png](../../../knowledge/assets/handlers-resource-mapping/flow.png)

## ハンドラクラス名

* nablarch.fw.web.handler.ResourceMapping

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

[内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#内部フォーワードハンドラ) よりも後に配置すること

本ハンドラは、 [内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#内部フォーワードハンドラ) の機能により提供される `forward://` スキームを使用できる。
このため、本ハンドラは [内部フォーワードハンドラ](../../component/handlers/handlers-forwarding-handler.md#内部フォーワードハンドラ) より後に配置する必要がある。

[HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#httpレスポンスハンドラ) よりも後に配置すること

本ハンドラは、 [HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#httpレスポンスハンドラ) の機能により提供される `servlet://` 、 `file://` 、 `classpath://` スキームを使用できる。
また、エラーが発生した際は 404(Not Found)の応答を返す。
これらの応答を処理するため、本ハンドラは [HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#httpレスポンスハンドラ) より後に配置する必要がある。

## 静的リソースのダウンロード

本ハンドラの主たる用途である、静的リソースをダウンロードする際には `baseUri` と `basePath` 2つのプロパティを以下のように設定する。

```xml
<!-- 画像ファイルの静的リソースダウンロードを行うハンドラ -->
<component name="imgMapping"
           class="nablarch.fw.web.handler.ResourceMapping">
  <property name="baseUri" value="/"/>
  <property name="basePath" value="servlet:///"/>
</component>
```

それぞれの設定項目の意味は下記の通り

| 設定項目 | 意味 |
|---|---|
| baseUri | 処理対象のURL。このURLにマッチしない場合、ハンドラは  HTTPステータス404(NotFound)の応答を返す。 |
| basePath | baseUriにマッチした場合のレスポンスのベースURL。  スキーマ指定を省略した場合、 `servlet://` スキーマが使用される。 |

ただし、上記設定のハンドラを単純にハンドラキューに入れた場合、サーバに送られたすべてのURLの処理が
静的リソースとして処理される。
つまり、ハンドラキュー上の本ハンドラ以降のハンドラすべてが実行されなくなる。

このため、  [本ハンドラの使用例](../../component/handlers/handlers-request-handler-entry.md#本ハンドラの使用例) に記載のとおり、 [リクエストハンドラエントリ](../../component/handlers/handlers-request-handler-entry.md#リクエストハンドラエントリ) と組み合わせて使用する必要がある。
