# バリデーション機能の拡張

## 

バリデーション機能の拡張サンプルが提供する機能: メールアドレスバリデーション、日本電話番号バリデーション、コード値精査。

<details>
<summary>keywords</summary>

メールアドレスバリデーション, 日本電話番号バリデーション, コード値精査, バリデーション機能拡張, biz-samples

</details>

## 提供パッケージ

**パッケージ**: `please.change.me.core.validation.validator`

<details>
<summary>keywords</summary>

please.change.me.core.validation.validator, バリデーション提供パッケージ

</details>

## 

**クラス**: `MailAddressValidator`
**アノテーション**: `@MailAddress`

| プロパティ名 | 設定内容 |
|---|---|
| messageId (必須) | 精査エラー時のメッセージID (例: `{0}は有効なメールアドレスではありません。`) |

> **注意**: ローカル部とドメイン部が分かれている場合など、アノテーション精査が利用できない場合は `VariousValidationUtil.isValidMailAddress(value)` を使用する。有効なメールアドレスの場合trueを返す。

<details>
<summary>keywords</summary>

MailAddressValidator, @MailAddress, messageId, VariousValidationUtil, isValidMailAddress, メールアドレスバリデーション設定

</details>

## メールアドレスバリデーション

メールアドレス構成: `"ローカル部" @ "ドメイン部"`

**全体精査仕様**:
- 必須精査なし
- 使用可能文字: アルファベット大小 (A-Z, a-z)、数字 (0-9)、記号 `! # $ % & \ * + - . / = ? @ ^ _ { | } ~` およびバッククォート
- `@` が1つのみ存在すること
- JavaMailの形式チェックでエラーとならないこと

> **注意**: 無効なASCII文字 (使用不可): `" ( ) , : ; < > [ \ ]` およびスペース。RFC 5322のquoted-string記法は本機能では無効とする。

**ローカル部精査仕様**:
- 先頭が `@` ではないこと（ローカル部が存在すること）
- 64文字以下

**ドメイン部精査仕様**:
- 末尾が `@` ではないこと（ドメイン部が存在すること）
- 255文字以下
- 末尾が `.` ではないこと
- `.` が1つ以上存在すること
- 先頭が `.` ではないこと
- `.` が連続していないこと

> **注意**: メールアドレスの全桁数チェックはプロジェクト毎に決めること（本機能では精査しない）。

<details>
<summary>keywords</summary>

メールアドレス精査仕様, ローカル部, ドメイン部, JavaMail, メールアドレス有効文字, 64文字, 255文字

</details>

## 

日本の電話番号入力パターン:
1. 電話番号を一つの文字列として入力 → 単項目精査 (`JapaneseTelNumberValidator` / `@JapaneseTelNumber`)
2. 市外局番・市内局番・加入者番号を別々の入力項目として入力 → `VariousValidationUtil.isValidJapaneseTelNum()`

<details>
<summary>keywords</summary>

日本電話番号バリデーション, JapaneseTelNumberValidator, VariousValidationUtil, isValidJapaneseTelNum, 電話番号入力パターン

</details>

## 日本電話番号バリデーション

**クラス**: `JapaneseTelNumberValidator`
**アノテーション**: `@JapaneseTelNumber`

| プロパティ名 | 設定内容 |
|---|---|
| messageId (必須) | 精査エラー時のメッセージID (例: `{0}は有効な電話番号ではありません。`) |

<details>
<summary>keywords</summary>

JapaneseTelNumberValidator, @JapaneseTelNumber, messageId, 単項目電話番号精査

</details>

## 精査仕様

**単項目電話番号精査仕様**:
- 必須精査なし
- 先頭が「0」であること
- ハイフンと数字のみで構成されていること
- 桁数パターンが下記のいずれかであること

| 市外局番桁数 - 市内局番桁数 - 加入者番号桁数 | 例 |
|---|---|
| 3桁 - 3桁 - 4桁 | 012-345-6789 |
| 3桁 - 4桁 - 4桁 | 012-3456-7890 |
| 4桁 - 2桁 - 4桁 | 0123-45-6789 |
| 5桁 - 1桁 - 4桁 | 01234-5-6789 |
| 2桁 - 4桁 - 4桁 | 01-2345-6789 |
| 11桁 | 01234567890 |
| 10桁 | 0123456789 |

<details>
<summary>keywords</summary>

単項目電話番号精査仕様, 市外局番, 市内局番, 加入者番号, 電話番号桁数パターン, JapaneseTelNumber

</details>

## 精査仕様

**クラス**: `VariousValidationUtil`
**メソッド**: `boolean isValidJapaneseTelNum(areaCode, cityCode, subscriberNumber)`
- `areaCode`: 市外局番
- `cityCode`: 市内局番
- `subscriberNumber`: 加入者番号
- 戻り値: 有効な日本の電話番号の場合true

> **警告**: 全引数がnullまたは空文字列の場合、trueを返す。3項目すべての入力が必須の場合は、呼び出し元で必須精査を行うこと。

**複数項目電話番号精査仕様**:
- 全項目入力チェックは行わない
- 先頭が「0」であること
- ハイフンと数字のみで構成されていること
- 桁数パターンが下記のいずれかであること

| 市外局番桁数 - 市内局番桁数 - 加入者番号桁数 | 例 |
|---|---|
| 3桁 - 3桁 - 4桁 | 012-345-6789 |
| 3桁 - 4桁 - 4桁 | 012-3456-7890 |
| 4桁 - 2桁 - 4桁 | 0123-45-6789 |
| 5桁 - 1桁 - 4桁 | 01234-5-6789 |
| 2桁 - 4桁 - 4桁 | 01-2345-6789 |

<details>
<summary>keywords</summary>

VariousValidationUtil, isValidJapaneseTelNum, 複数項目電話番号精査, 市外局番, 加入者番号, null空文字警告

</details>

## 実装例

```java
@ValidateFor("registerCompany")
public static void validateForRegisterCompany(
                      ValidationContext<CompanyEntity> context) {
    // 単項目精査
    ValidationUtil.validateWithout(context, REGISTER_COMPANY_SKIP_PROPS);
    if (!context.isValid()) {
        return;
    }
    // 項目間精査
    CompanyEntity companyEntity = context.createObject();
    // 全項目入力チェック（必要な場合のみ）
    if (StringUtil.isNullOrEmpty(companyEntity.getAreaCode,
                                 companyEntity.getCityCode,
                                 companyEntity.getSubscriberNumber)) {
        // コンテキストにメッセージ追加
    }
    // 電話番号精査
    if (!VariousValidationUtil.isValidJapaneseTelNum(
                                 companyEntity.getAreaCode,
                                 companyEntity.getCityCode,
                                 companyEntity.getSubscriberNumber)) {
        // コンテキストにメッセージ追加
    }
```

<details>
<summary>keywords</summary>

電話番号バリデーション実装例, ValidationUtil, isValidJapaneseTelNum, 項目間精査, validateForRegisterCompany

</details>

## 

複数の機能から異なるパターンを指定してコード値精査を行うためのユーティリティ `CodeValidationUtil` を提供する。

**クラス**: `CodeValidationUtil`

提供メソッド:

`void validate(context, codeId, pattern, propertyName)`
- `context`: 精査コンテキスト
- `codeId`: コードID
- `pattern`: パターン
- `propertyName`: 精査対象のプロパティ

`void validate(context, codeId, pattern, propertyName, messageId)`
- `messageId`: デフォルトのメッセージIDを上書きする場合に指定

<details>
<summary>keywords</summary>

CodeValidationUtil, コード値精査, パターン指定, validate, codeId, pattern

</details>

## コード値精査

```java
// CodeValidationUtil#validateでコード値精査
CodeValidationUtil.validate(context, "0001", "PATTERN1", "gender");

// メッセージIDを上書きする場合、第5引数に指定
CodeValidationUtil.validate(context, "0001", "PATTERN1", "gender", "message_id");
```

<details>
<summary>keywords</summary>

CodeValidationUtil, コード値精査使用例, validate, codeId, pattern, messageId上書き

</details>
