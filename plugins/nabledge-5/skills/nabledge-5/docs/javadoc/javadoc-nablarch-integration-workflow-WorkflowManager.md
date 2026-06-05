# class WorkflowManager

**パッケージ:** nablarch.integration.workflow

---

```java
public final class WorkflowManager
```

ワークフローの管理を行うクラス。

**作成者:** Ryo Tanaka  
**導入バージョン:** 1.4.2  

---

## コンストラクタの詳細

### WorkflowManager

```java
private WorkflowManager()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### startInstance

```java
public static WorkflowInstance startInstance(String workflowId)
                               throws IllegalArgumentException
```

指定されたワークフローIDのワークフローを開始する。

**パラメータ:**
- `workflowId` - 新規に開始するワークフローのワークフローID

**戻り値:**
開始されたワークフローのインスタンスをあらわす {@link WorkflowInstance}

**例外:**
- `IllegalArgumentException` - 指定されたワークフローIDに対応するワークフロー定義が存在しない場合。

---

### startInstance

```java
public static WorkflowInstance startInstance(String workflowId, Map<String,?> parameter)
                               throws IllegalArgumentException
```

指定されたワークフローIDのワークフローを開始する。

**パラメータ:**
- `workflowId` - 新規に開始するワークフローのワークフローID
- `parameter` - 開始イベントから、次のタスクまでワークフローを進行させる際に、各フローノードで使用するパラメータ

**戻り値:**
開始されたワークフローのインスタンスをあらわす {@link WorkflowInstance}

**例外:**
- `IllegalArgumentException` - 指定されたワークフローIDに対応するワークフロー定義が存在しない場合。

---

### findInstance

```java
public static WorkflowInstance findInstance(String instanceId)
```

すでに開始されているワークフローのインスタンスを取得する。

**パラメータ:**
- `instanceId` - 取得するワークフローインスタンスのインスタンスID

**戻り値:**
取得されたワークフローインスタンス

---

### getCurrentVersion

```java
public static int getCurrentVersion(String workflowId)
                      throws IllegalArgumentException
```

指定されたワークフローIDのワークフロー定義で、現在有効なバージョンを取得する。

**パラメータ:**
- `workflowId` - ワークフローID

**戻り値:**
現在有効なバージョン

**例外:**
- `IllegalArgumentException` - 指定されたワークフローIDが存在しない場合。

---

### getWorkflowInstanceFactory

```java
private static WorkflowInstanceFactory getWorkflowInstanceFactory()
```

ワークフローインスタンスのファクトリクラスを取得する。

**戻り値:**
ワークフローインスタンスのファクトリクラス

---
