# アクティブタスクの判定と処理の分岐

## タスクがアクティブかどうかの判定

`WorkflowInstance#isActive` でアクティブタスクを判定する。ワークフロー進行後のアクティブタスクや現在のアクティブタスクに応じて処理を分岐する場合、`isActive` の結果に応じて分岐する。

```java
WorkflowInstance workflow = WorkflowManager.findInstance(application.getString("WF_INSTANCE_ID"));

if (workflow.isActive(REAPPLICATION_TASK)) {
    // 再申請タスクがアクティブの場合、再申請用画面に遷移
    setupAssignUserList(context);
    return new HttpResponse("/ss11AD/W11AD0203.jsp");
} else {
    // 確認/承認タスクがアクティブの場合、確認/承認用画面に遷移
    application.put("historyComment", form.getHistoryComment());
    context.setRequestScopedVar("W11AD02", application);
    context.setRequestScopedVar("confirmTask", workflow.isActive(CONFIRMATION_TASK));
    context.setRequestScopedVar("authorizeTask", workflow.isActive(AUTHORIZATION_TASK));
    return new HttpResponse("/ss11AD/W11AD0201.jsp");
}
```

<details>
<summary>keywords</summary>

WorkflowInstance, WorkflowManager, isActive, アクティブタスク判定, 処理分岐, ワークフロー進行

</details>

## 担当ユーザ/グループへのアクティブタスクの割り当て状況の確認

`WorkflowInstance#hasActiveUserTask` / `WorkflowInstance#hasActiveGroupTask` で、ユーザ/グループに割り当てられたアクティブタスクの存在を確認できる。一覧画面から承認画面への遷移時など排他制御を行わない場合、遷移先でアクティブタスクが実際にユーザに割り当てられているか確認が必要。

```java
// アクティブタスク割当精査
if (!workflow.hasActiveUserTask(ThreadContext.getUserId())) {
    throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00034"));
}
```

<details>
<summary>keywords</summary>

WorkflowInstance, WorkflowManager, hasActiveUserTask, hasActiveGroupTask, ThreadContext, ApplicationException, MessageUtil, MessageLevel, アクティブタスク割り当て確認, ユーザタスク確認, グループタスク確認

</details>

## 画面表示項目の切り替え

タスク判定結果をリクエストスコープに格納し、JSPで参照して画面表示項目を切り替える。

業務アクション:
```java
// 確認タスクがアクティブかどうかの判定結果をリクエストスコープに格納
context.setRequestScopedVar("confirmTask", workflow.isActive(CONFIRMATION_TASK));
// 承認タスクがアクティブかどうかの判定結果をリクエストスコープに格納
context.setRequestScopedVar("authorizeTask", workflow.isActive(AUTHORIZATION_TASK));
```

JSP:
```jsp
<c:if test="${confirmTask}">
  <n:set var="pageTitleName" value="交通費申請確認"/>
  <n:set var="forwardButtonName" value="確認"/>
  <n:set var="forwardUri" value="/action/ss11AD/W11AD02Action/RW11AD0202"/>
  <n:set var="rejectUri" value="/action/ss11AD/W11AD02Action/RW11AD0203"/>
  <n:set var="turnDownUri" value="/action/ss11AD/W11AD02Action/RW11AD0204"/>
</c:if>
<c:if test="${authorizeTask}">
  <n:set var="pageTitleName" value="交通費申請承認"/>
  <n:set var="forwardButtonName" value="承認"/>
  <n:set var="forwardUri" value="/action/ss11AD/W11AD02Action/RW11AD0205"/>
  <n:set var="rejectUri" value="/action/ss11AD/W11AD02Action/RW11AD0206"/>
  <n:set var="turnDownUri" value="/action/ss11AD/W11AD02Action/RW11AD0207"/>
</c:if>
```

<details>
<summary>keywords</summary>

WorkflowInstance, isActive, 画面表示切り替え, リクエストスコープ, JSP分岐, setRequestScopedVar

</details>
