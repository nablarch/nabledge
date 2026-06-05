# class DataReadHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Object,Result>

---

```java
public class DataReadHandler
implements Handler<Object,Result>
```

業務コンポーネントで処理するデータを{@link nablarch.fw.DataReader}から読み込む
{@link Handler}実装クラス。
<p/>
{@link nablarch.fw.DataReader}から読み込んだデータをリクエストとして、
後続のハンドラに処理を委譲する。
<br/>
データが存在しない場合(読み込んだデータがnull)の場合は、
後続のハンドラに処理は移譲せずに{@link NoMoreRecord}を返却する。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### readCount

```java
private int readCount
```

データ読み込み回数

---

### maxCount

```java
private int maxCount
```

データ読み込みの上限回数。

---

### executionIdAttribute

```java
private ThreadContextAttribute<Object> executionIdAttribute
```

実行時ID初期化コンポーネント

---

## メソッドの詳細

### handle

```java
public Result handle(Object o, ExecutionContext context)
```

{@inheritDoc}

---

### writeWarnLog

```java
protected void writeWarnLog(Object requestData, Throwable t)
```

ワーニングログを出力する。

**パラメータ:**
- `requestData` - リクエストデータ
- `t` - 例外情報

---

### countUp

```java
private void countUp(ExecutionContext context)
```

データ読み込み回数を計数し、上限を超えていれば、
実行コンテキスト上のリーダを削除する。

**パラメータ:**
- `context` - 実行コンテキスト

---

### setMaxCount

```java
public DataReadHandler setMaxCount(int maxCount)
```

データ読み込みの上限回数を指定する。
<p/>
上限に達した段階で、実行コンテキスト上のreaderを除去する。
それ以降は、ExecutionContext#hanNextData() の結果は常にfalseを返す。
デフォルトの設定値は0 (=無制限)
<p/>
なお、この値に正数を指定している場合は、読み込み回数のカウントアップの際に
同期処理が行われる。

**パラメータ:**
- `maxCount` - データ読み込みの上限回数。
0もしくは負数を設定した場合は無制限。

**戻り値:**
このオブジェクト自体

---

### setExecutionIdAttribute

```java
public DataReadHandler setExecutionIdAttribute(ExecutionIdAttribute attribute)
```

実行時IDを初期化する際に使用する{@see ThreadContextAttribute}を設定する。

**パラメータ:**
- `attribute` - 実行時IDを初期化する{@see ThreadContextAttribute}

**戻り値:**
このオブジェクト自体。executionIdAttribute

---
