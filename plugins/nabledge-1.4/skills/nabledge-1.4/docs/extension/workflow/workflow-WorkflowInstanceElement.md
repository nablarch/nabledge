# ワークフローインスタンス

## ワークフローインスタンス概要

ワークフローインスタンスの情報として、「ワークフローに含まれているタスクに割り当てられている担当ユーザ/担当グループ」と「現在処理可能なタスク」の2つを管理する。

<details>
<summary>keywords</summary>

ワークフローインスタンス管理, 担当ユーザ管理, 担当グループ管理, タスク割り当て, アクティブフローノード

</details>

## タスク担当ユーザ/タスク担当グループ

ワークフローに含まれる各タスクに割り当てられているユーザ/グループ。

- [workflow_element_task](workflow-WorkflowProcessElement.md) には単一の担当ユーザ/グループのみ割り当て可能
- [workflow_element_multi_instance_task](workflow-WorkflowProcessElement.md) には複数の担当ユーザ/グループを割り当て可能

> **重要**: 一つのタスクには、ユーザもしくはグループのどちらか片方しか割り当てることはできない。[workflow_element_multi_instance_task](workflow-WorkflowProcessElement.md) であっても、一部を担当ユーザ・残りを担当グループに割り当てることは不可。

タスクが [workflow_complete_task](workflow-WorkflowApplicationApi.md) によって終了しても担当情報は削除されない。再度そのタスクが [workflow_active_flow_node](#s2) となった際には、以前の担当ユーザ/グループの [workflow_active_task](#s3) が作成される。

<details>
<summary>keywords</summary>

タスク担当ユーザ, タスク担当グループ, マルチインスタンスタスク, タスク割り当て制約, ユーザグループ排他割り当て不可, workflow_task_assignee, workflow_complete_task

</details>

## アクティブフローノード

ワークフローインスタンスで現在処理可能となっているフローノード。

- 通常は [workflow_element_task](workflow-WorkflowProcessElement.md) または [workflow_element_multi_instance_task](workflow-WorkflowProcessElement.md) がアクティブフローノードとなる
- ワークフローが完了した場合は [workflow_element_event_terminate](workflow-WorkflowProcessElement.md) がアクティブフローノードとなる

ワークフローの進行状況は、このアクティブフローノードの変化によって管理される。

<details>
<summary>keywords</summary>

アクティブフローノード, ワークフロー進行状況, 終了イベント, workflow_active_flow_node, 処理可能フローノード

</details>

## アクティブユーザタスク/アクティブグループタスク

ワークフローインスタンスで現在ユーザ/グループが処理可能なタスク。現在のアクティブフローノードに割り当てられている担当ユーザ/グループのタスクが登録されている。

<details>
<summary>keywords</summary>

アクティブユーザタスク, アクティブグループタスク, 処理可能タスク, workflow_active_task

</details>
