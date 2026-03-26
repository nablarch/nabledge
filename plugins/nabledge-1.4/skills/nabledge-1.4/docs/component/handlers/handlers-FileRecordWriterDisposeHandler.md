# 出力ファイル開放ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.FileRecordWriterDisposeHandler`

業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放（クローズ）するハンドラ。後続のハンドラの処理結果に関わらず全ての出力ファイルを解放する。本ハンドラ使用時、業務アクションハンドラ内で出力ファイルを開放する必要はない。

> **警告**: `FileRecordWriterHolder` クラス経由で書き込みが行われた出力ファイルのみ開放する。`FileRecordWriterHolder` 以外のクラスを使用して書き込んだ出力ファイルは開放の対象外。

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, nablarch.common.handler.FileRecordWriterDisposeHandler, FileRecordWriterHolder, 出力ファイル開放, ファイルクローズ, 業務アクションハンドラ

</details>

## ハンドラ処理フロー

**往路処理**
1. 後続ハンドラに処理を委譲し、その結果を取得する。

**復路処理**
2. `FileRecordWriterHolder` によって書き込んだ全ファイルの開放処理を行う。
   - 2a. 開放処理中にIOエラーが発生した場合はワーニングログのみ出力し、再送出しない。それ以外のエラーは再送出して終了。
3. 往路で取得した処理結果を返却して終了。

**例外処理**
- 1a. 後続ハンドラ処理中にエラーが発生した場合、出力ファイルの開放を行った後、元例外を再送出して終了する。

<details>
<summary>keywords</summary>

FileRecordWriterHolder, ハンドラ処理フロー, 出力ファイル開放, IOエラー処理, 例外処理, 往路復路

</details>

## 設定項目・拡張ポイント

実装内容の変更は基本的に不要。そのまま使用可能。

```xml
<component class="nablarch.common.handler.FileRecordWriterDisposeHandler" />
```

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, DI設定, XML設定例, コンポーネント設定

</details>

## 未実装機能・要望

現時点では未実装機能・要望はとくになし。

<details>
<summary>keywords</summary>

未実装機能, 要望

</details>
