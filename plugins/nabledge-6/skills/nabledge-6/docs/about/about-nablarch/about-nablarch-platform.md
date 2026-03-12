# 稼動環境

**公式ドキュメント**: [稼動環境](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/platform.html)

## Nablarchフレームワークの環境要件

## Nablarchフレームワークの環境要件

Nablarchフレームワークの最低動作要件:

- Java SE 17
- JDBC 3.0

使用する機能に応じて必要なJakarta EE仕様:

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

> **重要**: 上記バージョン番号は最低バージョンを示す。Java標準仕様・Jakarta EE仕様は後方互換が維持されるため、表記バージョン以上であれば使用可能。

<details>
<summary>keywords</summary>

Java SE 17, JDBC 3.0, Jakarta EE, 動作要件, 最低要件, 環境要件, Jakarta Servlet, Jakarta Persistence, Jakarta Batch, Jakarta Bean Validation, Jakarta Standard Tag Library, Jakarta Activation, Jakarta Server Pages, Jakarta Mail, Jakarta Messaging, Jakarta RESTful Web Services

</details>

## Nablarchフレームワークのテスト環境

## Nablarchフレームワークのテスト環境

Nablarchフレームワークが動作確認済みの環境:

**Java**
- Java SE 17/21

> **補足**: Java 21で使用する場合、別途設定変更が必要。設定方法は [../blank_project/setup_blankProject/setup_Java21](../../setup/blank-project/blank-project-setup_Java21.md) を参照。

**データベース**
- Oracle Database 19c/21c/23ai
- IBM Db2 11.5/12.1
- SQL Server 2017/2019/2022
- PostgreSQL 12.2/13.2/14.0/15.2/16.2/17.4

**アプリケーションサーバ**
- WebSphere Application Server Liberty 25.0.0.2
- Open Liberty 25.0.0.2
- Red Hat JBoss Enterprise Application Platform 8.0.0
- WildFly 35.0.1.Final
- Apache Tomcat 10.1.17

**Jakarta EE**
- Hibernate Validator 8.0.0.Final
- JBeret 2.1.1.Final

**MOM（メッセージ指向ミドルウェア）**
- IBM MQ 9.3

**ブラウザ（PC）**
- Microsoft Edge
- Mozilla Firefox
- Google Chrome
- Safari

<details>
<summary>keywords</summary>

Oracle Database, PostgreSQL, IBM Db2, SQL Server, Apache Tomcat, WildFly, JBoss EAP, WebSphere Application Server Liberty, テスト環境, 動作確認済み, Java 21, IBM MQ, Hibernate Validator, Open Liberty, JBeret

</details>
