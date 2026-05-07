# ワークフローインスタンス

[ワークフローライブラリ](../../extension/workflow/workflow-workflow-doc-index.md) がワークフローインスタンス情報として管理する情報について記載する。

[ワークフローライブラリ](../../extension/workflow/workflow-workflow-doc-index.md) は、ワークフローインスタンスの情報として、大きく分けて
「ワークフローに含まれているタスクに割り当てられている担当ユーザ/担当グループ」と
「現在処理可能なタスク」の2つを管理する。

## タスク担当ユーザ/タスク担当グループ

ワークフローに含まれる各タスクに割り当てられているユーザ/グループをあらわす。

[タスク](../../extension/workflow/workflow-WorkflowProcessElement.md#タスク) の場合には、単一の担当ユーザ/グループのみ割り当てることができ、
[マルチインスタンス・タスク](../../extension/workflow/workflow-WorkflowProcessElement.md#マルチインスタンスタスク) の場合には、複数の担当ユーザ/グループを
割り当てることができる。

ただし、一つのタスクには、ユーザもしくはグループのどちらか片方しか割り当てることはできない。
たとえば、 [マルチインスタンス・タスク](../../extension/workflow/workflow-WorkflowProcessElement.md#マルチインスタンスタスク) で複数の担当を割り当て、その一部を
担当ユーザとし、残りを担当グループに割り当てる、といったことはできない。

タスクが [ワークフローの進行](../../extension/workflow/workflow-WorkflowApplicationApi.md#ワークフローの進行) によって終了したとしても削除されることはなく、
再度そのタスクが [アクティブフローノード](../../extension/workflow/workflow-WorkflowInstanceElement.md#アクティブフローノード) となった際には、以前から割り当てられているユーザ/グループの
[アクティブユーザタスク/アクティブグループタスク](../../extension/workflow/workflow-WorkflowInstanceElement.md#アクティブユーザタスクアクティブグループタスク) が作成される。

## アクティブフローノード

ワークフローインスタンスで、現在処理可能となっているフローノード。

基本的には、 [タスク](../../extension/workflow/workflow-WorkflowProcessElement.md#タスク) 、 [マルチインスタンス・タスク](../../extension/workflow/workflow-WorkflowProcessElement.md#マルチインスタンスタスク) が
アクティブフローノードとなるが、ワークフローが完了した場合には [停止イベント](../../extension/workflow/workflow-WorkflowProcessElement.md#停止イベント) が
アクティブフローノードとなる。

ワークフローの進行状況は、このアクティブフローノードが変化していくことで管理される。

## アクティブユーザタスク/アクティブグループタスク

ワークフローインスタンスで、現在ユーザ/グループが処理可能であるタスク。

現在のアクティブフローノードに割り当てられている担当ユーザ/グループのタスクが登録されている。
