# bouncycastleを使用した電子署名つきメールの送信サンプルの使用方法

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/biz_samples/09/index.html) [2](https://github.com/nablarch/nablarch-smime-integration)

## 環境準備

> **重要**: 本機能はサンプル実装のため、導入プロジェクトで使用する際には、ソースコード（プロダクション、テストコード共に）をプロジェクトに取込使用すること。
> ソースコード: https://github.com/nablarch/nablarch-smime-integration

**モジュール**:
```xml
<dependency>
  <groupId>org.bouncycastle</groupId>
  <artifactId>bcmail-jdk18on</artifactId>
  <version>1.72</version>
</dependency>
```

> **補足**: テストはRelease 1.72で実施済み。bouncycastleのサイトで最新リリースを必ず確認し、1.72より新しいバージョンがリリースされている場合は最新バージョンを適用すること。

電子署名用証明書は認証局から発行してもらい、メール送信バッチからアクセス可能なディレクトリに配置する。そのディレクトリへのアクセス権限は必要最小限にし、不要なユーザが証明書にアクセスできないようにすること。

<details>
<summary>keywords</summary>

bcmail-jdk18on, bouncycastle, 電子署名証明書, Maven依存関係, 証明書ファイル配置, アクセス権限, サンプル実装, ソースコード取込

</details>

## 電子署名付きメール送信機能の構造

本機能は `nablarch.common.mail.MailSender` の拡張機能。メール送信パターンIDを元に証明書を特定し、電子署名を付加する。

本機能を使用する場合、メール送信パターンIDを使用できるテーブル設計が必須。

詳細は、[メール送信機能](../../component/libraries/libraries-mail.md) を参照すること。

<details>
<summary>keywords</summary>

MailSender, nablarch.common.mail.MailSender, メール送信パターンID, 電子署名, SMIMEメール, テーブル設計

</details>

## 設定ファイルの準備

証明書以外の設定はNablarchのメール送信機能と同じ。証明書設定のみ追加で必要。

**クラス**: `please.change.me.common.mail.smime.CertificateWrapper`

| プロパティ名 | 説明 |
|---|---|
| password | 証明書ファイルへアクセスするためのパスワード |
| keyPassword | 証明書に格納された秘密鍵にアクセスするためのパスワード |
| certificateFileName | 証明書ファイルのパス |
| keyStoreType | キーストアタイプ（例: PKCS12、JKS） |

証明書はファイル単位でコンポーネント定義し、`certificateList` マップでメール送信パターンIDと紐付ける。

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
  <!-- メール送信パターンID:01 → certificate_1 の証明書を使用 -->
  <entry key="01" value-name="certificate_1" />
  <!-- メール送信パターンID:02 → certificate_2 の証明書を使用 -->
  <entry key="02" value-name="certificate_2" />
</map>
```

<details>
<summary>keywords</summary>

CertificateWrapper, please.change.me.common.mail.smime.CertificateWrapper, password, keyPassword, certificateFileName, keyStoreType, certificateList, 証明書設定, メール送信パターンID

</details>

## 実行方法

実行対象アクションクラスを `please.change.me.common.mail.smime.SMIMESignedMailSender` としてメール送信バッチプロセスを起動する。起動時には、そのプロセスが処理すべきメールを特定できるメール送信パターンIDを引数として指定すること。

<details>
<summary>keywords</summary>

SMIMESignedMailSender, please.change.me.common.mail.smime.SMIMESignedMailSender, メール送信パターンID, バッチ起動, 電子署名付きメール送信

</details>
