# 稼動環境

**公式ドキュメント**: [稼動環境](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/platform.html)

## Nablarchフレームワークの環境要件

Nablarchフレームワークの最低動作要件:
- Java SE 6
- JDBC 3.0

使用する機能に応じて追加で必要なJava標準仕様:
- JavaServer Pages Standard Tag Library 1.1
- JavaBeans Activation Framework 1.1
- JavaServer Pages 2.1
- Java Servlet 2.5
- JavaMail API 1.4
- Java Message Service API 1.1-rev-1
- Java Persistence 2.0
- Batch Applications for the Java Platform 1.0
- Bean Validation 1.1
- Java API for RESTful Web Services (JAX-RS) 2.0

> **重要**: 記載のバージョン番号は最低バージョンを示す。Java標準仕様は後方互換が維持されるため、記載バージョン以上であれば動作する。

<details>
<summary>keywords</summary>

環境要件, 動作要件, Java SE 6, JDBC 3.0, Bean Validation, JAX-RS, Java Persistence, Java Servlet, JavaMail, JMS, 最低動作要件

</details>

## Nablarchフレームワークのテスト環境

Nablarchフレームワークが動作確認済みの環境:

**Java**
- Java SE 6/7/8/11/17/21

> **注意**: Java11で使用する場合、別途設定変更が必要。設定方法は [../blank_project/setup_blankProject/setup_Java11](../../setup/blank-project/blank-project-setup_Java11.md) を参照。

> **注意**: Java17で使用する場合、別途設定変更が必要。設定方法は [../blank_project/setup_blankProject/setup_Java17](../../setup/blank-project/blank-project-setup_Java17.md) を参照。

> **注意**: Java21で使用する場合、別途設定変更が必要。設定方法は [../blank_project/setup_blankProject/setup_Java21](../../setup/blank-project/blank-project-setup_Java21.md) を参照。

**データベース**
- Oracle Database 12c/19c/21c/23ai
- IBM Db2 10.5/11.5
- SQL Server 2017/2019/2022
- PostgreSQL 10.0/11.5/12.2/13.2/14.0/15.2/16.2

**アプリケーションサーバ**
- Oracle Weblogic Server 14.1.1
- WebSphere Application Server 9.0.5.8
- WildFly 26.0.1.Final
- Apache Tomcat 9.0.54

**Java EE**
- Hibernate Validator 5.3.6.Final
- JBeret 1.3.4.Final

**MOM（メッセージ指向ミドルウェア）**
- IBM MQ 9.3

**ブラウザ（PC）**
- Internet Explorer 11
- Microsoft Edge
- Mozilla Firefox
- Google Chrome
- Safari

**ブラウザ（スマートフォン）**
- Safari(iOS)
- Google Chrome(Android)

<details>
<summary>keywords</summary>

テスト環境, 動作確認済み環境, Java 11, Java 17, Java 21, Oracle Database, PostgreSQL, IBM Db2, SQL Server, Tomcat, WildFly, WebSphere, WebLogic, Hibernate Validator, JBeret, IBM MQ, ブラウザ対応

</details>

## Nablarchフレームワークの稼動実績

2016年2月時点の稼働実績:

**OS**
- RedHat Enterprise Linux 5/6
- WindowsServer 2008
- AIX 7

**Java**
- Java SE 6/7/8

**データベース**
- Oracle Database 11g/12c
- DB2 10
- SQLServer 2008
- PostgreSQL 9

**アプリケーションサーバ**
- Oracle Weblogic Server 11g/12c
- WebSphere Application Server 7/8
- JBoss Application Server 7
- Apache Tomcat 6/7/8

**MOM（メッセージ指向ミドルウェア）**
- IBM MQ 9.3

<details>
<summary>keywords</summary>

稼動実績, 本番実績, 運用実績, RedHat Enterprise Linux, AIX, JBoss Application Server, Oracle Weblogic, WebSphere

</details>
