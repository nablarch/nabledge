# PBKDF2を用いたパスワード暗号化機能サンプル

**公式ドキュメント**: [PBKDF2を用いたパスワード暗号化機能サンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/01/0101_PBKDF2PasswordEncryptor.html)

## 提供パッケージ

**クラス**: `please.change.me.common.authentication.encrypt.PBKDF2PasswordEncryptor`

**パッケージ**: `please.change.me.common.authentication.encrypt`

<details>
<summary>keywords</summary>

PBKDF2PasswordEncryptor, please.change.me.common.authentication.encrypt, パスワード暗号化, パッケージ

</details>

## 概要

PBKDF2によるパスワード暗号化（ソルト付加＋ストレッチング）のサンプル実装。[../index](biz-samples-biz_samples.md) 内での使用を想定。

<details>
<summary>keywords</summary>

PBKDF2, パスワード暗号化, ソルト付加, ストレッチング

</details>

## 要求

## 実装済み

- 複数ユーザが同一パスワードを使用する場合でも、暗号化パスワードを異なる値にできる。
- 十分な長さのソルトを付加してレインボーテーブルによるパスワード解読への対策ができる。
- ストレッチング回数の変更により総当り攻撃への対策ができる。

## 未検討（非対応）

- ユーザごとのランダムなソルト付加は未対応。
- ソルトのデータベース外セキュアストレージへの保管は未対応。

<details>
<summary>keywords</summary>

パスワード暗号化要件, レインボーテーブル対策, 総当り攻撃対策, ソルト, ストレッチング, 未検討機能

</details>

## パスワード暗号化機能の詳細

PBKDF2でパスワードを暗号化し、Base64エンコードした文字列を返す。

ソルトは「システム共通固定値（fixedSalt）」と「ユーザID」を連結したバイト列を使用する。異なるユーザが同一パスワードを使用しても、暗号化されたパスワードは異なる値となる。

- `fixedSalt` プロパティに十分な長さのソルトを指定することでレインボーテーブル対策が可能。
- `iterationCount` プロパティでストレッチング回数を指定することで総当り攻撃対策が可能。

ストレッチング回数の検討方法は `pbkdf2IterationCount` セクションを参照。

<details>
<summary>keywords</summary>

PBKDF2, パスワード暗号化, Base64, ソルト, ユーザID連結, fixedSalt, iterationCount

</details>

## 設定方法

```xml
<component name="passwordEncryptor"
           class="please.change.me.common.authentication.encrypt.PBKDF2PasswordEncryptor">
  <property name="fixedSalt" value=" !!! please.change.me !!! TODO: MUST CHANGE THIS VALUE." />
  <property name="iterationCount" value="3966" />
  <property name="keyLength" value="256" />
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| fixedSalt | ○ | | システム共通のソルト用固定文字列。実際のソルトはこの文字列とユーザIDを連結したバイト列。 |
| iterationCount | | 3966 | ストレッチング回数。 |
| keyLength | | 256 | 暗号化パスワードの長さ（ビット数）。 |

> **重要**: `fixedSalt` はパスワードの暗号強度に関わる値。この文字列とユーザIDを連結したバイト列が **必ず20バイト以上** となることを保証すること（`fixedSalt` のみで20バイトを確保することを推奨）。
>
> **注**: 2014年1月時点で14文字以上の文字列に対応したレインボーテーブルの販売が確認されているため、20バイト以上を推奨している。プロジェクトでの使用に当たっては、**必ず最新の情報を確認し**、十分であると想定できるソルト長を設定すること。

`iterationCount`: SHA-256などのハッシュ化関数での計算時間の10000倍程度になるよう設定すること。デフォルト値3966はキリのいい数値を避けた意図的な選択であり、推測が容易でない値を設定することでパスワード解読の脅威を緩和している。

> **補足**: ストレッチング処理はCPU負荷が高い。PCIDSSに準拠するシステムでなく特別なセキュリティが不要であれば `1` を指定すればよい。

`keyLength`: 内部ハッシュ関数がSHA-256のため256以上の値を設定すること。指定ビット数のバイト列をBase64エンコードした長さの文字列が生成される。

<details>
<summary>keywords</summary>

PBKDF2PasswordEncryptor, fixedSalt, iterationCount, keyLength, XML設定, レインボーテーブル対策, 総当り攻撃対策, ソルト長, ストレッチング回数

</details>

## ストレッチング回数の設定値について

デフォルト値3966の根拠（英数字混在8文字パスワード、1秒間に10^11回SHA-256計算可能な環境を想定）:

1. ストレッチングなしでの総当り完了時間: `(62^8) / (10^11) ≈ 2183秒`
2. 総当り完了を1年間に延ばすために必要なSHA-256比の倍率: `(60×60×24×365) / 2183 ≈ 14444倍`

PBKDF2の計算時間がSHA-256の約15000倍以上になるよう `iterationCount` を設定すればよい。開発用PC（Intel Core i7-4770 3.40GHz）での実測では3500〜4000回で約15000倍となり、4000回時の計算時間は15〜20ms程度（ログイン処理のボトルネックにはならない）。

> **重要**: PBKDF2暗号化処理中はCPUをほぼ占有する。実際の稼動環境で許容時間に収まるか必ず検証すること。

<details>
<summary>keywords</summary>

pbkdf2IterationCount, ストレッチング回数, iterationCount, デフォルト値, 3966, 総当り攻撃, SHA-256, 計算時間

</details>
