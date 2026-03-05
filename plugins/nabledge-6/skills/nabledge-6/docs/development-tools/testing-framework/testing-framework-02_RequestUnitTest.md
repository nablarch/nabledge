# リクエスト単体テスト（ウェブアプリケーション）

## データベース関連機能

データベース機能は`DbAccessTestSupport`クラスに委譲。

> **重要**: 以下のメソッドはリクエスト単体テストでは不要のため、意図的に委譲していない（アプリケーションプログラマの誤解を防ぐため）：
> - `public void beginTransactions()`
> - `public void commitTransactions()`
> - `public void endTransactions()`
> - `public void setThreadContextValues(String sheetName, String id)`

詳細は[02_DbAccessTest](testing-framework-02_DbAccessTest.md)を参照。

## 事前準備補助機能

**HttpRequest作成**

```java
HttpRequest createHttpRequest(String requestUri, Map<String, String[]> params)
```

引数: リクエストURI, リクエストパラメータ。HTTPメソッドはPOSTに設定される。パラメータやURI以外のデータを設定する場合は、返却されたインスタンスに対して追加設定すること。

**ExecutionContext作成**

```java
ExecutionContext createExecutionContext(String userId)
```

引数のユーザIDをセッションに格納（ログイン状態を模擬）。

**トークン発行**

2重サブミット防止を施しているURIに対するテストには、テスト実行前にトークン発行とセッション設定が必要。

```java
void setValidToken(HttpRequest request, ExecutionContext context)
```

トークン発行＋セッション格納。

```java
void setToken(HttpRequest request, ExecutionContext context, boolean valid)
```

第3引数がtrueの場合は`setValidToken`と同じ動作。falseの場合はセッションからトークン情報を除去。テストデータでトークン設定可否を制御する場合に使用：

```java
// テストデータから取得したものとする
String isTokenValid; 

// "true"の場合はトークンが設定される
setToken(req, ctx, Boolean.parseBoolean(isTokenValid));
```

## システムリポジトリの初期化

`execute`メソッド内部でシステムリポジトリの再初期化を実行。クラス単体テストとリクエスト単体テストで設定を分けずに連続実行可能。

処理手順:
1. 現在のシステムリポジトリの状態をバックアップ
2. テスト対象ウェブアプリケーションのコンポーネント設定ファイルでシステムリポジトリを再初期化
3. `execute`メソッド終了時にバックアップを復元

設定の詳細は:ref:`howToConfigureRequestUnitTestEnv`を参照。

## メッセージ

```java
void assertApplicationMessageId(String expectedCommaSeparated, ExecutionContext actual);
```

引数:
- 期待するメッセージID（複数ある場合はカンマ区切り）
- ExecutionContext

アプリケーション例外に格納されたメッセージIDが想定通りであることを確認。例外が発生しなかった場合、またはアプリケーション例外以外の例外が発生した場合はアサート失敗。

> **補足**: メッセージIDの比較はソート後に行うため、テストデータ記載時に順序を気にする必要はない。

## HTMLダンプ出力ディレクトリ

テスト実行時、`tmp/html_dump`ディレクトリがプロジェクトルートに作成される。構造：
- `tmp/html_dump/{テストクラス名}/{テストケース説明}.html`

HTMLリソース（スタイルシート、画像等）も同ディレクトリに出力されるため、このディレクトリを保存すればどの環境でも同じようにHTMLを参照可能。

> **注意**: `html_dump`ディレクトリが既に存在する場合、`html_dump_bk`にバックアップされる。

ディレクトリ構造図: ![HTMLダンプ出力ディレクトリ構造](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_RequestUnitTest/htmlDumpDir.png)

## 各種設定値

リクエスト単体テストの環境設定は、コンポーネント設定ファイルで変更可能。

**コンポーネント設定ファイル設定項目**:

| 設定項目名 | 説明 | デフォルト値 |
|---|---|---|
| htmlDumpDir | HTMLダンプファイル出力ディレクトリ | `./tmp/html_dump` |
| webBaseDir | ウェブアプリケーションのルートディレクトリ[1] | `../main/web` |
| xmlComponentFile | リクエスト単体テスト実行時に使用するコンポーネント設定ファイル[2] | (なし) |
| userIdSessionKey | ログイン中ユーザIDを格納するセッションキー | `user.id` |
| exceptionRequestVarKey | ApplicationExceptionが格納されるリクエストスコープのキー | `nablarch_application_error` |
| dumpFileExtension | ダンプファイルの拡張子 | `html` |
| httpHeader | HttpRequestにHTTPリクエストヘッダとして格納される値 | `Content-Type: application/x-www-form-urlencoded`<br>`Accept-Language: ja JP` |
| sessionInfo | セッションに格納される値 | (なし) |
| htmlResourcesExtensionList | ダンプディレクトリへコピーされるHTMLリソースの拡張子 | css、jpg、js |
| jsTestResourceDir | javascriptの自動テスト実行時に使用するリソースのコピー先ディレクトリ名 | `../test/web` |
| backup | ダンプディレクトリのバックアップOn/Off | `true` |
| htmlResourcesCharset | CSSファイル(スタイルシート)の文字コード | `UTF-8` |
| checkHtml | HTMLチェックの実施On/Off | `true` |
| htmlChecker | HTMLチェックを行うオブジェクト。`nablarch.test.tool.htmlcheck.HtmlChecker`インタフェース実装クラスのインスタンス。詳細は :ref:`customize_html_check` を参照。 | `nablarch.test.tool.htmlcheck.Html4HtmlChecker`。`htmlCheckerConfig`で設定した設定ファイルが適用される。 |
| htmlCheckerConfig | HTMLチェックツールの設定ファイルパス。`htmlChecker`を設定しなかった場合のみ有効。 | `test/resources/httprequesttest/html-check-config.csv` |
| ignoreHtmlResourceDirectory | HTMLリソースの中でコピー対象外とするディレクトリ名のLIST | (なし) |
| tempDirectory | JSPのコンパイル先ディレクトリ | jettyのデフォルト動作に依存[3] |
| uploadTmpDirectory | アップロードファイルを一時的に格納するディレクトリ。テスト時に準備したアップロード対象ファイルは本ディレクトリにコピー後に処理される。これにより、アクションでファイルを移動した場合でも、本ディレクトリ配下のファイルが移動されるだけであり、実態が移動されることを防ぐ。 | `./tmp` |
| dumpVariableItem | HTMLダンプファイル出力時に可変項目(JSESSIONID、2重サブミット防止用のトークン)を出力するか否か。これらの項目はテスト実行毎に異なる値が設定される。HTMLダンプ結果を毎回同じ結果にしたい場合(前回実行結果と差異がないことを確認したい場合等)は`false`に設定。可変項目をそのまま出力する場合は`true`に設定。 | `false` |

[1] PJ共通のwebモジュールが存在する場合、カンマ区切りでディレクトリを設定する。複数指定された場合、先頭から順にリソースが読み込まれる。例:

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
  <property name="webBaseDir" value="/path/to/web-a/,/path/to/web-common"/>
</component>
```

この場合、web-a、web-commonの順にリソースが探索される。

[2] この項目を設定した場合、リクエスト送信直前に指定されたコンポーネント設定ファイルで初期化が行われる。通常は設定不要。クラス単体テストとリクエスト単体テストとで設定を変える必要がある場合のみ設定する。

[3] jettyのデフォルト動作では、「./work」がコンパイル先ディレクトリとなる。「./work」が存在しない場合は、Tempフォルダ(Windowsの場合は、ユーザのホームディレクトリ/Local Settings/Temp)が出力先となる。

> **補足**: `ignoreHtmlResourceDirectory`にバージョン管理用のディレクトリ(.svnや.git)を設定すると、HTMLリソースコピー時のパフォーマンスが向上する。

**設定例**:

セッションに値を設定する例:

| キー | 値 | 説明 |
|---|---|---|
| commonHeaderLoginUserName | "リクエスト単体テストユーザ" | 共通ヘッダ領域に表示するログインユーザ名 |
| commonHeaderLoginDate | "20100914" | 共通ヘッダ領域に表示するログイン日時 |

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlDumpDir" value="./tmp/html_dump"/>
    <property name="webBaseDir" value="../main/web"/>
    <property name="xmlComponentFile" value="http-request-test.xml"/>
    <property name="userIdSessionKey" value="user.id"/>
    <property name="httpHeader">
        <map>
            <entry key="Content-Type" value="application/x-www-form-urlencoded"/>
            <entry key="Accept-Language" value="ja JP"/>
        </map>
    </property>
    <property name="sessionInfo">
        <map>
            <entry key="commonHeaderLoginUserName" value="リクエスト単体テストユーザ"/>
            <entry key="commonHeaderLoginDate" value="20100914" />
        </map>
    </property>
    <property name="htmlResourcesExtensionList">
        <list>
            <value>css</value>
            <value>jpg</value>
            <value>js</value>
        </list>
    </property>
    <property name="backup" value="true" />
    <property name="htmlResourcesCharset" value="UTF-8" />
    <property name="ignoreHtmlResourceDirectory">
        <list>
            <value>.svn</value>
        </list>
    </property>
    <property name="tempDirectory" value="webTemp" />
    <property name="htmlCheckerConfig"
      value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

**パフォーマンス最適化**:

性能が低いPCでリクエスト単体テスト実行速度を向上させたい場合の設定。

> **補足**: Pentium4、Pentium Dual-Core等の処理性能が低いCPUに効果がある。それ以降のCPUでは効果が限定的なため、無理に設定する必要はない。

## JVMオプションの指定

最大ヒープサイズと最小ヒープサイズを同一にすることで、ヒープサイズ拡張のオーバヘッドを回避できる:

```
-Xms256m -Xmx256m
```

クラスファイルの検証を省略することで実行速度が向上する:

```
-Xverify:none
```

## HTMLリソースコピーの抑止

システムプロパティ `-Dnablarch.test.skip-resource-copy=true` を指定すると、 :ref:`HTMLダンプ出力<dump-dir-label>` 時のHTMLリソースコピーを抑止できる。

静的なHTMLリソース(CSS、画像ファイル等)を頻繁に編集しない場合、テスト実行の度にコピーする必要はないため、このシステムプロパティを設定してもよい。

> **重要**: 本システムプロパティを指定した場合、HTMLリソースのコピーが行われなくなるので、CSSなどのHTMLリソースを編集しても :ref:`HTMLダンプ出力<dump-dir-label>` に反映されない。

> **補足**: HTMLリソースディレクトリが存在しない場合は、システムプロパティの設定有無に関わらず、HTMLリソースのコピーが実行される。
