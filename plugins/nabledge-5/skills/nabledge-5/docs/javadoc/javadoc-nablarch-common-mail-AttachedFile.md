# class AttachedFile

**パッケージ:** nablarch.common.mail

---

```java
public class AttachedFile
```

メール添付ファイルの情報を保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### contentType

```java
private String contentType
```

メール添付ファイルのContent-Type

---

### file

```java
private File file
```

メール添付ファイル

---

## コンストラクタの詳細

### AttachedFile

```java
public AttachedFile(String contentType, File file)
```

メール添付ファイルのContent-Typeを指定し、AttachedFileオブジェクトを生成する。

**パラメータ:**
- `contentType` - メール添付ファイルのContent-Type
- `file` - メール添付ファイル

---

### AttachedFile

```java
public AttachedFile()
```

AttachedFileオブジェクトを生成する。

---

## メソッドの詳細

### getName

```java
public String getName()
```

メール添付ファイル名を取得する。

**戻り値:**
メール添付ファイル名

---

### getContentType

```java
public String getContentType()
```

メール添付ファイルのContent-Typeを取得する。

**戻り値:**
Content-Type

---

### setContentType

```java
public void setContentType(String contentType)
```

メール添付ファイルのContent-Typeを設定する。

**パラメータ:**
- `contentType` - Content-Type

---

### getFile

```java
public File getFile()
```

メール添付ファイルを取得する。

**戻り値:**
メール添付ファイル

---

### setFile

```java
public void setFile(File file)
```

メール添付ファイルを設定する。

**パラメータ:**
- `file` - メール添付ファイル

---
