## 出力ファイル開放ハンドラ

**クラス名:** `nablarch.common.handler.FileRecordWriterDisposeHandler`

-----

-----

-----

### 概要

業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放（クローズ）するハンドラ。
後続のハンドラの処理結果に関わらず全ての出力ファイルを解放する。
本ハンドラを使用する場合、業務アクションハンドラ内で出力ファイルを開放する必要はない。

> **Warning:**
> 本ハンドラは、 [FileRecordWriterHolder](../../javadoc/nablarch/common/io/FileRecordWriterHolder.html) クラス経由で書き込みが行われた出力ファイルのみ開放する。

> [FileRecordWriterHolder](../../javadoc/nablarch/common/io/FileRecordWriterHolder.html) 以外のクラスを使用して書き込んだ出力ファイルは、開放の対象外となるので注意すること。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| 出力ファイル開放ハンドラ | nablarch.common.handler.FileRecordWriterDisposeHandler | Object | Object | - | 業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放する | - |

### ハンドラ処理フロー

**[往路処理]**

**1. (後続ハンドラに対する処理委譲)**

後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**2. (出力ファイルの開放)**

[FileRecordWriterHolder](../../javadoc/nablarch/common/io/FileRecordWriterHolder.html) によって書き込みを行った全てのファイルの開放処理を行う。

**2a. (開放処理中のエラー)**

なお、開放処理中にIOエラーが発生した場合は、ワーニングログのみ出力し、再送出は行なわない。
それ以外のエラーが発生した場合は再送出して終了する。

**3. (正常終了)**

**1.** で取得した処理結果を返却して終了する。

**[例外処理]**

**1a. (後続ハンドラの処理でエラー)**

後続ハンドラの処理中にエラーが発生した場合、 **2. (出力ファイルの開放)** を行った後、
発生した元例外を再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの実装内容は基本的に変更不要なものであり、そのまま使用することができる。
以下はDIリポジトリ設定ファイルへの記述例である。

```xml
<component class="nablarch.common.handler.FileRecordWriterDisposeHandler" />
```

### 未実装機能・要望

(とくになし。)
