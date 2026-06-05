# class RequestThreadLoopHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class RequestThreadLoopHandler
implements Handler<Object,Object>
```

各サブスレッド上のループ毎にリクエスト処理を実行するハンドラ。
<p/>
本クラスは、サーバソケットや受信電文キュー等を監視し、リアルタイム応答を行う
サーバ型プロセスで使用するハンドラである。
サーバ型プロセスでは、マルチスレッドハンドラが生成する各サブスレッド上で
次のループを繰り返す。
<div><b>
データリーダによるリクエストの受信 → リクエスト処理の実行 → 次のリクエストの待機
</b></div>
本ハンドラではこの形態のループ制御を行う。
サーバ型処理では、バッチ処理とは異なり、個々のリクエスト処理は完全に独立しており、
1つのリクエスト処理がエラーとなっても他のリクエスト処理はそのまま継続しなければならない。
このため、本ハンドラで捕捉した例外は、プロセス正常停止要求や致命的な一部の例外を除き
リトライ可能例外{@link RetryableException}として再送出する。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### serviceUnavailabilityRetryInterval

```java
private int serviceUnavailabilityRetryInterval
```

後続ハンドラから閉局中例外が送出された場合、
このスレッドが次のリクエスト処理を開始するまでに待機する時間。

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public Result handle(Object data, ExecutionContext ctx)
```

{@inheritDoc}

---

### setServiceUnavailabilityRetryInterval

```java
public RequestThreadLoopHandler setServiceUnavailabilityRetryInterval(int msec)
```

後続ハンドラから閉局中例外が送出された場合に、次のリクエスト処理を開始するまでに待機する時間を設定する。
設定値が0以下の場合は、待機せずに即時リトライを行なう。
デフォルトの設定値は1000msecである。

**パラメータ:**
- `msec` - 閉局エラー中の各スレッド待機時間 (単位: msec)

**戻り値:**
このオブジェクト自体

---
