# レジュームデータリーダ

## レジュームデータリーダ

**クラス名**: `nablarch.fw.reader.ResumeDataReader`

**読み込むデータの型**: ラップするデータリーダが読み込むデータの型

ファイルを読み込むデータリーダにレジューム機能を追加するデータリーダ。障害発生などの原因によりバッチが途中で終了した場合、未処理レコードから業務処理を再開できる。レジューム機能を追加したいデータリーダを本データリーダでラップすることにより、レジュームが有効となる。

**使用例** — [ファイルデータリーダ](readers-FileDataReader.md) をラップ:

```java
DataReader<DataRecord> reader = new FileDataReader()
        .setDataFile("record.dat")
        .setLayoutFile("record");
return new ResumeDataReader<DataRecord>().setSourceReader(reader);
```

**使用例** — [ValidatableFileDataReader](readers-ValidatableFileDataReader.md) をラップ:

```java
DataReader<DataRecord> reader = new ValidatableFileDataReader()
        .setValidatorAction(new FileLayoutValidatorAction())
        .setDataFile("record.dat").setLayoutFile("record");
return new ResumeDataReader<DataRecord>().setSourceReader(reader);
```

`FileBatchAction`_ を継承したバッチ業務アクションを作成する場合、`FileBatchAction`_ がデフォルトで [ValidatableFileDataReader](readers-ValidatableFileDataReader.md) をラップしたレジュームデータリーダを生成するため、実装不要。詳細は [../handler/FileBatchAction](../handlers/handlers-FileBatchAction.md) を参照。

**レジューム処理の流れ**:

1回目の実行（障害で途中終了）:
1. ファイル先頭から読み込み
2. バッチ業務アクションを実行
3. レジュームポイントをリクエスト管理テーブルに保存
（No1～3の処理を繰り返す）
4. 障害発生で処理が途中終了

2回目の実行（途中から再開）:
1. リクエスト管理テーブルからレジュームポイントを読み込む
2. ファイルからレコードを読み込む
3. レジュームポイントに到達するまでファイル読み込みを繰り返す
4. バッチ業務アクションを実行
5. レジュームポイントをリクエスト管理テーブルに保存
（ファイル終端までNo2～5の処理を繰り返す）

> **注意**: レジュームポイントはラップしたデータリーダの`read()`メソッドの実行回数（データを読み込んだ回数）を保存する。この実行回数は、データリーダの機能によってはファイルの物理的なレコードとは一致しない値となる。障害発生ポイントの特定にはアプリケーション実装でログに物理レコード番号やキー情報を出力すること。

物理レコード数とレジュームポイントが一致していなくても、レジューム機能は問題なく動作する。これは、同じファイルを何度読んでもデータリーダが返す値は変わらないため、レジュームポイントまで読み飛ばす処理は正常に機能するからである。

> **警告**: 障害発生ポイント以前のデータ（既に正常に処理が終わっているデータ）にパッチを当てた場合は、レジュームポイントを0クリアして1レコード目から再処理する必要がある。

**リクエスト管理テーブル構造**:

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| レジュームポイント | NUMBER(10) | ラップしたデータリーダの実行回数 |

> **重要**: レジュームポイントは自動的にクリアされない。レジュームを使用するバッチジョブを作成する際は、レジュームポイントをゼロクリアするバッチジョブもセットで作成し、事前にゼロクリアを行うように設計すること。

<details>
<summary>keywords</summary>

ResumeDataReader, nablarch.fw.reader.ResumeDataReader, FileDataReader, ValidatableFileDataReader, FileLayoutValidatorAction, FileBatchAction, レジューム機能, バッチ再実行, レジュームポイント, リクエスト管理テーブル

</details>

## 設定項目

`ResumePointManager`_ を用いてリクエスト管理テーブルのテーブル名、カラム名やレジューム要否などを設定する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tableName | String | ○ | | リクエスト管理テーブル名 |
| requestIdColumnName | String | ○ | | リクエストIDカラム名 |
| resumePointColumnName | String | ○ | | レジュームポイントカラム名 |
| resumable | boolean | | false | レジュームを有効にするかどうか |
| excludingRequestList | List\<String\> | | 空のリスト | レジューム機能を無効にするリクエストIDのリスト |
| dbTransactionName | String | | "transaction" | データベースリソース名 |

```xml
<component name="resumePointManager"
    class="nablarch.fw.reader.ResumePointManager">
    <property name="tableName" value="BATCH_REQUEST" />
    <property name="requestIdColumnName" value="REQUEST_ID" />
    <property name="resumePointColumnName" value="RESUME_POINT" />
    <property name="resumable" value="true" />
    <property name="excludingRequestList">
      <list>
         <value>RB11AC0150</value>
      </list>
    </property>
    <property name="dbTransactionName" value="transaction" />
</component>
```

<details>
<summary>keywords</summary>

ResumePointManager, nablarch.fw.reader.ResumePointManager, tableName, requestIdColumnName, resumePointColumnName, resumable, excludingRequestList, dbTransactionName, レジューム設定, レジュームポイント管理

</details>
