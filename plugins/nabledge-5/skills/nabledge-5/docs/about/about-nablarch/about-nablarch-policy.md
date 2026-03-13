# 基本方針

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/policy.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/annotation/Published.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/java/math/BigDecimal.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/java/text/DecimalFormat.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/Deprecated.html)

## 外部から受け付ける未入力値の扱い

Nablarchでは、外部から受け付ける未入力値を `null` に統一する。

- HTTPリクエストパラメータやXMLなどの外部データの未入力値は `null` に変換する
- 外部へ `null` を出力する際はデータ形式に応じた未入力値に変換する
- 変換はNablarchのハンドラ・ライブラリが行うため、アプリケーションで変換する必要はない

> **重要**: 未入力値を `null` に変換するには [normalize_handler](../../component/handlers/handlers-normalize_handler.md) をハンドラキューに追加する必要がある。

アプリケーションでは未入力値を `null` として開発すること。

<details>
<summary>keywords</summary>

未入力値, null変換, normalize_handler, 空文字列統一, 入力値正規化

</details>

## コレクションや配列を返すAPIは原則nullを戻さない

Nablarchのコレクションや配列を返すAPIは、対象データが存在しない場合、`null` ではなく空のコレクションや配列を返す。

ただし、HTTPリクエストパラメータのように識別子を指定して取得するAPIは `null` を返す。

<details>
<summary>keywords</summary>

コレクション, 配列, null戻り値, HTTPリクエストパラメータ, 空コレクション

</details>

## Nablarchは検査例外を送出しない

Nablarch内の全APIは非検査例外のみを送出する。Nablarchで定義している例外クラスも全て非検査例外。

これによりアプリケーションで例外を意識する必要がなく、ハンドラで共通的な例外処理が可能。

<details>
<summary>keywords</summary>

検査例外, 非検査例外, 例外処理, throws, RuntimeException

</details>

## ログや例外のメッセージは英語で統一する

Nablarchは日本以外での使用も想定しているため、ログや例外のメッセージは全て英語としている。なお、Nablarch内で出力しているログや例外のメッセージを英語以外に変更する機能は提供していない。

<details>
<summary>keywords</summary>

ログメッセージ, 例外メッセージ, 英語統一, 多言語

</details>

## コンポーネントを差し替えることでNablarchが発行するSQLを変更できる

NablarchのDBアクセスコンポーネントにはインタフェースが定義されており、実装の差し替えが可能。

- プロジェクト側で実装クラスを作成し設定ファイルからコンポーネントを差し替えることで、発行するSQLを変更できる
- テーブルのカラム追加や削除はコンポーネント差し替えで対応可能
- テーブル名やカラム名をデフォルトから変更する場合は、新クラスの作成は不要で設定ファイルの修正のみで対応可能

<details>
<summary>keywords</summary>

SQL変更, コンポーネント差し替え, DBアクセス, テーブル設定, カラム変更

</details>

## OSSは使用しない

Nablarchのプロダクションコードは、致命的な不具合や脆弱性への迅速な対応・リリースを目的としてOSSを使用していない。

OSSのメリットがあるものは [adaptor](../../component/adapters/adapters-adaptors.md) としてOSSを使用できるコンポーネントを提供しているため、プロジェクト要件に応じて採用できる。

<details>
<summary>keywords</summary>

OSS不使用, アダプタ, adaptor, 脆弱性対応, プロダクションコード

</details>

## 複数の例外が発生した場合は起因例外をスローする

処理中に複数の例外が発生した場合、Nablarchは起因例外をスローする。起因例外以外の情報はWARNINGログに出力する。

<details>
<summary>keywords</summary>

起因例外, 複数例外, WARNINGログ, 例外連鎖

</details>

## スレッドセーフである

Nablarchが提供する機能は基本的にスレッドセーフ。ハンドラキュー上のハンドラを各スレッドで実行するアーキテクチャを採用しているため。詳細は [nablarch_architecture](about-nablarch-architecture.md) を参照。

- [repository](../../component/libraries/libraries-repository.md) 上のオブジェクトはシングルトンとなるため、スレッドセーフにする必要がある

> **補足**: スレッドアンセーフな機能（例: データベース接続等）はJavadoc上にスレッドアンセーフであることを明記している。

<details>
<summary>keywords</summary>

スレッドセーフ, シングルトン, ハンドラキュー, スレッドアンセーフ, repository

</details>

## Java6に準拠している

NablarchのプロダクションコードはJava6準拠で、Java7以降で提供されているAPIは使用していない（既存導入プロジェクトへの後方互換維持のため）。

アプリケーション開発はJava6以降のバージョンであればよく、Java7以降のAPIも使用可能。

<details>
<summary>keywords</summary>

Java6準拠, 後方互換, Java7, バージョン互換性

</details>

## アプリケーションで使用してもよいAPIについて

アプリケーション開発で必要なAPIを公開APIとして定義しており、`Published` アノテーションが付与されている。

公開APIはバージョンアップ時に後方互換を維持するが、致命的な不具合と脆弱性の対応時には後方互換を維持できない場合もある。

<details>
<summary>keywords</summary>

公開API, Published, 後方互換, バージョンアップ, nablarch.core.util.annotation.Published

</details>

## 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について

文字列からBigDecimalに変換する際に指数表現（例: `9e100000`）を指定した場合、`BigDecimal#toPlainString()` の呼び出しや `DecimalFormat` でのフォーマット時に非常に大きい文字列が生成されヒープが圧迫される問題がある。

Nablarchは `BigDecimal#scale` を使用して桁数チェックを行い、許容するscaleの範囲（`-9999` ～ `9999`）を超える指数表現の値を変換しようとした場合、例外を送出してヒープが圧迫されないようにしている。

許容するscaleの範囲は設定で変更可能。設定はシステムリポジトリの環境設定ファイルに指定する（[repository-environment_configuration](../../component/libraries/libraries-repository.md) 参照）。

```properties
nablarch.max_scale=10
```

<details>
<summary>keywords</summary>

BigDecimal, ヒープ不足, 指数表現, scale, nablarch.max_scale, DecimalFormat

</details>

## 非推奨(Deprecated)APIについて

Nablarchでは以下に該当するAPIに `@Deprecated` アノテーションを付与して非推奨とする。

1. **他パッケージに移動したクラス**: 移動前クラスを非推奨とし、Javadocに移動先クラスを使用するよう記載。移動前クラスは移動後クラスに全処理を委譲するため動作は保証されるが、メソッド追加は行われないため移動先クラスを使用することが好ましい。

2. **不具合やセキュリティ面で問題のあるクラスやメソッド**: Javadocに理由と代替APIを記載。問題を解消したAPIを使用するよう対応が必要。

> **重要**: 不具合や脆弱性は基本的に修正するが、クラス構造的制約や後方互換維持のため問題のあるAPIを非推奨として残す場合がある。非推奨APIとして残した場合は、新たな不具合が見つかっても対応しない。そのため、問題が解消された新しいAPIを使用するようアプリケーション側は必ず対応する必要がある。

> **補足**: 代替機能の使用を推奨しているものは非推奨API（@Deprecated付与）としていない。これらのAPIは使用自体は問題なく、不具合があればバージョンアップ時に対応するためである。

<details>
<summary>keywords</summary>

非推奨API, @Deprecated, パッケージ移動, セキュリティ, 代替API

</details>
