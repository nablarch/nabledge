# class CheckRoleLogger

**パッケージ:** nablarch.common.authorization.role

**実装されたインタフェース:**
- Initializable

---

```java
public class CheckRoleLogger
implements Initializable
```

アクションメソッドに設定された{@link CheckRole}アノテーションの情報をログに出力するロガー。
<p>
このクラスは、指定されたパッケージ以下に存在するクラスを走査して、
各メソッドとそこに設定された{@link CheckRole}アノテーションの情報を抽出する。
そして、抽出した情報をログにデバッグレベルで出力する。<br>
これは、アクションメソッドへの{@link CheckRole}の設定が設計通りになっているかを
確認することを目的とした機能となる。
</p>
<p>
このクラスは、まず{@code targetPackage}で指定されたパッケージ配下を再帰的に走査し、
処理対象の候補となるクラスを発見する。
次に、発見したクラスの完全修飾名が{@code targetClassPattern}で指定された正規表現に
一致するかどうかを確認し、一致する場合は対象のクラスとして処理する。<br>
そして、処理対象となったクラスから、そのクラスで宣言された{@code public}メソッドの情報が抽出される
（親クラスで宣言されたメソッドは対象にならない）。
抽出されたメソッドからは、以下の情報が取り出されてログに出力される。
</p>
<ul>
  <li>クラスの完全修飾名({@code Class.getName()}で取得できる値)</li>
  <li>シグネチャ(メソッド名と引数の型の並び)</li>
  <li>{@link CheckRole}アノテーションの {@code value} に設定された値(未設定の場合は空)</li>
  <li>{@link CheckRole}アノテーションの {@code anyOf} に設定された値(未設定の場合は空)</li>
</ul>
<p>
このクラスは{@link Initializable}を実装しており、アプリケーション起動時の初期化のタイミングで
ログを出力する。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### LINE_SEP

```java
private static final String LINE_SEP
```

行の区切り文字。

---

### SEP

```java
private static final String SEP
```

要素の区切り文字。

---

### TITLE

```java
private static final String TITLE
```

ログのタイトル。

---

### HEADER

```java
private static final String HEADER
```

ログのヘッダー。

---

### targetPackage

```java
private String targetPackage
```

---

### targetClassPattern

```java
private String targetClassPattern
```

---

## メソッドの詳細

### initialize

```java
public void initialize()
```

---

### findTargetMethods

```java
private List<Method> findTargetMethods()
```

出力対象のメソッドを抽出する。

**戻り値:**
出力対象のメソッド一覧

---

### formatMethodSettings

```java
private List<String> formatMethodSettings(List<Method> targetMethods)
```

各メソッドに設定された{@link CheckRole}の情報をログ出力用にフォーマットする。

**パラメータ:**
- `targetMethods` - 出力対象のメソッド一覧

**戻り値:**
各メソッドの設定をフォーマットしたログメッセージ一覧

---

### setTargetPackage

```java
public void setTargetPackage(String targetPackage)
```

走査対象となるパッケージの名前を設定する。

**パラメータ:**
- `targetPackage` - 走査対象となるパッケージの名前

---

### setTargetClassPattern

```java
public void setTargetClassPattern(String targetClassPattern)
```

処理対象となるクラスを特定するための正規表現を設定する。
<p>
この正規表現は、クラスの完全修飾名に対して適用される。<br>
デフォルトは {@code ^.*Action$} が設定されている({@code "Action"}で終わるクラスが対象)。
</p>

**パラメータ:**
- `targetClassPattern` - 処理対象となるクラスを特定するための正規表現

---
