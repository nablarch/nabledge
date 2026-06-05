# class StreamResponse

**パッケージ:** nablarch.common.web.download

**継承階層:**
```
java.lang.Object
  └─ HttpResponse
      └─ nablarch.common.web.download.StreamResponse
```

---

```java
public class StreamResponse
extends HttpResponse
```

ストリームからHTTPレスポンスメッセージを生成するクラス。
<p/>
本クラスは、ファイルシステム上のファイルやデータベースのBLOB型のカラムに格納した
バイナリデータのダウンロードに使用する。

**作成者:** Kiyohito Itoh  

---

## コンストラクタの詳細

### StreamResponse

```java
public StreamResponse(Blob blob)
```

{@code StreamResponse}オブジェクトを生成する。

**パラメータ:**
- `blob` - バイナリラージオブジェクト

**例外:**
- `RuntimeException` - ストリームアクセス時にエラーが発生した場合

---

### StreamResponse

```java
public StreamResponse(File file, boolean deleteOnCleanup)
```

{@code StreamResponse}オブジェクトを生成する。

**パラメータ:**
- `file` - ファイル
- `deleteOnCleanup` - リクエスト処理の終了時にダウンロード元のファイルを削除する場合は{@code true}

---

## メソッドの詳細

### initialize

```java
private void initialize(InputStream inputStream)
```

入力ストリームから初期化を行う。
初期化完了後に入力ストリームを閉じる。

**パラメータ:**
- `inputStream` - 入力ストリーム

---
