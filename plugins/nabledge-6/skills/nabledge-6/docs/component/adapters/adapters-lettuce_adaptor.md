# Lettuceアダプタ

## 概要

:ref:`session_store` および :ref:`health_check_endpoint_handler` で[Redis(外部サイト、英語)](https://redis.io/)を使用可能にするアダプタ。Redisクライアントライブラリとして[Lettuce(外部サイト、英語)](https://redis.github.io/lettuce/)を使用。

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
