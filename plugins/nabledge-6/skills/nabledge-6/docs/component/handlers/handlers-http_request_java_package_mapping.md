# HTTPリクエストディスパッチハンドラ

## 概要

URL形式: `/<baseUri>/<className>/<methodName>`

- `baseUri`: コンテキストルートからの相対パス
- `className`: クラス名
- `methodName`: HTTPメソッド + メソッド名として実装。`post`メソッドでURLのmethodNameが`register`の場合、アクションクラスのメソッド名は`postRegister`。`get`/`post`の場合は`do`も使用可（例: `doRegister`）

> **重要**: クラス名を元にURLが決まるため柔軟なURLを使用できない。例えば`/user/index`のようなURLを使いたい場合、クラス名を`user`にする必要があり、Javaの一般的なクラス名規約に違反するため推奨されない。このハンドラよりも、URLとアクションクラスとのマッピングを柔軟に設定できる :ref:`router_adaptor` の使用を推奨する。

処理内容: URIを解析し、対応するアクションのメソッドを呼び出す。

![処理の流れ](../../knowledge/component/handlers/assets/handlers-http_request_java_package_mapping/flow.png)

## ハンドラクラス名

**クラス名**: `HttpRequestJavaPackageMapping`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

**ハンドラキューの最後に置くこと**: 本ハンドラは後続のハンドラを呼び出さない。このため、本ハンドラの配置はハンドラキューの最後に置くこと。

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

## アクションが複数のパッケージに配置される場合の設定

ベースパッケージを全Actionが置かれるパッケージに設定し、URIのクラス名にベースパッケージからActionまでのパスを記載する。

![パッケージマッピング例](../../knowledge/component/handlers/assets/handlers-http_request_java_package_mapping/package_mapping.png)
