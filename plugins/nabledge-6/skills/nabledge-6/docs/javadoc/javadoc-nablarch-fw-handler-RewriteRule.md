# class RewriteRule

**パッケージ:** nablarch.fw.handler

---

```java
public abstract class RewriteRule
```

置換ルール。

**param:** 処理対象オブジェクトの型  
**param:** 継承型  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### COND_LINE_FORMAT

```java
private static final Pattern COND_LINE_FORMAT
```

記述書式

---

### pattern

```java
private Pattern pattern
```

処理対象パターン

---

### rewriteTo

```java
private String rewriteTo
```

置換先文字列

---

### conditions

```java
private final List<Condition> conditions
```

適用条件

---

### exports

```java
private final List<Export> exports
```

変数定義

---

### PLACE_HOLDER

```java
private static final Pattern PLACE_HOLDER
```

埋め込み変数のプレースホルダー

---

## メソッドの詳細

### getPathToRewrite

```java
protected abstract String getPathToRewrite(TData data)
```

書き換え対象のパスを取得する。

**パラメータ:**
- `data` - 処理対象オブジェクト

**戻り値:**
書き換え対象パス文字列

---

### applyRewrittenPath

```java
protected abstract void applyRewrittenPath(String rewrittenPath, TData data)
```

書き換えられたパスを処理対象オブジェクトに反映する。

**パラメータ:**
- `rewrittenPath` - 書き換えられたパス
- `data` - 処理対象オブジェクト

---

### getParam

```java
protected Object getParam(String scope, String name, TData data, ExecutionContext context)
```

変数の値を返す。

この実装では、以下の変数種別に対応する。
<pre>
----------- ------------------------
種別名       内容
----------- ------------------------
request     リクエストスコープ変数
session     セッションスコープ変数
thread      スレッドコンテキスト変数
----------- ------------------------
</pre>
なお、該当する変数が定義されていなかった場合はnullを返す。

**パラメータ:**
- `scope` - 変数種別
- `name` - 変数名
- `data` - 処理対象オブジェクト
- `context` - 実行コンテキスト

**戻り値:**
変数の値

---

### exportParam

```java
protected void exportParam(String scope, String name, String value, TData data, ExecutionContext context)
```

変数を定義する。

**パラメータ:**
- `scope` - 変数種別
- `name` - 変数名
- `value` - 変数の値
- `data` - 処理対象オブジェクト
- `context` - 実行コンテキスト

---

### rewrite

```java
public String rewrite(TData data, ExecutionContext context)
```

このオブジェクトの設定に従ってパスの置換処理をおこない、
置換後のパス文字列を返す。
置換処理が行われなかった場合はnullを返す。

**パラメータ:**
- `data` - 処理対象オブジェクト
- `context` - 実行コンテキスト

**戻り値:**
置換処理が行われた場合は置換後の文字列。
         行われなかった場合はnull。

---

### interpolate

```java
private String interpolate(String str, Map<String,List<String>> backRefs, TData data, ExecutionContext context)
```

埋め込み文字列を反映する。

**パラメータ:**
- `str` - 処理対象文字列
- `backRefs` - バックリファレンス
- `data` - 処理対象オブジェクト
- `context` - 実行コンテキスト

**戻り値:**
処理結果文字列

---

### setPattern

```java
public TSelf setPattern(String pattern)
```

この置換ルールが適用されるパスのパターンを正規表現で設定する。

**パラメータ:**
- `pattern` - この置換ルールが適用されるパスのパターン

**戻り値:**
このオブジェクト自体

---

### setRewriteTo

```java
public TSelf setRewriteTo(String rewriteTo)
```

この置換ルールが適用された場合に置き換えられる文字列を指定する。
この文字列中では、以下の埋め込みパラメータを使用することができる。

**パラメータ:**
- `rewriteTo` - この置換ルールが適用された場合に置き換えられる文字列

**戻り値:**
このオブジェクト自体

---

### setExports

```java
public TSelf setExports(List<String> exportDefinitions)
```

変数定義を設定する。

既存の設定はクリアされる。

**パラメータ:**
- `exportDefinitions` - 変数定義

**戻り値:**
このオブジェクト自体

---

### addExport

```java
public TSelf addExport(String exportDefinition)
```

リクエストスコープ変数定義を追加する。

同名の変数が既に定義されていた場合は上書きする。

**パラメータ:**
- `exportDefinition` - 変数名

**戻り値:**
このオブジェクト自体

---

### setConditions

```java
public TSelf setConditions(List<String> conditions)
```

置換処理の適用条件を設定する。

既存の設定はクリアされる。

**パラメータ:**
- `conditions` - 適用条件

**戻り値:**
このオブジェクト自体

---

### addCondition

```java
public TSelf addCondition(String condition)
```

置換処理の適用条件を追加する。

**パラメータ:**
- `condition` - 適用条件

**戻り値:**
このオブジェクト自体

---
