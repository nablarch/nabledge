# Nablarchサーブレットコンテキスト初期化リスナ

## 概要

**クラス名**: `nablarch.fw.web.servlet.NablarchServletContextListener`

サーブレットコンテキストの初期化時（デプロイ時）に呼ばれ、リポジトリの初期化処理・ログの初期化処理および終端処理を行う。画面オンライン処理におけるハンドラキュー構成と、ハンドラキューの起点となるサーブレットフィルタ [WebFrontController](handlers-WebFrontController.md) の初期化もここで行われる。

> **注意**: このクラスはハンドラではないが、ハンドラ構成を説明する都合上ここで解説する。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [WebFrontController](handlers-WebFrontController.md) | リポジトリ内にオブジェクトキー名 **webFrontController** で定義されている必要がある |

<details>
<summary>keywords</summary>

NablarchServletContextListener, nablarch.fw.web.servlet.NablarchServletContextListener, WebFrontController, webFrontController, サーブレットコンテキスト初期化, リポジトリ初期化, ログ初期化, ハンドラキュー構成

</details>

## 設定項目・拡張ポイント

サーブレットコンテキストリスナとしてデプロイし、コンテキスト初期化時に以下のコンテキスト変数を参照する。

| 変数名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| di.config | ○ | | リポジトリの設定ファイルのパスを設定する。クラスパスリソースから検索される。`file://` から始まるパスを設定することでローカルファイルシステム上のファイルを検索可能。 |
| di.duplicate-definition-policy | | OVERRIDE | 設定ファイル読み込み時に設定値の上書きが検出された際の動作ポリシー。詳細は `リポジトリ`_ を参照。 |

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

di.config, di.duplicate-definition-policy, web.xml, コンテキスト変数, サーブレットコンテキストリスナ設定, RepositoryBasedWebFrontController

</details>
