

![handler_structure_bg.png](../../../knowledge/assets/readers-ResumeDataReader/handler_structure_bg.png)

![handler_bg.png](../../../knowledge/assets/readers-ResumeDataReader/handler_bg.png)

## レジュームデータリーダ

ファイルを読み込むデータリーダにレジューム機能を追加するデータリーダ。

本データリーダを使用すると、障害発生などの原因によりバッチが途中で終了した場合に、未処理レコードから業務処理を再開（レジューム）できる。
再実行の際には、正常に処理できたレコードに対する業務処理はスキップされる。

レジューム機能を追加したいデータリーダを本データリーダでラップすることにより、レジュームが有効となる。

**クラス名**
nablarch.fw.reader.ResumeDataReader
**読み込むデータの型**
ラップするデータリーダが読み込むデータの型

**使用例**

* データリーダファクトリ内で [ファイルデータリーダ](../../component/readers/readers-FileDataReader.md) をラップしたレジュームデータリーダを生成する例

```java
DataReader<DataRecord> reader = new FileDataReader()
        .setDataFile("record.dat")
        .setLayoutFile("record");
// FileDataReaderをラップしてレジューム機能を追加する
return new ResumeDataReader<DataRecord>().setSourceReader(reader);
```

* データリーダファクトリ内で [事前精査機能付きファイルデータリーダ](../../component/readers/readers-ValidatableFileDataReader.md) をラップしたレジュームデータリーダを生成する例

```java
DataReader<DataRecord> reader = new ValidatableFileDataReader()
        .setValidatorAction(new FileLayoutValidatorAction())
        .setDataFile("record.dat").setLayoutFile("record");

// ValidatableFileDataReaderをラップしてレジューム機能を追加する
return new ResumeDataReader<DataRecord>().setSourceReader(reader);
```

なお、 [FileBatchAction](../../javadoc/nablarch/fw/action/FileBatchAction.html) を継承したバッチ業務アクションを作成する場合は、 [FileBatchAction](../../javadoc/nablarch/fw/action/FileBatchAction.html) がデフォルトで [事前精査機能付きファイルデータリーダ](../../component/readers/readers-ValidatableFileDataReader.md) をラップしたレジュームデータリーダを生成するので、
アプリケーションプログラマがレジュームデータリーダや事前検証機能付きファイルデータリーダを生成するコードを実装する必要はない。

詳細は [ファイル入力のバッチ業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-FileBatchAction.md) を参照すること。

**レジューム処理概要**

レジュームは、リクエスト管理テーブルにレジュームポイントを保存することにより実現する。

レジュームポイントには、一番最後に処理が成功した場所が保存される。
たとえば、入力ファイルの7行目までの処理が成功し、8行目の処理が失敗してバッチが終了する場合、バッチ終了時点のレジュームポイントの値は「7」となる。

レジュームポイントとして保存される値は1つのみで、処理が成功する度にその値は上書かれる。

以下にファイル読み込み処理の途中で障害が発生する例をもとに、レジューム処理の流れを示す。

① 1回目のファイル読み込みバッチの実行（障害が発生し、処理が途中で終了する）

1. レジュームデータリーダが、ファイルの先頭から読み込みを行う。
2. バッチ業務アクションを実行する。
3. レジュームデータリーダがレジュームポイントをリクエスト管理テーブルに保存する。 [1]
【 **No1～3** の処理を繰り返す】
4. DB接続などの障害発生が発生し、処理が途中で終了する。

② 2回目のファイル読み込みバッチの実行（ファイルの途中から処理を再開する）

1. レジュームデータリーダが、リクエスト管理テーブルからレジュームポイントを読み込む。
2. ファイルからレコードを読み込む。
3. レジュームポイントに到達していない場合は、レジュームポイントに到達するまでファイル読み込み( **No2** )を繰り返す。
4. バッチ業務アクションを実行する。
5. レジュームデータリーダがレジュームポイントをリクエスト管理テーブルに保存する。
（ファイル終端まで **No2～5** の処理を繰り返す）

[トランザクションループ制御ハンドラ](../../component/handlers/handlers-LoopHandler.md) の設定により一定件数ごとにコミットを行なっている場合は、コミット前の最後の処理でのみ実施する。

> **Note:**
> レジュームデータリーダはレジュームポイントとしてラップしたデータリーダの *read()* メソッドの実行回数（データを読み込んだ回数）を保存する。
> この実行回数は、データリーダの機能によってはファイルの物理的なレコードとは一致しない値となる。
> このため、レジュームポイントを元に障害発生ポイントを特定するような設計にするのではなく、
> アプリケーションの実装で障害が発生した物理レコード番号やキー情報をログに出力すること。

> 物理レコード数とレジュームポイントが一致していなくても、レジューム機能は問題なく動作する。
> これは、同じファイルを何度読んでもデータリーダが返す値は変わらないため、レジュームポイントまで読み飛ばす処理は正常に機能するからである。

> > **Warning:**
> > 障害発生ポイントのレコードにパッチを当てることは問題ないが、発生ポイント以前のデータ（既に正常に処理が終わっているデータ）
> > に対してパッチを当てた場合は、レジュームポイントを0クリアして1レコード目から再度処理する必要があるため注意すること。

**テーブル構成**

以下は、本データリーダが参照するリクエスト管理テーブルの構造である。

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| レジュームポイント | NUMBER(10) | ラップしたデータリーダの実行回数 |

**ジョブの設計時に考慮すべきこと**

レジュームポイントは自動的にクリアされないので、レジュームを使用してファイルを読み込むバッチジョブを作成する際は、レジュームポイントをゼロクリアするバッチジョブもセットで作成し、事前にゼロクリアを行うように設計すること。

### 設定項目

レジュームポイント管理クラス（ [ResumePointManager](../../javadoc/nablarch/fw/reader/ResumePointManager.html) ）を用いてリクエスト管理テーブルのテーブル名、カラム名やレジューム要否など、レジューム関連の設定を行うことができる。

レジュームポイント管理クラスの設定項目の一覧は以下のとおりである。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| リクエスト管理テーブル名 | tableName | String | 必須指定 |
| リクエストIDカラム名 | requestIdColumnName | String | 必須指定 |
| レジュームポイントカラム名 | resumePointColumnName | String | 必須指定 |
| レジュームを有効にするかどうか | resumable | boolean | 任意指定(デフォルト = false(無効)) |
| レジューム機能を無効にするリクエストIDのリスト | excludingRequestList | List<String> | 任意指定(デフォルト = 空のリスト) |
| データベースリソース名 | dbTransactionName | String | 任意指定(デフォルト = "transaction") |

**設定例**

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
