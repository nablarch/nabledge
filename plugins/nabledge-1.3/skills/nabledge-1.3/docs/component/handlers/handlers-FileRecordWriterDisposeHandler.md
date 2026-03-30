# 出力ファイル開放ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.FileRecordWriterDisposeHandler`

業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放（クローズ）するハンドラ。後続ハンドラの処理結果に関わらず全ての出力ファイルを解放する。本ハンドラを使用する場合、業務アクションハンドラ内で出力ファイルを開放する必要はない。

> **警告**: 本ハンドラは `FileRecordWriterHolder` クラス経由で書き込みが行われた出力ファイルのみ開放する。`FileRecordWriterHolder` 以外のクラスを使用して書き込んだ出力ファイルは開放の対象外となるので注意すること。

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, FileRecordWriterHolder, 出力ファイル開放, ファイルクローズ, 業務アクションハンドラ

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 後続ハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**
2. `FileRecordWriterHolder` によって書き込みを行った全てのファイルの開放処理を行う。
3. 開放処理中にIOエラーが発生した場合はワーニングログのみ出力し、再送出は行わない。それ以外のエラーが発生した場合は再送出して終了する。
4. **1.** で取得した処理結果を返却して終了する。

**[例外処理]**
- 後続ハンドラの処理中にエラーが発生した場合、出力ファイルの開放を行った後、発生した元例外を再送出して終了する。

<details>
<summary>keywords</summary>

往路処理, 復路処理, 例外処理, IOエラー, 出力ファイル開放フロー, FileRecordWriterHolder

</details>

## 設定項目・拡張ポイント

本ハンドラの実装内容は基本的に変更不要なものであり、そのまま使用できる。

```xml
<component class="nablarch.common.handler.FileRecordWriterDisposeHandler" />
```

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, DIリポジトリ設定, コンポーネント設定, XML設定例

</details>

## 未実装機能・要望

なし

<details>
<summary>keywords</summary>

未実装機能, 拡張ポイント

</details>
