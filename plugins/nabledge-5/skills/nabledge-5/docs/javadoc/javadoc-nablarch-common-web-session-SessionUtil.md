# class SessionUtil

**パッケージ:** nablarch.common.web.session

---

```java
public final class SessionUtil
```

セッションに関するユーティリティ。
<p/>
業務Actionハンドラからは、必ず本クラスを使用してセッションの読み書きを行う。
<p/>
セッションへの登録処理は{@link SessionManager}によって提供される。
{@link SessionManager}の実装は、{@link SystemRepository}からコンポーネント名"sessionManager"で取得される。
<p/>
本クラスは{@link SessionStoreHandler}と併せて使用すること。

**作成者:** kawasima  
**作成者:** tajima  

---

## コンストラクタの詳細

### SessionUtil

```java
private SessionUtil()
```

本クラスはインスタンスを生成しない。

---

## メソッドの詳細

### get

```java
public static T get(ExecutionContext ctx, String name)
```

名称を指定してセッションからオブジェクトを取得する。
<p/>
セッションに指定した名称をもつオブジェクトが存在しない場合、
{@link SessionKeyNotFoundException}を送出する。
<pre>
{@code
// "userName"という名称のオブジェクトがセッションに登録済み。設定値は"Nabu Rakutaro"
SessionUtil.get(ctx, "userName"); // -> "Nabu Rakutaro"

// セッションに存在しないオブジェクトを指定
SessionUtil.get(ctx, "test"); // -> SessionKeyNotFoundExceptionを送出
}
</pre>

**パラメータ:**
- `<T>` - セッションに格納されているオブジェクトの型
- `ctx` - 実行コンテキスト
- `name` - セッションに登録したオブジェクトの名称

**戻り値:**
セッションから取得したオブジェクト

**例外:**
- `SessionKeyNotFoundException` - 指定したオブジェクトの名称がセッションに存在しない場合

---

### orNull

```java
public static T orNull(ExecutionContext ctx, String name)
```

名称を指定してセッションからオブジェクトを取得する。
<p/>
セッションに指定した名称をもつオブジェクトが存在しない場合、nullを返す。
<pre>
{@code
// "userName"という名称のオブジェクトがセッションに登録済み。設定値は"Nabu Rakutaro"
SessionUtil.orNull(ctx, "userName"); // -> "Nabu Rakutaro"

// セッションに存在しないオブジェクトを指定
SessionUtil.orNull(ctx, "test"); // -> null
}
</pre>

**パラメータ:**
- `<T>` - セッションに格納されているオブジェクトの型
- `ctx` - 実行コンテキスト
- `name` - セッションに登録したオブジェクトの名称

**戻り値:**
セッションから取得したオブジェクト

---

### or

```java
public static T or(ExecutionContext ctx, String name, T defaultValue)
```

名称を指定してセッションからオブジェクトを取得する。
<p/>
セッションに指定した名称をもつオブジェクトが存在しない場合、デフォルト値を返す。
<pre>
{@code
// "userName"という名称のオブジェクトがセッションに登録済み。設定値は"Nabu Rakutaro"
SessionUtil.or(ctx, "userName", "デフォルト値"); // -> "Nabu Rakutaro"

// セッションに存在しないオブジェクトを指定
SessionUtil.or(ctx, "test", "デフォルト値"); // -> "デフォルト値"
}
</pre>

**パラメータ:**
- `<T>` - セッションに格納されているオブジェクトの型
- `ctx` - 実行コンテキスト
- `name` - セッションに登録したオブジェクトの名称
- `defaultValue` - デフォルト値

**戻り値:**
セッションから取得したオブジェクト

---

### getSessionValue

```java
private static T getSessionValue(ExecutionContext ctx, String name)
```

指定されたセッションオブジェクトを取得する。

**パラメータ:**
- `<T>` - セッションに格納されているオブジェクトの型
- `ctx` - 実行コンテキスト
- `name` - セッションに登録したオブジェクトの名称

**戻り値:**
セッションから取得したオブジェクト

---

### put

```java
public static void put(ExecutionContext ctx, String name, Object value)
```

{@link SessionStore}に変数を保存する。
<p/>
オブジェクトの保存先は{@link SessionManager}で指定した{@link SessionStore}が選択される。
同一の登録名をもつオブジェクトは上書きされる。
よって、複数の{@link SessionStore}を利用する場合でも、
同一の登録名をもつオブジェクトは一つしか登録できない。
<p/>
注意:セッションで管理できるオブジェクトの制限について、
{@link #put(ExecutionContext, String, Object, String)}を参照すること。
<p/>
<pre>
{@code
SessionUtil.put(ctx, "userName", "Nabu Rakutaro");
}
</pre>

**パラメータ:**
- `ctx` - 実行コンテキスト
- `name` - セッションに登録するオブジェクトの名称
- `value` - セッションに登録するオブジェクト

---

### put

```java
public static void put(ExecutionContext ctx, String name, Object value, String storeName)
```

保存先の{@link SessionStore}を指定して、セッションに変数を保存する。
<p/>
同一の登録名をもつオブジェクトは上書きされる。
よって、複数の{@link SessionStore}を利用する場合でも、
同一の登録名をもつオブジェクトは一つしか登録できない。
<p/>
注意:セッションに直接格納し、復元ができるオブジェクトの制限について<br/>
セッションに直接格納できるのは、下記条件を満たすJava Beanオブジェクトのみである。
<ul>
    <li>デフォルトコンストラクタが定義されていること</li>
    <li>値を保持したいプロパティに対し、setter及びgetterが定義されていること</li>
    <li>シリアライズ可能であること</li>
</ul>
上記条件を満たさないオブジェクトを登録した場合、格納/復元処理が正常に動作しない。
例えば、配列型のオブジェクトを直接セッションに格納した場合、復元できない。
その場合、配列を直接格納するのではなくBeanオブジェクトのプロパティとして保持し、
Beanオブジェクトをセッションに格納すること。
<p/>
<pre>
{@code
SessionUtil.put(ctx, "userName", "Nabu Rakutaro", "httpSession");
}
</pre>

**パラメータ:**
- `ctx` - 実行コンテキスト
- `name` - セッションに登録するオブジェクトの名称
- `value` - セッションに登録するオブジェクト
- `storeName` - 登録対象のセッションストア名

---

### getSessionManager

```java
private static SessionManager getSessionManager()
```

リポジトリから{@link SessionManager}を取得する。

**戻り値:**
{@link SessionManager}

---

### delete

```java
public static T delete(ExecutionContext ctx, String name)
```

セッションを削除する。
<p/>
指定した名称のセッションオブジェクトが存在しない場合は無視される。
<pre>
{@code
// Sessionスコープに"sessionProject"という名称でオブジェクトが登録されている前提
SessionUtil.delete(context, "sessionProject");
}
</pre>

**パラメータ:**
- `ctx` - 実行コンテキスト
- `name` - セッションに登録したオブジェクトの名称

**戻り値:**
削除されたセッションの値(セッションオブジェクトが存在しない場合は{@code null})

---

### invalidate

```java
public static void invalidate(ExecutionContext ctx)
```

セッションを無効化する。

**パラメータ:**
- `ctx` - 実行コンテキスト

---

### changeId

```java
public static void changeId(ExecutionContext ctx)
```

セッションIDを変更する。
<p>
このメソッドを実行すると、セッションIDだけが変更され
セッションに保存した情報は維持される。
</p>

**パラメータ:**
- `ctx` - 実行コンテキスト

---
