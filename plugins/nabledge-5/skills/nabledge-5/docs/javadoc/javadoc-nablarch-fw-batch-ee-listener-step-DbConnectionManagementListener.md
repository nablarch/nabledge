# class DbConnectionManagementListener

**パッケージ:** nablarch.fw.batch.ee.listener.step

**継承階層:**
```
java.lang.Object
  └─ AbstractNablarchStepListener
      └─ nablarch.fw.batch.ee.listener.step.DbConnectionManagementListener
```

---

```java
public class DbConnectionManagementListener
extends AbstractNablarchStepListener
```

バッチ処理で必要となるデータベース接続をスレッドローカル上で管理する{@link javax.batch.api.listener.StepListener}実装クラス。
<p/>

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### dbConnectionManagementHandler

```java
private DbConnectionManagementHandler dbConnectionManagementHandler
```

データベース接続ハンドラ

---

## メソッドの詳細

### setDbConnectionManagementHandler

```java
public void setDbConnectionManagementHandler(DbConnectionManagementHandler dbConnectionManagementHandler)
```

データベース接続ハンドラを設定する。

**パラメータ:**
- `dbConnectionManagementHandler` - データベース接続ハンドラ

---

### beforeStep

```java
public void beforeStep(NablarchListenerContext context)
```

{@link DbConnectionManagementHandler}を使用してデータベース接続を{@link nablarch.core.db.connection.DbConnectionContext}に登録する。

---

### afterStep

```java
public void afterStep(NablarchListenerContext context)
```

{@link DbConnectionManagementHandler}を使用してデータベース接続を開放する。

---
