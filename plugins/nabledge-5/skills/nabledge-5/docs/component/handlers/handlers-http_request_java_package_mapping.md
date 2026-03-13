# HTTPリクエストディスパッチハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/http_request_java_package_mapping.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpRequestJavaPackageMapping.html)

## ハンドラクラス名

> **重要**: クラス名ベースでURLが決まるため柔軟なURLが使えない。例えば `/user/index` というURLを使いたい場合、クラス名を `user` にする必要があり、Javaの一般的なクラス名規約に違反する。このハンドラより、URLとアクションクラスのマッピングを柔軟に設定できる [router_adaptor](../adapters/adapters-router_adaptor.md) の使用を推奨する。

URLの形式: `/<baseUri>/<className>/<methodName>`

| ラベル | 意味 |
|---|---|
| baseUri | コンテキストルートからの相対パス |
| className | クラス名 |
| methodName | HTTPメソッド + メソッド名。POSTで `register` の場合→ `postRegister`。`get`/`post` は `do` も使用可→ `doRegister` |

処理: URIを解析し、対応するアクションのメソッドを呼び出す。

**クラス**: `nablarch.fw.web.handler.HttpRequestJavaPackageMapping`

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, nablarch.fw.web.handler.HttpRequestJavaPackageMapping, HTTPリクエストディスパッチ, URLディスパッチ, router_adaptor推奨, baseUri, className, methodName, doメソッド

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

本ハンドラは後続のハンドラを呼び出さない。このため、本ハンドラの配置はハンドラキューの最後に置くこと。

<details>
<summary>keywords</summary>

ハンドラキュー最後, 後続ハンドラ非呼び出し, 配置制約

</details>

## ディスパッチの設定

baseUri とベースパッケージの設定が必須。

```xml
<component name="packageMapping"
           class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri" value="/action/"/>
  <property name="basePackage" value="jp.co.tis.nablarch.example"/>
</component>
```

上記設定（baseUri=`action`、basePackage=`jp.co.tis.nablarch.example`）でのディスパッチ例:
- URL `/action/UserAction/index` → クラス `jp.co.tis.nablarch.example.UserAction`

<details>
<summary>keywords</summary>

baseUri, basePackage, packageMapping, ディスパッチ設定, アクションクラスマッピング

</details>

## アクションが複数のパッケージに配置される場合の設定

ベースパッケージを全Actionが置かれる共通の親パッケージに設定し、URIの className 部分にベースパッケージからActionまでのサブパスを含める。

![パッケージマッピングの例](../../../knowledge/component/handlers/assets/handlers-http_request_java_package_mapping/package_mapping.png)

<details>
<summary>keywords</summary>

複数パッケージ, サブパッケージ, パッケージマッピング, basePackage, URIパス

</details>
