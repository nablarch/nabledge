# 基本方針

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/policy.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/annotation/Published.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/java/math/BigDecimal.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/java/text/DecimalFormat.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/Deprecated.html)

## 外部から受け付ける未入力値の扱い

Nablarchでは外部から受け付けた未入力値を `null` に変換する。HTTPリクエストのパラメータやXMLなど外部から受け付けたデータの未入力値は `null` に変換される。外部へ `null` を出力する場合は、出力形式に応じて未入力を意味する値に変換される。変換はNablarchのハンドラ・ライブラリが行うため、アプリケーションで変換する必要はない。

> **重要**: この未入力値の `null` 変換を有効にするには、[normalize_handler](../../component/handlers/handlers-normalize_handler.md) をハンドラキューに追加する必要がある。

アプリケーションでは未入力値を `null` として開発すること。

<details>
<summary>keywords</summary>

normalize_handler, 未入力値, null変換, 入力値正規化, ハンドラキュー

</details>

## コレクションや配列を返すAPIは原則nullを戻さない

Nablarchが提供するコレクションや配列を返すAPIは、対象データが存在しない場合に `null` ではなく空のコレクションや配列を返す。

ただし、HTTPリクエストパラメータのように識別子を指定して取得するAPIの場合は、空の配列ではなく `null` を返す。

<details>
<summary>keywords</summary>

コレクション, 配列, null戻り値, 空コレクション, 空配列

</details>

## Nablarchは検査例外を送出しない

Nablarch内の全てのAPIは非検査例外のみを送出する。Nablarchで定義している例外クラスも全て非検査例外。これにより、アプリケーションで例外を意識する必要がなく、ハンドラで共通的な例外処理を行うことができる。

<details>
<summary>keywords</summary>

検査例外, 非検査例外, 例外処理, RuntimeException, ハンドラ

</details>

## ログや例外のメッセージは英語で統一する

Nablarchのログや例外のメッセージは全て英語で統一されている。Nablarch内で出力しているログや例外のメッセージを英語以外に変更する機能は提供していない。

<details>
<summary>keywords</summary>

ログ, 例外メッセージ, 英語, 国際化, メッセージ言語

</details>

## コンポーネントを差し替えることでNablarchが発行するSQLを変更できる

Nablarchでデータベースにアクセスするコンポーネントにはインタフェースが定義されており、実装の差し替えが可能。プロジェクト側で実装クラスを作成し設定ファイルからコンポーネントを差し替えることで、発行するSQLを変更できる（例: テーブルのカラム追加・削除への対応）。

テーブル名やカラム名をデフォルトから変更したい場合は、新しいクラスを作成する必要はなく、設定ファイルの修正のみでよい。

<details>
<summary>keywords</summary>

SQL変更, コンポーネント差し替え, データベースアクセス, テーブル名変更, 設定ファイル

</details>

## OSSは使用しない

Nablarchのプロダクションコードは、致命的な不具合や脆弱性への迅速な対応・リリースを目的としてOSSを使用していない。

OSSを使用したい場合は、[adaptor](../../component/adapters/adapters-adaptors.md) としてOSSを使用できるコンポーネントが提供されている。

<details>
<summary>keywords</summary>

OSS, 依存関係, アダプタ, adaptor, プロダクションコード

</details>

## 複数の例外が発生した場合は起因例外をスローする

処理中に複数の例外が発生した場合、Nablarchは起因例外をスローする。起因例外以外の情報はWARNINGログに出力される。

<details>
<summary>keywords</summary>

起因例外, 例外スロー, WARNINGログ, 複数例外, 例外チェーン

</details>

## スレッドセーフである

Nablarchが提供する機能は基本的にスレッドセーフ。ハンドラキュー上のハンドラを各スレッドで実行するアーキテクチャのため、各スレッドが安全に要求を処理できる。アーキテクチャの詳細は [nablarch_architecture](about-nablarch-architecture.md) 参照。

[repository](../../component/libraries/libraries-repository.md) 上のオブジェクトはシングルトンとなるため、スレッドセーフにする必要がある。

> **補足**: スレッドアンセーフな機能（例: データベース接続）はJavadoc上にスレッドアンセーフであることが明記されている。

<details>
<summary>keywords</summary>

スレッドセーフ, シングルトン, ハンドラキュー, repository, スレッドアンセーフ

</details>

## Java17に準拠している

Nablarch6のプロダクションコードはJava17に準拠しており、Java18以降で提供されているAPIは使用していない。これは既存のNablarch6導入プロジェクトに対する後方互換を維持するためである。

Nablarch6を使用したアプリケーション開発はJava17以降のバージョンであればよく、Java18以降で提供されているAPIも問題なく使用できる。

<details>
<summary>keywords</summary>

Java17, 後方互換, Nablarch6, Java対応バージョン, Java18

</details>

## アプリケーションで使用してもよいAPIについて

Nablarchでは公開APIに `Published` アノテーションが付与されており、どのクラスやメソッドが公開APIかわかるようになっている。

公開APIはバージョンアップ時に後方互換を維持する。ただし、致命的な不具合と脆弱性の対応時には後方互換を維持できない場合もある。

<details>
<summary>keywords</summary>

Published, 公開API, 後方互換, nablarch.core.util.annotation.Published, アノテーション

</details>

## 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について

文字列からBigDecimalへの変換時に指数表現（例: `9e100000`）を指定すると、`BigDecimal#toPlainString()` の呼び出しや `DecimalFormat` でのフォーマット時に非常に大きい文字列が生成されヒープが圧迫される。

Nablarchでは `BigDecimal#scale` を使用して桁数チェックを行い、許容するscaleの範囲（デフォルト: `-9999` 〜 `9999`）を超える指数表現の値を変換しようとした場合に例外を送出してヒープ圧迫を防止する。

許容するscaleの範囲は設定で変更可能。設定は [repository-environment_configuration](../../component/libraries/libraries-repository.md) の環境設定ファイルに指定する。

```properties
nablarch.max_scale=10
```

（上記は許容範囲を `-10` 〜 `10` に設定する例）

<details>
<summary>keywords</summary>

BigDecimal, 指数表現, ヒープ不足, nablarch.max_scale, scale, DecimalFormat

</details>

## 非推奨(Deprecated)APIについて

以下に該当するAPIには `@Deprecated` アノテーションを付与し非推奨とする。

1. **他パッケージに移動したクラス**: 移動前クラスは非推奨とし、移動後クラスに全処理を委譲するため動作は保証される。ただしメソッド追加などは行われないため、移動先クラスを使用することが好ましい。
2. **不具合やセキュリティ面で問題のあるクラスやメソッド**: Javadocに理由および代わりに使用すべきAPIや実装方法が記載されている。

> **重要**: 不具合や脆弱性については基本的に問題を解消するよう修正する。しかし、クラス構造的な制約や後方互換の維持を目的として問題のあるAPIを非推奨として残す場合がある。非推奨APIとして残した場合は、新たな不具合などが見つかっても対応は行わない。問題が解消された新しいAPIを使用するようアプリケーション側は必ず対応する必要がある。

> **補足**: 本ドキュメントで代替機能の使用を推奨しているものについては、非推奨API（`@Deprecated` の付与）とはしていない。これらのAPIは使用すること自体は問題なく、不具合があった場合もバージョンアップ時に対応するためである。

<details>
<summary>keywords</summary>

Deprecated, 非推奨API, @Deprecated, 廃止予定, java.lang.Deprecated

</details>
