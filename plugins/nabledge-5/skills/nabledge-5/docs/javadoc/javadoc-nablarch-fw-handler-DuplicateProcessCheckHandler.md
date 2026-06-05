# class DuplicateProcessCheckHandler

**パッケージ:** nablarch.fw.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class DuplicateProcessCheckHandler
implements Handler<Object,Object>
```

プロセスの２重起動をチェックするハンドラ。
<p/>
<p/>
プロセスの２重起動チェックは、{@link DuplicateProcessChecker}にて行う。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### exitCode

```java
private int exitCode
```

終了コード

---

### duplicateProcessChecker

```java
private DuplicateProcessChecker duplicateProcessChecker
```

プロセス２重起動チェックを行うクラス

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
public Object handle(Object o, ExecutionContext context)
```

{@inheritDoc}
<p/>
プロセス（リクエスト）が２重起動でないことをチェックする。
２重起動の場合には、例外を送出し処理を終了する。

---

### inactive

```java
private void inactive(boolean throwException)
```

プロセスの非アクティブ化を行う。

非アクティブ化処理中に例外が発生し、かつ呼び出し元で例外が発生していない場合
{@link RuntimeException}を送出する。

**パラメータ:**
- `throwException` - 呼び出し元で例外が発生しているか否か

---

### setExitCode

```java
public void setExitCode(int exitCode)
```

終了コードを設定する。

**パラメータ:**
- `exitCode` - 終了コード

---

### setDuplicateProcessChecker

```java
public void setDuplicateProcessChecker(DuplicateProcessChecker duplicateProcessChecker)
```

プロセス２重起動チェックを行うクラスを設定する。

**パラメータ:**
- `duplicateProcessChecker` - プロセス２重起動チェックを行うクラス。

---
