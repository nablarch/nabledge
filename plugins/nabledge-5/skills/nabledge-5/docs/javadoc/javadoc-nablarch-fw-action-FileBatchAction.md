# class FileBatchAction

**パッケージ:** nablarch.fw.action

**継承階層:**
```
java.lang.Object
  └─ FileBatchActionBase<DataRecord>
      └─ nablarch.fw.action.FileBatchAction
```

**実装されたインタフェース:**
- DataReaderFactory<DataRecord>

---

```java
public abstract class FileBatchAction
extends FileBatchActionBase<DataRecord>
implements DataReaderFactory<DataRecord>
```

ファイル入力バッチにおける業務処理のサポートクラス。
<p/>
業務処理を実装するメソッドのシグニチャは{@link nablarch.fw.handler.RecordTypeBinding}の仕様に従って作成すること。<br/>
{@code
do[レコードタイプ名](DataRecord record, ExecutionContext context)
}

**関連項目:** nablarch.fw.reader.FileDataReader  
**関連項目:** nablarch.fw.handler.RecordTypeBinding  
**作成者:** Iwauo Tajima  

---

## コンストラクタの詳細

### FileBatchAction

```java
public FileBatchAction()
```

FileBatchActionオブジェクトを生成する。

---

## メソッドの詳細

### createReader

```java
public ResumeDataReader<DataRecord> createReader(ExecutionContext context)
```

データリーダを作成する。
<p/>
この実装では、入力ファイルを読み込む{@link nablarch.core.dataformat.FileRecordReader}を作成し、
{@link ResumeDataReader}にラップして返却する。<br/>
また、入力ファイルの事前検証処理が必要な場合は{@link #getValidatorAction()}をオーバーライドし、
FileRecordReaderを{@link ValidatableFileDataReader}でラップする。

---
