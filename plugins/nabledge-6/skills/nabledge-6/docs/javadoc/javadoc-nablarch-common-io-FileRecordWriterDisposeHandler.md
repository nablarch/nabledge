# class FileRecordWriterDisposeHandler

**パッケージ:** nablarch.common.io

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class FileRecordWriterDisposeHandler
implements Handler<Object,Object>
```

後続のハンドラの実行が終了した後に、
カレントスレッド上で管理されているファイルレコードライタ（{@link nablarch.core.dataformat.FileRecordWriter}）が保持するストリームのクローズ
およびDataRecordWriterのインスタンスを削除するクラス。

本ハンドラが自動的にストリームのクローズを行うので、
通常、業務アプリケーションでファイルレコードライタを扱う際に、ストリームをクローズする必要はない。

**作成者:** Masato Inoue  

---

## メソッドの詳細

### handle

```java
public Object handle(Object data, ExecutionContext ctx)
```

後続のハンドラの実行が終了した後に、
カレントスレッド上で管理されているファイルレコードライタが保持するストリームのクローズおよび
DataRecordWriterのインスタンスを削除する。

**パラメータ:**
- `data` - 入力データ
- `ctx` - 実行コンテキスト

**戻り値:**
処理結果データ

---
