# interface WorkflowInstance

**パッケージ:** nablarch.integration.workflow

---

```java
public interface WorkflowInstance
```

ワークフローインスタンスをあらわすインタフェース。

**作成者:** Ryo Tanaka  
**導入バージョン:** 1.4.2  

---

## メソッドの詳細

### completeUserTask

```java
void completeUserTask()
                      throws IllegalStateException
```

アクティブユーザタスクを完了させた後、ワークフロー定義に従ってワークフローを進行させ、ワークフローインスタンスのアクティブフローノードを次のタスク
もしくは停止イベントに進行させる。

**例外:**
- `IllegalStateException` - 終了させる対象のアクティブユーザタスクが見つからない場合。

---

### completeUserTask

```java
void completeUserTask(String assigned)
                      throws IllegalStateException
```

アクティブユーザタスクを完了させた後、ワークフロー定義に従ってワークフローを進行させ、ワークフローインスタンスのアクティブフローノードを次のタスク
もしくは停止イベントに進行させる。

**パラメータ:**
- `assigned` - タスクを完了させるユーザ

**例外:**
- `IllegalStateException` - {@code assigned} に対してアクティブユーザタスクが見つからない場合。

---

### completeUserTask

```java
void completeUserTask(Map<String,?> parameter)
                      throws IllegalStateException
```

アクティブユーザタスクを完了させた後、ワークフロー定義に従ってワークフローを進行させ、ワークフローインスタンスのアクティブフローノードを次のタスク
もしくは停止イベントに進行させる。

**パラメータ:**
- `parameter` - ワークフローを進行させる際に、各フローノードで使用するパラメータ

**例外:**
- `IllegalStateException` - 終了させる対象のアクティブユーザタスクが見つからない場合。

---

### completeUserTask

```java
void completeUserTask(Map<String,?> parameter, String assigned)
                      throws IllegalStateException
```

アクティブユーザタスクを完了させた後、ワークフロー定義に従ってワークフローを進行させ、ワークフローインスタンスのアクティブフローノードを次のタスク
もしくは停止イベントに進行させる。

**パラメータ:**
- `parameter` - ワークフローを進行させる際に、各フローノードで使用するパラメータ
- `assigned` - タスクを完了させるユーザ

**例外:**
- `IllegalStateException` - {@code assigned} に対してアクティブユーザタスクが見つからない場合、またはワークフローが既に完了している場合。

---

### completeGroupTask

```java
void completeGroupTask(String assigned)
                       throws IllegalStateException
```

アクティブグループタスクを完了させた後、ワークフロー定義に従ってワークフローを進行させ、ワークフローインスタンスのアクティブフローノードを次のタスク
もしくは停止イベントに進行させる。

**パラメータ:**
- `assigned` - タスクを完了させるグループ

**例外:**
- `IllegalStateException` - {@code assigned} に対してアクティブグループタスクが見つからない場合、またはワークフローが既に完了している場合。

---

### completeGroupTask

```java
void completeGroupTask(Map<String,?> parameter, String assigned)
                       throws IllegalStateException
```

アクティブグループタスクを完了させた後、ワークフロー定義に従ってワークフローを進行させ、ワークフローインスタンスのアクティブフローノードを次のタスク
もしくは停止イベントに進行させる。

**パラメータ:**
- `parameter` - ワークフローを進行させる際に、各フローノードで使用するパラメータ
- `assigned` - タスクを完了させるグループ

**例外:**
- `IllegalStateException` - {@code assigned} に対してアクティブグループタスクが見つからない場合、またはワークフローが既に完了している場合。

---

### triggerEvent

```java
void triggerEvent(String eventTriggerId)
                  throws IllegalStateException
```

アクティブフローノードから、境界イベントトリガーIDに対応する境界イベントを取得し、現在のタスクを中断して、境界イベントから取得される進行先フローノードに
ワークフローを進行させる。

**パラメータ:**
- `eventTriggerId` - 境界イベントトリガーID

**例外:**
- `IllegalStateException` - アクティブフローノードから、境界イベントトリガーIDに対応する境界イベントを取得できなかった場合。

---

### triggerEvent

```java
void triggerEvent(String eventTriggerId, Map<String,?> parameter)
                  throws IllegalStateException
```

アクティブフローノードから、境界イベントトリガーIDに対応する境界イベントを取得し、現在のタスクを中断して、境界イベントから取得される進行先フローノードに
ワークフローを進行させる。

**パラメータ:**
- `eventTriggerId` - 境界イベントトリガーID
- `parameter` - ワークフローを進行させる際に利用するパラメータ

**例外:**
- `IllegalStateException` - アクティブフローノードから、境界イベントトリガーIDに対応する境界イベントを取得できなかった場合。

---

### assignUser

```java
void assignUser(String taskId, String user)
                throws IllegalStateException, IllegalArgumentException
```

タスクに担当ユーザを割り当てる。

**パラメータ:**
- `taskId` - 担当ユーザを割り当てる対象のタスク
- `user` - 担当ユーザ

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - 指定されたタスクが存在しない場合

---

### assignUsers

```java
void assignUsers(String taskId, List<String> users)
                 throws IllegalStateException, IllegalArgumentException
```

タスクに担当ユーザを割り当てる。マルチインスタンスでないタスクに対しては、複数ユーザを割り当てることは出来ない。
<p/>
マルチインスタンスタスクで、シーケンシャルタイプの場合は、指定された担当ユーザの順序がタスクの実行順となる。
すでにタスクに担当ユーザや担当グループが割り当てられている場合、それらの情報はクリアされ、今回設定した担当ユーザのみが有効となる。

**パラメータ:**
- `taskId` - タスクID
- `users` - 担当ユーザリスト

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - 指定されたタスクが存在しない場合、もしくはマルチインスタンスでないタスクに複数ユーザを割り当てようとした場合。

---

### assignGroup

```java
void assignGroup(String taskId, String group)
                 throws IllegalStateException, IllegalArgumentException
```

タスクに担当グループを割り当てる。
<p/>
すでにタスクに担当ユーザや担当グループが割り当てられている場合、それらの情報はクリアされ、今回設定した担当グループ情報のみが有効となる。

**パラメータ:**
- `taskId` - タスクのフローノードID
- `group` - 担当グループ

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - 指定されたタスクが存在しない場合

---

### assignGroups

```java
void assignGroups(String taskId, List<String> groups)
                  throws IllegalStateException, IllegalArgumentException
```

タスクに担当グループを割り当てる。マルチインスタンスでないタスクに対しては、複数グループを割り当てることは出来ない。
<p/>
マルチインスタンスタスクで、シーケンシャルタイプの場合は、指定された担当グループの順序がタスクの実行順となる。
すでにタスクに担当ユーザや担当グループが割り当てられている場合、それらの情報はクリアされ、今回設定した担当ユーザのみが有効となる。

**パラメータ:**
- `taskId` - タスクのフローノードID
- `groups` - 担当グループ

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - 指定されたタスクが存在しない場合、もしくはマルチインスタンスでないタスクに複数グループを割り当てようとした場合。

---

### assignUserToLane

```java
void assignUserToLane(String laneId, String user)
                      throws IllegalStateException, IllegalArgumentException
```

レーンIDで指定されたレーンに属するすべてのタスクに、指定された担当ユーザを割り当てる。

**パラメータ:**
- `laneId` - 担当ユーザを割り当てるタスクが属するレーンのレーンID
- `user` - 担当ユーザ

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - マルチインスタンスでないタスクに複数ユーザを割り当てようとした場合。

---

### assignUsersToLane

```java
void assignUsersToLane(String laneId, List<String> users)
                       throws IllegalStateException, IllegalArgumentException
```

レーンIDで指定されたレーンに属するすべてのタスクに、指定された担当ユーザを割り当てる。

**パラメータ:**
- `laneId` - 担当ユーザを割り当てるタスクが属するレーンのレーンID
- `users` - 担当ユーザリスト

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - マルチインスタンスでないタスクに複数ユーザを割り当てようとした場合。

---

### assignGroupToLane

```java
void assignGroupToLane(String laneId, String group)
                       throws IllegalStateException, IllegalArgumentException
```

レーンIDで指定されたレーンに属するすべてのタスクに、指定された担当グループを割り当てる。

**パラメータ:**
- `laneId` - 担当グループを割り当てるタスクが属するレーンのレーンID
- `group` - 担当グループ

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - マルチインスタンスでないタスクに複数グループを割り当てようとした場合。

---

### assignGroupsToLane

```java
void assignGroupsToLane(String laneId, List<String> groups)
                        throws IllegalStateException, IllegalArgumentException
```

レーンIDで指定されたレーンに属するすべてのタスクに、指定された担当グループを割り当てる。

**パラメータ:**
- `laneId` - 担当ユーザを割り当てるタスクが属するレーンのレーンID
- `groups` - 担当ユーザ

**例外:**
- `IllegalStateException` - ワークフローがすでに完了している場合
- `IllegalArgumentException` - マルチインスタンスでないタスクに複数グループを割り当てようとした場合。

---

### changeAssignedUser

```java
void changeAssignedUser(String taskId, String oldUser, String newUser)
                        throws IllegalArgumentException, IllegalStateException
```

タスクに現在アサインされている担当ユーザを、別の担当ユーザに振り替える。
<p/>
指定されたタスクがアクティブタスクの場合は、アクティブユーザタスクについても振り替えを行う。

**パラメータ:**
- `taskId` - 担当ユーザを振り替えるタスク
- `oldUser` - 振替元の担当ユーザ
- `newUser` - 振替先の担当ユーザ

**例外:**
- `IllegalArgumentException` - 指定されたタスクがワークフロー定義に存在しない場合
- `IllegalStateException` - 指定されたタスクに、振替元の担当ユーザがアサインされていない場合

---

### changeAssignedGroup

```java
void changeAssignedGroup(String taskId, String oldGroup, String newGroup)
                         throws IllegalArgumentException, IllegalStateException
```

タスクに現在アサインされている担当グループを、別の担当グループに振り替える。
<p/>
指定されたタスクがアクティブである場合は、アクティブグループタスクについても振り替えを行う。

**パラメータ:**
- `taskId` - 担当ユーザを振り替えるタスク
- `oldGroup` - 振替元の担当グループ
- `newGroup` - 振替先の担当グループ

**例外:**
- `IllegalArgumentException` - 指定されたタスクがワークフロー定義に存在しない場合
- `IllegalStateException` - 指定されたタスクに、振替元の担当グループがアサインされていない場合

---

### getAssignedUsers

```java
List<String> getAssignedUsers(String taskId)
                              throws IllegalArgumentException
```

タスクに割り当てられた担当ユーザを取得する。
<p/>
担当ユーザは、実行順でソートされて返却される。

**パラメータ:**
- `taskId` - タスクID

**戻り値:**
担当ユーザ

**例外:**
- `IllegalArgumentException` - 指定されたタスクがワークフロー定義に存在しない場合

---

### getAssignedGroups

```java
List<String> getAssignedGroups(String taskId)
                               throws IllegalArgumentException
```

タスクに割り当てられた担当グループを取得する。
<p/>
担当グループは、実行順でソートされて返却される。

**パラメータ:**
- `taskId` - タスクID

**戻り値:**
担当グループ

**例外:**
- `IllegalArgumentException` - 指定されたタスクがワークフロー定義に存在しない場合

---

### hasActiveUserTask

```java
boolean hasActiveUserTask(String user)
```

指定されたユーザのアクティブユーザタスクが存在するかどうかを確認する。

**パラメータ:**
- `user` - ユーザ

**戻り値:**
ユーザのアクティブユーザタスクが存在する場合は {@code true}

---

### hasActiveGroupTask

```java
boolean hasActiveGroupTask(String group)
```

指定されたグループのアクティブグループタスクが存在するかどうかを確認する。

**パラメータ:**
- `group` - グループ

**戻り値:**
グループのアクティブグループタスクが存在する場合は {@code true}

---

### getInstanceId

```java
String getInstanceId()
```

現在のワークフローインスタンスのインスタンスIDを取得する。

**戻り値:**
ワークフローインスタンスのインスタンスID

---

### getWorkflowId

```java
String getWorkflowId()
```

ワークフローIDを取得する。

**戻り値:**
ワークフローID

---

### getVersion

```java
long getVersion()
```

バージョン番号を取得する。

**戻り値:**
バージョン番号

---

### isActive

```java
boolean isActive(String flowNodeId)
```

指定されたフローノードIDがアクティブな状態かどうかを判定する。

**パラメータ:**
- `flowNodeId` - フローノードID

**戻り値:**
アクティブな場合はtrue

---

### isCompleted

```java
boolean isCompleted()
```

ワークフローが完了状態かどうかを判定する。

**戻り値:**
ワークフローが完了している場合は {@code true}

---
