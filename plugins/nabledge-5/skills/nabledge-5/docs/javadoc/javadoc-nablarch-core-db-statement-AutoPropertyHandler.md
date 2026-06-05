# interface AutoPropertyHandler

**パッケージ:** nablarch.core.db.statement

---

```java
public interface AutoPropertyHandler
```

オブジェクトの自動設定項目のフィールドに値を設定するインタフェース。<br>
オブジェクトの事前変換処理が必要な場合には、本インターフェースの実装クラスを追加し、
実処理実行前にexecuteメソッドを呼び出すこと。
オブジェクトに対する

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### handle

```java
void handle(Object obj)
```

指定されたオブジェクトのフィールドの値に自動設定値を設定する。

**パラメータ:**
- `obj` - オブジェクト

---
