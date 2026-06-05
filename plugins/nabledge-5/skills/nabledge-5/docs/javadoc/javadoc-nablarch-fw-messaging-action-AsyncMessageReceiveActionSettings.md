# class AsyncMessageReceiveActionSettings

**パッケージ:** nablarch.fw.messaging.action

---

```java
public class AsyncMessageReceiveActionSettings
```

{@link AsyncMessageReceiveAction}用設定クラス。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### formClassPackage

```java
private String formClassPackage
```

フォームクラス配置パッケージ

---

### receivedSequenceGenerator

```java
private IdGenerator receivedSequenceGenerator
```

受信電文連番を採番するオブジェクト

---

### receivedSequenceFormatter

```java
private IdFormatter receivedSequenceFormatter
```

受信電文連番を採番する際に使用するフォーマッタ

---

### targetGenerateId

```java
private String targetGenerateId
```

受信電文連番を採番するためのID

---

### dbTransactionName

```java
private String dbTransactionName
```

受信テーブル登録用のトランザクション名

---

### sqlFilePackage

```java
private String sqlFilePackage
```

SQLファイル配置パッケージ

---

### formClassSuffix

```java
private String formClassSuffix
```

Formクラスのサフィックス

---

## メソッドの詳細

### getFormClassPackage

```java
public String getFormClassPackage()
```

Formクラスの配置パッケージを取得する。

**戻り値:**
Formクラスの配置パッケージ

---

### setFormClassPackage

```java
public void setFormClassPackage(String formClassPackage)
```

Formクラスの配置パッケージを設定する。

**パラメータ:**
- `formClassPackage` - Formクラスの配置パッケージ

---

### getReceivedSequenceGenerator

```java
public IdGenerator getReceivedSequenceGenerator()
```

受信電文連番を採番するための{@link IdGenerator}を取得する。

**戻り値:**
{@link IdGenerator}

---

### setReceivedSequenceGenerator

```java
public void setReceivedSequenceGenerator(IdGenerator receivedSequenceGenerator)
```

受信電文連番を採番するための{@link IdGenerator}を設定する。

**パラメータ:**
- `receivedSequenceGenerator` - {@link IdGenerator}

---

### getReceivedSequenceFormatter

```java
public IdFormatter getReceivedSequenceFormatter()
```

受信電文連番を採番する際に使用するフォーマッタを取得する。

**戻り値:**
{@link IdFormatter}

---

### setReceivedSequenceFormatter

```java
public void setReceivedSequenceFormatter(IdFormatter receivedSequenceFormatter)
```

受信電文連番を採番する際に使用するフォーマッタを設定する。

**パラメータ:**
- `receivedSequenceFormatter` - {@link IdFormatter}

---

### getTargetGenerateId

```java
public String getTargetGenerateId()
```

受信電文連番を採番するためのIDを取得する。

**戻り値:**
受信電文連番を採番するためのID

---

### setTargetGenerateId

```java
public void setTargetGenerateId(String targetGenerateId)
```

受信電文連番を採番するためのIDを設定する。
<p/>
設定されたIDは、{@link IdGenerator#generateId(String)}の引数として使用する。

**パラメータ:**
- `targetGenerateId` - 受信電文連番を採番するためのID

---

### getDbTransactionName

```java
public String getDbTransactionName()
```

DBトランザクション名を取得する。

**戻り値:**
DBトランザクション名

---

### setDbTransactionName

```java
public void setDbTransactionName(String dbTransactionName)
```

DBトランザクション名を設定する。
<p/>
本設定を省略した場合、DBトランザクション名は{@link TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY}となる。

**パラメータ:**
- `dbTransactionName` - DBトランザクション名

---

### getSqlFilePackage

```java
public String getSqlFilePackage()
```

SQLファイルの配置パッケージを取得する。

**戻り値:**
SQLファイルの配置パッケージ

---

### setSqlFilePackage

```java
public void setSqlFilePackage(String sqlFilePackage)
```

SQLファイルの配置パッケージを設定する。

**パラメータ:**
- `sqlFilePackage` - SQLファイルの配置パッケージ

---

### getFormClassSuffix

```java
public String getFormClassSuffix()
```

Formクラスのサフィックスを取得する。

**戻り値:**
Formクラスのサフィックス

---

### setFormClassSuffix

```java
public void setFormClassSuffix(String formClassSuffix)
```

Formクラスのサフィックスを設定する。
<p/>
メッセージをテーブルに登録する際に使用するFormクラスのクラス名のサフィックスとして使用する。
本設定を省略した場合、デフォルト値で「Form」が使用される。

**パラメータ:**
- `formClassSuffix` - Formクラスのサフィックス。

---
