# Nablarch 6u1 リリースノート

## Nablarch 6u1 変更一覧

## アプリケーションフレームワーク

| No. | 分類 | 区分 | 概要 | 修正バージョン | システムへの影響 |
|---|---|---|---|---|---|
| 1 | システム日時 | 変更 | `SystemTimeUtil`でLocalDateTime型でのシステム日時取得に対応（従来のDate型に加えて） | nablarch-core 2.1.0 | なし |
| 2 | ユニバーサルDAO | 変更 | 検索結果をマッピングするBeanのデータタイプとしてLocalDateTime型・LocalDate型に対応 | nablarch-common-dao 2.1.0 | なし |
| 3 | BeanUtil | 変更 | Java 16以降のレコードに対応。レコードオブジェクトの生成・値コピーが可能になった | nablarch-core-beans 2.1.0 | なし |
| 4 | 汎用データフォーマット | 不具合 | JSON読み込み時に値の最後がエスケープ文字（`\`）だとエラーが発生する問題を修正。`\u005C`をエスケープ開始文字として誤解析する問題も修正。不具合の起因バージョン: モジュール（nablarch-core-dataformat）1.0.0、Nablarch 1.4.0 | nablarch-core-dataformat 2.0.1 | なし |
| 5 | ユニバーサルDAO | 変更 | ページング処理で使用する件数取得SQLをカスタマイズできるよう`Dialect`インターフェースを拡張 | nablarch-core-jdbc 2.1.0 | **あり** |
| 6 | HTTPリクエスト | 変更 | HTTPリクエストからリクエストパラメータを取得するAPIをアーキテクト向け公開APIに変更（アーキテクトが基盤部品を作る場合に限定）。`InjectForm`を使わずActionクラスでバリデーションエラーをハンドリングする場合は、このAPIを使ってリクエストパラメータを取り出す時に**必ずバリデーションが実行されるよう共通部品を作成**すること。ActionクラスからこのAPIを直接利用することは想定していない。共通部品の実装例はNo.16のExampleを参照 | nablarch-fw-web 2.1.0 | なし |
| 7 | RESTfulウェブサービス | 変更 | クエリパラメータ・パスパラメータ取得用の専用HTTPリクエストクラスを追加。Actionから利用可能な公開APIとして提供。取得したパラメータは必要に応じてバリデーションを実施すること。なお、従来通り`@Consumes`アノテーションと`@Valid`アノテーションを使ってパラメータをFormにバインドする場合は、バインド時に自動でバリデーションが実行される | nablarch-fw-jaxrs 2.1.0 | なし |
| 8 | AWSにおける分散トレーシング | 変更 | Jakarta EE未対応だった依存ライブラリをJakarta EE対応バージョンに更新（AWS X-Ray SDK: 2.4.0→2.15.0、Jersey: 2.32→3.1.1） | nablarch-document 6u1 | なし |
| 9 | ブランクプロジェクト | 変更 | Java 21で動かす際に必要な修正手順を解説書に追加 | nablarch-document 6u1 | なし |
| 10 | 稼働環境 | 変更 | テスト環境を以下の通り更新。**Java**: Java SE 17/21。**データベース**: Oracle Database 12c/19c/21c/23c、IBM Db2 10.5/11.5、SQL Server 2017/2019/2022、PostgreSQL 10.0/11.5/12.2/13.2/14.0/15.2/16.2。**アプリケーションサーバ**: WildFly 31.0.1.Final、Apache Tomcat 10.1.17、Jakarta EE、Hibernate Validator 8.0.0.Final、JBeret 2.1.1.Final。**MOM**: IBM MQ 9.3 | nablarch-document 6u1 | なし |
| 11 | 全ブランクプロジェクト | 変更 | Java 21でビルド・実行できるようライブラリおよびMavenプラグインのバージョンを更新。Java 21で動かす際は「Java21で使用する場合のセットアップ方法」を実施すること | nablarch-web/jaxrs/batch/batch-ee/batch-dbless/container-web/container-jaxrs/container-batch/container-batch-dbless 6u1 | なし |

## アダプタ

| No. | 分類 | 区分 | 概要 | 修正バージョン | システムへの影響 |
|---|---|---|---|---|---|
| 12 | SLF4Jアダプタ | 変更 | SLF4J 2.0以降ではロギング実装検索の仕組みが変更されSLF4Jアダプタがログ出力できない問題を修正。SLF4Jバージョンを1.7.25→2.0.11に更新 | slf4j-nablarch-adaptor 2.1.0 | なし |
| 13 | logアダプタ | 変更 | SLF4J 2.0以降でもlogアダプタが使用できるようSLF4Jバージョンを1.7.22→2.0.11に更新 | nablarch-slf4j-adaptor 2.1.0 | なし |
| 14 | Redisストア(Lettuce)アダプタ | 変更 | LettuceからNettyへの推移的依存バージョン競合によりリクエスト単体テスト実行時にエラーが発生する問題を修正。Lettuceバージョンを5.3.0.RELEASE→6.2.3.RELEASEに更新 | nablarch-lettuce-adaptor 2.1.0 | なし |
| 15 | IBM MQアダプタ | 変更 | 入手不可となったWebSphere MQ 7.5付属ライブラリからIBM MQ 9.3使用に変更。解説書のアダプタ名もIBM WebSphere MQ→IBM MQに変更 | nablarch-wmq-adaptor 2.1.0 | **あり** |

## Example / テスティングフレームワーク

| No. | 分類 | 区分 | 概要 | 修正バージョン | システムへの影響 |
|---|---|---|---|---|---|
| 16 | HTTPリクエスト (Example) | 変更 | No.6の使用例としてHTTPリクエストからリクエストパラメータを取得するユーティリティの実装例を追加 | nablarch-example-web 6u1 | なし |
| 17 | HTTPリクエスト (テスティングフレームワーク) | 変更 | 自動テスト内でHTTPリクエストのリクエストパラメータを検証できるよう`HttpRequestTestSupport`に公開APIを追加（`getParamMap`、`getParam`）。当該APIではバリデーションは実行しない | nablarch-testing 2.1.0 | なし |

## システムへの影響がある変更

**No.5: Dialectインターフェース拡張（件数取得SQL）**

> **重要**: プロジェクト独自のダイアレクトを`DefaultDialect`を継承せず`Dialect`インターフェースを直接実装している場合、コンパイルエラーが発生します。対処方法は「件数取得SQLの拡張ポイント追加」セクションを参照してください。

- 独自ダイアレクトなし、または`DefaultDialect`を継承して実装している場合は影響なし

**No.15: IBM MQアダプタ**

> **重要**: 古いIBM MQ（IBM WebSphere MQ）では動作しない可能性があります。IBM MQ 9.3へバージョンアップしてください。バージョンアップできない場合は、[解説書](https://nablarch.github.io/docs/6u1/doc/application_framework/adaptors/webspheremq_adaptor.html)に記載のとおりアダプタが使用するライブラリのバージョンを変更してください。

## バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`6u1`に書き換える
2. Mavenのビルドを再実行する

## 件数取得SQLの拡張ポイント追加

ページング処理で使用する件数取得SQLを変更するための拡張ポイントを追加。

## 変更内容

- `Dialect`インターフェースに`convertCountSql(String, Object, StatementFactory)`メソッドを追加（参考: [Dialectインターフェース](https://nablarch.github.io/docs/6u1/doc/application_framework/application_framework/libraries/database/database.html#database-dialect)）
- `DefaultDialect`クラスに上記メソッドの実装を追加

これにより、性能劣化への対応等で件数取得SQLを変更したい場合に、自動生成されるSQLから任意のSQLに差し替えることが可能になった。

## 影響確認方法

| 状況 | 影響 |
|---|---|
| 独自ダイアレクトなし | なし |
| `DefaultDialect`を継承して実装（[解説書記載の方法](https://nablarch.github.io/docs/6u1/doc/application_framework/application_framework/libraries/database/database.html#database-add-dialect)） | なし |
| `Dialect`インターフェースを直接実装 | **コンパイルエラーが発生** |

## 影響があった場合の対処方法

プロジェクト独自のダイアレクトに以下のメソッドを実装してください。

```java
@Override
public String convertCountSql(String sqlId, Object condition, StatementFactory statementFactory) {
    return convertCountSql(statementFactory.getVariableConditionSqlBySqlId(sqlId, condition));
}
```

これによりコンパイルエラーが解消され、件数取得SQLはバージョンアップ前と同じ動作になります。件数取得SQLを差し替えたい場合は、[ユニバーサルDAO解説書](https://nablarch.github.io/docs/6u1/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal_dao-customize_sql_for_counting)を参考に上記メソッドの実装を変更してください。
