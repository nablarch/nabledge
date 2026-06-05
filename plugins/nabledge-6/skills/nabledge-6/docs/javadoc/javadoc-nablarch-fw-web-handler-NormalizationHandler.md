# class NormalizationHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- Handler<HttpRequest,Object>

---

```java
public class NormalizationHandler
implements Handler<HttpRequest,Object>
```

リクエストパラメータの値をノーマライズするハンドラ。
<p>
このハンドラはデフォルトで、リクエストパラメータの前後のホワイトスペースを除去する。
<p>
もし、デフォルト実装以外のノーマライズ処理を行う必要がある場合は、{@link #setNormalizers(List)}を使用して、{@link Normalizer}を設定すること。
{@link #setNormalizers(List)}では、デフォルトの動作が上書きされるため、デフォルトで適用されている{@link TrimNormalizer}の設定も行う必要がある。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### normalizers

```java
private List<Normalizer> normalizers
```

このハンドラで行うノーマライザのリスト

---

## コンストラクタの詳細

### NormalizationHandler

```java
public NormalizationHandler()
```

デフォルトの構成でハンドラオブジェクトを生成する。
<p>
デフォルト構成では、{@link TrimNormalizer}が有効となる。

---

## メソッドの詳細

### handle

```java
public Object handle(HttpRequest request, ExecutionContext context)
```

---

### setNormalizers

```java
public void setNormalizers(List<Normalizer> normalizers)
```

{@link Normalizer}を設定する。

**パラメータ:**
- `normalizers` - ノーマライザ

---
