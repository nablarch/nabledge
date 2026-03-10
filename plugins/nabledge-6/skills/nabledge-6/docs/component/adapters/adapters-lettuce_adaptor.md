# Lettuceアダプタ

**公式ドキュメント**: [Lettuceアダプタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/lettuce_adaptor.html)

## 概要

:ref:`session_store` および :ref:`health_check_endpoint_handler` で[Redis(外部サイト、英語)](https://redis.io/)を使用可能にするアダプタ。Redisクライアントライブラリとして[Lettuce(外部サイト、英語)](https://redis.github.io/lettuce/)を使用。

<details>
<summary>keywords</summary>

Redisアダプタ, Lettuce, Redis, セッションストア, ヘルスチェック, session_store, health_check_endpoint_handler

</details>

## モジュール一覧

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

> **補足**: テスト済みバージョン: Redis 5.0.9、Lettuce 5.3.0.RELEASE。バージョンを変更する場合はプロジェクト側でテストを行うこと。

<details>
<summary>keywords</summary>

nablarch-lettuce-adaptor, nablarch-main-default-configuration, Maven依存関係, Redisバージョン, Lettuceバージョン

</details>
