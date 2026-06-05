# class AsyncMessageSendActionSettings

**パッケージ:** nablarch.fw.messaging.action

---

```java
public class AsyncMessageSendActionSettings
```

{@link AsyncMessageSendAction}用設定クラス。

**作成者:** hisaaki sioiri  

---

## フィールドの詳細

### sqlFilePackage

```java
private String sqlFilePackage
```

SQLファイル配置パッケージ

---

### queueName

```java
private String queueName
```

送信キュー名称

---

### headerFormatName

```java
private String headerFormatName
```

ヘッダフォーマット名

---

### formatDir

```java
private String formatDir
```

フォーマット定義ファイルの格納ディレクトリ(論理名)

---

### transactionName

```java
private String transactionName
```

トランザクション名

---

### formClassName

```java
private String formClassName
```

Formクラス名

---

### headerItemList

```java
private List<String> headerItemList
```

ヘッダに格納する項目名のリスト

---

## メソッドの詳細

### getSqlFilePackage

```java
public String getSqlFilePackage()
```

SQLファイルの配置パッケージを取得する。

**戻り値:**
SQLファイルの配置パッケージ

---

### setSqlFilePackage

```java
public void setSqlFilePackage(String sqlFilePackage)
```

SQLファイルの配置パッケージを設定する。

**パラメータ:**
- `sqlFilePackage` - SQLファイルの配置パッケージ

---

### getQueueName

```java
public String getQueueName()
```

送信キュー名称を設定する。

**戻り値:**
送信キュー名称

---

### setQueueName

```java
public void setQueueName(String queueName)
```

送信キュー名称を取得する。

**パラメータ:**
- `queueName` - 送信キュー名称

---

### getHeaderFormatName

```java
public String getHeaderFormatName()
```

ヘッダフォーマット名を取得する。

**戻り値:**
ヘッダフォーマット名

---

### setHeaderFormatName

```java
public void setHeaderFormatName(String headerFormatName)
```

ヘッダフォーマット名を設定する。

**パラメータ:**
- `headerFormatName` - ヘッダフォーマット名

---

### getFormatDir

```java
public String getFormatDir()
```

フォーマット定義ファイルの格納ディレクトリ(論理名)を取得する。

**戻り値:**
フォーマット定義ファイルの格納ディレクトリ(論理名)

---

### setFormatDir

```java
public void setFormatDir(String formatDir)
```

フォーマット定義ファイルの格納ディレクトリ(論理名)を設定する。

**パラメータ:**
- `formatDir` - フォーマット定義ファイルの格納ディレクトリ(論理名)

---

### setTransactionName

```java
public void setTransactionName(String transactionName)
```

トランザクション名を設定する。

**パラメータ:**
- `transactionName` - トランザクション名

---

### getTransactionName

```java
public String getTransactionName()
```

トランザクション名を取得する。

**戻り値:**
トランザクション名

---

### getFormClassName

```java
public String getFormClassName()
```

フォームクラス名を取得する。

**戻り値:**
フォームクラス名

---

### setFormClassName

```java
public void setFormClassName(String formClassName)
```

フォームクラス名を設定する。

**パラメータ:**
- `formClassName` - フォームクラス名

---

### setHeaderItemList

```java
public void setHeaderItemList(List<String> headerItemList)
```

ヘッダに設定する項目のリストを設定する。

**パラメータ:**
- `headerItemList` - ヘッダに設定する項目のリスト

---

### getHeaderItemList

```java
public List<String> getHeaderItemList()
```

ヘッダに設定する項目のリストを取得する。

**戻り値:**
ヘッダに設定する項目のリスト

---
