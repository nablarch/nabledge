# データベースを入力とするChunkステップ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/database_reader.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/chunk/BaseDatabaseItemReader.html)

## データベースを入力とするChunkステップ

データベースから処理対象データを抽出する場合、JSR352提供のリーダではなく `BaseDatabaseItemReader` を実装すること。

`BaseDatabaseItemReader` を実装することで、リーダ専用のDB接続を使用してデータ抽出が可能。トランザクション制御時にカーソルが自動クローズされるDBでも動作する。

**クラス**: `nablarch.fw.batch.ee.chunk.BaseDatabaseItemReader`

実装パターン:
- `doOpen(Serializable checkpoint)`: 処理対象データを取得する。大量データの場合は遅延ロード（`UniversalDao.defer().findAllBySqlFile()`）を使用してヒープ圧迫を避けること
- `readItem()`: 次の1レコードを返す。データなし/最後まで処理済みの場合は `null` を返す
- `doClose()`: リソース解放が必要な場合に実装する

```java
@Dependent
@Named
public class EmployeeSearchReader extends BaseDatabaseItemReader {
  private DeferredEntityList<EmployeeForm> list;
  private Iterator<EmployeeForm> iterator;
  private final ProgressManager progressManager;

  @Inject
  public EmployeeSearchReader(ProgressManager progressManager) {
    this.progressManager = progressManager;
  }

  @Override
  public void doOpen(Serializable checkpoint) throws Exception {
    progressManager.setInputCount(
        UniversalDao.countBySqlFile(EmployeeForm.class, "SELECT_EMPLOYEE"));
    list = (DeferredEntityList<EmployeeForm>) UniversalDao.defer()
            .findAllBySqlFile(EmployeeForm.class, "SELECT_EMPLOYEE");
    iterator = list.iterator();
  }

  @Override
  public Object readItem() {
    if (iterator.hasNext()) {
      return iterator.next();
    }
    return null;
  }

  @Override
  public void doClose() throws Exception {
    list.close();
  }
}
```

<details>
<summary>keywords</summary>

BaseDatabaseItemReader, nablarch.fw.batch.ee.chunk.BaseDatabaseItemReader, DeferredEntityList, UniversalDao, ProgressManager, doOpen, readItem, doClose, データベース入力, Chunkステップ, 遅延ロード, リーダ専用DB接続, @Dependent, @Named, @Inject, EmployeeSearchReader, EmployeeForm

</details>
