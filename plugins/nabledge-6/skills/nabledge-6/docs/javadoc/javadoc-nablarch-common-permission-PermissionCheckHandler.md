# class PermissionCheckHandler

**パッケージ:** nablarch.common.permission

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class PermissionCheckHandler
implements Handler<Object,Object>
```

認可判定を行うハンドラ。
<br>
<br>
このクラスを使用する場合は、下記プロパティを設定する。
<dl>
<dt>{@link #permissionFactory}
<dd>{@link Permission}を生成する{@link PermissionFactory}。必須。
<dt>{@link #ignoreRequestIds}
<dd>認可判定を行わないリクエストID。オプション。<br>
    複数指定する場合はカンマ区切り。
</dl>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### permissionFactory

```java
private PermissionFactory permissionFactory
```

{@link Permission}を生成する{@link PermissionFactory}

---

### ignoreRequestIds

```java
private Set<String> ignoreRequestIds
```

認可判定を行わないリクエストID

---

### usesInternalRequestId

```java
private boolean usesInternalRequestId
```

サービス提供可否判定を行う際に内部リクエストIDを使用するかどうか

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public Object handle(Object inputData, ExecutionContext context)
              throws Forbidden
```

リクエストIDを使用して認可判定を行う。<br>
<br>
下記の順に処理を行う。
<ol>
<li>{@link nablarch.core.ThreadContext}からリクエストIDを取得し、認可判定の対象リクエストかをチェックする。<br>
    対象でない場合は、認可判定を行わずに次のハンドラに処理を委譲する。</li>
<li>{@link ThreadContext#getUserId()}からユーザIDを取得する。<br>
    ユーザIDが設定されていない場合は、認可判定を行わずに次のハンドラに処理を委譲する。</li>
<li>ユーザに紐付く認可情報を取得し、認可判定を行う。<br>
    認可判定に成功した場合は、{@link ThreadContext}に{@link Permission}を設定し、次のハンドラに処理を委譲する。<br>
    認可判定に失敗した場合は、指定されたリソースパスとステータスコードを使用して{@link Forbidden}をスローする。
</li>
</ol>

**パラメータ:**
- `inputData` - 処理対象データ
- `context` - 実行コンテキスト

**戻り値:**
処理結果

**例外:**
- `Forbidden` - 認可判定に失敗した場合(nablarch.fw.Result$Forbidden)

---

### setPermissionFactory

```java
public PermissionCheckHandler setPermissionFactory(PermissionFactory permissionFactory)
```

{@link Permission}を生成する{@link PermissionFactory}を設定する。

**パラメータ:**
- `permissionFactory` - {@link Permission}を生成する{@link PermissionFactory}

**戻り値:**
自身のインスタンス

---

### setIgnoreRequestIds

```java
public PermissionCheckHandler setIgnoreRequestIds(String requestIds)
```

認可判定を行わないリクエストIDを設定する。

**パラメータ:**
- `requestIds` - 認可判定を行わないリクエストID

**戻り値:**
自身のインスタンス

---

### setUsesInternalRequestId

```java
public PermissionCheckHandler setUsesInternalRequestId(boolean usesInternal)
```

認可判定を内部リクエストIDを用いて行うか否かを設定する。

明示的に設定しなかった場合のデフォルトは true (内部リクエストIDを使用する。)

**パラメータ:**
- `usesInternal` - 内部リクエストIDを使用して判定を行う場合は true
                     常に外部から送信されたリクエストIDを使って判定を行う場合は false

**戻り値:**
このハンドラインスタンス自体

---
