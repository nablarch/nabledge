# class OsEnvironmentVariableExternalizedLoader

**パッケージ:** nablarch.core.repository.di.config.externalize

**実装されたインタフェース:**
- ExternalizedComponentDefinitionLoader

---

```java
public class OsEnvironmentVariableExternalizedLoader
implements ExternalizedComponentDefinitionLoader
```

OS環境変数をコンポーネント定義として読み込む{@link ExternalizedComponentDefinitionLoader}。
<p/>
このローダーは、読み込み済みのコンポーネントの名前を元に、OS環境変数を検索する。<br/>
このとき、OS環境変数で使用できる文字種に制限があることを踏まえて、コンポーネント名を
次のように変換してから検索する。
<ol>
  <li>ドット({@code "."})とハイフン({@code "-"})をアンダーバー({@code "_"})に置換する</li>
  <li>小文字を大文字に変換する({@link String#toUpperCase()})</li>
</ol>
<p/>
つまり、{@code "foo-bar.fizz-buzz"}という名前のコンポーネントが存在した場合は、
{@code "FOO_BAR_FIZZ_BUZZ"}という名前でOS環境変数が検索されることになる。
<p/>
変換後の名前でOS環境変数が見つかった場合は、その値を{@code String}のコンポーネントとして読み込む。

**作成者:** Tomoyuki Tanaka  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

---

### env

```java
private final Map<String,String> env
```

---

## コンストラクタの詳細

### OsEnvironmentVariableExternalizedLoader

```java
public OsEnvironmentVariableExternalizedLoader()
```

コンストラクタ。

---

### OsEnvironmentVariableExternalizedLoader

```java
OsEnvironmentVariableExternalizedLoader(Map<String,String> env)
```

環境変数の{@link Map}を外部から指定するコンストラクタ。
<p/>
このコンストラクタは単体テスト用のため、アプリケーションのコードからは利用しないこと。

**パラメータ:**
- `env` - 環境変数の{@link Map}

---

## メソッドの詳細

### load

```java
public List<ComponentDefinition> load(DiContainer container, Map<String,ComponentHolder> loadedComponents)
```

---

### convertToEnvName

```java
private String convertToEnvName(String componentName)
```

コンポーネント名を、検索用のOS環境変数名に変換する。

**パラメータ:**
- `componentName` - コンポーネント名

**戻り値:**
変換後のOS環境変数名

---
