# class SessionStore

**パッケージ:** nablarch.common.web.session

---

```java
public abstract class SessionStore
```

セッションの内容をストアに格納/読み込みするクラスが継承する共通実装。

**作成者:** kawasima  
**作成者:** tajima  
**関連項目:** nablarch.common.web.session.store  

---

## フィールドの詳細

### name

```java
private String name
```

セッションストア名

---

### expiresMilliSeconds

```java
private Long expiresMilliSeconds
```

有効期間(ミリ秒)

---

### stateEncoder

```java
private StateEncoder stateEncoder
```

セッション内容の直列化モジュール

---

## コンストラクタの詳細

### SessionStore

```java
protected SessionStore(String name)
```

コンストラクタ。
デフォルトのセッションストア名を設定する。

**パラメータ:**
- `name` - セッションストア名

---

## メソッドの詳細

### setName

```java
public void setName(String name)
```

セッションストア名を設定する。

**パラメータ:**
- `name` - セッションストア名

---

### getName

```java
public String getName()
```

セッションストア名を取得する。

**戻り値:**
セッションストア名

---

### setExpires

```java
public void setExpires(Long expires)
```

有効期限(単位:秒)を設定する。

**パラメータ:**
- `expires` - 有効期限(単位:秒)

---

### setExpires

```java
public void setExpires(Long expires, TimeUnit timeUnit)
```

有効期限を設定する。

**パラメータ:**
- `expires` - 有効期限
- `timeUnit` - 時間単位

---

### load

```java
public abstract List<SessionEntry> load(String sessionId, ExecutionContext executionContext)
```

セッションの内容をストアからロードする。

セッションの内容が存在しない場合は空リストを返す。

**パラメータ:**
- `sessionId` - セッションID
- `executionContext` - コンテキスト

**戻り値:**
セッションエントリリスト

---

### save

```java
public abstract void save(String sessionId, List<SessionEntry> entries, ExecutionContext executionContext)
```

セッションの内容をストアに保存する。

**パラメータ:**
- `sessionId` - セッションID
- `entries` - セッションエントリリスト
- `executionContext` - コンテキスト

---

### delete

```java
public abstract void delete(String sessionId, ExecutionContext executionContext)
```

セッションの内容をストアから削除する。

**パラメータ:**
- `sessionId` - セッションID
- `executionContext` - コンテキスト

---

### invalidate

```java
public abstract void invalidate(String sessionId, ExecutionContext executionContext)
```

セッションストアを無効にする。

**パラメータ:**
- `sessionId` - セッションID
- `executionContext` - コンテキスト

---

### encode

```java
protected byte[] encode(List<SessionEntry> entries)
```

セッションエントリリストをエンコードする。

**パラメータ:**
- `entries` - セッションエントリリスト

**戻り値:**
バイト配列

---

### decode

```java
protected List<SessionEntry> decode(byte[] encoded)
```

セッションエントリリストをデコードする。

**パラメータ:**
- `encoded` - エンコードされたバイト配列

**戻り値:**
セッションエントリリスト

---

### getExpiresMilliSeconds

```java
public long getExpiresMilliSeconds()
```

有効期限(単位:ミリ秒)で取得する。

**戻り値:**
有効期限(単位:ミリ秒)

---

### isExtendable

```java
public boolean isExtendable()
```

セッション全体の有効期限に寄与するかを取得する。

ストアの有効期限をセッショントラキングIDの保持期限に反映させない場合は、
本メソッドをサブクラス側でオーバーライドしてfalseを返却するようにする。

**戻り値:**
このストアの有効期限をセッションの維持期間に反映させる場合はtrue

---

### getStateEncoder

```java
public StateEncoder getStateEncoder()
```

セッション内容の直列化モジュールを取得する。

**戻り値:**
セッション内容の直列化モジュール

---

### setStateEncoder

```java
public void setStateEncoder(StateEncoder stateEncoder)
```

セッション内容の直列化モジュールを設定する。

**パラメータ:**
- `stateEncoder` - セッション内容の直列化モジュール

---
