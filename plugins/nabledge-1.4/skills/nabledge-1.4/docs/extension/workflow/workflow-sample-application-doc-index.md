# ワークフローアプリケーション実装ガイド

サンプルアプリケーションを例に、ワークフローライブラリを使用したアプリケーションの実装方法を説明する。

> **Note:**
> 本ガイドでは、サンプルアプリケーションが想定するワークフロー定義をBPMNという表記法で定義している。
> 本表記法について知りたい場合、解説書の [ワークフロー定義](../../../workflow/doc/index.html#workflow-definition) を参照すること。

> また、ワークフローインスタンスやフロー定義について知りたい場合、
> 解説書の [ワークフローインスタンスの説明](../../../workflow/doc/09/WorkflowInstanceElement.html) や
> [ワークフロー定義例](../../../workflow/doc/09/WorkflowProcessSample.html) を参照すること。

実装方法の説明に使用するサンプルアプリケーションの概要を以下に示す。

* [サンプルアプリケーション概要](../../extension/workflow/workflow-SampleApplicationDesign.md)

ワークフローライブラリを使用したアプリケーションの基本的な実装方法を以下で説明する。

* [ワークフローライブラリの基本的な使用方法](../../extension/workflow/workflow-SampleApplicationImplementation.md)

ワークフローライブラリを使用するアプリケーションでは、ワークフローで今どのタスクが処理可能（アクティブ）かに応じて、
画面の項目名やボタンなどの表示を切り替える必要がある。以下では、アクティブタスクの判断方法と表示切替の方法について説明する。

* [アクティブタスクの判定と処理の分岐](../../extension/workflow/workflow-SampleApplicationViewImplementation.md)

ゲートウェイの進行先ノードの判定処理やマルチインスタンス・タスクの終了判定処理では、
使用する判定ロジックを任意のロジックに変更できる。
以下では、ゲートウェイの進行先ノード判定ロジックを任意のロジックに変更する方法について説明する。

* [ゲートウェイの進行先ノード判定ロジックを変更する方法](../../extension/workflow/workflow-SampleApplicationExtension.md)
