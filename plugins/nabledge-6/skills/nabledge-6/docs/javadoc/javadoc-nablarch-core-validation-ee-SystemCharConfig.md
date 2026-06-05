# class SystemCharConfig

**パッケージ:** nablarch.core.validation.ee

---

```java
public class SystemCharConfig
```

システム許容文字のバリデーションに関する設定を保持するクラス。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### allowSurrogatePair

```java
private boolean allowSurrogatePair
```

サロゲートペアを許容するかどうかを表すフラグ

---

## メソッドの詳細

### isAllowSurrogatePair

```java
public boolean isAllowSurrogatePair()
```

サロゲートペアを許容するかどうかを表すフラグを取得する。

**戻り値:**
サロゲートペアを許容する場合は{@code true}（デフォルトは{@code false}）

---

### setAllowSurrogatePair

```java
public void setAllowSurrogatePair(boolean allowSurrogatePair)
```

サロゲートペアを許容するかどうかを表すフラグを設定する

**パラメータ:**
- `allowSurrogatePair` - サロゲートペアを許容する場合は{@code true}（デフォルトは{@code false}）

---
