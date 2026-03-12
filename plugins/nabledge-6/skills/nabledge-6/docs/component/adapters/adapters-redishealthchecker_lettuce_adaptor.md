# Redisヘルスチェッカ(Lettuce)アダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/lettuce_adaptor/redishealthchecker_lettuce_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/health/HealthChecker.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/health/RedisHealthChecker.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceRedisClient.html)

## Redisのヘルスチェックを行う

**クラス**: `nablarch.integration.health.RedisHealthChecker`, `nablarch.fw.web.handler.health.HealthChecker`

`HealthCheckEndpointHandler` の `healthCheckers` プロパティに `RedisHealthChecker` を指定することで、Redisのヘルスチェックを実現できる。

`RedisHealthChecker` は `LettuceRedisClient` を使ってキーの存在確認を行い、例外が発生しなければヘルスチェックが成功と判断する。キーは存在しなくてよい。

キーを変更する場合は `key` プロパティに指定する。

```xml
<component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
  <property name="healthCheckers">
    <list>
      <component class="nablarch.integration.health.RedisHealthChecker">
        <property name="client" ref="lettuceRedisClient" />
      </component>
    </list>
  </property>
</component>
```

キー変更時の設定例:

```xml
<component class="nablarch.integration.health.RedisHealthChecker">
  <property name="client" ref="lettuceRedisClient" />
  <property name="key" ref="pingtest" />
</component>
```

LettuceRedisClientの設定については [redisstore_redis_client_config_client_classes](adapters-redisstore_lettuce_adaptor.md) を参照。

<details>
<summary>keywords</summary>

RedisHealthChecker, LettuceRedisClient, HealthChecker, HealthCheckEndpointHandler, healthCheckers, client, key, Redisヘルスチェック, ヘルスチェック設定, Lettuceアダプタ

</details>
