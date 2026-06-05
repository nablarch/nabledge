# interface PathOptionsFormatter

**パッケージ:** nablarch.integration.router

---

```java
public interface PathOptionsFormatter
```

ログに出力するために {@link PathOptions} をフォーマットする機能を提供するインターフェース。

**作成者:** Tanaka Tomoyuki  

---

## メソッドの詳細

### format

```java
String format(List<PathOptions> pathOptionsList)
```

{@link PathOptions} のリストをログ出力用にフォーマットする。

**パラメータ:**
- `pathOptionsList` - フォーマット対象の {@link PathOptions} のリスト

**戻り値:**
フォーマット結果

---
