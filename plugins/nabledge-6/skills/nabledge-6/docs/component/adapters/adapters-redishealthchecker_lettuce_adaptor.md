# Redisヘルスチェッカ(Lettuce)アダプタ

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

LettuceRedisClientの設定については :ref:`redisstore_redis_client_config_client_classes` を参照。
