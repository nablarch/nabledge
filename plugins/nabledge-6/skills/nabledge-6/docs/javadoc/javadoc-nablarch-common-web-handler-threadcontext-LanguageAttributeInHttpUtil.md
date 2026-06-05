# class LanguageAttributeInHttpUtil

**パッケージ:** nablarch.common.web.handler.threadcontext

---

```java
public final class LanguageAttributeInHttpUtil
```

HTTP上で選択された言語の保持を行う際に使用するユーティリティクラス。
<p/>
{@link nablarch.core.repository.SystemRepository}から"languageAttribute"という名前で取得した{@link LanguageAttributeInHttpSupport}のサブクラスに処理を委譲する。
このため、本クラスを使用する場合は、{@link nablarch.core.repository.SystemRepository}に{@link LanguageAttributeInHttpSupport}のサブクラスを登録すること。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LANGUAGE_ATTRIBUTE_COMPONENT_NAME

```java
private static final String LANGUAGE_ATTRIBUTE_COMPONENT_NAME
```

リポジトリから{@link LanguageAttributeInHttpSupport}を取得する際に使用するコンポーネント名

---

## コンストラクタの詳細

### LanguageAttributeInHttpUtil

```java
private LanguageAttributeInHttpUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### keepLanguage

```java
public static void keepLanguage(HttpRequest request, ExecutionContext context, String language)
```

指定された言語の保持と{@link ThreadContext}への設定を行う。
<p/>
指定された言語がサポート対象外である場合は処理を行わない。
サポート対象言語とは、{@link HttpLanguageAttribute}で設定された言語である。
<p/>
言語の保持については、アプリケーションで使用する{@link LanguageAttributeInHttpSupport}のサブクラスのJavadocを参照。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト
- `language` - 言語

---
