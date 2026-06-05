# class ExecutionContext

**パッケージ:** nablarch.fw

**継承階層:**
```
java.lang.Object
  └─ HandlerQueueManager<ExecutionContext>
      └─ nablarch.fw.ExecutionContext
```

---

```java
public class ExecutionContext
extends HandlerQueueManager<ExecutionContext>
```

一連のハンドラ実行において、共通して読み書きするデータを保持するクラス。
<p/>
具体的には以下の情報を保持する。
<ul>
    <li>ハンドラキュー</li>
    <li>データリーダ もしくは データリーダファクトリ</li>
    <li>ユーザセッションスコープ情報</li>
    <li>リクエストスコープ情報</li>
</ul>
本クラスのセッションスコープはスレッドアンセーフである。
複数スレッドから使用する場合はセッションスコープにスレッドセーフなMap実装を設定すること。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### FW_PREFIX

```java
public static final String FW_PREFIX
```

各種スコープ上の変数をフレームワークが使用する際に
名前に付けるプレフィックス（予約名）

---

### handlerQueue

```java
private final ArrayList<Handler> handlerQueue
```

ハンドラキュー

---

### reader

```java
private DataReader<?> reader
```

データリーダ

---

### readerFactory

```java
private DataReaderFactory<?> readerFactory
```

データリーダファクトリ

---

### sessionScopeMap

```java
private Map<String,Object> sessionScopeMap
```

セッションスコープ上の変数を格納したMap

---

### sessionStoreMap

```java
private Map<String,Object> sessionStoreMap
```

セッションストア上の変数を格納したMap

---

### requestScopeMap

```java
private Map<String,Object> requestScopeMap
```

リクエストスコープ上の変数を格納するMap

---

### lastReadData

```java
private Object lastReadData
```

この実行コンテキストによって最後に読み込まれたデータ

---

### lastRecordNumber

```java
private int lastRecordNumber
```

現在、物理的に読み込んでいるレコードのレコード番号

---

### processSucceeded

```java
private boolean processSucceeded
```

処理結果

---

### currentRequestObject

```java
private Object currentRequestObject
```

現在処理中のリクエストオブジェクト

---

### DATA_PROCESSED_WHEN_THROWN_MAP_KEY

```java
private static final String DATA_PROCESSED_WHEN_THROWN_MAP_KEY
```

例外を送出したスレッドが例外発生時に処理していた入力データをリクエストスコープに格納する際に使用するキー

---

### THROWN_EXCEPTION_KEY

```java
public static final String THROWN_EXCEPTION_KEY
```

例外をリクエストスコープから取得する際に使用するキー

---

### THROWN_APPLICATION_EXCEPTION_KEY

```java
public static final String THROWN_APPLICATION_EXCEPTION_KEY
```

{@link ApplicationException}をリクエストスコープから取得する際に使用するキー

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## コンストラクタの詳細

### ExecutionContext

```java
public ExecutionContext()
```

デフォルトコンストラクタ

---

### ExecutionContext

```java
public ExecutionContext(ExecutionContext original)
```

元となる実行コンテキストから、新たな実行コンテキストのオブジェクトを作成する。
<p/>
作成される実行コンテキストの状態は以下の通り。
<ul>
    <li>ハンドラキューには、元のオブジェクトからシャローコピーを作成して設定する。</li>
    <li>リクエストスコープには、新規インスタンスを設定する(コピーされない)。</li>
    <li>それ以外のフィールドには、元のオブジェクトの参照を設定する。</li>
</ul>

**パラメータ:**
- `original` - 元となる実行コンテキスト

---

## メソッドの詳細

### getHandlerQueue

```java
public List<Handler> getHandlerQueue()
```

---

### handleNext

```java
public TResult handleNext(TData data)
                   throws NoMoreHandlerException, ClassCastException
```

ハンドラキュー上の次のハンドラに処理を委譲する。

**パラメータ:**
- `<TData>` - 処理対象データの型
- `<TResult>` - 処理結果データの型
- `data` - 処理対象データ

**戻り値:**
実行結果

**例外:**
- `NoMoreHandlerException` - 次のハンドラが存在しない場合。
- `ClassCastException` - ハンドラの型変数と実際のハンドラの戻り値の型が異なる場合。

---

### getNextHandler

```java
public Handler<TData,TResult> getNextHandler()
                                      throws NoMoreHandlerException, ClassCastException
```

ハンドラキュー上の次のハンドラを取得する。

**パラメータ:**
- `<TData>` - 処理対象データの型
- `<TResult>` - 処理結果データの型

**戻り値:**
次のハンドラ

**例外:**
- `NoMoreHandlerException` - 次のハンドラが存在しない場合。
- `ClassCastException` - ハンドラの型変数と実際のハンドラの戻り値の型が異なる場合。

---

### findHandler

```java
public T findHandler(Object data, Class<T> targetType, Class<?> stopType)
```

ハンドラキュー上の後続ハンドラのうち、
指定されたクラスもしくはインタフェースを実装している直近のハンドラを返す。
<p/>
該当するハンドラが登録されていなかった場合は{@code null}を返す。

**パラメータ:**
- `<T>` - 検索対象のハンドラ型
- `data` - このハンドラに対する入力オブジェクト
- `targetType` - 検索対象のハンドラ型
- `stopType` - このタイプのハンドラよりも後続にあるハンドラを検索対象から除外する。

**戻り値:**
検索結果 (該当するハンドラが存在しなかった場合は{@code null}を返す。)

---

### selectHandlers

```java
public List<T> selectHandlers(Object data, Class<T> targetType, Class<?> stopType)
```

ハンドラキュー上の後続ハンドラのうち、
指定されたクラスもしくはインタフェースを実装しているものを全て返す。
<p/>
該当するハンドラが登録されていなかった場合は空のリストを返す。

**パラメータ:**
- `<T>` - 検索対象のハンドラ型
- `data` - このハンドラに対する入力オブジェクト
- `targetType` - 検索対象のハンドラ型
- `stopType` - このタイプのハンドラよりも後続にあるハンドラを検索対象から除外する。

**戻り値:**
検索結果

---

### copy

```java
public final ExecutionContext copy()
```

自身の複製を返す。
<p/>
複製処理の本体は{@link ExecutionContext#copyInternal()}に委譲している。

**戻り値:**
自身の複製。

---

### copyInternal

```java
protected ExecutionContext copyInternal()
```

自身の複製を返す。
<p/>
当メソッドが返すインスタンスはレシーバと同じ型でなければいけない。<br/>
つまりobj.getClass() == obj.copy().getClass()がtrueでなければいけない。当メソッドをサブクラスでオーバーライドする場合はこの制約に注意して実装すること。

**戻り値:**
自身の複製。

---

### readNextData

```java
public TData readNextData()
```

この実行コンテキスト上のデータリーダを使用して、次のデータを読み込む。

**パラメータ:**
- `<TData>` - データリーダが読み込むデータの型

**戻り値:**
読み込んだデータ

---

### getLastReadData

```java
public TData getLastReadData()
```

この実行コンテキストが最後に読み込んだデータオブジェクトを返す。

**パラメータ:**
- `<TData>` - データオブジェクトの型

**戻り値:**
この実行コンテキストが最後に読み込んだデータオブジェクト

---

### clearLastReadData

```java
public void clearLastReadData()
```

この実行コンテキストが最後に読み込んだデータオブジェクトをクリアする。

---

### putDataOnException

```java
public void putDataOnException(Throwable e, Object data)
```

例外に関連するデータを追加する。
<p/>
指定された例外およびデータはリクエストスコープに保持する。

**パラメータ:**
- `e` - 例外
- `data` - 例外に関連するデータ

---

### getDataProcessedWhenThrown

```java
public Object getDataProcessedWhenThrown(Throwable e)
```

指定した例外を送出したスレッドが、例外発生時に処理していた入力データを返す。

**パラメータ:**
- `e` - 例外

**戻り値:**
指定した例外を送出したスレッドが例外発生時に処理していた入力データ。存在しない場合はnull

---

### getDataProcessedWhenThrownMap

```java
private Map<Throwable,Object> getDataProcessedWhenThrownMap()
```

例外を送出したスレッドが例外発生時に処理していた入力データを格納したマップをリクエストスコープから取得する。
<p/>
存在しない場合はマップを新規に作成しリクエストスコープに追加する。

**戻り値:**
例外を送出したスレッドが例外発生時に処理していた入力データを格納したマップ

---

### hasNextData

```java
public boolean hasNextData()
```

この実行コンテキスト上のデータリーダから次に読み出すことができるデータが残っているかどうか。

**戻り値:**
次に読み出すデータが存在する場合は{@code true}

---

### getDataReader

```java
public DataReader<TData> getDataReader()
```

データリーダを取得する。
<p/>
データリーダが設定されていない場合は、
データリーダファクトリを使用してリーダを生成し、その結果を返す。
ファクトリも設定されていない場合はnullを返す。

**パラメータ:**
- `<TData>` - データリーダが読み込むデータ型

**戻り値:**
データリーダ

---

### setDataReader

```java
public ExecutionContext setDataReader(DataReader<TData> reader)
```

データリーダを設定する。

**パラメータ:**
- `<TData>` - データリーダが読み込むデータ型
- `reader` - データリーダ

**戻り値:**
このオブジェクト自体

---

### setDataReaderFactory

```java
public ExecutionContext setDataReaderFactory(DataReaderFactory<TData> factory)
```

データリーダのファクトリを設定する。

**パラメータ:**
- `<TData>` - ファクトリが生成するデータリーダが読み込むデータ型
- `factory` - 設定するデータリーダファクトリ

**戻り値:**
このオブジェクト自体

---

### closeReader

```java
public ExecutionContext closeReader()
```

現在使用しているデータリーダを閉じる。
<p/>
リーダを閉じる際に例外が発生した場合は、ワーニングログを出力し、
処理を継続する。

**戻り値:**
このオブジェクト自体

---

### getException

```java
public Throwable getException()
```

リクエストスコープから例外を取得する。
<p/>
{@link #THROWN_EXCEPTION_KEY}キーを使用する。

**戻り値:**
例外。リクエストスコープに例外が設定されていない場合はnull

---

### getApplicationException

```java
public ApplicationException getApplicationException()
```

リクエストスコープから{@link ApplicationException}を取得する。
<p/>
{@link #THROWN_APPLICATION_EXCEPTION_KEY}キーを使用する。

**戻り値:**
{@link ApplicationException}。
         リクエストスコープに{@link ApplicationException}が設定されていない場合はnull

---

### setException

```java
public void setException(Throwable e)
```

リクエストスコープに例外を設定する。
<p/>
{@link #THROWN_EXCEPTION_KEY}キーに例外を設定する。
さらに、例外が{@link ApplicationException}の場合は、
{@link #THROWN_APPLICATION_EXCEPTION_KEY}キーにも設定する。

**パラメータ:**
- `e` - 例外

---

### isProcessSucceeded

```java
public boolean isProcessSucceeded()
```

処理が正常終了したかどうかを取得する。

**戻り値:**
正常終了した場合{@code true}

---

### setCurrentRequestObject

```java
public void setCurrentRequestObject(Object currentRequestObject)
```

現在処理中のリクエストオブジェクトを設定する。

**パラメータ:**
- `currentRequestObject` - 現在処理中のリクエストオブジェクト

---

### getCurrentRequestObject

```java
public Object getCurrentRequestObject()
```

現在処理中のリクエストオブジェクトを取得する。
<p/>
本メソッドは、{@ref InboundHandleable}または{@ref OutboundHandleable}の処理中にリクエストオブジェクトを取得する際に使用する。

**戻り値:**
現在処理中のリクエストオブジェクト

---

### setProcessSucceeded

```java
public void setProcessSucceeded(boolean processSucceeded)
```

処理が正常終了したかどうかを設定する。

**パラメータ:**
- `processSucceeded` - 正常終了の場合{@code true}

---

### setRequestScopeMap

```java
public ExecutionContext setRequestScopeMap(Map<String,Object> m)
```

リクエストスコープを設定する。

**パラメータ:**
- `m` - リクエストスコープ上の変数を格納するMap

**戻り値:**
このオブジェクト自体

---

### getRequestScopeMap

```java
public Map<String,Object> getRequestScopeMap()
```

リクエストスコープ上の変数を格納したMapオブジェクトへの参照を返す。
<p/>
このMapへの変更はリクエストスコープに直接反映される。

**戻り値:**
リクエストスコープへの参照

---

### getRequestScopedVar

```java
public T getRequestScopedVar(String varName)
                      throws ClassCastException
```

リクエストスコープ上の変数の値を取得する。

**パラメータ:**
- `<T>` - 期待する変数の型
- `varName` - 変数名

**戻り値:**
変数の値

**例外:**
- `ClassCastException` - 実際の変数の型が期待する変数の型と適合しなかった場合。

---

### setRequestScopedVar

```java
public ExecutionContext setRequestScopedVar(String varName, Object varValue)
```

リクエストスコープ上の変数の値を設定する。
<p/>
既に定義済みの変数は上書きされる。

**パラメータ:**
- `varName` - 変数名
- `varValue` - 変数の値

**戻り値:**
このオブジェクト自体

---

### setSessionStoreMap

```java
public ExecutionContext setSessionStoreMap(Map<String,Object> m)
```

セッションストア上の変数を格納したMapを設定する。

**パラメータ:**
- `m` - セッションストア上の変数を格納したMap

**戻り値:**
このオブジェクト自体

---

### getSessionStoreMap

```java
public Map<String,Object> getSessionStoreMap()
```

セッションストア情報を格納したMapオブジェクトへの参照を返す。
<p/>
このMapへの変更はセッションストアに直接反映される。

**戻り値:**
セッションストアへの参照

---

### getSessionStoredVar

```java
public T getSessionStoredVar(String varName)
                      throws ClassCastException
```

セッションストア上の変数の値を取得する。

**パラメータ:**
- `<T>` - 期待する変数の型
- `varName` - 変数名

**戻り値:**
変数の値

**例外:**
- `ClassCastException` - 実際の変数の型が期待する変数の型と適合しなかった場合。

---

### setSessionStoredVar

```java
public ExecutionContext setSessionStoredVar(String varName, Object varValue)
```

セッションストア上の変数の値を設定する。
<p/>
既に定義済みの変数は上書きされる。

**パラメータ:**
- `varName` - 変数名
- `varValue` - 変数の値

**戻り値:**
このオブジェクト自体

---

### setSessionScopeMap

```java
public ExecutionContext setSessionScopeMap(Map<String,Object> m)
```

セッションスコープ上の変数を格納したMapを設定する。

**パラメータ:**
- `m` - リクエストスコープ上の変数を格納したMap

**戻り値:**
このオブジェクト自体

---

### getSessionScopeMap

```java
public Map<String,Object> getSessionScopeMap()
```

セッションスコープ情報を格納したMapオブジェクトへの参照を返す。
<p/>
このMapへの変更はセッションスコープに直接反映される。

**戻り値:**
セッションスコープへの参照

---

### getSessionScopedVar

```java
public T getSessionScopedVar(String varName)
                      throws ClassCastException
```

セッションスコープ上の変数の値を取得する。

**パラメータ:**
- `<T>` - 期待する変数の型
- `varName` - 変数名

**戻り値:**
変数の値

**例外:**
- `ClassCastException` - 実際の変数の型が期待する変数の型と適合しなかった場合。

---

### setSessionScopedVar

```java
public ExecutionContext setSessionScopedVar(String varName, Object varValue)
```

セッションスコープ上の変数の値を設定する。
<p/>
既に定義済みの変数は上書きされる。

**パラメータ:**
- `varName` - 変数名
- `varValue` - 変数の値

**戻り値:**
このオブジェクト自体

---

### invalidateSession

```java
public ExecutionContext invalidateSession()
```

現在のリクエストに紐付けられたセッションスコープを無効化する。

**戻り値:**
このオブジェクト自体

---

### isNewSession

```java
public boolean isNewSession()
```

新規セッションであるかどうか。

**戻り値:**
新規セッションである場合は{@code true}

---

### hasSession

```java
public boolean hasSession()
```

セッションがあるかどうか。

**戻り値:**
セッションがある場合[@code true}

---

### setLastRecordNumber

```java
public void setLastRecordNumber(int lastRecordNumber)
```

データリーダが、現時点で物理的に読み込んでいるレコードのレコード番号を設定する。

**パラメータ:**
- `lastRecordNumber` - 現時点で物理的に読み込んでいるレコードのレコード番号

---

### getLastRecordNumber

```java
public int getLastRecordNumber()
```

データリーダが、現時点で物理的に読み込んでいるレコードのレコード番号を返却する。
<p/>
本メソッドは、{@link nablarch.fw.reader.FileDataReader}を使用してファイルを読み込んでいる場合にのみ値を返却する。
FileDataReader以外を使用している場合は0を返す。

**戻り値:**
現時点で物理的に読み込んでいるレコードのレコード番号

---
