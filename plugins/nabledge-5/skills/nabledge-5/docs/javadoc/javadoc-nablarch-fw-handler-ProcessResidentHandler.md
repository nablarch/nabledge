# class ProcessResidentHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class ProcessResidentHandler
implements Handler<Object,Object>
```

プロセスを常駐化するためのハンドラ。
<p/>
本ハンドラは、プロセスを常駐化するものであり下記表の条件に従い、
後続処理の呼び出しや処理停止の判断を行う。
<pre>
-----------------------------+----------------------------------------------------------------------
正常に処理を終了する条件     | {@link #setNormalEndExceptions(java.util.List)}で設定した例外が送出された場合(サブクラス含む)
                             |
                             | 設定を省略した場合のデフォルト動作として、{@link ProcessStop}が発生した場合に処理を停止する。
                             | これは、本ハンドラの後続ハンドラに{@link ProcessStopHandler}を設定することにより、
                             | 安全に常駐プロセスを停止することを可能としている。
-----------------------------+----------------------------------------------------------------------
異常終了する条件             | {@link #setAbnormalEndExceptions(java.util.List)}で設定した例外が送出された場合(サブクラス含む)
                             | または、{@link Error}が送出された場合(サブクラス含む)
-----------------------------+----------------------------------------------------------------------
後続ハンドラを呼び出す条件   | 上記に該当しない例外が発生した場合は、障害通知ログを出力後に一定時間待機し、
                             | 再度後続ハンドラに処理を委譲する。
                             | また、例外が発生せずに後続ハンドラが正常に処理を終了した場合も、
                             | 一定時間待機後に再度後続ハンドラに処理を委譲する。
                             |
                             | 待機時間(データ監視間隔)は、{@link #setDataWatchInterval(int)}によって設定した時間(ms)となる。
                             | 設定を省略した場合のデータ監視間隔は1000msとなる。
                             |
                             | なお、本ハンドラはサービス閉塞中例外({@link ServiceUnavailable})が発生した場合は、
                             | 一定時間待機後に後続ハンドラを呼び出す仕様となっている。
                             | このため、本ハンドラの後続ハンドラに{@link nablarch.common.handler.ServiceAvailabilityCheckHandler}を設定することにより、
                             | プロセスが開局されるまで業務処理(バッチアクション)の実行を抑制することが可能となっている。
-----------------------------+----------------------------------------------------------------------
</pre>
以下は、本ハンドラの設定例である。
<p/>
データ監視間隔は、常駐プロセスごとに異なる値を設定する事が想定される。
常駐プロセスごとに異なる値を設定するには、下記例のように設定ファイルを記述し、
常駐プロセス起動時にデータ監視間隔を指定すれば良い。
<pre>
&lt;!-- 常駐化ハンドラの設定 -->
&lt;component class="nablarch.fw.handler.ProcessResidentHandler">
  &lt;!--
  データ監視間隔
  データ監視間隔は、プレースホルダ形式で記述しシステムプロパティの値を埋め込めるようにする。
  -->
  &lt;property name="dataWatchInterval" value="${data-watch-interval}" />
&lt;/component>
</pre>

<pre>
// 常駐プロセス起動時にシステムプロパティ(-Dオプション)にデータ監視間隔を設定する。
// 500msを設定する場合の例
java -Ddata-watch-interval=500 ・・・
</pre>

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー。

---

### dataWatchInterval

```java
private int dataWatchInterval
```

データの監視間隔。

---

### normalEndExceptions

```java
private final List<Class<? extends RuntimeException>> normalEndExceptions
```

正常にプロセスを停止する例外のリスト。

---

### abnormalEndExceptions

```java
private final List<Class<? extends RuntimeException>> abnormalEndExceptions
```

プロセスを異常終了させる例外のリスト。

---

## メソッドの詳細

### handle

```java
public Object handle(Object data, ExecutionContext context)
```

{@inheritDoc}

---

### isProcessAbnormalEnd

```java
private boolean isProcessAbnormalEnd(RuntimeException runtimeException)
```

プロセスを異常終了させるか否か。

**パラメータ:**
- `runtimeException` - エラー情報

**戻り値:**
処理を異常終了させる場合はtrue

---

### isProcessNormalEnd

```java
private boolean isProcessNormalEnd(RuntimeException runtimeException)
```

正常に処理を終了させるか否か。
<p/>
パラメータで指定された{@link RuntimeException}が、
{@link #setNormalEndExceptions(java.util.List)}で設定された例外クラスの場合
(サブクラス含む)は、処理を正常に終了する。

**パラメータ:**
- `runtimeException` - エラー情報

**戻り値:**
処理を正常に停止させる場合はtrue

---

### setDataWatchInterval

```java
public void setDataWatchInterval(int dataWatchInterval)
```

データ監視間隔(ミリ秒)を設定する。

**パラメータ:**
- `dataWatchInterval` - データ監視間隔(ミリ秒)

---

### setNormalEndExceptions

```java
public void setNormalEndExceptions(List<String> normalEndExceptions)
```

処理を正常に終了させる例外クラスを設定する。

**パラメータ:**
- `normalEndExceptions` - 正常に処理を終了させる例外クラス

---

### setAbnormalEndExceptions

```java
public void setAbnormalEndExceptions(List<String> abnormalEndExceptions)
```

処理を異常終了させる例外クラスを設定する。

**パラメータ:**
- `abnormalEndExceptions` - 異常終了させる例外クラス

---

### restoreHandlerQueue

```java
private ExecutionContext restoreHandlerQueue(ExecutionContext context, List<Handler> snapshot)
```

ハンドラキューの内容を、ループ開始前の状態に戻す。

**パラメータ:**
- `context` - 実行コンテキスト
- `snapshot` - ハンドラキューのスナップショット

**戻り値:**
実行コンテキスト(引数と同じインスタンス)

---
