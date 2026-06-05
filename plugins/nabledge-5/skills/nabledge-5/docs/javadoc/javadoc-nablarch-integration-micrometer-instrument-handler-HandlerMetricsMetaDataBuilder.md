# interface HandlerMetricsMetaDataBuilder

**パッケージ:** nablarch.integration.micrometer.instrument.handler

---

```java
public interface HandlerMetricsMetaDataBuilder
```

ハンドラで収集するメトリクスに設定するメタ情報を生成するビルダー。

**param:** 処理対象データ型  
**param:** 処理結果データ型  
**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### getMetricsName

```java
String getMetricsName()
```

メトリクスの名前を取得する。

**戻り値:**
メトリクスの名前

---

### getMetricsDescription

```java
String getMetricsDescription()
```

メトリクスの説明を取得する。

**戻り値:**
メトリクスの説明

---

### buildTagList

```java
List<Tag> buildTagList(TData param, ExecutionContext executionContext, TResult result, Throwable thrownThrowable)
```

メトリクスに設定するタグのリストを生成する。

**パラメータ:**
- `param` - ハンドラに渡された処理対象データ
- `executionContext` - 実行時コンテキスト
- `result` - ハンドラが返した処理結果データ（ハンドラが例外をスローした場合は {@code null}）
- `thrownThrowable` - ハンドラがスローした例外（例外がスローされていない場合は {@code null}）

**戻り値:**
生成したタグのリスト

---
