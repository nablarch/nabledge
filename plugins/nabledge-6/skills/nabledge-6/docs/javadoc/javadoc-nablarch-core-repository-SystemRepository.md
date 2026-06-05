# class SystemRepository

**パッケージ:** nablarch.core.repository

---

```java
public final class SystemRepository
```

設定値およびコンポーネントを保持するクラス。<br/>
アプリケーションの設定値の取得とコンポーネントを生成する責務は{@link ObjectLoader}を実装したクラスが持つ。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### objects

```java
private static Map<String,Object> objects
```

リポジトリに配置されたオブジェクトのMap。

---

## コンストラクタの詳細

### SystemRepository

```java
private SystemRepository()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### clear

```java
public static void clear()
```

ロードされたオブジェクトをクリアする。

---

### load

```java
public static void load(ObjectLoader loader)
```

{@link ObjectLoader}からオブジェクトをロードする。
<p/>
本メソッドは、登録済みのオブジェクトに対して追加でロードを行う。
よって、登録済みのオブジェクトは、再度本メソッドを起動してもクリアされない。
<p/>
登録済みのオブジェクトと同名のオブジェクトを{@link ObjectLoader}からロードした場合上書きされる。

**パラメータ:**
- `loader` - オブジェクトローダ

---

### getObject

```java
public static Object getObject(String name)
```

コンポーネント名を指定して、リポジトリに登録されたコンポーネントを取得する。

**パラメータ:**
- `name` - コンポーネント名

**戻り値:**
リポジトリに登録されたコンポーネント

---

### getString

```java
public static String getString(String name)
```

設定値の登録名を指定してリポジトリに登録された文字列の設定値を取得する。

**パラメータ:**
- `name` - 設定値の登録名

**戻り値:**
リポジトリに登録された文字列設定値

**例外:**
- `ClassCastException` - リポジトリに登録されたオブジェクトが、String型にキャストできない型であった場合

---

### getBoolean

```java
public static boolean getBoolean(String name)
```

設定値の登録名を指定してリポジトリに登録された真偽値の設定値を取得する。
<p/>
以下の文字列と一致する設定値が登録されていた場合に「true」を返却する。大文字・小文字は区別しない。
<ul>
    <li>"true"</li>
    <li>"on"</li>
    <li>"yes"</li>
</ul>

**パラメータ:**
- `name` - 設定値の登録名

**戻り値:**
リポジトリに登録されたBoolean型の設定値

**例外:**
- `ClassCastException` - リポジトリに登録されたオブジェクトが、String型にキャストできない型であった場合

---

### get

```java
public static T get(String name)
      throws ClassCastException
```

リポジトリに登録されたコンポーネントを取得する。

**パラメータ:**
- `<T>` - 取得するコンポーネントの型
- `name` - コンポーネント名

**戻り値:**
コンポーネント コンポーネントが見つからなかった場合はnullを返却する

**例外:**
- `ClassCastException` - 型引数{@code <T>}が、リポジトリに登録されたコンポーネントの型と一致しなかった場合

---
