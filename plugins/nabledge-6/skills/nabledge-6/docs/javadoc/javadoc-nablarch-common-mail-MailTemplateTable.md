# class MailTemplateTable

**パッケージ:** nablarch.common.mail

**実装されたインタフェース:**
- Initializable

---

```java
public class MailTemplateTable
implements Initializable
```

メールテンプレート管理テーブルのスキーマ情報を保持するデータオブジェクト。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### tableName

```java
private String tableName
```

テーブル名

---

### mailTemplateIdColumnName

```java
private String mailTemplateIdColumnName
```

メールテンプレートIDにのカラム名

---

### langColumnName

```java
private String langColumnName
```

言語のカラム名

---

### subjectColumnName

```java
private String subjectColumnName
```

件名のカラム名

---

### mailBodyColumnName

```java
private String mailBodyColumnName
```

メール本文のカラム名

---

### charsetColumnName

```java
private String charsetColumnName
```

文字セットのカラム名

---

### findSql

```java
private String findSql
```

メールテンプレートを取得するSQL

---

## メソッドの詳細

### setTableName

```java
public void setTableName(String tableName)
```

メールテンプレート管理テーブルの名前を設定する。

**パラメータ:**
- `tableName` - メールテンプレート管理テーブルの名前

---

### setMailTemplateIdColumnName

```java
public void setMailTemplateIdColumnName(String mailTemplateIdColumnName)
```

メールテンプレート管理テーブルのテンプレートIDカラムの名前を設定する。

**パラメータ:**
- `mailTemplateIdColumnName` - メールテンプレート管理テーブルのテンプレートIDカラムの名前

---

### setLangColumnName

```java
public void setLangColumnName(String langColumnName)
```

メールテンプレート管理テーブルの言語カラムの名前を設定する。

**パラメータ:**
- `langColumnName` - メールテンプレート管理テーブルの言語カラムの名前

---

### setSubjectColumnName

```java
public void setSubjectColumnName(String subjectColumnName)
```

メールテンプレート管理テーブルの件名カラムの名前を設定する。

**パラメータ:**
- `subjectColumnName` - メールテンプレート管理テーブルの件名カラムの名前

---

### setMailBodyColumnName

```java
public void setMailBodyColumnName(String mailBodyColumnName)
```

メールテンプレート管理テーブルの本文カラムの名前を設定する。

**パラメータ:**
- `mailBodyColumnName` - メールテンプレート管理テーブルの本文カラムの名前

---

### setCharsetColumnName

```java
public void setCharsetColumnName(String charsetColumnName)
```

メールテンプレート管理テーブルの文字セットカラムの名前を設定する。

**パラメータ:**
- `charsetColumnName` - メールテンプレート管理テーブルの文字セットカラムの名前

---

### find

```java
public MailTemplateTable.MailTemplate find(String templateId, String lang)
```

メールテンプレート情報を取得する。

**パラメータ:**
- `templateId` - メールテンプレートID
- `lang` - 言語

**戻り値:**
取得したテンプレート情報

---

### initialize

```java
public void initialize()
```

SQLを初期化する。

---
