# 稼動環境

## Nablarchフレームワークの環境要件

> **補足**: Nablarchフレームワーク以外のコンテンツ（Nablarch SQL Executor等）の稼動環境は各コンテンツのドキュメントを参照。

**最小要件**:
- Java SE 17
- JDBC 3.0

**機能別追加要件（Jakarta EE仕様）**:
- Jakarta Standard Tag Library 3.0
- Jakarta Activation 2.1
- Jakarta Server Pages 3.1
- Jakarta Servlet 6.0
- Jakarta Mail 2.1
- Jakarta Messaging 3.1
- Jakarta Persistence 3.1
- Jakarta Batch 2.1
- Jakarta Bean Validation 3.0
- Jakarta RESTful Web Services 3.1

> **重要**: 記載バージョン番号以上であれば互換性あり。Java標準仕様とJakarta EE仕様は基本的に後方互換を維持。

## Nablarchフレームワークのテスト環境

**Java**:
- Java SE 17/21 [1]

**データベース**:
- Oracle Database 19c/21c/23ai
- IBM Db2 11.5/12.1
- SQL Server 2017/2019/2022
- PostgreSQL 12.2/13.2/14.0/15.2/16.2/17.4

**アプリケーションサーバ**:
- WebSphere Application Server Liberty 25.0.0.2
- Open Liberty 25.0.0.2
- Red Hat JBoss Enterprise Application Platform 8.0.0
- WildFly 35.0.1.Final
- Apache Tomcat 10.1.17

**Jakarta EE**:
- Hibernate Validator 8.0.0.Final
- JBeret 2.1.1.Final

**MOM（メッセージ指向ミドルウェア）**:
- IBM MQ 9.3

**ブラウザ（PC）**:
- Microsoft Edge
- Mozilla Firefox
- Google Chrome
- Safari

[1] Java21使用時は別途設定変更が必要。設定方法は :doc:`../blank_project/setup_blankProject/setup_Java21` を参照。
