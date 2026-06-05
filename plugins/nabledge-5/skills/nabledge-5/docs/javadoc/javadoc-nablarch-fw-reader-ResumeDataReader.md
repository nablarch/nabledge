# class ResumeDataReader

**パッケージ:** nablarch.fw.reader

**実装されたインタフェース:**
- DataReader<TData>

---

```java
public class ResumeDataReader
implements DataReader<TData>
```

ファイルを読み込むデータリーダをラップして、レジューム機能を追加するデータリーダ。
<p>
本クラスは、ラップしたデータリーダの{@link DataReader#read(ExecutionContext) read}メソッドの実行回数を、
正常に処理できたポイントとして実行管理テーブルに保存する。<br/>
正常に処理できたポイントは業務処理がコミットされるタイミングで保存される。
業務処理が失敗しトランザクションがロールバックされる場合、正常に処理できたポイントの保存は行われない。<br/>
障害発生時などに処理を再実行する場合、本クラスは正常に処理できたポイントまでのファイル読み込み（業務処理）をスキップし、
再開ポイント(正常に処理できたポイントの次のポイント)からファイル読み込みを再開する。<br/>
そのため、再開ポイント以前のデータに対してパッチを当てた際は、正常に処理できたポイントを0クリアする必要がある。<br/>
なお、{@link nablarch.fw.action.FileBatchAction}を継承したバッチ業務アクションを作成する場合は、
{@code FileBatchAction}がデフォルトで{@link ValidatableFileDataReader}をラップした{@code ResumeDataReader}を生成するので、
アプリケーションプログラマが上記２つのオブジェクトを生成するコードを実装する必要はない。

**param:** このクラスが読み込んだデータの型  
**作成者:** Masato Inoue  
**関連項目:** FileDataReader  
**関連項目:** nablarch.fw.reader.ResumePointManager  

---

## フィールドの詳細

### sourceReader

```java
private DataReader<TData> sourceReader
```

レジューム機能を追加するデータリーダ

---

### resumePointManager

```java
private ResumePointManager resumePointManager
```

実行管理テーブルに格納されている、正常に処理できたポイントの参照・更新を行うクラスのインスタンス

---

### resumePoint

```java
private int resumePoint
```

正常に処理できたポイント

---

## メソッドの詳細

### read

```java
public synchronized TData read(ExecutionContext ctx)
```

レジューム機能を追加するデータリーダからデータを読み込む。
<p/>
データを読み込んだ回数を正常に処理できたポイントとして実行管理テーブルに保存し、
処理再開時にはその次のポイントから読み込みを再開する。<br/>
トランザクションループ制御ハンドラの設定により一定件数ごとにコミットを行なっている場合は、
コミット前の最後の処理で正常に処理できたポイントを実行管理テーブルに保存する。<br/>
次に読み込むデータが存在しない場合は{@code null}を返す。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
入力データオブジェクト

---

### hasNext

```java
public synchronized boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
次に読み込むデータが存在する場合は{@code true}

---

### close

```java
public synchronized void close(ExecutionContext ctx)
```

このリーダの利用を停止し、内部的に保持している各種リソースを解放する。

**パラメータ:**
- `ctx` - 実行コンテキスト

---

### readToResumePoint

```java
protected void readToResumePoint(ExecutionContext ctx)
```

レジューム機能が有効になっている場合、正常に処理できたポイントまでのレジュームを行う。

**パラメータ:**
- `ctx` - 実行コンテキスト

**例外:**
- `IllegalStateException` - 次に読み込むデータが存在しない場合

---

### getInvalidResumePointMessage

```java
private String getInvalidResumePointMessage(int resumePoint, int numberOfReads)
```

実行管理テーブルに格納されている、正常に処理できたポイントが不正な場合の例外メッセージを取得する。

**パラメータ:**
- `resumePoint` - 正常に処理できたポイント
- `numberOfReads` - 入力データの読み込み回数

**戻り値:**
正常に処理できたポイントが不正な場合の例外メッセージ

---

### loadResumePoint

```java
protected int loadResumePoint()
```

正常に処理できたポイントを取得する。
<p/>
レジューム機能が無効になっている場合は0を返す。

**戻り値:**
正常に処理できたポイント

---

### saveResumePoint

```java
protected void saveResumePoint()
```

正常に処理できたポイントを保存する。
<p/>
レジューム機能が無効になっている場合は何もしない。

---

### setSourceReader

```java
public synchronized ResumeDataReader<TData> setSourceReader(DataReader<TData> sourceReader)
```

レジューム機能を追加するデータリーダを設定する。

**パラメータ:**
- `sourceReader` - レジューム機能を追加するデータリーダ

**戻り値:**
このオブジェクト自体

---
