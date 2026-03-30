# 出力ファイル開放ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.FileRecordWriterDisposeHandler`

業務アクションハンドラで書き込みを行った全出力ファイルを開放（クローズ）するハンドラ。後続ハンドラの処理結果に関わらず全ファイルを開放する。本ハンドラを使用する場合、業務アクションハンドラ内で出力ファイルを開放する必要はない。

> **警告**: 本ハンドラは `FileRecordWriterHolder` クラス経由で書き込まれた出力ファイルのみ開放対象とする。`FileRecordWriterHolder` 以外のクラスで書き込んだ出力ファイルは開放されない。

<details>
<summary>keywords</summary>

FileRecordWriterDisposeHandler, nablarch.common.handler.FileRecordWriterDisposeHandler, FileRecordWriterHolder, 出力ファイル開放, ファイルクローズ, ハンドラ

</details>

## ハンドラ処理フロー

**往路処理**
1. 後続ハンドラに処理を委譲し、結果を取得する。

**復路処理**
2. `FileRecordWriterHolder` によって書き込みを行った全ファイルの開放処理を行う。
   - 2a. 開放処理中にIOエラーが発生した場合はワーニングログのみ出力し、再送出しない。それ以外のエラーは再送出して終了する。
3. 手順1で取得した処理結果を返却して終了する。

**例外処理**
- 後続ハンドラの処理でエラーが発生した場合、出力ファイルの開放処理（手順2）を行った後、元例外を再送出して終了する。

<details>
<summary>keywords</summary>

FileRecordWriterHolder, 往路処理, 復路処理, 例外処理, IOエラー, ファイル開放フロー

</details>

## 設定項目・拡張ポイント

実装変更不要。そのまま使用できる。

```xml
<component class="nablarch.common.handler.FileRecordWriterDisposeHandler" />
```

<details>
<summary>keywords</summary>

DIコンポーネント設定, XML設定例, コンポーネント定義, FileRecordWriterDisposeHandler

</details>

## 未実装機能・要望

未実装機能・要望なし。

<details>
<summary>keywords</summary>

未実装機能, 要望

</details>
