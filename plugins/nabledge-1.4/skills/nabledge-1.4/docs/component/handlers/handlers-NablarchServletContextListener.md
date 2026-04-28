## Nablarchサーブレットコンテキスト初期化リスナ

**クラス名:** `nablarch.fw.web.servlet.NablarchServletContextListener`

-----

### 概要

このクラスはサーブレットコンテキストの初期化時(デプロイ時)に呼ばれ、
リポジトリの初期化処理を行う。
また、ログの初期化処理および終端処理を行う。

特に、画面オンライン処理における、ハンドラキュー構成とハンドラキューの起点となる
サーブレットフィルタ [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md) の初期化はここで行われる。

> **Note:**
> このクラスはハンドラでは無いが、ハンドラ構成を説明する都合上ここであわせて解説する。

-----

**処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| Nablarchサーブレットコンテキスト初期化リスナ | nablarch.fw.web.servlet.NablarchServletContextListener | - | - | サーブレットコンテキスト初期化時に、リポジトリおよびハンドラキューの初期化処理を行う。 | - | Fatalログを出力した上で再送出する。(デプロイエラーになる。) |
| Webフロントコントローラ (サーブレットフィルタ) | nablarch.fw.web.servlet.WebFrontController | ServletRequest/Response | - | HttpServletRequest/HttpServletResponseからHTTPリクエストオブジェクトを作成し、ハンドラキューに処理を委譲する。 | (Webコンテナ側に制御を戻す。) | このハンドラでは例外およびエラーの捕捉は行なわず、そのまま送出する。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md) | 本クラスが初期化するリポジトリ内に、このサーブレットフィルタが オブジェクトキー名 **webFrontController** で定義されている必要がある。 |

### 設定項目・拡張ポイント

本クラスは、サーブレットコンテキストリスナとしてデプロイし、
コンテキスト初期化時に以下のコンテキスト変数を参照する。

| 変数名 | 設定内容 |
|---|---|
| di.config (必須) | リポジトリの設定ファイルのパスを設定する。 設定ファイルは基本的にクラスパスリソースから検索されるが、 **“file://“** から始まるパスを設定することでローカルファイルシステム上の ファイルを検索できる。 |
| di.duplicate-definition-policy | リポジトリの設定ファイル読み込み時に、 設定値の上書き設定が検出された際の動作ポリシーを設定する。 設定すべき値の詳細については、 [リポジトリ](../02_FunctionDemandSpecifications/01_Core/02_Repository.html) を参照。 設定しなかった場合、OVERRIDE。 |

以下は **web.xml** の設定例である。

```xml
<web-app>
  <context-param>
    <!-- リポジトリの設定ファイルパス -->
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
