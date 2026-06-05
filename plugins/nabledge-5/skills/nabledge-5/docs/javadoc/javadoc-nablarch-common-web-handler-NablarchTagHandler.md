# class NablarchTagHandler

**パッケージ:** nablarch.common.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class NablarchTagHandler
implements HttpRequestHandler
```

Nablarchのカスタムタグ機能に必要なリクエスト処理を行うハンドラ。<br>
このハンドラは、1リクエストにつき一度だけ下記の処理を行う。
内部フォワードにより1リクエストにつき複数回呼ばれても初回のみ処理を行う。
<ul>
<li>ボタン又はリンク毎のパラメータ変更機能を実現するために、リクエストに変更パラメータを設定する。</li>
<li>リクエストにcheckboxタグのチェックなしに対応する値を設定する。</li>
<li>hiddenタグの暗号化機能に対応する改竄チェックと復号を行う。</li>
<li>HTTPアクセスログのリクエストパラメータを出力する。</li>
<li>カスタムタグのデフォルト値をJSPで参照できるように、{@link nablarch.common.web.tag.CustomTagConfig}をリクエストスコープに設定する。</li>
</ul>
改竄チェックと復号は、カスタムタグのデフォルト値設定において、hiddenタグの暗号化機能を「使用する」に設定している場合のみ処理を行う。
hiddenタグの暗号化機能を「使用しない」に設定している場合は、何もせずに次のハンドラに処理を委譲する。
さらに、カスタムタグのデフォルト値設定の暗号化を行わないリクエストIDに現在のリクエストIDが含まれる場合は、
改竄チェックと復号を行わずに次のハンドラに処理を委譲する。
<br>
このハンドラを使用する場合は、改竄を検知した場合に遷移する画面とステータスを必ずプロパティで指定する必要がある。
<br><br>
HTTPアクセスログの出力は、{@link HttpAccessLogUtil}に委譲する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### DECRYPTED_PARAMS

```java
public static final String DECRYPTED_PARAMS
```

復号したリクエストパラメータをリクエストスコープに設定する属性名

---

### CUSTOM_TAG_CONFIG_KEY

```java
public static final String CUSTOM_TAG_CONFIG_KEY
```

{@link CustomTagConfig}をリクエストスコープに格納する際に使用するキー

---

### path

```java
private String path
```

改竄を検知した場合に送信する画面のリソースパス

---

### sessionExpirePath

```java
private String sessionExpirePath
```

セッションから情報が取得出来なかった場合に表示する画面のリソースパス

---

### statusCode

```java
private int statusCode
```

改竄を検知した場合のレスポンスステータス

---

### sessionExpireStatusCode

```java
private int sessionExpireStatusCode
```

セッションから情報が取得出来なかった場合のレスポンスステータス

---

## メソッドの詳細

### setPath

```java
public void setPath(String path)
```

改竄を検知した場合に送信する画面のリソースパスを設定する。

**パラメータ:**
- `path` - 改竄を検知した場合に送信する画面のリソースパス

---

### setSessionExpirePath

```java
public void setSessionExpirePath(String sessionExpirePath)
```

セッションから暗号化鍵情報が取得出来なかった場合に表示する画面のリソースパスを設定する。 <br />
この値を設定しなかった場合、 path プロパティに設定した改竄エラー画面が表示される。

**パラメータ:**
- `sessionExpirePath` - セッションから情報が取得出来なかった場合に表示する画面のリソースパス

---

### setStatusCode

```java
public void setStatusCode(int statusCode)
```

改竄を検知した場合のレスポンスステータスを設定する。<br>
デフォルトは400。

**パラメータ:**
- `statusCode` - 改竄を検知した場合のレスポンスステータス

---

### setSessionExpireStatusCode

```java
public void setSessionExpireStatusCode(int sessionExpireStatusCode)
```

セッションから情報が取得出来なかった場合のレスポンスステータスを設定する。

**パラメータ:**
- `sessionExpireStatusCode` - セッションから情報が取得出来なかった場合のレスポンスステータス

---

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

{@inheritDoc}<br>
<br>
1リクエストにつき一度だけ下記の処理を順に行う。
内部フォワードにより1リクエストにつき複数回呼ばれても初回のみ処理を行う。
<ul>
<li>リクエストに変更パラメータを設定する。</li>
<li>"nablarch_tag_config"という変数名でリクエストスコープに{@link nablarch.common.web.tag.CustomTagConfig}を設定する。</li>
<li>hiddenタグの値を復号し、リクエストパラメータに設定する。
復号では、改竄チェックを行い、改竄を検知した場合は指定された画面に遷移する。
復号が成功した場合は、次のハンドラに処理を委譲する。
復号処理は、{@link HiddenEncryptionUtil#decryptHiddenValues(ExecutionContext, String)}に移譲する。</li>
<li>HTTPアクセスログのリクエストパラメータを出力する。</li>
</ul>

---

### restoreKeyValueSet

```java
protected void restoreKeyValueSet(HttpRequest request)
```

複合キーの値を復元する。

**パラメータ:**
- `request` - {@link HttpRequest}

---

### isDecryptionRequired

```java
private boolean isDecryptionRequired(HttpRequest request, CustomTagConfig config)
```

hiddenタグの暗号化機能に対応する復号を行うか否かを判定する。
<p/>
hidden暗号化機能を使用する設定になっている場合、
かつ現在のリクエストIDが暗号化しないリクエストID設定に含まれない場合にtrueを返す。

**パラメータ:**
- `config` - カスタムタグ設定
- `request` - HTTPリクエストオブジェクト

**戻り値:**
復号を行う場合はtrue

---

### writeParametersLog

```java
protected void writeParametersLog(HttpRequest request, ExecutionContext context)
                        throws ClassCastException
```

HTTPアクセスログのリクエストパラメータを出力する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}

**例外:**
- `ClassCastException` - context の型がServletExecutionContext で無い場合。

---

### setNablarchHiddenValueToRequest

```java
private void setNablarchHiddenValueToRequest(HttpRequest request, String submitName, Map<String,List<String>> params)
```

nablarch_hiddenパラメータをリクエストに設定する。

**パラメータ:**
- `request` - リクエスト
- `submitName` - サブミットされた要素のname属性
- `params` - nablarch_hiddenパラメータ

---

### setCheckboxOffValueToRequest

```java
private void setCheckboxOffValueToRequest(HttpRequest request)
```

checkboxタグのチェックなしに対応する値をリクエストに設定する。

**パラメータ:**
- `request` - リクエスト

---

### getNablarchHiddenValue

```java
private String getNablarchHiddenValue(HttpRequest request)
```

nablarch_hiddenパラメータの値を取得する。

**パラメータ:**
- `request` - リクエスト

**戻り値:**
nablarch_hiddenパラメータの値。有効な値が存在しない場合はnull

---

### getSubmitName

```java
private String getSubmitName(HttpRequest request)
```

サブミットされた要素のname属性を取得する。

**パラメータ:**
- `request` - リクエスト

**戻り値:**
サブミットされた要素のname属性。有効な値が存在しない場合はnull

---
