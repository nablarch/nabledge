# Jakarta Batchに準拠したバッチアプリケーションの悲観的ロック

**公式ドキュメント**: [Jakarta Batchに準拠したバッチアプリケーションの悲観的ロック](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/pessimistic_lock.html)

## 悲観的ロックの実装パターン

ItemReaderでは処理対象レコードの主キーのみ取得し、ItemProcessorで主キーをもとに悲観的ロック付きで取得することで、ロック時間を短縮して他プロセスへの影響を抑える。

**ポイント**:
- `ItemReader`: `UniversalDao.defer().findAllBySqlFile()` で主キーのみ取得する
- `ItemProcessor`: 主キーをもとに `UniversalDao.findBySqlFile()` でロック付き取得する
- :ref:`universal_dao` を使用した悲観的ロックは :ref:`universal_dao_jpa_pessimistic_lock` を参照

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
        if (iterator.hasNext()) return iterator.next();
        return null;
    }

    @Override
    public void close() throws Exception { list.close(); }
}

@Dependent
@Named
public class SampleProcessor implements ItemProcessor {
    @Override
    public Object processItem(Object item) {
        final Project project =
                UniversalDao.findBySqlFile(Project.class, "FIND_BY_ID_WITH_LOCK", item);
        // 業務処理のため省略
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

UniversalDao, DeferredEntityList, AbstractItemReader, AbstractItemWriter, ItemProcessor, 悲観的ロック, ロック時間短縮, Jakartaバッチ, 主キー取得, バッチ排他制御, @Dependent, @Named, SampleReader, SampleProcessor, SampleWriter, ProjectId, Project

</details>
