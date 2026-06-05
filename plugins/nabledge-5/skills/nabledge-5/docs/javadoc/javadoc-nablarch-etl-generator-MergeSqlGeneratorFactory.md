# class MergeSqlGeneratorFactory

**パッケージ:** nablarch.etl.generator

---

```java
public final class MergeSqlGeneratorFactory
```

MERGE文のジェネレータのファクトリクラス。
<p>
{@link DatabaseMetaData#getURL()}を元に、接続さきデータベース製品を判断し、MERGE文のジェネレータを生成する。
<p>
MERGE文に対応するデータベースは以下の通り。
<ul>
<li>Oracle</li>
<li>H2</li>
<li>SQL Server</li>
<li>PostgreSQL</li>
<li>DB2</li>
</ul>

**作成者:** siosio  

---

## コンストラクタの詳細

### MergeSqlGeneratorFactory

```java
private MergeSqlGeneratorFactory()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### create

```java
public static MergeSqlGenerator create(TransactionManagerConnection connection)
```

MERGE文を生成するジェネレータを生成する。

**パラメータ:**
- `connection` - データベース接続

**戻り値:**
MERGE文のジェネレータ

---
