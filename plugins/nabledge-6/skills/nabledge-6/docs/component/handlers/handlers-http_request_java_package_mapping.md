# HTTPリクエストディスパッチハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/http_request_java_package_mapping.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpRequestJavaPackageMapping.html)

## 概要

URL形式: `/<baseUri>/<className>/<methodName>`

- `baseUri`: コンテキストルートからの相対パス
- `className`: クラス名
- `methodName`: HTTPメソッド + メソッド名として実装。`post`メソッドでURLのmethodNameが`register`の場合、アクションクラスのメソッド名は`postRegister`。`get`/`post`の場合は`do`も使用可（例: `doRegister`）

> **重要**: クラス名を元にURLが決まるため柔軟なURLを使用できない。例えば`/user/index`のようなURLを使いたい場合、クラス名を`user`にする必要があり、Javaの一般的なクラス名規約に違反するため推奨されない。このハンドラよりも、URLとアクションクラスとのマッピングを柔軟に設定できる [router_adaptor](../adapters/adapters-router_adaptor.md) の使用を推奨する。

処理内容: URIを解析し、対応するアクションのメソッドを呼び出す。

![処理の流れ](../../../knowledge/component/handlers/assets/handlers-http_request_java_package_mapping/flow.png)

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, HTTPリクエストディスパッチ, URLマッピング, アクションクラス, router_adaptor推奨

</details>

## ハンドラクラス名

**クラス名**: `HttpRequestJavaPackageMapping`

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, nablarch.fw.web.handler.HttpRequestJavaPackageMapping, ハンドラクラス名

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

nablarch-fw-web, com.nablarch.framework, Maven依存関係

</details>

## 制約

**ハンドラキューの最後に置くこと**: 本ハンドラは後続のハンドラを呼び出さない。このため、本ハンドラの配置はハンドラキューの最後に置くこと。

<details>
<summary>keywords</summary>

ハンドラキュー, 配置順序, 最後に配置, 制約

</details>

## ディスパッチの設定

`baseUri`（コンテキストルートからの相対パス）と`basePackage`（アクションを配置するパッケージ）の設定が必須。

```xml
<component name="packageMapping"
           class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri" value="/action/"/>
  <property name="basePackage" value="jp.co.tis.nablarch.example"/>
</component>
```

ディスパッチ例: URL `/action/UserAction/index` → クラス `jp.co.tis.nablarch.example.UserAction`

<details>
<summary>keywords</summary>

baseUri, basePackage, ディスパッチ設定, URLマッピング設定, packageMapping

</details>

## アクションが複数のパッケージに配置される場合の設定

ベースパッケージを全Actionが置かれるパッケージに設定し、URIのクラス名にベースパッケージからActionまでのパスを記載する。

![パッケージマッピング例](../../../knowledge/component/handlers/assets/handlers-http_request_java_package_mapping/package_mapping.png)

<details>
<summary>keywords</summary>

複数パッケージ, パッケージマッピング, アクションクラス配置, サブパッケージ

</details>
