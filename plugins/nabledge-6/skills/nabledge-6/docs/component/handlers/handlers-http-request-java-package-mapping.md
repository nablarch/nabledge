# HTTPリクエストディスパッチハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* ディスパッチの設定
* アクションが複数のパッケージに配置される場合の設定

本ハンドラは、アプリケーションの機能ごとに行う処理を記載するアクションに処理を委譲する。
委譲先のクラス、メソッドは、アクセスしたURLによって決定される。
本クラスを使用したディスパッチでは、URL形式は下記の通りであることを想定している。

URL形式

/<baseUri>/<className>/<methodName>

上記形式の<>で囲まれた部分はそれぞれ下記を意味する。

| ラベル | 意味 |
|---|---|
| baseUri | コンテキストルートからの相対パス |
| className | クラス名 |
| methodName | アクションクラスのメソッド名は、HTTPのメソッド + メソッド名として実装する。  httpのメソッドが `post` の場合で、URLのmethodNameが `register` の場合には、 アクションクラスのメソッド名は、 `postRegister` とする。  なお、 `get` と `post` の場合には、 `do` を使用できる。 上記の例の場合、 `doRegister` となる。 |

> **Tip:**
> URLとアクションとのマッピングの指定方法については、 [ディスパッチの設定](../../component/handlers/handlers-http-request-java-package-mapping.md#ディスパッチの設定) を参照。

> **Important:**
> HTTPリクエストディスパッチハンドラでは、クラス名を元にURLが決まるため、柔軟なURLを使用できない。
> 例えば、  `/user/index` のようなURLを使用したい場合、クラス名を `user` とする必要がある。
> これは、Javaの一般的なクラス名の規約に違反しており、推奨されない。

> このため、このハンドラを使うよりも、URLとアクションクラスとのマッピングを柔軟に設定できる [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#ルーティングアダプタ) を使用することを推奨する。

本ハンドラでは、以下の処理を行う。

* URIを解析し、対応するアクションのメソッドを呼び出す。

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-http-request-java-package-mapping/flow.png)

## ハンドラクラス名

* nablarch.fw.web.handler.HttpRequestJavaPackageMapping

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

ハンドラキューの最後に置くこと

本ハンドラは、後続のハンドラを呼び出さない。
このため、本ハンドラの配置はハンドラキューの最後に置くこと。

## ディスパッチの設定

本クラスを使用する際は、前述の baseUri と、アクションを配置するパッケージ(ベースパッケージ)の設定が必須となる。
以下にbaseUri を `action` 、ベースパッケージを `jp.co.tis.nablarch.example` に設定する例を示す。

```xml
<component name="packageMapping"
           class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri" value="/action/"/>
  <property name="basePackage" value="jp.co.tis.nablarch.example"/>
</component>
```

上記設定の場合のディスパッチ例を以下に示す。

/action/UserAction/index

jp.co.tis.nablarch.example.UserAction

## アクションが複数のパッケージに配置される場合の設定

アクションは、複数のパッケージにまたがって配置できる。
この場合、前述の [ディスパッチの設定](../../component/handlers/handlers-http-request-java-package-mapping.md#ディスパッチの設定) に記載のベースパッケージを全Actionが置かれるパッケージに
設定し、URIのクラス名にベースパッケージから対応づける Action までのパスを記載する。

以下にクラスの配置とURLの対応付けの例を示す。

![package_mapping.png](../../../knowledge/assets/handlers-http-request-java-package-mapping/package_mapping.png)
