# Nablarchサーブレットコンテキスト初期化リスナ

## 

**クラス名**: `nablarch.fw.web.servlet.NablarchServletContextListener`

<details>
<summary>keywords</summary>

NablarchServletContextListener, nablarch.fw.web.servlet.NablarchServletContextListener, サーブレットコンテキスト初期化リスナ, クラス名

</details>

## 概要

サーブレットコンテキストの初期化時（デプロイ時）にリポジトリの初期化処理、ログの初期化処理および終端処理を行う。画面オンライン処理におけるハンドラキュー構成とハンドラキューの起点となるサーブレットフィルタ [WebFrontController](handlers-WebFrontController.md) の初期化もここで行われる。

<details>
<summary>keywords</summary>

WebFrontController, リポジトリ初期化, ログ初期化, ハンドラキュー構成, サーブレットコンテキスト初期化

</details>

## 

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [WebFrontController](handlers-WebFrontController.md) | リポジトリ内にオブジェクトキー名 **webFrontController** で定義されている必要がある。 |

<details>
<summary>keywords</summary>

WebFrontController, webFrontController, ハンドラキュー, 関連ハンドラ, 処理概要

</details>

## 設定項目・拡張ポイント

サーブレットコンテキストリスナとしてデプロイし、コンテキスト初期化時に以下のコンテキスト変数を参照する。

| 変数名 | 必須 | 説明 |
|---|---|---|
| `di.config` | ○ | リポジトリの設定ファイルのパス。クラスパスリソースから検索。`file://` から始まるパスでローカルファイルシステム上のファイルも参照可能。 |
| `di.duplicate-definition-policy` | | 設定ファイル読み込み時に設定値の上書きが検出された際の動作ポリシー。未設定の場合は `OVERRIDE`。詳細は :ref:`リポジトリ` を参照。 |

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

di.config, di.duplicate-definition-policy, RepositoryBasedWebFrontController, web.xml, コンテキスト変数, OVERRIDE

</details>
