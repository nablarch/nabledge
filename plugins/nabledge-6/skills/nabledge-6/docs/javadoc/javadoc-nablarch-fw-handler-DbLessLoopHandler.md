# class DbLessLoopHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Object,Result>

---

```java
public class DbLessLoopHandler
implements Handler<Object,Result>
```

トランザクション制御をせず処理するループ制御ハンドラークラス。
<p/>
本ハンドラは、アプリケーションが処理すべきデータが存在する間、後続のハンドラに対して繰り返し処理を委譲する。
処理すべきデータが存在するかは、{@link nablarch.fw.ExecutionContext#hasNextData()}により判断する。

**作成者:** Shinya Hijiri  

---

## メソッドの詳細

### handle

```java
public Result handle(Object data, ExecutionContext context)
```

---

### shouldStop

```java
public boolean shouldStop(ExecutionContext context)
```

現在の処理終了後にループを止める場合にtrueを返す。
<p/>
デフォルトの実装では、実行コンテキスト上のデータリーダのデータが
空になるまで繰り返し処理を行う。
<p/>
これと異なる条件でループを停止させたい場合は、本メソッドをオーバライドすること。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
ループを止める場合はtrue

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
