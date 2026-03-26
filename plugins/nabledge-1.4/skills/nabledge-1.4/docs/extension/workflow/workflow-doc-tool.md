# ワークフロー定義データ生成ツール

## 概要

BPMN 2.0準拠のワークフロー定義ファイル（XMLファイル）を読み込み、マスタデータとして投入可能な形式でExcelファイルを出力するツール。

<details>
<summary>keywords</summary>

ワークフロー定義データ生成ツール, BPMN 2.0, ワークフロー定義ファイル, Excelファイル出力, マスタデータ生成

</details>

## 前提

- ワークフロー定義ファイルがワークフロー設計ガイドに従って作成されていること
- ツールが出力するテーブル・カラム名称がワークフローライブラリで使用するテーブル・カラム名称と同一であること

<details>
<summary>keywords</summary>

前提条件, ワークフロー設計ガイド, テーブル・カラム名称, ワークフローライブラリ

</details>

## ツール配置場所

サンプルプロジェクトの `tool/workflowDefinitionGenerator` ディレクトリに配置。

| ファイル/ディレクトリ | 説明 |
|---|---|
| output | 自動生成されるワークフロー定義データの出力ディレクトリ |
| resources | 設定ファイル格納ディレクトリ |
| log | エラー情報出力ファイルの出力ディレクトリ |
| WorkflowDefinitionGenerator_build.xml | Antビルドファイル（通常、変更の必要なし） |
| WorkflowDefinitionGenerator_build.properties | Antビルドファイルのプロパティファイル |

<details>
<summary>keywords</summary>

ツール配置場所, workflowDefinitionGenerator, Antビルドファイル, WorkflowDefinitionGenerator_build.xml, WorkflowDefinitionGenerator_build.properties

</details>

## 利用の準備

設定ファイル:

| ファイル | 説明 |
|---|---|
| WorkflowDefinitionGenerator.config | 環境設定ファイル（出力先ファイルパス、入力ファイル拡張子等） |
| WorkflowDefinitionGenerator.xml | コンポーネント定義ファイル（Reader/Writerクラス設定、省略記法マッピング設定） |

環境設定ファイルのキー:

| キー名 | 設定内容 |
|---|---|
| inputFileDir | ワークフロー定義ファイルのルートディレクトリ。配下ファイルを再帰的に読み込む |
| inputFileExtension | 入力ファイルの拡張子（カンマ区切り）。例：bpmn,xml |
| outputFilePath | 出力ファイルパス。既存ファイルが存在する場合、内容は破棄される |
| logFilePath | エラー情報出力ファイルパス |
| workflowIdColumnLength | ワークフローID桁数（ID体系で定義された桁数。ワークフロー定義ファイル内に定義したIDの桁数指定が正しいか精査を行うための設定値） |
| laneIdColumnLength | レーンID桁数（ID体系で定義された桁数。ワークフロー定義ファイル内に定義したIDの桁数指定が正しいか精査を行うための設定値） |
| flowNodeIdColumnLength | フローノードID桁数（ID体系で定義された桁数。ワークフロー定義ファイル内に定義したIDの桁数指定が正しいか精査を行うための設定値） |
| boundaryEventTriggerIdColumnLength | 境界イベントトリガーID桁数（ID体系で定義された桁数。ワークフロー定義ファイル内に定義したIDの桁数指定が正しいか精査を行うための設定値） |

> **重要**: outputFilePathに既存ファイルを指定した場合、既存の内容は破棄される。出力ファイルにワークフロー定義テーブル以外のデータを設定しないこと。

<details>
<summary>keywords</summary>

環境設定, WorkflowDefinitionGenerator.config, inputFileDir, inputFileExtension, outputFilePath, logFilePath, workflowIdColumnLength, laneIdColumnLength, flowNodeIdColumnLength, boundaryEventTriggerIdColumnLength, コンポーネント定義ファイル

</details>

## 利用手順

実行コマンド:

```bash
ant -f WorkflowDefinitionGenerator_build.xml
```

全ワークフロー定義ファイルを読み込み精査し、正常なファイルのデータを1つのExcelファイルに集約して出力する。出力ファイル名は環境設定ファイルに記載したもの（デフォルト: MASTER_DATA_WF.xls）。

<details>
<summary>keywords</summary>

ant コマンド, MASTER_DATA_WF.xls, ツール実行, WorkflowDefinitionGenerator_build.xml

</details>

## 精査エラー発生時の動作

- 精査エラーが発生したファイルのデータはExcelに出力されない（正常なファイルのみ出力）
- 全ファイルが不正な場合、Excelファイル自体を出力しない
- エラー情報（ファイル名・エラーメッセージ）はエラー情報出力ファイルに出力

出力例:
```
fileName = [WF0001_交通費申請_ver1_20140805.bpmn] フローノードIDの桁数がID体系で定められた桁数と異なります。IDを修正してください。 id = [T00001] name = [確認] （設定値:10 実際:6）
```

<details>
<summary>keywords</summary>

精査エラー, エラー出力, エラー情報ファイル, ワークフロー定義データ出力なし

</details>

## 仕様

ツールがModeler上の以下の要素から値を読み込み、ワークフロー定義データとして出力する:
- プール
- レーン
- ユーザタスク
- XORゲートウェイ
- 開始イベント
- 停止イベント
- 中断メッセージ境界イベント
- シーケンスフロー

<details>
<summary>keywords</summary>

読込対象, BPMN要素, ユーザタスク, XORゲートウェイ, シーケンスフロー, 中断メッセージ境界イベント, プール, レーン

</details>

## ワークフロー定義

ワークフロー定義ファイル名フォーマット: `[ワークフローID]_[ワークフロー名]_ver[バージョン]_[適用日].bpmn`

例: `WF0001_交通費申請_ver1_20140805.bpmn` → ワークフローID: WF0001、バージョン: 1、ワークフロー名: 交通費申請、適用日: 20140805

| 定義 | 内容 |
|---|---|
| ワークフローID | ワークフロー定義ファイル名から取得 |
| バージョン | ワークフロー定義ファイル名から取得 |
| ワークフロー名 | ワークフロー定義ファイル名から取得 |
| 適用日 | ワークフロー定義ファイル名から取得 |

<details>
<summary>keywords</summary>

ワークフロー定義テーブル, ワークフローID, バージョン, ワークフロー名, 適用日, ファイル名フォーマット, bpmn

</details>

## レーン

| 定義 | 内容 |
|---|---|
| ワークフローID | レーンが属しているワークフローID |
| バージョン | レーンが属しているワークフローのバージョン |
| レーンID | Modeler上でレーンの「Id」に指定したID |
| レーン名 | Modeler上でレーンの「Name」に指定した名称 |

<details>
<summary>keywords</summary>

レーンテーブル, レーンID, レーン名, Modeler

</details>

## フローノード

| 定義 | 内容 |
|---|---|
| ワークフローID | フローノードが属しているワークフローID |
| バージョン | フローノードが属しているワークフローのバージョン |
| フローノードID | Modeler上でフローノードの「Id」に指定したID |
| レーンID | フローノードが属しているレーンID |
| フローノード名 | Modeler上でフローノードの「Name」に指定した名称 |

<details>
<summary>keywords</summary>

フローノードテーブル, フローノードID, フローノード名, レーンID

</details>

## シーケンスフロー

| 定義 | 内容 |
|---|---|
| ワークフローID | シーケンスフローが属しているワークフローID |
| バージョン | シーケンスフローが属しているワークフローのバージョン |
| シーケンスフローID | Modeler上でシーケンスフローの「Id」に指定したID |
| 接続元フローノードID | シーケンスフローの接続元フローノードID |
| 接続先フローノードID | シーケンスフローの接続先フローノードID |
| フロー進行条件 | 「Condition」に完全修飾名を指定した場合はその値、省略記法を指定した場合は省略記法に紐付くクラスの完全修飾名 |
| シーケンスフロー名 | Modeler上でシーケンスフローの「Name」に指定した名称 |

<details>
<summary>keywords</summary>

シーケンスフローテーブル, シーケンスフローID, 接続元フローノードID, 接続先フローノードID, フロー進行条件, Condition, シーケンスフロー名

</details>

## 境界イベントトリガー

| 定義 | 内容 |
|---|---|
| ワークフローID | 境界イベントが属しているワークフローID |
| バージョン | 境界イベントが属しているワークフローのバージョン |
| 境界イベントトリガーID | Modeler上で境界イベントの「Messages」に指定した値 |
| 境界イベントトリガー名 | Modeler上で境界イベントの「Messages」に指定した値 |

<details>
<summary>keywords</summary>

境界イベントトリガーテーブル, 境界イベントトリガーID, 境界イベントトリガー名, Messages

</details>

## 境界イベント

| 定義 | 内容 |
|---|---|
| ワークフローID | 境界イベントが属しているワークフローID |
| バージョン | 境界イベントが属しているワークフローのバージョン |
| フローノードID | Modeler上で境界イベントの「Id」に指定したID |
| 境界イベントトリガーID | Modeler上で境界イベントの「Message」に指定した値 |
| 接続先タスクID | 境界イベントが接続しているフローノードID |

<details>
<summary>keywords</summary>

境界イベントテーブル, 境界イベントトリガーID, 接続先タスクID, 中断メッセージ境界イベント

</details>

## タスク

| 定義 | 内容 |
|---|---|
| ワークフローID | タスクが属しているワークフローID |
| バージョン | タスクが属しているワークフローのバージョン |
| フローノードID | Modeler上でアクティビティに指定したID |
| マルチインスタンス種別 | 「Is Sequential」ON → SEQUENTIAL（順次マルチインスタンス）、OFF → PARALLEL（並行マルチインスタンス）、マルチインスタンスでない場合 → NONE |
| 完了条件 | 「Completion condition」に完全修飾名を指定した場合はその値、省略記法の場合は省略記法に紐付くクラスの完全修飾名 |

<details>
<summary>keywords</summary>

タスクテーブル, マルチインスタンス種別, SEQUENTIAL, PARALLEL, NONE, 完了条件, Is Sequential, Completion condition

</details>

## イベント

| 定義 | 内容 |
|---|---|
| ワークフローID | イベントノードが属しているワークフローID |
| バージョン | イベントノードが属しているワークフローのバージョン |
| フローノードID | Modeler上で開始/停止イベントの「Id」に指定したID |
| イベント種別 | 開始イベント → START、停止イベント → TERMINATE |

<details>
<summary>keywords</summary>

イベントテーブル, イベント種別, START, TERMINATE, 開始イベント, 停止イベント

</details>

## ゲートウェイ

| 定義 | 内容 |
|---|---|
| ワークフローID | ゲートウェイが属しているワークフローID |
| バージョン | ゲートウェイが属しているワークフローのバージョン |
| フローノードID | Modeler上でゲートウェイの「Id」に指定したID |
| ゲートウェイ種別 | XORゲートウェイ → EXCLUSIVE |

<details>
<summary>keywords</summary>

ゲートウェイテーブル, ゲートウェイ種別, EXCLUSIVE, XORゲートウェイ

</details>

## 構文精査

ワークフロー定義ファイルがBPMN 2.0のXSD定義に準拠しているか精査する（IDの重複等）。

> **注意**: BPMN 2.0のXSD定義に違反している場合、そのファイルのワークフロー定義データを出力しない。正常に読み込みが行えたファイルのみ出力する。

<details>
<summary>keywords</summary>

構文精査, BPMN 2.0 XSD検証, IDの重複, XSD定義

</details>

## ワークフローライブラリの制約に関する精査

ワークフローライブラリが提供するワークフロー機能の制約（プール数、利用可能フローノード等）への準拠を精査する。

> **注意**: 精査エラーが発生した場合、そのファイルのワークフロー定義データを出力しない（正常に読み込みが行えたファイルについては出力する）。

フロー進行条件・完了条件のクラス存在確認は行わない（設計時にクラスが存在しないことがある）。クラス名が誤っている場合、システムリポジトリの初期化時のワークフローエンジン初期化処理で例外が発生する。

ツールが行うフロー進行条件・完了条件の精査:
- `クラス名（省略記法） + (パラメータ1, パラメータ2, ....)` の形式であること（パラメータが無い場合は括弧を書かない）
- クラス名（省略記法）部分が `.`（ピリオド）で開始・終了していないこと
- クラス名（省略記法）部分に連続する `.` を含まないこと
- クラス名（省略記法）部分に空白文字（全角空白を含む）を含まないこと
- 空白文字のみのパラメータが指定されていないこと

<details>
<summary>keywords</summary>

ワークフローライブラリ制約精査, フロー進行条件精査, 完了条件精査, クラス名形式チェック, 省略記法検証, プール数, 利用可能フローノード

</details>

## プロジェクト固有の設定について

以下の変更がある場合、コンポーネント定義ファイルを修正する。

| 変更内容 | 修正対象コンポーネント/マップ名 |
|---|---|
| ワークフロー定義ファイルの読込元、出力先 | workflowDefinitionReader、workflowDefinitionWriter |
| フロー進行条件、完了条件クラスの省略記法 | flowProceedCondition、completionCondition |

Readerクラスを変更する例:
```xml
<component name="workflowDefinitionReader" class="please.change.me.sample.ss11.CustomWorkflowDefinitionReader"/>
<component name="workflowDefinitionWriter" class="nablarch.tool.workflow.WorkflowDefinitionExcelWriter">
    <property name="workflowDefinitionSchema" ref="workflowDefinitionSchema"/>
    <property name="outputFilePath" value="${outputFilePath}"/>
</component>
```

<details>
<summary>keywords</summary>

プロジェクト固有設定, workflowDefinitionReader, workflowDefinitionWriter, WorkflowDefinitionExcelWriter, Readerクラス変更, コンポーネント定義ファイル変更

</details>

## 省略記法について

コンポーネント定義ファイルで任意の文字列とクラスの完全修飾名のマッピングを登録することで、Modeler上でフロー進行条件・完了条件クラスを指定する際に完全修飾名の代わりに登録した文字列（省略記法）を使用できる。

デフォルトのフロー進行条件省略記法:
```xml
<map name="flowProceedCondition">
    <entry key="eq" value="nablarch.tool.workflow.EqFlowProceedCondition"/>
    <entry key="ge" value="nablarch.tool.workflow.GeFlowProceedCondition"/>
    <entry key="gt" value="nablarch.tool.workflow.GtFlowProceedCondition"/>
    <entry key="le" value="nablarch.tool.workflow.LeFlowProceedCondition"/>
    <entry key="lt" value="nablarch.tool.workflow.LtFlowProceedCondition"/>
    <entry key="ne" value="nablarch.tool.workflow.NeFlowProceedCondition"/>
</map>
```

デフォルトの完了条件省略記法:
```xml
<map name="completionCondition">
    <entry key="all" value="nablarch.tool.workflow.AllCompletionCondition"/>
    <entry key="or" value="nablarch.tool.workflow.OrCompletionCondition"/>
</map>
```

Modeler入力と出力の対応例:
| Modeler上の入力値 | 出力結果 |
|---|---|
| all | nablarch.tool.workflow.AllCompletionCondition |
| or(1) | nablarch.tool.workflow.OrCompletionCondition(1) |

<details>
<summary>keywords</summary>

省略記法, flowProceedCondition, completionCondition, EqFlowProceedCondition, GeFlowProceedCondition, GtFlowProceedCondition, LeFlowProceedCondition, LtFlowProceedCondition, NeFlowProceedCondition, AllCompletionCondition, OrCompletionCondition, 完全修飾名マッピング

</details>

## 省略記法の追加・変更

コンポーネント定義ファイルの `flowProceedCondition` または `completionCondition` マップの `key`/`value` を編集する。

完了条件クラスの省略記法を変更する例:
```xml
<map name="completionCondition">
    <entry key="all" value="please.change.me.sample.ss11.component.CM111004Component"/><!-- PJ固有の完了条件クラス -->
    <entry key="or" value="nablarch.tool.workflow.OrCompletionCondition"/>
</map>
```

<details>
<summary>keywords</summary>

省略記法追加, 省略記法変更, flowProceedCondition, completionCondition, key, value, カスタム完了条件クラス

</details>
