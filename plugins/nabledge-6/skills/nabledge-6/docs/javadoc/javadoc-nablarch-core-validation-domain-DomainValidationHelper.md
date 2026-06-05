# class DomainValidationHelper

**パッケージ:** nablarch.core.validation.domain

---

```java
public class DomainValidationHelper
```

ドメイン定義によるバリデーションをサポートするヘルパークラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### domainAnnotation

```java
private Class<? extends Annotation> domainAnnotation
```

ドメインを表すアノテーションのクラス

---

## メソッドの詳細

### setDomainAnnotation

```java
public void setDomainAnnotation(String fqcn)
```

PJ毎に作成するドメインを表すアノテーションのFQCNを設定する。
<p/>
「ドメイン定義を表すEnum」と「ドメインを表すアノテーション」を1対1でPJ毎に作成し、
本プロパティに「ドメインを表すアノテーション」のFQCNを設定する。

**パラメータ:**
- `fqcn` - PJ毎に作成するドメインを表すアノテーションのFQCN

---

### getDomainAnnotation

```java
public Class<? extends Annotation> getDomainAnnotation()
```

ドメインを表すアノテーションのクラスを取得する。
<p/>
ドメインを表すアノテーションのクラスが設定されていない場合は、{@link IllegalStateException}を送出する。

**戻り値:**
ドメインを表すアノテーションのクラス

---

### isDomainAnnotation

```java
public boolean isDomainAnnotation(Annotation annotation)
```

指定されたアノテーションがドメインを表すアノテーションであるか否かを判定する。

**パラメータ:**
- `annotation` - アノテーション

**戻り値:**
指定されたアノテーションがドメインを表すアノテーションである場合はtrue、それ以外はfalse

---

### getConvertorAnnotation

```java
public Annotation getConvertorAnnotation(Annotation annotation)
```

ドメイン定義に指定されたコンバータのアノテーションを取得する。

**パラメータ:**
- `annotation` - ドメインを表すアノテーション

**戻り値:**
ドメイン定義に指定されたコンバータのアノテーション。コンバータのアノテーションが指定されていない場合はnull

---

### getValidatorAnnotations

```java
public List<Annotation> getValidatorAnnotations(Annotation annotation)
```

ドメイン定義に指定されたバリデータのアノテーションを取得する。

**パラメータ:**
- `annotation` - ドメインを表すアノテーション

**戻り値:**
ドメイン定義に指定されたバリデータのアノテーション

---

### getDomainDefinition

```java
protected DomainDefinition getDomainDefinition(Annotation annotation)
```

アノテーションのvalue属性に指定された値を取得する。
<p/>
アノテーションの属性に指定された値が取得できない場合は、 {@link IllegalArgumentException}を送出する。

**パラメータ:**
- `annotation` - アノテーション

**戻り値:**
アノテーションのvalue属性に指定された値

---

### getConvertorAnnotation

```java
public static Annotation getConvertorAnnotation(Enum<?> domainEnum)
```

ドメイン定義に指定されたコンバータのアノテーションを取得する。
<p/>
{@link DomainDefinition#getConvertorAnnotation()}の実装にて本メソッドを使用する。
実装例を以下に示す。
<pre>
public Annotation getConvertorAnnotation() {
    return DomainValidationHelper.getConvertorAnnotation(this);
}
</pre>

**パラメータ:**
- `domainEnum` - ドメイン定義

**戻り値:**
ドメイン定義に指定されたコンバータのアノテーション。コンバータのアノテーションが指定されていない場合はnull

---

### getValidatorAnnotations

```java
public static List<Annotation> getValidatorAnnotations(Enum<?> domainEnum)
```

ドメイン定義に指定されたバリデータのアノテーションを取得する。
<p/>
{@link DomainDefinition#getValidatorAnnotations()}の実装にて本メソッドを使用する。
実装例を以下に示す。
<pre>
public List<Annotation> getValidatorAnnotations() {
    return DomainValidationHelper.getValidatorAnnotations(this);
}
</pre>

**パラメータ:**
- `domainEnum` - ドメイン定義

**戻り値:**
ドメイン定義に指定されたバリデータのアノテーション

---

### getAnnotations

```java
private static List<Annotation> getAnnotations(Enum<?> targetEnum, Class<? extends Annotation> targetAnnotationClass)
```

Enumに指定されたアノテーションを取得する。

**パラメータ:**
- `targetEnum` - Enum
- `targetAnnotationClass` - 取得対象のアノテーションを表すクラス

**戻り値:**
Enumに指定されたアノテーション

---
