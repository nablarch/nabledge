# class EtlJobAbortedException

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.etl.EtlJobAbortedException
```

---

```java
public class EtlJobAbortedException
extends RuntimeException
```

バリデーションエラーが発生し、ステップを異常終了することを示す例外クラス。

**作成者:** Hisaaki Shiori  

---

## コンストラクタの詳細

### EtlJobAbortedException

```java
public EtlJobAbortedException(String message)
```

例外メッセージを持つ{@code EtlJobAborted}を生成する。

**パラメータ:**
- `message` - 例外メッセージ

---
