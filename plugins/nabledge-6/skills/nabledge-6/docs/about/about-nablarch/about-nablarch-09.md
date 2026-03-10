# bouncycastleを使用した電子署名つきメールの送信サンプルの使用方法

**公式ドキュメント**: [bouncycastleを使用した電子署名つきメールの送信サンプルの使用方法](https://nablarch.github.io/docs/LATEST/doc/biz_samples/09/index.html)

## 環境準備

本機能はサンプル実装のため、使用する際はソースコード（プロダクション・テストコード共に）をプロジェクトに取り込むこと。

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-smime-integration)

**モジュール**:
```xml
<dependency>
  <groupId>org.bouncycastle</groupId>
  <artifactId>bcjmail-jdk18on</artifactId>
  <version>1.78.1</version>
</dependency>
```

> **補足**: テストはRelease1.78.1で実施。[bouncycastleのサイト](https://www.bouncycastle.org/)で最新リリースを必ず確認し、1.78.1より新しいバージョンがあればプロジェクトに適用すること。

証明書は認証局から発行してもらい、メール送信機能（バッチ）からアクセス可能なディレクトリに配置すること。ディレクトリへのアクセス権限は必要最小限にし、不要なユーザが証明書にアクセスできないようにすること。

<details>
<summary>keywords</summary>

bcjmail-jdk18on, org.bouncycastle, bouncycastle, 電子署名, 証明書準備, Maven依存設定

</details>

## 電子署名付きメール送信機能の構造

**クラス**: `nablarch.common.mail.MailSender` の拡張機能。

メール送信パターンIDを元に証明書を特定し、電子署名を付加する。本機能を使用する場合、必ずメール送信パターンIDを使用できるテーブル設計とすること。

詳細は :ref:`メール送信機能<mail>` を参照。

<details>
<summary>keywords</summary>

nablarch.common.mail.MailSender, 電子署名付きメール, メール送信パターンID, テーブル設計

</details>

## 設定ファイルの準備

証明書に関する設定以外はNablarchのメール送信機能の設定と同じ。

**クラス**: `please.change.me.common.mail.smime.CertificateWrapper`（証明書ファイル単位でコンポーネントを設定する）

```xml
<component name="certificate_1" class="please.change.me.common.mail.smime.CertificateWrapper">
  <property name="password" value="password" />
  <property name="keyPassword" value="password" />
  <property name="certificateFileName" value="classpath:please/change/me/common/mail/smime/data/certificate_1.p12" />
  <property name="keyStoreType" value="PKCS12" />
</component>
<component name="certificate_2" class="please.change.me.common.mail.smime.CertificateWrapper">
  <property name="password" value="keystorePass" />
  <property name="keyPassword" value="testAliasPass" />
  <property name="certificateFileName" value="classpath:please/change/me/common/mail/smime/data/certificate_2.p12" />
  <property name="keyStoreType" value="JKS" />
</component>

<map name="certificateList">
  <entry key="01" value-name="certificate_1" />
  <entry key="02" value-name="certificate_2" />
</map>
```

| プロパティ名 | 説明 |
|---|---|
| password | 証明書ファイルへアクセスするためのパスワード |
| keyPassword | 証明書に格納された秘密鍵にアクセスするためのパスワード |
| certificateFileName | 証明書ファイルのパス |
| keyStoreType | キーストアタイプ（PKCS12またはJKS） |

<details>
<summary>keywords</summary>

please.change.me.common.mail.smime.CertificateWrapper, certificateList, 証明書設定, PKCS12, JKS, keyStoreType, certificateFileName, password, keyPassword

</details>

## 実行方法

アクションクラスに `please.change.me.common.mail.smime.SMIMESignedMailSender` を指定してバッチプロセスを起動する。プロセス起動時に処理すべきメールを特定できるメール送信パターンIDを引数として指定する。

<details>
<summary>keywords</summary>

please.change.me.common.mail.smime.SMIMESignedMailSender, メール送信バッチ, メール送信パターンID, バッチ起動

</details>
