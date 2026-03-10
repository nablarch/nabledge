# データベースを入力とするChunkステップ

## データベースを入力とするChunkステップ

データベースから処理対象データを抽出する場合、Jakarta Batchが提供するリーダではなく `BaseDatabaseItemReader` を実装すること。

リーダ専用のデータベース接続を使用するため、トランザクション制御時にカーソルが自動クローズされるデータベースでもChunkステップを実現できる。

**クラス**: `nablarch.fw.batch.ee.chunk.BaseDatabaseItemReader`

実装時は以下のメソッドをオーバーライドする:

- `doOpen(Serializable checkpoint)`: 処理対象データをデータベースから抽出する。大量データ取得時はヒープ圧迫を避けるため遅延ロード（`UniversalDao.defer()`）を使用すること。
- `readItem()`: 次の1レコードを返す。データが存在しない場合・最後まで処理した場合は `null` を返す。
- `doClose()`: リソース解放が必要な場合に実装する。

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
