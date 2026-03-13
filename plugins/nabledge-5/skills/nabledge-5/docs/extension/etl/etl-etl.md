# ETL

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/extension_components/etl/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/generator/MergeSqlGeneratorFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/TableCleaningBatchlet.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/WorkItem.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/FileItemReader.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/DatabaseItemWriter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/SqlLoaderBatchlet.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/SqlLoaderConfig.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/ValidationBatchlet.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/EtlJobAbortedException.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/Entity.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/Table.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/runtime/context/JobContext.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/DatabaseItemReader.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/FileItemWriter.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/DeleteInsertBatchlet.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/MergeBatchlet.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/etl/config/JsonConfigLoader.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-etl</artifactId>
</dependency>
```

> **補足**: ワークテーブルの内容を事前に削除する必要がある場合は、Chunkステップの前処理として [etl-truncate](#s6) を行うようステップを定義すること。

## Java Beansの作成

入力ファイルとワークテーブルに対応したJava Beansを以下のルールに従い作成する。

| 項目 | ルール |
|---|---|
| 行番号を保持する属性 | ワークテーブルには行番号を必ず保持させる。`WorkItem` を継承して実現すること。継承していない場合、後続のフェーズが実行できなくなる。 |
| 入力ファイルのレイアウト定義 | [data_bind](../../component/libraries/libraries-data_bind.md) を参照しアノテーションを設定すること。 |
| ワークテーブルのテーブル定義 | [universal_dao](../../component/libraries/libraries-universal_dao.md) を参照しアノテーションを設定すること。 |

## JOB定義

- Chunkとしてステップを定義する
- readerには `fileItemReader` を設定する
- writerには `databaseItemWriter` を設定する

```xml
<!-- id及びnextは適宜変更すること -->
<step id="extract" next="validation">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <!-- item-countは適宜変更すること -->
  <chunk item-count="3000">
    <reader ref="fileItemReader" />
    <writer ref="databaseItemWriter" />
  </chunk>
</step>
```

> **補足**: `fileItemReader` は [data_bind](../../component/libraries/libraries-data_bind.md) を使用してファイルを読み込む。ファイルの行番号は自動的に保持される（詳細は [data_bind-line_number](../../component/libraries/libraries-data_bind.md) 参照）。

## ETL用JOB設定ファイル

JOB定義のステップ名（step id）に対応したキーに設定する。

| キー | 設定する値 |
|---|---|
| type | `file2db` を固定で設定する |
| bean | [入力ファイルとワークテーブルに対応したJava Beans](#) の完全修飾名 |
| fileName | 入力ファイル名（配置ディレクトリは [etl-common-configuration](#s4) 参照） |

```javascript
"extract": {
  "type": "file2db",
  "bean": "sample.Sample",
  "fileName": "sample.csv"
}
```

## メッセージの定義

`FileItemReader` は取り込み対象のファイルが存在しない場合に例外を送出する。例外に設定するメッセージは [message](../../component/libraries/libraries-message.md) から取得するため、メッセージの設定が必要。詳細は [etl-message](#) を参照。

> **補足**: JOB定義及びETL用JOB設定ファイルは、[etl-json-configuration](#s5) の **ファイル出力のテンプレート** をダウンロードし編集すると良い。

## 出力先ファイルに対応したJava Beansの作成

レイアウト定義は [data_bind](../../component/libraries/libraries-data_bind.md) を参照しアノテーションを設定する。

## 編集用SQLの作成

- ファイル名: 出力先ファイルに対応したJava Beansのクラス名 + `.sql`
- 配置先: クラスパス配下の同クラスのパッケージと同じディレクトリ
- 例: 完全修飾名 `nablarch.sample.SampleFileDto` → `nablarch/sample/SampleFileDto.sql`
- SQLIDは任意の値を指定。[etl-load-file-configuration](#) で参照する
- 外部からパラメータを渡すことは不可

## JOB定義

Chunkとしてステップを定義する。readerに `databaseItemReader`、writerに `fileItemWriter` を設定する。

```xml
<step id="load">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <chunk item-count="3000">
    <reader ref="databaseItemReader" />
    <writer ref="fileItemWriter" />
  </chunk>
</step>
```

## ETL用JOB設定ファイル（db2file）

| キー | 設定する値 |
|---|---|
| type | `db2file`（固定） |
| bean | 出力先ファイルに対応したJava Beansの完全修飾名 |
| fileName | 出力ファイル名（ディレクトリは [etl-common-configuration](#s4) 参照） |
| sqlId | 編集用SQLに定義したSQLID |

```javascript
"load": {
  "type": "db2file",
  "bean": "sample.SampleDto",
  "fileName": "output.csv",
  "sqlId": "SELECT_ALL"
}
```

`FileItemWriter` は出力先ファイルを開けない場合に例外を送出する。例外メッセージは [message](../../component/libraries/libraries-message.md) から取得するため、メッセージの設定が必要。詳細は [etl-message](#) を参照。

[message](../../component/libraries/libraries-message.md) から以下のメッセージを取得するため、事前に [message](../../component/libraries/libraries-message.md) の設定に従いメッセージを定義すること。

| メッセージID | 説明 |
|---|---|
| nablarch.etl.input-file-not-found | [etl-extract-sql_loader](#) および [etl-extract-chunk](#s7) で入力ファイルが存在しない場合の例外メッセージ。プレースホルダ(添字:0)には存在しない入力ファイルのパスが設定される。 |
| nablarch.etl.invalid-output-file-path | [etl-load-file](#) で出力先ファイルが開けない場合の例外メッセージ。プレースホルダ(添字:0)には開けないファイルのパスが設定される。 |
| nablarch.etl.validation-error | [etl-transform-validation](#) でバリデーションエラーが発生したことをログに出力する際のメッセージ。ファイルの内容が不正とは、数値項目に非数値が設定されていた場合や、許容する桁数よりも大きい桁数の値が設定されていた場合のことを指す。 |

定義例:

```properties
nablarch.etl.input-file-not-found=入力ファイルが存在しません。外部からファイルを受信できているか、ディレクトリやファイルの権限は正しいかを確認してください。入力ファイル=[{0}]
nablarch.etl.invalid-output-file-path=出力ファイルパスが正しくありません。ディレクトリが存在しているか、権限が正しいかを確認してください。出力ファイルパス=[{0}]
nablarch.etl.validation-error=入力ファイルのバリデーションでエラーが発生しました。入力ファイルが正しいかなどを相手先システムに確認してください。
```

<details>
<summary>keywords</summary>

nablarch-etl, com.nablarch.framework, ETLモジュール, Maven依存関係, WorkItem, FileItemReader, DatabaseItemWriter, nablarch.etl.WorkItem, nablarch.etl.FileItemReader, nablarch.etl.DatabaseItemWriter, fileItemReader, databaseItemWriter, file2db, fileName, ETL Extractフェーズ Chunk, ファイル取り込み ワークテーブル登録, DatabaseItemReader, FileItemWriter, databaseItemReader, fileItemWriter, db2file, ファイル出力, ETL Loadフェーズ, JOB設定ファイル, nablarch.etl.input-file-not-found, nablarch.etl.invalid-output-file-path, nablarch.etl.validation-error, ETLメッセージ定義, 入力ファイルエラーメッセージ, バリデーションエラーメッセージ, ファイル出力エラーメッセージ, メッセージID, プレースホルダ, ファイルの内容が不正, 数値項目に非数値, 桁数超過

</details>

## ETLの各フェーズの仕様

> **補足**: NablarchのETLは一般的なETLとは各フェーズの処理内容が異なる。Transformではデータ編集は行わず、Loadフェーズで行う。

## Extractフェーズ

ファイルの内容をデータベース上のワークテーブルに取り込む。

| ロード方法 | 内容 |
|---|---|
| Chunk | Chunkステップを使用してデータをワークテーブルにロードする。詳細は [etl-extract-chunk](#s7) |
| SQL*Loader | Oracle SQL*Loaderを使用してデータをワークテーブルにロードする。詳細は [etl-extract-sql_loader](#) |

## Transformフェーズ

ワークテーブルに取り込んだデータのバリデーションを行う。データ編集処理はLoadフェーズで行う（一般的なETLと異なる）。詳細は [etl-transform-validation](#)

## Loadフェーズ

データ変換用SQL文を実行し、データをデータベースやファイルに出力する。

| ロード方法 | 内容 |
|---|---|
| ファイル出力 | ファイルに出力する場合。詳細は [etl-load-file](#) |
| データベースの洗い替え | ロード先テーブルのデータを削除後にワークテーブルのデータを登録。詳細は [etl-load-replace_database](#) |
| データベースのマージ | キーが一致するデータが存在する場合は更新、存在しない場合は登録。対応DBは `MergeSqlGeneratorFactory` 参照。詳細は [etl-load-merge_database](#) |
| データベースへの登録 | ChunkステップでDBテーブルにデータを登録。ChunkのprocessorにJava側の編集処理を追加可能。詳細は [etl-load-insert_database](#) |

> **補足**: ワークテーブルの内容を事前に削除する必要がある場合は、SQL*Loaderの設定にてtruncateを実施すると良い（Oracle社のマニュアル参照）。

## Java Beansの作成

| 項目 | ルール |
|---|---|
| 行番号を保持する属性 | ワークテーブルには行番号を必ず保持させる。`WorkItem` を継承して実現すること。継承していない場合、後続のフェーズが実行できなくなる。 |
| 入力ファイルのレイアウト定義 | [data_bind](../../component/libraries/libraries-data_bind.md) を参照しアノテーションを設定する。`SqlLoaderBatchlet` では使用しないが、コントロールファイルの自動生成時に使用する（詳細は [etl-extract-sql_loader-control_file](#) 参照）。 |
| ワークテーブルのテーブル定義 | [universal_dao](../../component/libraries/libraries-universal_dao.md) を参照しアノテーションを設定する。`SqlLoaderBatchlet` では使用しないが、バリデーション時に使用するため設定が必要。またコントロールファイルの自動生成時にも使用する。 |

## JOB定義

- batchletとしてステップを定義する
- batchletクラスには `sqlLoaderBatchlet` を設定する

```xml
<!-- id及びnextは適宜変更すること -->
<step id="extract" next="validation">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <batchlet ref="sqlLoaderBatchlet" />
</step>
```

## ETL用JOB設定ファイル

[Extract(Chunk版)のETL用JOB設定ファイル](#) を参照。

## 接続先データベースの設定

[コンポーネント設定ファイル](../../component/libraries/libraries-repository.md) に接続先データベースの情報を設定する。

```xml
<component name="sqlLoaderConfig" class="nablarch.etl.SqlLoaderConfig">
  <!-- 接続ユーザ -->
  <property name="userName" value="${nablarch.db.user}" />
  <!-- 接続パスワード -->
  <property name="password" value="${nablarch.db.password}" />
  <!-- 接続先データベース名 -->
  <property name="databaseName" value="${sqlloader.database}" />
</component>
```

- コンポーネント名は `sqlLoaderConfig` とする
- 設定するクラスは `SqlLoaderConfig` とする
- 接続先データベースの情報は環境毎に変わる可能性があるため [環境設定ファイル](../../component/libraries/libraries-repository.md) に定義し [環境設定ファイルの値を参照](../../component/libraries/libraries-repository.md) するとよい

## コントロールファイルの作成

- [etl_maven_plugin](etl-etl_maven_plugin.md) を使用して [入力ファイルとワークテーブルに対応したJava Beans](#) から自動生成できる
- [etl_maven_plugin](etl-etl_maven_plugin.md) を使用した場合は、ワークテーブルへの行番号の挿入も自動的に設定される
- [etl_maven_plugin](etl-etl_maven_plugin.md) を使用せずにコントロールファイルを作成する場合は、ワークテーブルに対する行番号の設定を必ず行うこと

## SQL*Loaderに関わるファイルの命名規則

ファイルの配置ディレクトリの設定は [etl-common-configuration](#s4) を参照。

| ファイルの種類 | ファイル名 |
|---|---|
| コントロールファイル | クラス名 + `.ctl`（例: クラス名が `sample.SampleFile` の場合は `SampleFile.ctl`） |
| 不良ファイル | クラス名 + `.bad`（例: `SampleFile.bad`） |
| ログファイル | クラス名 + `.log`（例: `SampleFile.log`） |

## メッセージの定義

`SqlLoaderBatchlet` は取り込み対象のファイルが存在しない場合に例外を送出する。例外に設定するメッセージは [message](../../component/libraries/libraries-message.md) から取得するため、メッセージの設定が必要。詳細は [etl-message](#) を参照。

> **補足**: JOB定義及びETL用JOB設定ファイルは、[etl-json-configuration](#s5) の **Loadフェーズで洗い替えモードを使用する場合のテンプレート** をダウンロードし編集すると良い。

## 洗い替え対象テーブルに対応したEntityの作成

テーブル定義は [universal_dao](../../component/libraries/libraries-universal_dao.md) を参照しアノテーションを設定する。

## 編集用SQLの作成

- ファイル名: 洗い替え対象テーブルのEntityクラス名 + `.sql`
- 配置先: クラスパス配下の同クラスのパッケージと同じディレクトリ
- 例: 完全修飾名 `nablarch.sample.SampleEntity` → `nablarch/sample/SampleEntity.sql`
- SQLIDは任意の値を指定。[etl-load-replace_database-configuration](#) で参照する
- 外部からパラメータを渡すことは不可

## JOB定義

batchletとしてステップを定義し、batchletクラスに `deleteInsertBatchlet` を設定する。

```xml
<step id="load">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <batchlet ref="deleteInsertBatchlet" />
</step>
```

## ETL用JOB設定ファイル（洗い替えモード）

| キー | 設定する値 |
|---|---|
| type | `db2db`（固定） |
| bean | 洗い替え対象テーブルEntityの完全修飾名 |
| sqlId | 編集用SQLのSQLID |
| insertMode | INSERT時のモード（省略時: `NORMAL`） |
| updateSize.size | コミット間隔。省略時は1回のINSERT-SELECTで全データ登録 |
| updateSize.bean | ワークテーブルに対応したJava Beansの完全修飾名（updateSize.size設定時は必須） |

**insertMode の値:**
- `NORMAL`: ヒント句なしでINSERT
- `ORACLE_DIRECT_PATH`: ヒント句自動設定でダイレクトパスインサートモード（Oracleのみ有効）

**updateSize設定時の注意:** コミット間隔を設定する場合、[ワークテーブルに定義された行番号カラム](#s3) を使用してSQLを分割実行する。編集用SQLに `where line_number between ? and ?` の範囲検索条件が必須。`updateSize.bean` も必ず設定すること。

```javascript
"load": {
  "type": "db2db",
  "bean": "sample.SampleEntity",
  "sqlId": "SELECT_ALL",
  "insertMode": "NORMAL",
  "updateSize": {
    "size": 5000,
    "bean": "sample.SampleWorkEntity"
  }
}
```

### ETL用JOB設定ファイルを配置するディレクトリのパスを変更する

ETL用JOB設定ファイルを配置するディレクトリのパスを変更する場合は、コンポーネント設定ファイルに設定する。

- コンポーネント名は `etlConfigLoader` とすること
- `JsonConfigLoader` の `configBasePath` プロパティにパスを設定すること

```xml
<component name="etlConfigLoader" class="nablarch.etl.config.JsonConfigLoader">
  <property name="configBasePath" value="classpath:META-INF/sample" />
</component>
```

<details>
<summary>keywords</summary>

MergeSqlGeneratorFactory, Extractフェーズ, Transformフェーズ, Loadフェーズ, SQL*Loader, Chunkステップ, ワークテーブル取り込み, バリデーション, データ変換, SqlLoaderBatchlet, SqlLoaderConfig, nablarch.etl.SqlLoaderBatchlet, nablarch.etl.SqlLoaderConfig, sqlLoaderBatchlet, コントロールファイル, ETL Extractフェーズ SQL*Loader, Oracle連携 ETL, DeleteInsertBatchlet, deleteInsertBatchlet, db2db, 洗い替え, insertMode, ORACLE_DIRECT_PATH, updateSize, ETL Loadフェーズ, JsonConfigLoader, nablarch.etl.config.JsonConfigLoader, configBasePath, etlConfigLoader, JOB設定ファイルパス変更, ETL設定ディレクトリ変更, コンポーネント設定

</details>

## ETLを使用するバッチの設計ポイント

## ファイル取り込み処理

### ワークテーブル

取り込み対象ファイルの内容を保持するテーブル。Extractフェーズでロードされ、Transform/Loadの入力テーブルとなる。

**カラム設計指針** (不正な値であってもワークテーブルにロードできるよう以下の指針に従い設計すること):

| 設計項目 | 指針 |
|---|---|
| カラムの型 | 原則可変長文字列型。バイナリデータを保存するカラムは文字列型に変換出来ないためバイナリ型を使用する。 |
| カラムのデータ長 | 可変長ファイル（CSV等）はDBで定義可能な最大値。固定長ファイルは項目長をカラムのデータ長とする。 |

**行番号カラム** (`LINE_NUMBER`、整数型、必須定義):
- Transformフェーズ: バリデーションエラー発生時の行番号ログ出力、エラーレコード削除の条件として使用。
- Loadフェーズ: 洗い替え・マージ処理でコミット間隔を制御する際に使用。

> **補足**: 行番号カラムは本テーブルにはロード不要。データベースへの登録（[etl-load-insert_database](#)）では自動的に除外される。洗い替え（[etl-load-replace_database](#)）・マージ（[etl-load-merge_database](#)）使用時はSQLのSELECT句に行番号カラムを含めないこと。

### エラーテーブル

バリデーションエラーとなったレコードの退避先テーブル。ワークテーブルと全く同一のレイアウトにすること。

### 本テーブル

行番号カラムは不要。ワークテーブルのカラムは基本的に文字列型のため、本テーブルへ取り込む際に型変換が必要。データベースへの登録（[etl-load-insert_database](#)）ではEntityの型定義に従い自動型変換。洗い替え・マージ使用時はSQL内で明示的に型変換すること（暗黙変換に依存しないこと）。

## ファイル出力処理

本テーブルの内容をファイルに出力する。ファイル取り込みと異なり設計時の特別な注意点はない。要件に従い本テーブルとファイルレイアウトを設計し、[etl-load-file](#) 時にSQLで値の編集を行う。

## エラーテーブルの設計

バリデーションエラーとなったレコードはワークテーブルからエラーテーブルに移送（ワークテーブルからは削除）される。このため、ワークテーブルと全く同じレイアウトでエラーレコード格納用テーブルを定義する。

## エラーテーブルに対応したEntityの作成

[Extract(Chunk版)](#) や [Extract(SQL*Loader版)](#) で作成したワークテーブルに対応するJava Beansを継承して作成すると良い。継承した場合、`Entity` アノテーションと `Table` アノテーションを設定する。

## JOB定義

- batchletとしてステップを定義する
- batchletクラスには `validationBatchlet` を設定する
- `progressLogOutputInterval` プロパティに進捗ログの出力間隔を設定する（デフォルト: `1000`）

```xml
<!-- id及びnextは適宜変更すること -->
<step id="validation" next="load">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <batchlet ref="validationBatchlet">
    <properties>
      <property name="progressLogOutputInterval" value="5000" />
    </properties>
  </batchlet>
</step>
```

## ETL用JOB設定ファイル

| キー | 設定する値 |
|---|---|
| type | `validation` を固定で設定する |
| bean | ワークテーブルに対応するJava Beansの完全修飾名 |
| errorEntity | [エラーテーブルに対応したEntity](#) の完全修飾名 |
| mode | バリデーションエラー発生時のJOBの継続モード（省略時デフォルト: `ABORT`） |
| errorLimit | 許容するエラー数（省略または負数の場合は無効） |

**modeの設定値:**

- `ABORT`: バリデーションエラーが発生すると後続のステップは実行せず `EtlJobAbortedException` を送出しJOBを異常終了する。異常終了のタイミングは全レコードのバリデーション後となる。
- `CONTINUE`: バリデーションエラーが発生しても後続のステップが実行される。JOBの Exit Status には `WARNING` が設定される（詳細は [jsr352_exitcode_batch_application](../../processing-pattern/jakarta-batch/jakarta-batch-run_batch_application.md) 参照）。

**errorLimitの動作:** `mode` の設定に関係なく、許容するエラー数を超えるバリデーションエラーが発生したタイミングで `EtlJobAbortedException` を送出しJOBを異常終了する。

```javascript
"validation": {
  "type": "validation",
  "bean": "com.nablarch.example.app.batch.ee.dto.ZipCodeDto",
  "errorEntity": "com.nablarch.example.app.batch.ee.dto.ZipCodeErrorEntity",
  "mode": "ABORT",
  "errorLimit": 100
}
```

## メッセージの定義

`ValidationBatchlet` はバリデーションエラーが発生したことをログに出力する。ログに出力する文言は [message](../../component/libraries/libraries-message.md) から取得するため、メッセージの設定が必要。詳細は [etl-message](#) を参照。

> **補足**: JOB定義及びETL用JOB設定ファイルは、[etl-json-configuration](#s5) の **Loadフェーズでマージモードを使用する場合のテンプレート** をダウンロードし編集すると良い。

## マージ対象テーブルに対応したEntityの作成

テーブル定義は [universal_dao](../../component/libraries/libraries-universal_dao.md) を参照しアノテーションを設定する。

## 編集用SQLの作成

- ファイル名: マージ対象テーブルのEntityクラス名 + `.sql`
- 配置先: クラスパス配下の同クラスのパッケージと同じディレクトリ
- 例: 完全修飾名 `nablarch.sample.SampleEntity` → `nablarch/sample/SampleEntity.sql`
- SQLIDは任意の値を指定。[etl-load-merge_database-configuration](#) で参照する
- 外部からパラメータを渡すことは不可

## JOB定義

batchletとしてステップを定義し、batchletクラスに `mergeBatchlet` を設定する。

```xml
<step id="load">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <batchlet ref="mergeBatchlet" />
</step>
```

## ETL用JOB設定ファイル（マージモード）

| キー | 設定する値 |
|---|---|
| type | `db2db`（固定） |
| bean | マージ対象テーブルEntityの完全修飾名 |
| sqlId | 編集用SQLのSQLID |
| mergeOnColumns | マージ時に出力対象テーブルにデータが存在するかチェックするカラム名（配列） |
| updateSize.size | コミット間隔。省略時は1回のマージ実行で全データ登録 |
| updateSize.bean | ワークテーブルに対応したJava Beansの完全修飾名（updateSize.size設定時は必須） |

**updateSize設定時の注意:** コミット間隔を設定する場合、[ワークテーブルに定義された行番号カラム](#s3) を使用してSQLを分割実行する。編集用SQLに `where line_number between ? and ?` の範囲検索条件が必須。`updateSize.bean` も必ず設定すること。

```javascript
"load": {
  "type": "db2db",
  "bean": "sample.SampleEntity",
  "sqlId": "SELECT_ALL",
  "mergeOnColumns": [
    "key1"
  ],
  "updateSize": {
    "size": 5000,
    "bean": "sample.SampleWorkEntity"
  }
}
```

<details>
<summary>keywords</summary>

LINE_NUMBER, ワークテーブル設計, エラーテーブル, 行番号カラム, ファイル取り込み設計, 型変換, ValidationBatchlet, EtlJobAbortedException, nablarch.etl.ValidationBatchlet, nablarch.etl.EtlJobAbortedException, javax.persistence.Entity, javax.persistence.Table, validationBatchlet, progressLogOutputInterval, errorEntity, errorLimit, ETL Transformフェーズ バリデーション, エラーテーブル ABORT CONTINUE, MergeBatchlet, mergeBatchlet, db2db, マージ, mergeOnColumns, updateSize, ETL Loadフェーズ

</details>

## ETL JOBを実行するための設定

ETL JOBの実行には以下の3種類の設定ファイルが必要。

| 設定ファイル | 内容 |
|---|---|
| ETL用環境設定ファイル | 読み込むファイルパスなどの環境依存値を設定。詳細は [etl-common-configuration](#s4) |
| JOB定義ファイル | ETL JOBのJOB構成を定義。詳細は [etl-json-configuration](#s5) および [jsr352_batch](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md) |
| ETL用JOB設定ファイル | JOB毎の各フェーズ（Extract/Transform/Load）を設定。詳細は [etl-json-configuration](#s5) |

> **補足**: JOB定義及びETL用JOB設定ファイルは、[etl-json-configuration](#s5) の **JSR352のChunkを使用したファイル取り込みのテンプレート** をダウンロードし編集すると良い。

## 登録対象テーブルに対応したEntityの作成

テーブル定義は [universal_dao](../../component/libraries/libraries-universal_dao.md) を参照しアノテーションを設定する。

## 登録用SQLの作成

- ファイル名: 登録対象テーブルのEntityクラス名 + `.sql`
- 配置先: クラスパス配下の同クラスのパッケージと同じディレクトリ
- 例: 完全修飾名 `nablarch.sample.SampleEntity` → `nablarch/sample/SampleEntity.sql`
- SQLIDは任意の値を指定。[etl-load-insert_database-configuration](#) で参照する
- 外部からパラメータを渡すことは不可

## JOB定義

Chunkとしてステップを定義する。readerに `databaseItemReader`、writerに `databaseItemWriter` を設定する。

```xml
<step id="load">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <chunk item-count="3000">
    <reader ref="databaseItemReader" />
    <writer ref="databaseItemWriter" />
  </chunk>
</step>
```

## ETL用JOB設定ファイル（DB登録）

| キー | 設定する値 |
|---|---|
| type | `db2db`（固定） |
| bean | 登録対象テーブルEntityの完全修飾名 |
| sqlId | 登録用SQLのSQLID |

```javascript
"extract": {
  "type": "db2db",
  "bean": "sample.Sample",
  "sqlId": "SELECT_ALL"
}
```

<details>
<summary>keywords</summary>

ETL用環境設定ファイル, JOB定義ファイル, ETL用JOB設定ファイル, ETL設定ファイル構成, DatabaseItemReader, DatabaseItemWriter, databaseItemReader, databaseItemWriter, db2db, データベース登録, ETL Loadフェーズ, Chunk

</details>

## ETL用環境設定ファイルを作成する

環境依存値はシステムリポジトリ機能の環境設定ファイルに設定する（[repository-environment_configuration](../../component/libraries/libraries-repository.md) 参照）。

**ファイル入力を行う場合**:

| プロパティ名 | 説明 |
|---|---|
| nablarch.etl.inputFileBasePath | 入力ファイルを配置するディレクトリのパス |

**ファイル出力を行う場合**:

| プロパティ名 | 説明 |
|---|---|
| nablarch.etl.outputFileBasePath | 出力ファイルを配置するディレクトリのパス |

**Oracle SQL*Loader使用時**:

| プロパティ名 | 説明 |
|---|---|
| nablarch.etl.sqlLoaderControlFileBasePath | ctlファイルを配置するディレクトリのパス |
| nablarch.etl.sqlLoaderOutputFileBasePath | 実行ログを出力するディレクトリのパス |

<details>
<summary>keywords</summary>

nablarch.etl.inputFileBasePath, nablarch.etl.outputFileBasePath, nablarch.etl.sqlLoaderControlFileBasePath, nablarch.etl.sqlLoaderOutputFileBasePath, 環境依存値設定

</details>

## JOB定義ファイルとETL用JOB設定ファイルを作成する

ETL用JOB設定ファイルのファイル名: `<<JOB ID>>.json`、配置先: `META-INF/etl-config/`

> **補足**: 配置ディレクトリのパスを変更したい場合は [etl-loader-dir_path](#) 参照。

**テンプレート一覧**:

Oracle SQL*Loaderを使用したファイル取り込み（洗い替えモード）:
- [JOB定義ファイルのテンプレート](../../../knowledge/extension/etl/assets/etl-etl/sql_loader_replace.xml)
- [ETL用JOB設定ファイルテンプレート](../../../knowledge/extension/etl/assets/etl-etl/sql_loader_replace_config.json)

Oracle SQL*Loaderを使用したファイル取り込み（マージモード）:
- [JOB定義ファイルのテンプレート](../../../knowledge/extension/etl/assets/etl-etl/sql_loader_merge.xml)
- [ETL用JOB設定ファイルテンプレート](../../../knowledge/extension/etl/assets/etl-etl/sql_loader_merge_config.json)

JSR352のChunkを使用したファイル取り込み:
- [JOB定義ファイルのテンプレート](../../../knowledge/extension/etl/assets/etl-etl/chunk_replace.xml)
- [ETL用JOB設定ファイルテンプレート](../../../knowledge/extension/etl/assets/etl-etl/chunk_replace.json)

ファイル出力:
- [JOB定義ファイルのテンプレート](../../../knowledge/extension/etl/assets/etl-etl/file_output.xml)
- [ETL用JOB設定ファイルテンプレート](../../../knowledge/extension/etl/assets/etl-etl/file_output.json)

> **補足**: テンプレートで要件を満たせない場合はテンプレートをベースにステップの追加・変更で対応。例えばChunkでワークテーブルにロードしてマージモードで本テーブルにロードしたい場合は、SQL*LoaderとChunkのテンプレートを組み合わせる。

<details>
<summary>keywords</summary>

META-INF/etl-config/, JOB設定ファイルテンプレート, sql_loader_replace, sql_loader_merge, chunk_replace, file_output

</details>

## テーブルクリーニングステップを利用してテーブルのデータを削除する

テーブルのクリーニング（全削除）が必要な場合（例: Extractの前にワークテーブルを空にしたい場合）、テーブルクリーニング用のステップを定義する。

**JOB定義**:
- batchletとしてステップを定義。
- batchletクラスには `tableCleaningBatchlet` を設定。

```xml
<!-- id及びnextは適宜変更すること -->
<step id="truncate" next="extract">
  <listeners>
    <!-- リスナーの設定は省略 -->
  </listeners>
  <batchlet ref="tableCleaningBatchlet" />
</step>
```

> **補足**: `TableCleaningBatchlet` は [database](../../component/libraries/libraries-database.md) 機能を使用するため、事前に [database](../../component/libraries/libraries-database.md) の設定が必要。

**ETL用JOB設定ファイル**:

| キー | 設定する値 |
|---|---|
| type | `truncate`（固定） |
| entities | 削除対象テーブルのEntityクラスの完全修飾名を配列で設定。Entityクラスは [universal_dao](../../component/libraries/libraries-universal_dao.md) のルールに従い作成。 |

```javascript
"truncate": {
  "type": "truncate",
  "entities": [
    "sample.SampleEntity1",
    "sample.SampleEntity2"
  ]
}
```

<details>
<summary>keywords</summary>

TableCleaningBatchlet, tableCleaningBatchlet, テーブルクリーニング, テーブル全削除, truncate

</details>
