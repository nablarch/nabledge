# class JaxbBodyConverter

**パッケージ:** nablarch.fw.jaxrs

**継承階層:**
```
java.lang.Object
  └─ BodyConverterSupport
      └─ nablarch.fw.jaxrs.JaxbBodyConverter
```

---

```java
public class JaxbBodyConverter
extends BodyConverterSupport
```

JAXBを使用してリクエスト/レスポンスの変換を行う{@link BodyConverter}実装クラス。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### JAXB_CONTEXT_MAP

```java
private static final Map<Class<?>,JAXBContext> JAXB_CONTEXT_MAP
```

{@link JAXBContext}のキャッシュ

---

## メソッドの詳細

### convertRequest

```java
protected Object convertRequest(HttpRequest request, ExecutionContext context)
```

---

### convertResponse

```java
protected HttpResponse convertResponse(Object response, ExecutionContext context)
```

---

### isConvertible

```java
public boolean isConvertible(String mediaType)
```

---

### getJAXBContext

```java
private JAXBContext getJAXBContext(Class<?> beanClass)
                           throws JAXBException
```

Beanクラスに対応した{@link JAXBContext}を取得する。
<p/>
キャッシュ上に{@link JAXBContext}情報が存在する場合はその情報を返す。
まだキャッシュされていない場合には、{@link JAXBContext}を生成しキャッシュに格納する。

**パラメータ:**
- `beanClass` - Beanクラス

**戻り値:**
Beanクラスに対応した{@link JAXBContext}

**例外:**
- `JAXBException` - {@link JAXBContext}の生成に失敗した場合

---

### configure

```java
protected void configure(Marshaller marshaller)
               throws JAXBException
```

{@link Marshaller}に対するオプション設定を行う。
<p/>
このクラスではデフォルトで以下の設定でXMLの生成を行う。
設定を変更したい場合はサブクラス側で行う必要がある。

<ul>
    <li>改行、インデントを使用した形式にフォーマットする。</li>
    <li>
        文字コードはリソースメソッドの{@link javax.ws.rs.Produces}に設定された文字コードを使用する。<br/>
        文字コードが設定されていない場合はデフォルトエンコーディングを使用する。
    </li>
</ul>

**パラメータ:**
- `marshaller` - {@link Marshaller}

**例外:**
- `JAXBException` - オプション設定に失敗した場合

---

### configure

```java
protected void configure(Unmarshaller unmarshaller)
               throws JAXBException
```

{@link Unmarshaller}に対するオプション設定を行う。
<p/>
このクラスでは特に何も行わないので、オプション設定はサブクラス側で行う必要がある。

**パラメータ:**
- `unmarshaller` - {@link Unmarshaller}

**例外:**
- `JAXBException` - オプション設定に失敗した場合

---
