# class TransactionAbnormalEnd

**パッケージ:** nablarch.fw.results

**継承階層:**
```
java.lang.Object
  └─ nablarch.fw.results.InternalError
      └─ nablarch.fw.results.TransactionAbnormalEnd
```

---

```java
public class TransactionAbnormalEnd
extends nablarch.fw.results.InternalError
```

業務処理が異常終了したことを示す例外クラス。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### exitCode

```java
private final int exitCode
```

終了コード

---

## コンストラクタの詳細

### TransactionAbnormalEnd

```java
public TransactionAbnormalEnd(int exitCode, String failureCode, Object messageOptions)
```

終了コードとメッセージ（障害コードとオプション）を元に例外を構築する。

**パラメータ:**
- `exitCode` - 終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### TransactionAbnormalEnd

```java
public TransactionAbnormalEnd(int exitCode, Throwable error, String failureCode, Object messageOptions)
```

終了コードとメッセージ（障害コードとオプション）、元例外{@link Throwable}を元に例外を構築する。
<p/>
元例外が存在しない場合は、{@link #TransactionAbnormalEnd(int, String, Object...)} を使用する。

**パラメータ:**
- `exitCode` - 終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)
- `error` - 元例外
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

## メソッドの詳細

### validateExitCode

```java
private static void validateExitCode(int exitCode)
```

設定された終了コードの値のバリデーションを行う。

**パラメータ:**
- `exitCode` - 終了コード

---

### getStatusCode

```java
public int getStatusCode()
```

{@inheritDoc}

**戻り値:**
インスタンス生成時に指定された終了コードを返却する。

---
