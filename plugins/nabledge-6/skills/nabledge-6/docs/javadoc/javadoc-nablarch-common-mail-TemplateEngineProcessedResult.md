# class TemplateEngineProcessedResult

**パッケージ:** nablarch.common.mail

---

```java
public class TemplateEngineProcessedResult
```

テンプレートエンジンで処理した結果を保持するクラス。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### DEFAULT_DELIMITER

```java
public static final String DEFAULT_DELIMITER
```

---

### subject

```java
private final String subject
```

件名

---

### mailBody

```java
private final String mailBody
```

本文

---

### charset

```java
private final String charset
```

文字セット

---

## コンストラクタの詳細

### TemplateEngineProcessedResult

```java
public TemplateEngineProcessedResult(String subject, String mailBody, String charset)
```

{@link TemplateEngineProcessedResult}のインスタンスを生成する。

**パラメータ:**
- `subject` - 件名
- `mailBody` - 本文
- `charset` - 文字セット

---

## メソッドの詳細

### valueOf

```java
public static TemplateEngineProcessedResult valueOf(String value)
```

ルールに則って文字列を件名と本文に分割して{@link TemplateEngineProcessedResult}のインスタンスを生成するファクトリーメソッド。

<p>
これは{@link #DEFAULT_DELIMITER デフォルトのデリミタ}を指定して{@link #valueOf(String, String)}を呼び出すショートカットである。
</p>

**パラメータ:**
- `value` - 件名と本文を含む文字列

**戻り値:**
件名と本文がセットされたインスタンス

---

### valueOf

```java
public static TemplateEngineProcessedResult valueOf(String value, String delimiter)
                                      throws IllegalArgumentException
```

テンプレートエンジンで処理済みの文字列を件名と本文に分割して{@link TemplateEngineProcessedResult}のインスタンスを生成するファクトリーメソッド。

<p>
文字列はデリミタによって件名と本文に分割される。
基本的なルールは次の通り。
</p>

<ol>
<li>デリミタは引数{@code delimiter}で表される文字列だけからなる行とする（つまり前後に余計な文字を含むものはデリミタとみなさない）</li>
<li>デリミタより前にある行は件名とみなす</li>
<li>デリミタより後の文字列をすべて本文とみなす</li>
</ol>

<p>
例えば、このファクトリーメソッドに次のような文字列が渡されたとする。
</p>

<pre>{@code テスト件名
---
テスト本文１
テスト本文２
テスト本文３
}</pre>

<p>
デリミタが{@literal "---"}である場合、{@code テスト件名}が件名となり、{@code テスト本文１}以降が本文となる。
</p>

<p>
デリミタよりも前、件名を期待するエリアでは空行は無視される。
つまり、次のような文字列は有効である。
</p>

<pre>{@code
テスト件名


---
テスト本文１
テスト本文２
テスト本文３
}</pre>

<p>
デリミタよりも後、本文を構成するエリアでは空行も無視されずそのまま本文として扱われる。
</p>

<p>
なお、このファクトリーメソッドでは文字セットは設定されない。
</p>

**パラメータ:**
- `value` - 件名とデリミタと本文を含む文字列
- `delimiter` - 件名と本文を分けるデリミタ

**戻り値:**
件名と本文がセットされたインスタンス

**例外:**
- `IllegalArgumentException` - 次のいずれかの場合に投げられる。
         <ul>
         <li>デリミタが含まれない場合</li>
         <li>件名が無い場合</li>
         <li>件名が改行を含んで複数行に渡っている場合</li>
         <li>本文が無い場合</li>
         </ul>

---

### getSubject

```java
public String getSubject()
```

件名を取得する。

**戻り値:**
件名

---

### getMailBody

```java
public String getMailBody()
```

本文を取得する。

**戻り値:**
本文

---

### getCharset

```java
public String getCharset()
```

文字セットを取得する。

**戻り値:**
文字セット

---
