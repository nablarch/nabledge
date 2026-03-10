# オンラインアクセスログ集計機能

**公式ドキュメント**: [オンラインアクセスログ集計機能](https://nablarch.github.io/docs/LATEST/doc/biz_samples/10/contents/OnlineAccessLogStatistics.html)

## オンラインアクセスログ集計機能

オンラインアクセスログ集計機能は、画面機能から出力されるアクセスログを元にリクエストID単位に以下の情報を集計する。

- リクエスト数
- 閾値を超えた処理時間のリクエスト数
- 処理時間（平均）
- 処理時間（中央値）
- 処理時間（最大値）

> **補足**: リクエストIDは設定ファイルに指定することで、集計対象の機能を絞り込むことができる。

<details>
<summary>keywords</summary>

オンラインアクセスログ集計, リクエスト数集計, 処理時間集計, 閾値超過リクエスト数, アクセスログ統計

</details>

## サンプル構成

| サンプル名 | 概要 |
|---|---|
| オンラインアクセスログ解析バッチ | アクセスログを解析し、集計時に必要な情報のみをCSVファイルに出力するバッチ処理 |
| オンラインアクセスログ解析結果集計バッチ | 解析バッチで出力されたCSVファイルを元に集計処理を行うバッチ処理。集計期間は設定ファイルに指定された日数分 |
| オンラインアクセスログ集計結果レポートサンプル | 集計バッチで出力した集計結果を元にExcelにレポート（集計結果表）を出力するExcelマクロ |

<details>
<summary>keywords</summary>

サンプル構成, 解析バッチ, 集計バッチ, Excelレポートサンプル, 3種類構成

</details>

## 処理の流れ

オンラインアクセスログを元にExcelにレポート情報を出力するまでの処理の流れは図を参照。

> **補足**: オンラインログ配置サーバと運用担当者様端末を明示的に分けて記載している。オンラインアクセスログには個人情報が含まれている可能性があるため、セキュリティで保護された環境での実行を推奨する。なお、リクエスト情報集計結果には個人情報等の項目は含まれないため、セキュリティで保護された環境以外で実行することも可能であるが、ログの解析及び集計処理を実行した環境で実行することに特に問題はない。

<details>
<summary>keywords</summary>

処理フロー, ログ解析手順, 集計処理, レポート生成, セキュリティ推奨

</details>

## 各サンプルの仕様及び実行手順

## オンラインアクセスログ解析バッチ

日次で実行することを想定。解析結果CSVファイルは削除せずに蓄積すること（過去分の蓄積により後続集計処理の正確性が担保される）。

CSVファイル名: `REQUEST_INFO_YYYYMMDD.csv`（YYYYMMDD = システム日付8桁）

**CSVファイルへの出力内容**:

| 項目名 | 備考 |
|---|---|
| 年 | リクエストの終了(END)ログ出力日時の年 |
| 月 | リクエストの終了(END)ログ出力日時の月 |
| 日 | リクエストの終了(END)ログ出力日時の日 |
| プロセス名 | プロセス名（ログにプロセス名が出力されていない場合はブランク） |
| リクエストID | リクエストID |
| 処理時間 | リクエストの処理時間 |
| ステータスコード | 処理ステータスコード |

## オンラインアクセスログ解析結果集計バッチ

解析バッチで出力されたCSVファイルを元に集計処理を実行。集計期間は設定ファイルに指定された日数分。

> **補足**: 対象日数の判定はファイル名に含まれている日付を使用。解析処理が日次で実行されていない場合（例: 2日に1回）、CSVに複数日分が含まれるため、指定集計期間より前のログも集計結果に含まれる場合がある。

集計結果として以下の3種類のCSVファイルを出力:

| ファイル名 | 出力内容 | 注意事項 |
|---|---|---|
| 時間別集計結果 | 時間単位（0〜23）の集計結果 | |
| 日別集計結果 | 日単位（1〜31）の集計結果 | |
| 年月別集計結果 | 年月単位の集計結果（システム日次の年月のみ） | 過去分の集計結果は削除せずに蓄積すること |

> **補足**: 集計範囲が1ヶ月未満（例: 10日）の場合、年月集計結果はその期間のみの集計となる。

**集計結果CSVへの出力内容**:

| 項目名 | 備考 |
|---|---|
| リクエストID | リクエストID |
| 集計対象期間 | 時間別: 0〜23、日別: 1〜31、年月別: システム日付の年月 |
| プロセス名 | プロセス名 |
| リクエスト数 | 集計対象期間内のリクエスト数 |
| 処理時間が閾値を超えたリクエスト数 | 設定ファイルで指定された閾値時間を超えたリクエストの数 |
| 処理時間（平均） | 集計対象期間内での平均値 |
| 処理時間（中央値） | 集計対象期間内での中央値 |
| 処理時間（集計対象期間内での最大処理時間） | 集計対象期間内での最大処理時間 |

## オンラインアクセスログ集計結果レポートサンプル

集計バッチで出力した集計結果を元にExcelにレポート（集計結果表）を出力するExcelマクロ。表を元にグラフの作成などをする場合には、Excelの機能を使用してグラフ化を行うこと。

<details>
<summary>keywords</summary>

解析バッチ仕様, 集計バッチ仕様, REQUEST_INFO_YYYYMMDD.csv, 時間別集計, 日別集計, 年月別集計, CSV出力項目

</details>

## 本サンプルを実行するための設定情報（解析バッチ）

解析バッチおよび集計バッチの共通設定。設定値は `please.change.me.statistics.action.settings.OnlineStatisticsDefinition` のプロパティへ設定する（全て必須）。

標準構成の設定値は以下のファイルに用意されているため、環境に応じて変更が必要な項目のみ修正すること:
- `main/resources/statistics/onlineStatisticsDefinition.xml`
- `main/resources/statistics/statistics.config`

| 設定プロパティ名 | 設定内容 |
|---|---|
| accessLogDir | 解析対象ログのディレクトリパス（絶対パス or 相対パス） |
| accessLogFileNamePattern | 解析対象ログのファイル名パターン。ワイルドカードに`*`を使用（正規表現とは異なる）。例: `access*` |
| accessLogParseDir | ログ解析用一時ディレクトリパス（解析対象ログをここにコピーして処理）（絶対パス or 相対パス） |
| endLogPattern | 終了ログを特定するための正規表現パターン |
| includeRequestIdList | 解析対象のリクエストIDリスト。リクエストIDが増減した場合は追加・削除すること |
| findRequestIdPattern | 終了ログからリクエストIDを抽出する正規表現（リクエストID部分をグループ化すること） |
| findProcessNamePattern | 終了ログからプロセス名を抽出する正規表現（プロセス名部分をグループ化すること） |
| findStatusCodePattern | 終了ログからステータスコードを抽出する正規表現（ステータスコード部分をグループ化すること） |
| logOutputDateTimeStartPosition | ログ出力日時の開始位置（0始まりの文字数、`String#substring`と同仕様） |
| logOutputDateTimeEndPosition | ログ出力日時の終了位置（0始まりの文字数、`String#substring`と同仕様） |
| logOutputDateTimeFormat | ログ出力日時のフォーマット（SimpleDateFormat形式） |
| findExecutionTimePattern | 処理時間を抽出する正規表現（処理時間部分をグループ化すること） |
| thresholdExecutionTime | 処理時間の閾値（ミリ秒）。例: 3000 = 3秒超のリクエスト数を集計 |
| aggregatePeriod | 集計期間（日数）。年月集計をもれなく行うため最低30を推奨 |
| requestInfoFormatName | 解析結果CSVのフォーマット定義ファイル名。デフォルト: `main/format/requestInfo.fmt`（解析・集計バッチ共用）。フォーマット拡張時は新規ファイル名を指定すること |
| requestInfo.dir | 解析結果CSV出力先ディレクトリの論理名（実マッピング: `main/resources/statistics/file.xml`） |
| requestInfoSummaryBaseName | 集計結果CSV出力先ディレクトリの論理名（実マッピング: `main/resources/statistics/file.xml`） |
| requestInfoSummaryFormatName | 集計結果CSVのフォーマット定義ファイル名。デフォルト: `main/format/requestInfoAggregate.fmt`。フォーマット拡張時は新規ファイル名を指定すること |

<details>
<summary>keywords</summary>

OnlineStatisticsDefinition, please.change.me.statistics.action.settings.OnlineStatisticsDefinition, accessLogDir, accessLogFileNamePattern, accessLogParseDir, endLogPattern, includeRequestIdList, findRequestIdPattern, findProcessNamePattern, findStatusCodePattern, logOutputDateTimeStartPosition, logOutputDateTimeEndPosition, logOutputDateTimeFormat, findExecutionTimePattern, thresholdExecutionTime, aggregatePeriod, requestInfoFormatName, requestInfo.dir, requestInfoSummaryBaseName, requestInfoSummaryFormatName

</details>

## 実行方法（解析バッチ）

本バッチは :ref:`Nablarchのバッチ方式<nablarch_batch>` で実装。

| パラメータ | 値 |
|---|---|
| diConfig | `statistics-batch.xml`（resourcesにクラスパス設定の場合） |
| requestPath | `OnlineAccessLogParseAction` |
| userId | バッチユーザID |

<details>
<summary>keywords</summary>

OnlineAccessLogParseAction, statistics-batch.xml, バッチ実行パラメータ, diConfig, requestPath

</details>

## 本サンプルを実行するための設定情報（集計バッチ）

集計バッチの設定はオンラインアクセスログ解析バッチと共通。設定値は `please.change.me.statistics.action.settings.OnlineStatisticsDefinition` のプロパティへ設定する（全て必須）。設定プロパティの詳細は「本サンプルを実行するための設定情報（解析バッチ）」セクションを参照。

<details>
<summary>keywords</summary>

集計バッチ設定, OnlineStatisticsDefinition, 共通設定, statistics-batch.xml

</details>

## 実行方法（集計バッチ）

本バッチは :ref:`Nablarchのバッチ方式<nablarch_batch>` で実装。

| パラメータ | 値 |
|---|---|
| diConfig | `statistics-batch.xml`（resourcesにクラスパス設定の場合） |
| requestPath | `RequestInfoAggregateAction` |
| userId | バッチユーザID |

<details>
<summary>keywords</summary>

RequestInfoAggregateAction, statistics-batch.xml, バッチ実行パラメータ, diConfig, requestPath

</details>

## 実行方法（レポートサンプル）

集計結果表を作成するサンプル。表を元にグラフの作成などをする場合には、Excelの機能を使用してグラフ化を行うこと。

実行方法の詳細: `/tool/ウェブアプリケーションリクエストレポートツール.xls`

<details>
<summary>keywords</summary>

Excelマクロ, レポート出力, ウェブアプリケーションリクエストレポートツール, 集計結果表

</details>
