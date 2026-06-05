# class ValidationBatchlet

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractBatchlet
      └─ nablarch.etl.ValidationBatchlet
```

---

```java
public class ValidationBatchlet
extends AbstractBatchlet
```

一時テーブルのデータをバリデーションする{@link javax.batch.api.Batchlet}実装クラス。
<p/>
一時テーブルのデータを全レコード取得し、{@link ValidationStepConfig#getBean()}のバリデーションルールに従いバリデーションを実施する。
エラーが発生した場合には、そのレコードを退避テーブル(エラーテーブル)({@link ValidationStepConfig#getErrorEntity}に対応するテーブル)に移動する。
また、エラーの詳細はワーニングレベルでログ出力を行う。
<p/>
エラー発生時にジョブを継続するか否かのモード指定によって切り替えることができる。
{@link ValidationStepConfig#getMode()}が{@link Mode#CONTINUE}の場合には処理を継続し、
{@link Mode#ABORT}の場合には、{@link EtlJobAbortedException}を送出しジョブを異常終了する。
<p/>
許容するエラー数が設定でき、その数を超えた場合には即ジョブをアボートする。
許容するエラー数の設定は、{@link ValidationStepConfig#getErrorLimit()}より取得する。
この値が設定されていない場合やマイナス値の場合は、この機能は無効化される。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### jobContext

```java
private final JobContext jobContext
```

{@link JobContext}

---

### stepContext

```java
private final StepContext stepContext
```

{@link StepContext}

---

### stepConfig

```java
private final ValidationStepConfig stepConfig
```

ETLの設定

---

### progressManager

```java
private final ProgressManager progressManager
```

進捗状況を管理するBean

---

### progressLogOutputInterval

```java
String progressLogOutputInterval
```

進捗ログを出す間隔

---

## コンストラクタの詳細

### ValidationBatchlet

```java
public ValidationBatchlet(JobContext jobContext, StepContext stepContext, StepConfig stepConfig, ProgressManager progressManager)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `stepConfig` - ステップの設定
- `progressManager` - 進捗状況を管理するBean

---

## メソッドの詳細

### process

```java
public String process()
               throws Exception
```

---

### truncateErrorTable

```java
private static void truncateErrorTable(Class<?> errorTable)
```

エラーテーブルの内容をクリーニングする。
<p/>
本処理では、TRUNCATEのSQL文を構築する際にステートメントを発行しているが、
RDBMS製品によっては、TRUNCATE文の発行はトランザクション内の最初のステートメントである必要があるため、
TRUNCATEのSQL文の構築後に明示的にトランザクションをロールバックしている。
<p/>
そのため、もしステップリスナ等で事前にデータベースへの更新等を行っている場合、
その処理は取り消されるため注意すること。

**パラメータ:**
- `errorTable` - エラーテーブルの内容

---

### getRecordCountInInputTable

```java
private long getRecordCountInInputTable()
```

入力テーブルのレコード数を取得する。

**戻り値:**
レコード数

---

### deleteErrorRecord

```java
private static void deleteErrorRecord(Class<?> inputTable, Class<?> errorTable)
```

一時テーブルからエラーのレコード情報を削除する。

**パラメータ:**
- `inputTable` - 一時テーブル
- `errorTable` - エラーテーブル

---

### buildDeleteSql

```java
private static String buildDeleteSql(Class<?> inputTable, Class<?> errorTable)
```

エラーレコードをクリーニングするためのSQL文を構築する。

**パラメータ:**
- `inputTable` - 一時テーブル
- `errorTable` - エラーテーブル

**戻り値:**
SQL文

---

### verifyConfig

```java
private void verifyConfig()
```

設定値の検証を行う。

---

### buildResult

```java
private String buildResult(ValidationResult validationResult)
```

結果を構築する。

**パラメータ:**
- `validationResult` - バリデーション結果

**戻り値:**
終了ステータス

---

### onError

```java
private static void onError(WorkItem item, Set<ConstraintViolation<WorkItem>> constraintViolations, Class<?> errorTable)
```

Validationエラー時の処理を行う。

**パラメータ:**
- `item` - Validationエラーが発生したアイテム
- `constraintViolations` - Validationのエラー内容
- `errorTable` - エラーテーブルのエンティティクラス

---

### isOverLimit

```java
private static boolean isOverLimit(ValidationStepConfig stepConfig, ValidationResult validationResult)
```

エラーの許容数を超えたか否か。

**パラメータ:**
- `stepConfig` - 設定値
- `validationResult` - バリデーション結果情報

**戻り値:**
超えている場合は{@code true}

---

### commit

```java
private static void commit()
```

コミットを行う。

---

### getLogInterval

```java
private long getLogInterval()
```

進捗ログの出力間隔を取得する。

**戻り値:**
進捗ログの出力間隔

---
