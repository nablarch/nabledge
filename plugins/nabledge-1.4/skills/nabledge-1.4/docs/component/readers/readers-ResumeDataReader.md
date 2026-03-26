# レジュームデータリーダ

## レジュームデータリーダ

**クラス名**: `nablarch.fw.reader.ResumeDataReader`

ファイルを読み込むデータリーダにレジューム機能を追加するラッパーデータリーダ。レジューム機能を追加したいデータリーダを本クラスでラップすることで有効になる。レジューム機能により、バッチが途中終了した場合に未処理レコードから業務処理を再開できる。再実行時、正常処理済みレコードはスキップされる。

**使用例**

[FileDataReader](readers-FileDataReader.md) をラップする場合:

```java
DataReader<DataRecord> reader = new FileDataReader()
        .setDataFile("record.dat")
        .setLayoutFile("record");
return new ResumeDataReader<DataRecord>().setSourceReader(reader);
```

[ValidatableFileDataReader](readers-ValidatableFileDataReader.md) をラップする場合:

```java
DataReader<DataRecord> reader = new ValidatableFileDataReader()
        .setValidatorAction(new FileLayoutValidatorAction())
        .setDataFile("record.dat").setLayoutFile("record");
return new ResumeDataReader<DataRecord>().setSourceReader(reader);
```

> **補足**: [../handler/FileBatchAction](../handlers/handlers-FileBatchAction.md) を継承したバッチ業務アクションを作成する場合、FileBatchAction がデフォルトで [ValidatableFileDataReader](readers-ValidatableFileDataReader.md) をラップしたレジュームデータリーダを生成するため、アプリケーションプログラマが実装する必要はない。

**レジューム処理概要**

レジュームポイントはリクエスト管理テーブルに保存される。値は最後に成功した処理のread()実行回数（上書き方式）。

1回目（障害発生時）:
1. ファイル先頭から読み込み
2. バッチ業務アクション実行
3. レジュームポイントをリクエスト管理テーブルに保存（[../handler/LoopHandler](../handlers/handlers-LoopHandler.md) でコミット設定時はコミット前最後の処理のみ）
4. 障害発生で途中終了

2回目（再実行時）:
1. リクエスト管理テーブルからレジュームポイントを読み込む
2. ファイルからレコードを読み込む
3. レジュームポイントに到達していない場合は、レジュームポイントに到達するまでファイル読み込み（No2）を繰り返す
4. バッチ業務アクションを実行する
5. レジュームポイントをリクエスト管理テーブルに保存する

（ファイル終端まで No2〜5 の処理を繰り返す）

> **注意**: レジュームデータリーダはread()メソッドの実行回数をレジュームポイントとして保存する。この値はファイルの物理的なレコード番号と一致しない場合がある。障害発生ポイントの特定には、アプリケーション実装で物理レコード番号やキー情報をログに出力すること。物理レコード数とレジュームポイントが一致していなくてもレジューム機能は問題なく動作する（同じファイルを何度読んでもデータリーダが返す値は変わらないため）。

> **警告**: 障害発生ポイント以前のデータ（既に正常処理済み）にパッチを当てた場合は、レジュームポイントを0クリアして1レコード目から再処理する必要がある。

**テーブル構成**

リクエスト管理テーブル:

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| レジュームポイント | NUMBER(10) | ラップしたデータリーダの実行回数 |

**ジョブの設計時に考慮すべきこと**

レジュームポイントは自動的にクリアされない。レジュームを使用するバッチジョブ作成時は、レジュームポイントをゼロクリアするバッチジョブもセットで作成し、事前にゼロクリアを行うよう設計すること。

<details>
<summary>keywords</summary>

ResumeDataReader, nablarch.fw.reader.ResumeDataReader, FileDataReader, ValidatableFileDataReader, FileBatchAction, LoopHandler, FileLayoutValidatorAction, レジューム機能, バッチ再実行, レジュームポイント, リクエスト管理テーブル, レジューム処理概要

</details>

## 設定項目

`ResumePointManager` クラスを使用してリクエスト管理テーブルのテーブル名・カラム名やレジューム要否などを設定する。

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
    <!-- 以下のプロパティは省略可能 -->
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

ResumePointManager, nablarch.fw.reader.ResumePointManager, tableName, requestIdColumnName, resumePointColumnName, resumable, excludingRequestList, dbTransactionName, レジューム設定, リクエスト管理テーブル設定

</details>
