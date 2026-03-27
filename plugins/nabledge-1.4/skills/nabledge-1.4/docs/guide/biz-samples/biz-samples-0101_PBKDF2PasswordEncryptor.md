# PBKDF2を用いたパスワード暗号化機能サンプル

**公式ドキュメント**: [PBKDF2を用いたパスワード暗号化機能サンプル](http://www.ietf.org/rfc/rfc2898.txt)

## 提供パッケージ

**パッケージ**: `please.change.me.common.authentication`

<details>
<summary>keywords</summary>

PBKDF2PasswordEncryptor, パスワード暗号化, please.change.me.common.authentication

</details>

## 概要

PBKDF2を使用してソルト付加およびストレッチングを行い、パスワードを暗号化する実装サンプル。[../01_Authentication](biz-samples-01_Authentication.md) で使用することを想定している。

<details>
<summary>keywords</summary>

PBKDF2, パスワード暗号化, ソルト, ストレッチング

</details>

## 要求

## 実装済み

- 複数ユーザが同一パスワードを使用した場合も、暗号化パスワードは異なる値となる
- 十分な長さのソルトを設定することで、レインボーテーブルによるパスワード解読への対策が可能
- ストレッチング回数を変更することで、総当り攻撃への対策が可能

## 未検討（未実装）

- ユーザごとのランダムソルト付加
- ソルトのDB外セキュアストレージへの保管

<details>
<summary>keywords</summary>

パスワード暗号化要件, レインボーテーブル対策, 総当り攻撃対策, ソルト, ストレッチング

</details>

## パスワード暗号化機能の詳細

PBKDF2を使用してパスワードを暗号化し、Base64エンコードされた文字列として返却する。

ソルトは「システム共通固定値（`fixedSalt`）＋ユーザID」を連結したバイト列。異なるユーザが同一パスワードを使用しても、暗号化パスワードは異なる値となる。

- `fixedSalt` プロパティで十分な長さのソルトを設定 → レインボーテーブル対策
- `iterationCount` プロパティでストレッチング回数を設定 → 総当り攻撃対策

<details>
<summary>keywords</summary>

PBKDF2, Base64エンコード, fixedSalt, iterationCount, レインボーテーブル対策, 総当り攻撃対策, ソルト

</details>

## 設定方法

**クラス**: `please.change.me.common.authentication.PBKDF2PasswordEncryptor`

```xml
<component name="passwordEncryptor"
           class="please.change.me.common.authentication.PBKDF2PasswordEncryptor">
  <property name="fixedSalt" value=" !!! please.change.me !!! TODO: MUST CHANGE THIS VALUE." />
  <property name="iterationCount" value="3966" />
  <property name="keyLength" value="256" />
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| fixedSalt | ○ | | システム共通のソルト固定文字列。実際のソルトはこの文字列にユーザIDを連結したバイト列 |
| iterationCount | | 3966 | パスワード暗号化のストレッチング回数 |
| keyLength | | 256 | 暗号化パスワードの長さ（ビット数） |

> **警告**: `fixedSalt` とユーザIDを連結したバイト列が **必ず20バイト以上** となることを保証すること。`fixedSalt` 単独で20バイト以上確保することを推奨する。（2014年1月時点で14文字以上に対応したレインボーテーブルの販売が確認されているため、20バイト以上を推奨。）

> **注意**: `iterationCount` はSHA-256などのハッシュ化関数での計算時間の10000倍程度になるように設定すること。PCIDSSに準拠せず特別なセキュリティが不要であれば `1` を指定してもよい。`iterationCount` はCPU負荷の高い処理となる。

> **注意**: `keyLength` は内部ハッシュ関数がSHA-1のため、160以上を設定すること。

### ストレッチング回数の設定値について

- Intel Core i7-4770 3.40GHz環境での実測: `iterationCount` 3500〜4000程度でPBKDF2の計算時間がSHA-256の約15000倍
- `iterationCount` 4000時のPBKDF2の1回計算時間は15〜20ms程度（ログイン処理のボトルネックにならない値）

> **重要**: PBKDF2暗号化処理はCPUをほぼ占有する。実稼働環境でCPU占有時間が許容範囲内かを **必ず検証すること**。

<details>
<summary>keywords</summary>

PBKDF2PasswordEncryptor, fixedSalt, iterationCount, keyLength, ストレッチング回数, パスワード暗号化設定, please.change.me.common.authentication.PBKDF2PasswordEncryptor

</details>
