# Nablarch 5u12 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#clob) [2](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#id15) [3](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/message.html#message-change-formatter) [4](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#id13) [5](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#id8) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/support/ListSearchInfo.html#setResultCount-int-) [7](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/system_messaging/http_system_messaging.html) [8](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/index.html) [9](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#database-new-transaction) [10](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal-dao-transaction) [11](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#java-beans) [12](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#repository-override-bean) [13](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#listmap) [14](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#entityjpa) [15](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/architecture.html) [16](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/index.html) [17](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html) [18](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/jsr310_adaptor.html) [19](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/index.html) [20](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html) [21](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/send_sync.html) [22](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/send_sync.html) [23](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/http_send_sync.html) [24](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/nablarch_validation.html#nablarch-validation-definition-validator-convertor)

## 5u12 変更点一覧

## 5u12 変更点一覧（5u11からの変更）

### システムへの影響あり（本番環境）

**No.2 Nablarch Validation: NumberRange → DecimalRange変更**
- `NumberRange`を整数専用に変更。小数部を含む数値バリデーション用に`DecimalRange`を新規追加。
- 小数部が15桁など非常に大きい値が入力された場合、丸められた値を使用してバリデーションを行いエラーとなるべき値がバリデーションOKとなっていた不具合を修正。
- また、許容する値（min/max属性）に桁数が大きい値が指定されると、エラーメッセージ内の許容する最大値が指数表現となる問題も修正。
- `@NumberRange`のmin/max属性に小数部ありの値を使用している箇所は`@DecimalRange`に変更が必要（コンパイルエラーで検知可能）。
- 修正バージョン: `nablarch-core-validation 1.0.4`, `nablarch-main-default-configuration 1.0.6`
- 詳細な対応手順は「NumberRangeの対応方法」(s3)を参照。

**No.8 データベースアクセス: 型変換機能削除**
- 5u9で追加したデータベースアクセスの型変換機能（`nablarch.core.db.dialect.converter.AttributeConverter`インタフェース）を削除し、5u8以前の動作に戻す。
- 5u8以前から5u12へのバージョンアップは影響なし。5u9以降を使用している場合は対応が必要。
- 修正バージョン: `nablarch-core-jdbc 1.3.1`, `nablarch-common-dao 1.4.1`, `nablarch-jsr310-adaptor 1.0.1`
- 詳細な対応手順は「データベースアクセスの型変換機能削除の対応方法」(s4)を参照。
- 参照: [データベースアクセス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#id13), [ユニバーサルDAO](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#id8)

### 不具合修正

**No.1 Nablarch Validation: String配列バリデーション**
- 要素数1のString配列でnull値が含まれる場合に`NullPointerException`が発生する不具合を修正。null値はBeanプロパティにnullとして設定される（必須項目の場合は未入力エラーとなる）。
- 修正バージョン: `nablarch-core-validation 1.0.4`

**No.3 JDBCラッパー/ユニバーサルDAO: CLOBカラム対応**
- CLOBカラムの登録（更新）・参照が可能になった。
- 修正バージョン: `nablarch-core-jdbc 1.3.1`
- 参照: [JDBCラッパー](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#clob), [ユニバーサルDAO](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#id15)

**No.4 汎用データフォーマット: XML作成性能改善**
- ネストが深く属性数が多いXML作成時に処理時間が増大する問題を修正。
- 修正バージョン: `nablarch-core-dataformat 1.2.1`

**No.5 MOMメッセージング: JMSヘッダ値未設定**
- JMS使用時に`nablarch.fw.messaging.SendingMessage`のヘッダ値がJMS Messageに引き継がれない不具合を修正。JMS実装使用時のみ発生（WebsphereMQアダプタは非該当）。
- 修正バージョン: `nablarch-fw-messaging-mom 1.0.3`

**No.6 HTTPメッセージング: デフォルトContent-Type誤り修正**
- 送信時デフォルトContent-Typeの誤り「text/plane」を「text/plain」に修正。
- 修正バージョン: `nablarch-fw-messaging-http 1.0.3`

**No.7 メッセージ管理: 旧仕様フォーマッタ追加**
- 5u6で変更されたメッセージフォーマット機能に、5u5以前の仕様と同じフォーマッタ（`JavaMessageFormatBaseMessageFormatter`）を追加。5u5以前の仕様を使いたい場合はコンポーネント定義に追加する。
- 修正バージョン: `nablarch-core 1.3.1`
- 参照: [メッセージフォーマッタ変更](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/message.html#message-change-formatter)

**No.26 テスティングフレームワーク: 半角記号の不具合修正**
- セルへの特殊記述方法で半角記号を使用した場合、カンマ(,)・ダブルクォーテーション(")・シャープ(#)・バックスラッシュ(\\)が含まれるため後続処理でセルが配列とみなされる不具合を修正。これらの文字を半角記号生成から削除。`${半角記号, <文字数>}`の記法自体は変わらない。
- 修正バージョン: `nablarch-testing 1.1.2`

**No.20 JSR352ブランクプロジェクト: コンパイルエラー修正**
- 生成したブランクプロジェクトの稼働確認用ソースコードのコンパイルエラーを修正。

### 解説書・仕様変更

**No.10 解説書全体: 「コンポーネント設定ファイル」の表記ゆれを修正**
- 「コンポーネント設定ファイル」という文言に一部表記ゆれがあったため、解説書全体で文言を統一。

**No.11 HTTPメッセージングを非推奨化**
- HTTPメッセージングのクライアントサイド機能はボディ部レイアウトに制約があるため、JAX-RSクライアントの使用を推奨するよう変更。
- 参照: [HTTPシステムメッセージング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/system_messaging/http_system_messaging.html)

**No.12 HTTPメッセージング非推奨理由に追記**
- リクエストボディパース時の例外制御を細かく実施できないことを非推奨理由に追記。
- 参照: [ウェブサービス](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/index.html)

**No.13 データベースアクセス: トランザクション設定例の誤り修正**
- JDBCラッパー「現在のトランザクションとは異なるトランザクションでSQLを実行する」およびユニバーサルDAO「現在のトランザクションとは異なるトランザクションで実行する」の設定例が誤っていたため修正。
- 参照: [JDBCラッパー](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#database-new-transaction), [ユニバーサルDAO](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal-dao-transaction)

**No.14 システムリポジトリ: コンポーネントライフサイクル追記**
- XMLに定義したコンポーネントのライフサイクルおよびインスタンス生成単位を解説書に追記。
- 参照: [システムリポジトリ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#java-beans)

**No.15 ユニバーサルDAO: 別トランザクション機能の制約明記**
- 別トランザクション使用時でもデフォルトのトランザクションが開始していなければならないという制約を解説書に明記。
- 参照: [ユニバーサルDAO別トランザクション](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal-dao-transaction)

**No.16 システムリポジトリ: コンポーネント上書きはBeanのみ**
- コンポーネント上書き機能はBeanのみ対象でmapやlistは対象外であることを解説書に明記。
- 参照: [コンポーネント上書き](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#repository-override-bean), [listmap](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#listmap)

**No.17 ユニバーサルDAO: Temporalアノテーション使用に関する記述修正**
- 日付型の永続化判断はTemporalアノテーションではなくデータベースのメタ情報を元に行うため、解説書の記述を修正。
- 参照: [EntityとJPAアノテーション](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#entityjpa)

**No.18 JSR352バッチとNablarchのアーキテクチャ相違点追記**
- JSR352に準拠したバッチアプリケーションはハンドラキューを用いたアーキテクチャではない点を解説書に明記。
- 参照: [Nablarchアーキテクチャ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/architecture.html), [JSR352バッチ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/index.html)

**No.19 BeanUtilの章を独立**
- `BeanUtil`の説明をライブラリ配下に独立した章として追加。
- 参照: [BeanUtil](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html)

**No.21 JSR310アダプタ: 対応型の明記**
- Date and Time APIはLocalDate・LocalDateTimeのみ対応であることを明記（全ての型を扱えるわけではない）。
- 参照: [JSR310アダプタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/jsr310_adaptor.html)

**No.27 テスティングフレームワーク: gsp-dba-maven-plugin推奨に変更**
- マスタデータ投入ツールの解説書をgsp-dba-maven-pluginを推奨する形に変更（マスタデータ投入ツール自体は引き続き使用可能）。
- 参照: [マスタデータセットアップ](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/index.html)

**No.28 テスティングフレームワーク: NTFのタイプ識別子とデータ型の対応を解説書に記載**
- NTFでデフォルトで提供する「タイプ識別子とデータ型」の対応を解説書に記載。
- 参照: [バッチリクエスト単体テスト](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html), [送受信同期テスト（リクエスト単体）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/send_sync.html), [送受信同期テスト（取引単体）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/send_sync.html)

**No.29 テスティングフレームワーク: NTF(HTTP同期応答)で複数リクエストIDのテストデータ書き方を追記**
- NTFでHTTP同期応答メッセージ送信を使用する場合に、複数メッセージ（複数リクエストID）を送信する際のテストデータの書き方が分かりにくかったため、解説書に説明を追記。
- 参照: [HTTPリクエスト単体テスト（HTTP送受信同期）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/http_send_sync.html), [送受信同期テスト（リクエスト単体）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/send_sync.html)

**No.9 Javadoc: ListSearchInfo#setResultCountはフレームワーク専用**
- `nablarch.core.db.support.ListSearchInfo#setResultCount`はフレームワーク専用APIであることをJavadocに明記。
- 参照: [ListSearchInfo Javadoc](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/support/ListSearchInfo.html#setResultCount-int-)

### Exampleアプリケーション変更

**No.22 ウェブアプリケーション: プロジェクト一覧ソートプルダウン修正**
- プロジェクト一覧（ログイン後に表示される画面）で、プルダウンで選択されているソート項目と実際にソートされている項目が一致していなかったため、一致するように変更。

**No.23 ウェブアプリケーション: コンテキストパス指定時の顧客検索対応**
- コンテキストパスを指定した場合でも顧客選択ダイアログを使用して顧客検索が動作するよう変更。

**No.24 RESTfulウェブサービス: ProjectUpdateFormのsetter修正**
- `ProjectUpdateForm`のsetterで引数の値ではなく自身のフィールドの関係のない値を設定していたため、正しい実装に変更。

### ETL基盤

**No.25 ETL Mavenプラグイン: nablarch-etlの最新バージョン対応**
- `nablarch-etl`の最新バージョン(1.2.0)でも動作するよう`nablarch-etl-maven-plugin`を変更。
- 修正バージョン: `nablarch-etl-maven-plugin 1.0.1`（起因バージョン: 1.0.0）

### Nablarch開発標準

**No.30 SQLコーディング規約: select *禁止規約の内容変更**
- 「select *」の禁止は必須となっていたが、全てのカラムを取得したい場合（UniversalDAOを使用した場合）はこの限りではないとの但し書きをアプリケーション開発標準のSQLコーディング規約に追記。

<details>
<summary>keywords</summary>

NullPointerException, String配列バリデーション, NumberRange, DecimalRange, CLOBカラム, JMSヘッダ, HTTPメッセージング非推奨, JavaMessageFormatBaseMessageFormatter, AttributeConverter, DB型変換機能削除, ListSearchInfo, setResultCount, コンポーネント上書き, JSR310アダプタ, LocalDate, LocalDateTime, Temporalアノテーション, JSR352バッチ, 半角記号テスト, nablarch-core-validation, nablarch-core-jdbc, nablarch-fw-messaging-mom, nablarch-fw-messaging-http, nablarch-testing, nablarch-core-dataformat, nablarch-core, nablarch-common-dao, nablarch-jsr310-adaptor, nablarch-main-default-configuration, BeanUtil, SendingMessage, nablarch-etl-maven-plugin, ETLプラグイン, select *禁止, SQLコーディング規約, UniversalDAO, NTF, 5u12不具合修正, 指数表現, エラーメッセージ指数表現, ProjectUpdateForm

</details>

## バージョンアップ手順

## バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`5u12`に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, pom.xml, dependencyManagement, 5u12適用

</details>

## NumberRangeの対応方法

## NumberRangeの対応方法

> **重要**: `NumberRange`は整数専用に変更された。`@NumberRange`のmin/max属性に小数部ありの値を使用している箇所は`@DecimalRange`への変更が必要。コンパイルエラーで検知可能。

**変更例:**
- 変更前: `@NumberRange(min=0.0001, max=0.9999)`
- 変更後: `@DecimalRange(min="0.0001", max="0.9999")`

**メッセージ定義**: `NumberRangeValidator`で使用していたメッセージと同じものを`DecimalRangeValidator`に設定することで、画面上に同じメッセージが表示される。

**ValidationManager設定**: `DecimalRange`を使用するには`ValidationManager`に`DecimalRangeValidator`の追加が必要。
- 参照: [Nablarchバリデーション定義](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/nablarch_validation.html#nablarch-validation-definition-validator-convertor)

<details>
<summary>keywords</summary>

NumberRange, DecimalRange, @NumberRange, @DecimalRange, DecimalRangeValidator, 整数専用, 小数部バリデーション, ValidationManager, バリデーション移行

</details>

## データベースアクセスの型変換機能削除の対応方法

## データベースアクセスの型変換機能削除の対応方法（No.8）

> **重要**: 5u8以前から5u12へのバージョンアップは影響なし。5u9以降のバージョンを使用している場合は以下の対応が必要。

### ①EntityでLocalDate/LocalDateTimeを使用している場合

**発生する問題**: `gsp-dba-maven-plugin`でEntityの型にLocalDate/LocalDateTimeを使用する設定としている場合、ユニバーサルDAO・データベースアクセス機能使用時に「対応していない型」として例外が送出される。

**対応方法**: `gsp-dba-maven-plugin`の以下設定を削除するかfalseに変更し、Entityを再生成する。

```xml
<useJSR310>true</useJSR310>
```

### ②AttributeConverter実装クラスを作成している場合

**発生する問題**: `AttributeConverter`インタフェース（`nablarch.core.db.dialect.converter.AttributeConverter`）が削除されたためコンパイルエラーが発生する。

**対応方法**:
1. プロジェクトで作成した`AttributeConverter`インタフェース実装クラスを削除する
2. `AttributeConverter`実装クラスで行っていた型変換処理を、ユニバーサルDAO・データベースアクセス機能の呼び出し前にアプリケーション側で行うようソースコードを変更する

### ③Entityや検索条件オブジェクトにjava.util.Dateを使用している場合

**発生する問題**:
- ユニバーサルDAOのCRUD機能（SQL自動生成）: `@Temporal`アノテーションが参照されるようになる。OracleでDATE型カラムに`@Temporal(DATE)`を指定している場合、`java.util.Date`の時間情報が切り捨てられ0時0分0秒になる。
- ユニバーサルDAOのCRUD以外の機能・データベースアクセス機能: `java.util.Date`がそのままJDBC APIに渡されるため、JDBC実装によっては実行時エラーが発生する。

**対応方法**:
1. EntityのDate型プロパティに`@Temporal`アノテーションを付与（`gsp-dba-maven-plugin`使用時は自動設定されるため不要）
2. Oracleで時間情報を保持する必要がある場合: データベースカラム型をDATE型からTimestamp型に変更し、テーブル再作成・Entity再生成
3. ユニバーサルDAOのCRUD以外・データベースアクセス機能で`java.util.Date`を使用している箇所: `java.sql.Date`または`java.sql.Timestamp`に変更する（APIを呼び出す前にアプリケーション側で変換するか、`java.util.Date`の使用をやめる）

<details>
<summary>keywords</summary>

AttributeConverter, LocalDate, LocalDateTime, java.util.Date, useJSR310, DB型変換削除, Temporalアノテーション, gsp-dba-maven-plugin, java.sql.Date, java.sql.Timestamp, 5u9移行

</details>
