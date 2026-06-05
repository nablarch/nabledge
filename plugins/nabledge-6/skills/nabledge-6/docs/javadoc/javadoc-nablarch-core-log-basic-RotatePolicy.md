# interface RotatePolicy

**パッケージ:** nablarch.core.log.basic

---

```java
public interface RotatePolicy
```

ログのローテーションを行うインタフェース。<br>
ログのローテーションの種類毎に本インタフェースの実装クラスを作成する。

**作成者:** Kotaro Taki  

---

## メソッドの詳細

### initialize

```java
void initialize(ObjectSettings settings)
```

初期処理を行う。

**パラメータ:**
- `settings` - LogWriterの設定

---

### needsRotate

```java
boolean needsRotate(String message, Charset charset)
```

ローテーションが必要かの判定を行う。

**パラメータ:**
- `message` - ログファイルに書き込まれるメッセージ
- `charset` - 書き込み時に使用する文字エンコーディング

**戻り値:**
ローテーションが必要な場合はtrue

---

### decideRotatedFilePath

```java
String decideRotatedFilePath()
```

ローテーション先のファイル名を決定する。

**戻り値:**
ローテーション先のファイル名

---

### rotate

```java
void rotate(String rotatedFilePath)
```

ローテーションを行う。

**パラメータ:**
- `rotatedFilePath` - ローテーション先のファイルパス

---

### getSettings

```java
String getSettings()
```

ログファイル読み込み時に出力する、ローテーションの設定情報を返す。<br>

**戻り値:**
設定情報

---

### onWrite

```java
void onWrite(String message, Charset charset)
```

ログファイル書き込み時に発生するイベント。<br>
ファイルサイズによるローテーションなどを独自で実装したい場合に使用する。

**パラメータ:**
- `message` - ログファイルに書き込まれるメッセージ
- `charset` - 書き込み時に使用する文字エンコーディング

---

### onOpenFile

```java
void onOpenFile(File file)
```

ログファイル読み込み時に発生するイベント。<br>
ファイルサイズによるローテーションなどを独自で実装したい場合に使用する。

**パラメータ:**
- `file` - 読み込まれたファイル

---
