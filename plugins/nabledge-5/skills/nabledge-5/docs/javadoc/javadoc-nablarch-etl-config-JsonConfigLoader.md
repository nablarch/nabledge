# class JsonConfigLoader

**パッケージ:** nablarch.etl.config

**実装されたインタフェース:**
- EtlConfigLoader

---

```java
public class JsonConfigLoader
implements EtlConfigLoader
```

JSON形式のファイルに定義されたETLの設定をロードするクラス。
<p/>
"classpath:META-INF/etl-config/" 配下に置かれた "ジョブID.json" をロードする。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### configBasePath

```java
private String configBasePath
```

設定ファイルを配置するディレクトリのベースパス

---

### TYPE_REFERENCE

```java
private static final TypeReference<Map<String,StepConfig>> TYPE_REFERENCE
```

{@link ObjectMapper}でjsonからMapオブジェクトを生成する際に使用する型情報

---

## メソッドの詳細

### load

```java
public JobConfig load(JobContext jobContext)
```

設定ファイルから設定をロードする。

---

### setConfigBasePath

```java
public void setConfigBasePath(String configBasePath)
```

設定ファイルを配置するディレクトリのベースパスを設定する。
<p/>
パスの指定方法は{@link FileUtil#getResourceURL(String)}を参照。

**パラメータ:**
- `configBasePath` - ディレクトリのベースパス

---
