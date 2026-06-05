# class UploadSettings

**パッケージ:** nablarch.fw.web.upload

---

```java
public class UploadSettings
```

ファイルアップロードに関する各種設定値を保持するクラス。<br/>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### UPLOAD_FILE_TMP_DIR

```java
static final String UPLOAD_FILE_TMP_DIR
```

アップロードファイル一時保存ディレクトリ

---

### DEFAULT_SAVE_DIR

```java
private static final File DEFAULT_SAVE_DIR
```

デフォルトの一時保存ディレクトリ

---

### contentLengthLimit

```java
private int contentLengthLimit
```

許容するContent-Lengthの最大値

---

### maxFileCount

```java
private int maxFileCount
```

許容するファイル数の最大値

---

### autoCleaning

```java
private boolean autoCleaning
```

ファイルの自動クリーニングを行うかどうか

---

## メソッドの詳細

### getSaveDir

```java
File getSaveDir()
```

保存ディレクトリを取得する。<br/>
保存ディレクトリの物理パスは{@link FilePathSetting}から取得する。
{@link FilePathSetting}に指定されていない場合、
テンポラリディレクトリ("java.io.tmpdir")を使用する。

**戻り値:**
保存ディレクトリ

---

### getContentLengthLimit

```java
public int getContentLengthLimit()
```

Content-Length許容最大値を取得する。

**戻り値:**
Content-Length許容最大値

---

### setContentLengthLimit

```java
public void setContentLengthLimit(int contentLengthLimit)
```

Content-Length許容最大値を設定する。

**パラメータ:**
- `contentLengthLimit` - Content-Length許容最大値

---

### getMaxFileCount

```java
public int getMaxFileCount()
```

アップロードファイル数の上限を取得する。

**戻り値:**
アップロードファイル数の上限

---

### setMaxFileCount

```java
public void setMaxFileCount(int maxFileCount)
```

アップロードファイル数の上限を設定する。
<p>
0以下の値を設定した場合は無制限となる。
デフォルトは-1。
</p>

**パラメータ:**
- `maxFileCount` - アップロードファイル数の上限

---

### isAutoCleaning

```java
public boolean isAutoCleaning()
```

自動クリーニングを行うかどうか。

**戻り値:**
自動クリーニングする場合は、真（デフォルトは真）

---

### setAutoCleaning

```java
public void setAutoCleaning(boolean autoCleaning)
```

自動クリーニング要否を設定する。

**パラメータ:**
- `autoCleaning` - 自動クリーニング要否

---
