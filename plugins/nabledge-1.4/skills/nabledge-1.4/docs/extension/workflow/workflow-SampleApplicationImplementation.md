# ワークフローライブラリの基本的な使用方法

## ワークフローの開始

`WorkflowManager#startInstance(workflowId)` を呼び出してワークフローを開始する。返された `WorkflowInstance` を使って各タスクへの担当者/グループ割り当てを行う。

> **注意**: ワークフロー開始時に採番されるインスタンスIDは、以降のリクエストでワークフローインスタンスを取得できるよう、業務データのテーブルに格納すること。

**クラス**: `WorkflowManager`, `WorkflowInstance`

```java
// ワークフローを開始する
WorkflowInstance workflow = WorkflowManager.startInstance(TRANS_EXPENSE_APPLICATION_WORKFLOW_ID);

// 各タスクに担当ユーザを割り当てる
workflow.assignUser(CONFIRMATION_TASK, confirmUserId);
workflow.assignUser(AUTHORIZATION_TASK, authorizeUserId);
workflow.assignUser(REAPPLICATION_TASK, ThreadContext.getUserId());

// 業務データにインスタンスIDを格納する
entity.setWfInstanceId(workflow.getInstanceId());
```

<details>
<summary>keywords</summary>

WorkflowManager, WorkflowInstance, startInstance, assignUser, assignGroup, getInstanceId, ワークフロー開始, インスタンスID格納, 担当者割り当て

</details>

## ワークフローの進行

`WorkflowInstance#completeUserTask` または `WorkflowInstance#completeGroupTask` を呼び出してワークフローを進行させる。進行後に処理履歴の追加や業務データのステータス更新を行う。

> **注意**: ワークフロー進行後にそのワークフローが完了する場合にも、追加の処理は不要。

XORゲートウェイを通過する場合は `completeUserTask` に `Map<String, Object>` 型のパラメータを渡す必要がある。パラメータのキーと値はワークフロー定義ファイルのフロー進行条件に対応させる。

**クラス**: `WorkflowManager`, `WorkflowInstance`

```java
// ワークフローインスタンスを取得し、パラメータを渡してタスクを完了する
Map<String, Object> parameter = new HashMap<String, Object>();
parameter.put("condition", FORWARD_CONDITION);
WorkflowManager.findInstance(application.getString("WF_INSTANCE_ID")).completeUserTask(parameter);

// 業務データのステータスを更新
applicationEntity.setTransExpeAppliStatusCd(CONFIRM_COMPLETE);
updateApplicationStatus(applicationEntity);

// 処理履歴の追加
historyEntity.setTransExpeAppliActionCd(CONFIRM);
historyEntity.setTransExpeAppliResultCd(FORWARD_RESULT);
registerHistory(historyEntity);
```

<details>
<summary>keywords</summary>

WorkflowManager, WorkflowInstance, completeUserTask, completeGroupTask, findInstance, ワークフロー進行, XORゲートウェイ, フロー進行条件

</details>

## 境界イベントの実行

`WorkflowInstance#triggerEvent(triggerId)` を呼び出すことで境界イベントを実行する。呼び出すAPI以外は「ワークフローの進行」セクションと同様。

**クラス**: `WorkflowManager`, `WorkflowInstance`

```java
// 境界イベントを実行する
WorkflowManager.findInstance(application.getString("WF_INSTANCE_ID")).triggerEvent(CANCEL_TRIGGER);

// ワークアイテムの更新
applicationEntity.setTransExpeAppliStatusCd(CONFIRM_CANCEL);
updateApplicationStatus(applicationEntity);

// 履歴情報の登録
historyEntity.setTransExpeAppliActionCd(CANCEL);
historyEntity.setTransExpeAppliResultCd(FORWARD_RESULT);
registerHistory(historyEntity);
```

<details>
<summary>keywords</summary>

WorkflowManager, WorkflowInstance, triggerEvent, findInstance, 境界イベント, 引き戻し

</details>

## ワークフローの検索

ワークフローの検索は、`WF_ACTIVE_USER_TASK`（ユーザ割り当て済みアクティブタスク）や `WF_ACTIVE_GROUP_TASK`（グループ割り当て済みアクティブタスク）テーブルに対して通常のSQL検索を実装する。業務テーブルとアクティブタスクを `WF_INSTANCE_ID = ACTIVE_TASK.INSTANCE_ID` で INNER JOIN することで、アクティブなワークフロータスクに絞り込む。

```sql
-- 進行可能申請一覧検索用SQL
WITH
    ACTIVE_TASK AS
    (
    SELECT  -- アクティブユーザタスク
        WF_ACTIVE_USER_TASK.INSTANCE_ID,
        WF_ACTIVE_USER_TASK.FLOW_NODE_ID
    FROM WF_ACTIVE_USER_TASK
    WHERE WF_ACTIVE_USER_TASK.ASSIGNED_USER_ID = :loginUserId
    UNION ALL
    SELECT  -- アクティブグループタスク
        WF_ACTIVE_GROUP_TASK.INSTANCE_ID,
        WF_ACTIVE_GROUP_TASK.FLOW_NODE_ID
    FROM WF_ACTIVE_GROUP_TASK
    WHERE WF_ACTIVE_GROUP_TASK.ASSIGNED_GROUP_ID = :ugroupId
    )
SELECT
    WORK_ITEM.BUSINESS_TYPE,
    WORK_ITEM.APPLICATION_ID,
    WORK_ITEM.APPLICATION_DATE,
    USERS.KANJI_NAME APPLICATION_USER_NAME,
    WORK_ITEM.STATUS_CD
FROM
    (
    SELECT  -- 交通費申請
        TRANS_EXPE_APPLICATION.WF_INSTANCE_ID,
        '2' BUSINESS_TYPE,
        TRANS_EXPE_APPLICATION.TRANS_EXPE_APPLI_ID APPLICATION_ID,
        TRANS_EXPE_APPLICATION.INSERT_DATE_TIME APPLICATION_DATE,
        TRANS_EXPE_APPLICATION.INSERT_USER_ID APPLICATION_USER_ID,
        TRANS_EXPE_APPLICATION.TRANS_EXPE_APPLI_STATUS_CD STATUS_CD
    FROM
        TRANS_EXPE_APPLICATION
    INNER JOIN
        ACTIVE_TASK
    ON
        TRANS_EXPE_APPLICATION.WF_INSTANCE_ID = ACTIVE_TASK.INSTANCE_ID
    UNION ALL
    SELECT  -- ローン申請
        LOAN_APPLICATION.WF_INSTANCE_ID,
        '1',
        LOAN_APPLICATION.LOAN_APPLI_ID,
        LOAN_APPLICATION.INSERT_DATE_TIME,
        LOAN_APPLICATION.INSERT_USER_ID,
        LOAN_APPLICATION.LOAN_APPLI_STATUS_CD
    FROM
        LOAN_APPLICATION
    INNER JOIN
        ACTIVE_TASK
    ON
        LOAN_APPLICATION.WF_INSTANCE_ID = ACTIVE_TASK.INSTANCE_ID
    ) WORK_ITEM
INNER JOIN USERS ON WORK_ITEM.APPLICATION_USER_ID = USERS.USER_ID
WHERE
    $if(businessType) {WORK_ITEM.BUSINESS_TYPE = :businessType}
    AND $if(applicationUserId) {WORK_ITEM.APPLICATION_USER_ID = :applicationUserId}
```

<details>
<summary>keywords</summary>

WF_ACTIVE_USER_TASK, WF_ACTIVE_GROUP_TASK, ワークフロー検索, アクティブタスク検索, UNION ALL, INNER JOIN, WF_INSTANCE_ID

</details>

## 排他制御についての注意事項

> **重要**: ワークフローインスタンスの状態を変更する場合には、**必ず**業務データで排他制御を行う必要がある。

排他制御が必要なAPI:
- ワークフローの進行: `WorkflowInstance#completeUserTask`, `WorkflowInstance#completeGroupTask`
- 境界イベントによる進行: `WorkflowInstance#triggerEvent`
- ユーザ/グループの割り当て: `WorkflowInstance#assignUser`, `WorkflowInstance#assignGroup`
- 割り当て済みの変更: `WorkflowInstance#changeAssignedUser`, `WorkflowInstance#changeAssignedGroup`

排他制御の実装方法は通常の画面オンライン処理と同じ。

**クラス**: `HttpExclusiveControlUtil`

画面表示時（排他制御開始）:
```java
// 排他制御開始
HttpExclusiveControlUtil.prepareVersion(context,
        new ExclusiveCtrlTransExpeApplicationContext(applicationId));
```

処理実行時（排他チェック）:
```java
// 排他制御チェック（OptimisticLockException が発生した場合は @OnError でハンドリング）
HttpExclusiveControlUtil.updateVersionsWithCheck(request);
```

<details>
<summary>keywords</summary>

WorkflowInstance, completeUserTask, completeGroupTask, triggerEvent, assignUser, assignGroup, changeAssignedUser, changeAssignedGroup, HttpExclusiveControlUtil, OptimisticLockException, 排他制御, ワークフロー排他制御

</details>
