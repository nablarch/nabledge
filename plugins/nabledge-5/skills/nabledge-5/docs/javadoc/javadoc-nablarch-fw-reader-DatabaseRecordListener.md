# interface DatabaseRecordListener

**パッケージ:** nablarch.fw.reader

---

```java
public interface DatabaseRecordListener
```

{@link DatabaseRecordReader}で処理対象レコードをキャッシュするためのデータベースアクセス前に
コールバックされるメソッドを定義するインタフェース。

**作成者:** Naoki Yamamoto  

---

## メソッドの詳細

### beforeReadRecords

```java
void beforeReadRecords()
```

処理対象レコードをキャッシュするためのデータベースアクセス前に呼び出される。

---
