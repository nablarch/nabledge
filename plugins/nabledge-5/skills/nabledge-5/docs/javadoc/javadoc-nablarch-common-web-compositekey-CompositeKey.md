# class CompositeKey

**パッケージ:** nablarch.common.web.compositekey

**実装されたインタフェース:**
- Serializable

---

```java
public class CompositeKey
implements Serializable
```

画面から送信された複合キーを格納するクラス。
<p/>
フォームのプロパティとして本クラスを定義し{@link CompositeKeyType}アノテーションを付与することで、
送信された複合キーの解析・格納を自動で行うことができる。
<p/>
以下のようなパラメータで送信された複合キーを格納する。
<ul>
    <li>特定文字で区切った複合キーの集合(例："user001,pk2001,pk3001")。
        フォームには、CompositeKey型のプロパティを定義する。</li>
    <li>特定文字で区切った複合キーの集合の配列(例：{"user001,pk2001,pk3001","user002,pk2001,pk3001"})。
        フォームには、CompositeKey[]型のプロパティを定義する。</li>
</ul>
<p/>

**作成者:** Koichi Asano  
**関連項目:** CompositeKeyConvertor  
**関連項目:** CompositeKeyArrayConvertor  

---

## フィールドの詳細

### serialVersionUID

```java
private static final long serialVersionUID
```

シリアルバージョンUID。

---

### keys

```java
private String[] keys
```

キー

---

## コンストラクタの詳細

### CompositeKey

```java
public CompositeKey(String keys)
```

キーを指定して{@code CompositeKey}を構築する。

**パラメータ:**
- `keys` - 

---

## メソッドの詳細

### getKeys

```java
public String[] getKeys()
```

全てのキーを取得する。

**戻り値:**
全てのキー

---

### hashCode

```java
public int hashCode()
```

このオブジェクトのハッシュコード値を返す。

**戻り値:**
ハッシュコード値。同じ値のキーを保持しているオブジェクトは、同じハッシュコード値を返す

---

### equals

```java
public boolean equals(Object obj)
```

このオブジェクトと等価であるかを返す。
<p/>
{@code obj}が以下の条件を全て満たす場合{@code true}を返す。
<ul>
    <li>{@code null}ではないこと。</li>
    <li>CompositeKey型のオブジェクトであること。</li>
    <li>保持しているキーの値が、このオブジェクトが保持しているキーの値と一致すること。</li>
</ul>

**パラメータ:**
- `obj` - 比較対象のオブジェクト

**戻り値:**
このオブジェクトと等価である場合{@code true}

---

### toString

```java
public String toString()
```

このオブジェクトが保持しているキーを「,(カンマ)」区切りで列挙した文字列を返す。

**戻り値:**
キーを列挙した文字列

---
