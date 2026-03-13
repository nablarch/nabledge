# Redisヘルスチェッカ(Lettuce)アダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/lettuce_adaptor/redishealthchecker_lettuce_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/health/HealthChecker.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/health/RedisHealthChecker.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceRedisClient.html)

## Redisのヘルスチェックを行う

[health_check_endpoint_handler-add_health_checker](../handlers/handlers-health_check_endpoint_handler.md) で説明している `HealthChecker` を継承した `RedisHealthChecker` を `HealthCheckEndpointHandler` の `healthCheckers` プロパティに指定することで、Redisのヘルスチェックを実現できる。

```xml
<!-- ヘルスチェックエンドポイントハンドラ -->
<component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
  <!-- healthCheckersプロパティはリストで指定 -->
  <property name="healthCheckers">
    <list>
      <!-- Redisのヘルスチェック -->
      <component class="nablarch.integration.health.RedisHealthChecker">
        <!-- Redisのクライアント(LettuceRedisClient)を指定 -->
        <property name="client" ref="lettuceRedisClient" />
      </component>
    </list>
  </property>
</component>
```

`RedisHealthChecker` は `LettuceRedisClient` を使ってキーの存在確認を行い、例外が発生しなければヘルスチェック成功と判断する。キーは存在しなくてよい。`LettuceRedisClient` については [redisstore_redis_client_config_client_classes](adapters-redisstore_lettuce_adaptor.md) を参照。

キーを変更する場合は `RedisHealthChecker` の `key` プロパティに指定する。

```xml
<!-- Redisのヘルスチェック -->
<component class="nablarch.integration.health.RedisHealthChecker">
  <!-- Redisのクライアント(LettuceRedisClient)を指定 -->
  <property name="client" ref="lettuceRedisClient" />
  <!-- キーを指定 -->
  <property name="key" ref="pingtest" />
</component>
```

<details>
<summary>keywords</summary>

RedisHealthChecker, LettuceRedisClient, HealthChecker, HealthCheckEndpointHandler, healthCheckers, client, key, Redisヘルスチェック, キー存在確認

</details>
