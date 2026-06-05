# interface Permission

**パッケージ:** nablarch.common.permission

---

```java
public interface Permission
```

認可を行うインタフェース。<br>
<br>
認可判定の実現方法毎に本インタフェースの実装クラスを作成する。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### permit

```java
boolean permit(String requestId)
```

リクエストIDを認可判定する。

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
認可に成功した場合は<code>true</code>、認可に失敗した場合は<code>false</code>

---

### getRequestIds

```java
SortedSet<String> getRequestIds()
```

ユーザに許可されたリクエストIDを取得する。

**戻り値:**
ユーザに許可されたリクエストID

---
