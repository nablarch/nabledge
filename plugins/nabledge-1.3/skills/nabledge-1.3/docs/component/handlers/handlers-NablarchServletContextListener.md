# Nablarchサーブレットコンテキスト初期化リスナ

## 概要

**クラス名**: `nablarch.fw.web.servlet.NablarchServletContextListener`

サーブレットコンテキストの初期化時（デプロイ時）に呼ばれ、リポジトリの初期化処理、ログの初期化処理および終端処理を行う。

画面オンライン処理において、ハンドラキュー構成とハンドラキューの起点となるサーブレットフィルタ [WebFrontController](handlers-WebFrontController.md) の初期化はここで行われる。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [WebFrontController](handlers-WebFrontController.md) | 本クラスが初期化するリポジトリ内に、このサーブレットフィルタがオブジェクトキー名 **webFrontController** で定義されている必要がある |

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, webFrontController, サーブレットコンテキスト初期化, リポジトリ初期化, ログ初期化, ハンドラキュー構成

</details>

## 設定項目・拡張ポイント

サーブレットコンテキストリスナとしてデプロイし、コンテキスト初期化時に以下のコンテキスト変数を参照する。

| 変数名 | 必須 | 説明 |
|---|---|---|
| di.config | ○ | リポジトリの設定ファイルのパス。クラスパスリソースから検索。`file://` で始まるパスを指定するとローカルファイルシステム上のファイルを検索できる |
| di.duplicate-definition-policy | | 設定値の上書き検出時の動作ポリシー。詳細は `リポジトリ`_ を参照。未設定の場合 OVERRIDE |

**web.xml 設定例**:

```xml
<web-app>
  <context-param>
    <param-name>di.config</param-name>
    <param-value>web-component-configuration.xml</param-value>
  </context-param>

  <listener>
    <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
  </listener>

  <filter>
    <filter-name>controller</filter-name>
    <filter-class>nablarch.fw.web.servlet.RepositoryBasedWebFrontController</filter-class>
  </filter>

  <filter-mapping>
    <filter-name>controller</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
</web-app>
```

<details>
<summary>keywords</summary>

di.config, di.duplicate-definition-policy, コンテキスト変数設定, web.xml設定, 上書きポリシー, OVERRIDE, RepositoryBasedWebFrontController

</details>
