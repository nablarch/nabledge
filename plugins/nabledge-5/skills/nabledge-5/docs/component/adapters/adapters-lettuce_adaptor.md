# Lettuceアダプタ

**公式ドキュメント**: [Lettuceアダプタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/lettuce_adaptor.html)

## モジュール一覧

:ref:`session_store` および [health_check_endpoint_handler](../handlers/handlers-health_check_endpoint_handler.md) でRedisを使用できるようにするアダプタ。RedisクライアントライブラリはLettuceを使用。

> **補足**: Redis 5.0.9、Lettuce 5.3.0.RELEASE でテスト済み。バージョン変更時はプロジェクト側でテストを行うこと。

**モジュール**:
```xml
<!-- RedisStore Lettuceアダプタ -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-lettuce-adaptor</artifactId>
</dependency>

<!-- デフォルトコンフィグレーション -->
<dependency>
  <groupId>com.nablarch.configuration</groupId>
  <artifactId>nablarch-main-default-configuration</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-lettuce-adaptor, nablarch-main-default-configuration, session_store, health_check_endpoint_handler, Redis, Lettuce, セッションストア, ヘルスチェック, Redisアダプタ, lettuceアダプタ

</details>
