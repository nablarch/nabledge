# class TimeZoneAttributeInHttpUtil

**パッケージ:** nablarch.common.web.handler.threadcontext

---

```java
public final class TimeZoneAttributeInHttpUtil
```

HTTP上で選択されたタイムゾーンの保持を行う際に使用するユーティリティクラス。

**関連項目:** TimeZoneAttributeInHttpSupport  
**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### TIMEZONE_ATTRIBUTE_COMPONENT_NAME

```java
private static final String TIMEZONE_ATTRIBUTE_COMPONENT_NAME
```

リポジトリから{@link TimeZoneAttributeInHttpSupport}を取得する際に使用するコンポーネント名。

---

## コンストラクタの詳細

### TimeZoneAttributeInHttpUtil

```java
private TimeZoneAttributeInHttpUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### keepTimeZone

```java
public static void keepTimeZone(HttpRequest request, ExecutionContext context, String timeZone)
```

指定されたタイムゾーンの保持とスレッドローカルへの設定を行う。
<p/>
指定されたタイムゾーンがサポート対象のタイムゾーンでない場合は処理を行わない。
<p/>
サポート対象は、{@link nablarch.core.repository.SystemRepository}から取得した{@link TimeZoneAttributeInHttpSupport}で
サポートされているタイムゾーンとなる。
<p/>
タイムゾーンの保持については、アプリケーションで使用する
{@link TimeZoneAttributeInHttpSupport}のサブクラスのJavadocを参照。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト
- `timeZone` - タイムゾーン

**例外:**
- `IllegalArgumentException` - リポジトリにサポート用コンポーネントが存在しなかった場合

---
