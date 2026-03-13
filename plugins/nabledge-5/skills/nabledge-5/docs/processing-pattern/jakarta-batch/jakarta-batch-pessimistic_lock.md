# JSR352に準拠したバッチアプリケーションの悲観的ロック

**公式ドキュメント**: [JSR352に準拠したバッチアプリケーションの悲観的ロック](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/pessimistic_lock.html)

## 悲観的ロックの実装パターン

## 悲観的ロックの実装パターン

**実装ポイント**:
- `ItemReader` では処理対象レコードの主キーのみ取得する（ロック時間を短縮し他プロセスへの影響を抑えるため）
- `ItemProcessor` で主キーをもとに処理対象レコードを取得して悲観的ロックを行う
- [universal_dao](../../component/libraries/libraries-universal_dao.md) を使用した悲観的ロックの詳細は :ref:`universal_dao_jpa_pessimistic_lock` を参照

```java
@Dependent
@Named
public class SampleReader extends AbstractItemReader {

    private DeferredEntityList<ProjectId> list;
    private Iterator<ProjectId> iterator;

    @Override
    public void open(Serializable checkpoint) throws Exception {
        list = (DeferredEntityList<ProjectId>) UniversalDao.defer()
                .findAllBySqlFile(ProjectId.class, "GET_ID", condition);
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
    public void close() throws Exception {
        list.close();
    }
}

@Dependent
@Named
public class SampleProcessor implements ItemProcessor {

    @Override
    public Object processItem(Object item) {
        final Project project =
                UniversalDao.findBySqlFile(Project.class, "FIND_BY_ID_WITH_LOCK", item);
        return project;
    }
}

@Dependent
@Named
public class SampleWriter extends AbstractItemWriter {

    @Override
    public void writeItems(List<Object> items) {
        UniversalDao.batchUpdate(items);
    }
}
```

<details>
<summary>keywords</summary>

悲観的ロック, ItemReader, ItemProcessor, ItemWriter, JSR352, バッチ処理, ロック時間短縮, 主キー取得, SampleReader, SampleProcessor, SampleWriter, AbstractItemReader, AbstractItemWriter, DeferredEntityList, UniversalDao, @Dependent, @Named, ProjectId, Project

</details>
