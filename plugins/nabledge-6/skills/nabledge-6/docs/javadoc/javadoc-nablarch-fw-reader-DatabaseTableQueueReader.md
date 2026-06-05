# class DatabaseTableQueueReader

**パッケージ:** nablarch.fw.reader

**実装されたインタフェース:**
- DataReader<SqlRow>

---

```java
public class DatabaseTableQueueReader
implements DataReader<SqlRow>
```

データベースのテーブルを擬似的にキューのように扱うデータリーダ。
<p/>
本リーダはデータベースのテーブルをキューのように扱えるようにするため、
処理対象レコードが存在しない場合でも{@link #hasNext(nablarch.fw.ExecutionContext)}は
常に{@code true}を返却し、処理対象が存在するように振る舞う。
これにより、データが存在しない場合でも{@link #read(nablarch.fw.ExecutionContext)}が呼び出され、
テーブルの最新情報を取得し直すことが可能となる。
<p/>
本リーダは、処理対象レコードが存在しない場合、再度最新の情報を取得する。
この際に、他のスレッドで処理中のレコードが未処理のまま残っている可能性がある。
このため、各スレッドで処理中のレコードをヒープ上に保持し、
読み込んだ対象が他のスレッドで処理中のレコードではないことを確認する。
<p/>
対象のレコードが、他のスレッドで処理中である場合には、次のレコードを読み込み再度チェックを行う。
対象のレコードが、他のスレッドで処理中でない場合には、読み込んだレコードをクライアントに返却する。

**作成者:** hisaaki sioiri  
**関連項目:** DatabaseRecordReader  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### workingInputDataHolder

```java
private final WorkingInputDataHolder workingInputDataHolder
```

実行中要求を保持するオブジェクト

---

### originalReader

```java
private final DatabaseRecordReader originalReader
```

データベースリーダ。
<p/>
データベースへのアクセスは、このリーダに処理を移譲する。

---

### waitTime

```java
private final int waitTime
```

データが存在しない場合の待機時間(ミリ秒)。

---

### primaryKeys

```java
private final String[] primaryKeys
```

主キーのカラム名リスト

---

### closed

```java
private boolean closed
```

リーダが閉じられているか否か

---

## コンストラクタの詳細

### DatabaseTableQueueReader

```java
public DatabaseTableQueueReader(DatabaseRecordReader originalReader, int waitTime, String primaryKeys)
```

データベースをキューとして扱うリーダを生成する。

**パラメータ:**
- `originalReader` - データベースレコードリーダ
- `waitTime` - データが存在しない場合の待機時間（ミリ秒）
- `primaryKeys` - レコードを一意に識別する主キーのカラム名

---

## メソッドの詳細

### read

```java
public synchronized SqlRow read(ExecutionContext ctx)
```

次のレコードを読み込み返却する。
<p/>
本実装では、次のレコードが存在しない場合（カーソルの終端に達した場合）、
カーソルを再度開き直し最新の情報を取得後にレコードを読み込み返却する。
<p/>
読み込んだレコードが他スレッドで処理中のデータの場合には、
そのレコードを読み飛ばし、他のスレッドが処理していないレコードを返却する。
<p/>
次に読み込むレコードが存在しない場合は{@code null}を返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
レコード

---

### writeLog

```java
protected void writeLog(InputDataIdentifier inputDataIdentifier)
```

要求の識別情報をログに出力する。
<p/>
識別情報に個人情報等のようにログに出力すべきではない項目が含まれる場合には、
本メソッドをオーバーライドしマスク処理などを実施後にログ出力を行うこと。

**パラメータ:**
- `inputDataIdentifier` - 要求識別情報

---

### hasNext

```java
public synchronized boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。
<p/>
本実装ではデータベース上に処理対象データが無くなった場合でも処理を継続するため、常にデータ有り{@code true}を返す。<br/>
このリーダが閉じられた場合は{@code false}を返す。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
読み込むデータが存在する場合 {@code true}

---

### close

```java
public synchronized void close(ExecutionContext ctx)
```

このリーダの利用を停止し、内部的に保持している各種リソースを解放する。

**パラメータ:**
- `ctx` - 実行コンテキスト

---

### waitThread

```java
private void waitThread()
```

現在のスレッドを{@link #waitTime}分待機する。

**例外:**
- `RuntimeException` - 割り込みが発生した場合

---

### verifyParameter

```java
private void verifyParameter()
```

パラメータ情報が正しいことを検証する。

**例外:**
- `IllegalArgumentException` - 主キーのカラム名リストが{@code null}または空、
                                  もしくは、主キーのカラム名が重複している場合

---

### getOriginalReader

```java
public DatabaseRecordReader getOriginalReader()
```

オリジナルのリーダ({@link DatabaseRecordReader})を取得する。
<p/>
本メソッドは、以下の理由によりプロダクションコードからの呼び出しは推奨しない。<br/>

オリジナルリーダを取得すること自体は問題ないが、取得したオリジナルのリーダを操作してしまうと、
本リーダ内で保持しているオリジナルのリーダの状態も変更されてしまうため。

**戻り値:**
オリジナルのリーダ

---
