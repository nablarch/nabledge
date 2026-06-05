# interface CompletionCondition

**パッケージ:** nablarch.integration.workflow.condition

---

```java
public interface CompletionCondition
```

マルチインスタンスタスクの終了判定を行うインタフェース。

**作成者:** hisaaki sioiri  
**導入バージョン:** 1.4.2  

---

## メソッドの詳細

### isCompletedUserTask

```java
boolean isCompletedUserTask(Map<String,?> param, String instanceId, Task task)
```

ユーザタスクの終了判定を行う。

**パラメータ:**
- `param` - パラメータ
- `instanceId` - インスタンスID
- `task` - タスク

**戻り値:**
終了条件と一致した場合はtrue

---

### isCompletedGroupTask

```java
boolean isCompletedGroupTask(Map<String,?> param, String instanceId, Task task)
```

グループタスクの終了判定を行う。

**パラメータ:**
- `param` - パラメータ
- `instanceId` - インスタンスID
- `task` - タスク

**戻り値:**
終了条件と一致した場合はtrue

---
