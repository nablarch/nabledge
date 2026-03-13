# Nablarch 5u24 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/database.html#database-dialect) [2](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal_dao-customize_sql_for_counting) [3](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/data_io/data_format.html) [4](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html) [5](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java21.html) [6](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/nablarch/platform.html#id3) [7](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/blank_project/index.html) [8](https://nablarch.github.io/docs/5u24/doc/application_framework/adaptors/webspheremq_adaptor.html) [9](https://nablarch.github.io/docs/5u24/doc/examples/11/index.html) [10](https://nablarch.github.io/docs/5u24/publishedApi/nablarch-testing/publishedApiDoc/programmer/nablarch/test/core/http/HttpRequestTestSupport.html#getParamMap-nablarch.fw.web.HttpRequest-) [11](https://nablarch.github.io/docs/5u24/publishedApi/nablarch-testing/publishedApiDoc/programmer/nablarch/test/core/http/HttpRequestTestSupport.html#getParam-nablarch.fw.web.HttpRequest-java.lang.String-) [12](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/database.html#database-add-dialect)

## 5u24 変更一覧

## 5u24 変更一覧（5u23からの変更点）

| No. | コンテンツ | 分類 | リリース区分 | タイトル | 修正後バージョン | システムへの影響 |
|---|---|---|---|---|---|---|
| 1 | アプリケーションフレームワーク | ユニバーサルDAO | 変更 | 件数取得SQLをカスタマイズできるようにDialectインターフェースを拡張 | nablarch-core-jdbc 1.8.0 | あり |
| 2 | アプリケーションフレームワーク | 汎用データフォーマット | 不具合 | JSON値末尾エスケープ文字でエラー発生する問題を修正 | nablarch-core-dataformat 1.3.3 | なし |
| 3 | アプリケーションフレームワーク | HTTPリクエスト | 変更 | リクエストパラメータ取得APIをアーキテクト向け公開APIに変更 | nablarch-fw-web 1.13.0 | なし |
| 4 | アプリケーションフレームワーク | RESTfulウェブサービス | 変更 | RESTfulウェブサービス専用HTTPリクエストクラスを追加 | nablarch-fw-jaxrs 1.4.0 | なし |
| 5 | アプリケーションフレームワーク | ブランクプロジェクト | 変更 | Java 21で動かす際の修正手順を解説書に追加 | nablarch-document 5u24 | なし |
| 6 | アプリケーションフレームワーク | 稼働環境 | 変更 | テスト環境を更新 | nablarch-document 5u24 | なし |
| 7 | アプリケーションフレームワーク | 全ブランクプロジェクト | 変更 | Java 21に対応 | 各ブランクプロジェクト 5u24 | なし |
| 8 | アダプタ | IBM MQアダプタ | 変更 | 使用するIBM MQのバージョンをIBM MQ 9.3に変更 | nablarch-wmq-adaptor 1.1.0, nablarch-fw-messaging-mom 1.0.4 | あり |
| 9 | Nablarch実装例集 | メッセージング基盤テストシミュレータサンプル | 変更 | IBM MQとの通信にIBM MQアダプタを使用するように変更 | nablarch-messaging-simulator 1.3.0 | なし |
| 10 | Example | HTTPリクエスト | 変更 | リクエストパラメータを取得する共通部品を追加 | nablarch-example-web 5u24 | なし |
| 11 | テスティングフレームワーク | HTTPリクエスト | 変更 | リクエストパラメータ取得公開APIを追加 | nablarch-testing 1.6.0 | なし |

### システムへの影響がある変更

**No.1 ユニバーサルDAO: Dialectインターフェース拡張**

> **重要**: プロジェクト独自のダイアレクトを作成する際に、`DefaultDialect`を継承せずに`Dialect`インタフェースを直接実装している場合、`convertCountSql(String, Object, StatementFactory)`メソッドの実装が存在しないためコンパイルエラーが発生します。対処方法は「件数取得SQLの拡張ポイント追加」セクションを参照してください。

- `DefaultDialect`クラスを継承して実装している場合は影響なし
- ページング処理の件数取得SQLを自動生成SQLから任意のSQLに差し替え可能になります
- 参照: [データベースのDialect設定](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/database.html#database-dialect)
- 参照: [ユニバーサルDAO 件数取得SQLのカスタマイズ](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal_dao-customize_sql_for_counting)

**No.8 IBM MQアダプタ: IBM MQ 9.3使用に変更**

> **重要**: 古いIBM MQ（IBM WebSphere MQ）では動作しない可能性があります。IBM MQ 9.3にバージョンアップしてください。バージョンアップできない場合は、解説書に記載のとおりアダプタが使用するライブラリのバージョンを変更してください。

- 参照: [IBM MQアダプタ](https://nablarch.github.io/docs/5u24/doc/application_framework/adaptors/webspheremq_adaptor.html)

### その他の変更

**No.2 汎用データフォーマット: JSON値末尾エスケープ文字バグ修正**

- JSON値の最後がエスケープ文字（`\`）の場合にエラーが発生する不具合を修正（例: `{ "key" : "value\\"}` が正しく解析されるようになった）
- Unicode形式エスケープ文字（`\u005C`）が含まれる場合の解析失敗も修正（例: `{ "key" : "\u005Cvalue"}` が `\value` として正しく解析されるようになった）
- 参照: [汎用データフォーマット](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/data_io/data_format.html)

**No.3 HTTPリクエスト: リクエストパラメータ取得APIをアーキテクト向け公開APIに変更**

- `InjectForm`を使わず`Action`クラスでバリデーションエラーをハンドリングする場合に利用するアーキテクト向けAPI
- **アーキテクト向け公開APIのため、従来通りActionクラスで直接利用することは想定していません。** 共通部品を作成し、必ずバリデーションが実行されるよう実装してください
- バリデーション前のパラメータを取得できるAPIであるため、共通部品なしでの直接利用は危険

**No.4 RESTfulウェブサービス専用HTTPリクエストクラス追加**

- クエリパラメータ・パスパラメータ取得処理を公開APIとした専用HTTPリクエストクラスを追加
- RESTfulウェブサービスではアーキテクト限定でなく、ActionクラスなどからもAPIを直接利用可能
- `@Consumes`・`@Valid`アノテーションでFormにバインドする場合は従来通りバインド時にバリデーション実行
- 参照: [リソースメソッドのシグネチャ](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html)

**No.5 ブランクプロジェクト: Java 21対応手順追加**

- 参照: [Java21セットアップ手順](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java21.html)

**No.6 稼働環境テスト環境更新**

更新後のテスト環境:
- Java: Java SE 6/7/8/11/17/21
- Oracle Database: 12c/19c/21c/23c
- IBM Db2: 10.5/11.5
- SQL Server: 2017/2019/2022
- PostgreSQL: 10.0/11.5/12.2/13.2/14.0/15.2/16.2
- MOM: IBM MQ 9.3

参照: [稼働環境](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/nablarch/platform.html#id3)

**No.7 全ブランクプロジェクト: Java 21対応**

- Java 21でビルド・実行できるようにライブラリやMavenプラグインのバージョンを更新
- **Java 21で動かす際には「Java21で使用する場合のセットアップ方法」の実施が必要**
- 参照: [ブランクプロジェクト](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/blank_project/index.html)

**No.9 メッセージング基盤テストシミュレータサンプル: IBM MQアダプタ使用に変更**

- IBM MQアダプタを使用するように変更（Gradleビルドも廃止しMavenに統一）
- 参照: [メッセージングシミュレータサンプル](https://nablarch.github.io/docs/5u24/doc/examples/11/index.html)

**No.11 テスティングフレームワーク: HTTPリクエストパラメータ取得API追加**

- 自動テスト内でHTTPリクエスト状態を検証する目的で`HttpRequestTestSupport`にパラメータ取得APIを追加
- 当該APIはバリデーション検証目的のためバリデーションは実行されません
- 参照: [HttpRequestTestSupport#getParamMap](https://nablarch.github.io/docs/5u24/publishedApi/nablarch-testing/publishedApiDoc/programmer/nablarch/test/core/http/HttpRequestTestSupport.html#getParamMap-nablarch.fw.web.HttpRequest-)
- 参照: [HttpRequestTestSupport#getParam](https://nablarch.github.io/docs/5u24/publishedApi/nablarch-testing/publishedApiDoc/programmer/nablarch/test/core/http/HttpRequestTestSupport.html#getParam-nablarch.fw.web.HttpRequest-java.lang.String-)

<details>
<summary>keywords</summary>

Nablarch 5u24, リリースノート, 変更一覧, ユニバーサルDAO, Dialectインターフェース, IBM MQアダプタ, 汎用データフォーマット, HTTPリクエスト, RESTfulウェブサービス, ブランクプロジェクト, Java 21, nablarch-core-jdbc, nablarch-wmq-adaptor, nablarch-fw-web, nablarch-fw-jaxrs, nablarch-core-dataformat, nablarch-fw-messaging-mom, nablarch-messaging-simulator, nablarch-example-web, nablarch-testing, HttpRequestTestSupport, @Consumes, @Valid, 破壊的変更, システムへの影響, InjectForm

</details>

## バージョンアップ手順

## バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`5u24`に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, pom.xml, 5u24適用手順, dependencyManagement, Mavenビルド

</details>

## 件数取得SQLの拡張ポイント追加

## 件数取得SQLの拡張ポイント追加

### 変更点

- `Dialect`インタフェースに`convertCountSql(String, Object, StatementFactory)`メソッドを追加
- `DefaultDialect`クラスに上記メソッドの実装を追加
- ページング処理で使用する件数取得SQLを変更可能（自動生成SQLから任意のSQLへ差し替え可能）

参照: [Dialectの設定](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/database.html#database-dialect)

### 影響有無の確認方法

| 状況 | 影響 |
|---|---|
| 独自ダイアレクトを作成していない | 影響なし |
| `DefaultDialect`を継承して実装している | 影響なし |
| `Dialect`インタフェースを直接実装している（`DefaultDialect`非継承） | **コンパイルエラー発生** |

> **重要**: `DefaultDialect`を継承せずに`Dialect`インタフェースを直接実装している場合、新たに追加された`convertCountSql(String, Object, StatementFactory)`メソッドの実装が存在しないためコンパイルエラーが発生します。

参照: [独自ダイアレクトの作成](https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/database.html#database-add-dialect)

### 影響があった場合の対応方法

プロジェクトで独自に作成したダイアレクトに以下のメソッドを実装するとコンパイルエラーが解消され、バージョンアップ前と同じ件数取得SQLが発行されます。

```java
@Override
public String convertCountSql(String sqlId, Object condition, StatementFactory statementFactory) {
    return convertCountSql(statementFactory.getVariableConditionSqlBySqlId(sqlId, condition));
}
```

件数取得SQLを差し替えたい場合は、解説書を参考に上記メソッドの実装を変更してください。

<details>
<summary>keywords</summary>

件数取得SQL, Dialectインターフェース, convertCountSql, DefaultDialect, コンパイルエラー, ページング処理, StatementFactory, 独自ダイアレクト, ユニバーサルDAO拡張

</details>
