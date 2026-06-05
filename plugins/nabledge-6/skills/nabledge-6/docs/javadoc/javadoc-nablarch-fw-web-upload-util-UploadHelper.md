# class UploadHelper

**パッケージ:** nablarch.fw.web.upload.util

---

```java
public class UploadHelper
```

アップロードファイルに対する定型処理を提供するユーティリティクラス。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### partInfo

```java
private final PartInfo partInfo
```

処理対象のPart

---

## コンストラクタの詳細

### UploadHelper

```java
public UploadHelper(PartInfo partInfo)
```

{@code UploadHelper}を生成する。

**パラメータ:**
- `partInfo` - 処理対象の{@link PartInfo}オブジェクト

---

## メソッドの詳細

### moveFileTo

```java
public void moveFileTo(String basePathName, String fileName)
```

アップロードされたファイルを移動する。

**パラメータ:**
- `basePathName` - {@link FilePathSetting}のベースパス論理名
- `fileName` - 移動後のファイル名

---

### applyFormat

```java
public BulkValidator applyFormat(String layoutFileName)
```

フォーマットを適用する。
フォーマット定義ファイル取得先のディレクトリはデフォルト設定を使用する。

**パラメータ:**
- `layoutFileName` - フォーマット定義ファイル名

**戻り値:**
一括バリデーションクラス

**例外:**
- `IllegalStateException` - フォーマット適用に失敗した場合

---

### applyFormat

```java
public BulkValidator applyFormat(String basePathName, String layoutFileName)
```

フォーマットを適用する。

**パラメータ:**
- `basePathName` - {@link FilePathSetting}のベースパス論理名
- `layoutFileName` - フォーマット定義ファイル名

**戻り値:**
一括バリデーションクラス

**例外:**
- `IllegalStateException` - フォーマット適用に失敗した場合

---

### createApplyFormatException

```java
private IllegalStateException createApplyFormatException(String basePathName, String layoutFileName, File layoutFile, Throwable e)
```

applyFormat に失敗した際に送出する例外を作成する。

**パラメータ:**
- `basePathName` - フォーマットファイルのベースパス名
- `layoutFileName` - フォーマットファイルの論理名
- `layoutFile` - フォーマットファイル
- `e` - 元例外

**戻り値:**
applyFormat に失敗した際に送出する例外

---

### getLayoutFile

```java
private File getLayoutFile(String basePathName, String layoutFileName)
```

フォーマット定義ファイルを取得する。

**パラメータ:**
- `basePathName` - FilePathSettingのベースパス論理名
- `layoutFileName` - フォーマット定義ファイル名

**戻り値:**
フォーマット定義ファイル

---

### toByteArray

```java
public byte[] toByteArray()
```

ファイルをバイト配列に変換する。
</p>
入力ストリームが必要な場合は、{@link nablarch.fw.web.upload.PartInfo#getInputStream()}を使用すること。

**戻り値:**
バイト配列

---

### logContentOfUploaded

```java
private void logContentOfUploaded()
```

アップロードファイルの中身をログ出力する。

---
