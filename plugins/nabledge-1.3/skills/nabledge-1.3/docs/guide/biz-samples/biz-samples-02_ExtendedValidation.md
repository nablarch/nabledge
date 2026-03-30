# バリデーション機能の拡張

## 提供パッケージ

**パッケージ**: `please.change.me.core.validation.validator`

<details>
<summary>keywords</summary>

please.change.me.core.validation.validator, バリデーション機能拡張, パッケージ

</details>

## メールアドレスバリデーション

**クラス**: `MailAddressValidator`
**アノテーション**: `@MailAddress`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| messageId | ○ | 精査エラー時のメッセージID（例: "{0}は有効なメールアドレスではありません。"） |

> **注意**: ローカル部とドメイン部が別フィールドの場合など、アノテーションによる精査が利用できない場合は `VariousValidationUtil.isValidMailAddress(value)` を使用する（戻り値: 有効なメールアドレスである場合はtrue）。

### メールアドレス精査仕様

- 必須精査は行わない
- 有効文字種: 英数字(A-Z, a-z, 0-9)、記号: ! # $ % & \ * + - . / = ? @ ^ _ ` { | } ~
- `@`（アットマーク）が1つのみ存在すること
- JavaMailで送信する際に形式チェックエラーとならないこと

> **注意**: 無効なASCII文字: " ( ) , : ; < > [ \ ] およびスペース。RFC 5322のquoted-string記法は本機能では無効とする。

**ローカル部の精査仕様**:
- 先頭が`@`でないこと（ローカル部が存在すること）
- 64文字以下であること

**ドメイン部の精査仕様**:
- 末尾が`@`でないこと（ドメイン部が存在すること）
- 255文字以下であること
- 末尾が`.`でないこと
- `.`が存在すること
- 先頭が`.`でないこと
- `.`が連続しないこと

> **注意**: 全桁数チェックはRFC規定のローカル部（64文字以下）・ドメイン部（255文字以下）のみ。メールアドレス全体の桁数制限はプロジェクト毎に決定すること。

<details>
<summary>keywords</summary>

MailAddressValidator, VariousValidationUtil, @MailAddress, messageId, isValidMailAddress, メールアドレスバリデーション, ローカル部精査, ドメイン部精査

</details>

## 単項目の電話番号に対する精査

電話番号が市外局番等のフィールドに分かれておらず、一つの文字列として入力される場合の精査機能。

**クラス**: `JapaneseTelNumberValidator`
**アノテーション**: `@JapaneseTelNumber`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| messageId | ○ | 精査エラー時のメッセージID（例: "{0}は有効な電話番号ではありません。"） |

精査仕様:
- 必須精査は行わない
- 先頭が「0」で始まること
- ハイフンと数字のみで構成されていること
- 桁数パターン:

| 市外局番桁数-市内局番桁数-加入者番号桁数 | 例 |
|---|---|
| 3桁-3桁-4桁 | 012-345-6789 |
| 3桁-4桁-4桁 | 012-3456-7890 |
| 4桁-2桁-4桁 | 0123-45-6789 |
| 5桁-1桁-4桁 | 01234-5-6789 |
| 2桁-4桁-4桁 | 01-2345-6789 |
| 11桁 | 01234567890 |
| 10桁 | 0123456789 |

<details>
<summary>keywords</summary>

JapaneseTelNumberValidator, @JapaneseTelNumber, messageId, 電話番号バリデーション, 市外局番, 市内局番, 加入者番号, 単項目電話番号精査

</details>

## 複数項目で表される電話番号に対する精査

市外局番、市内局番、加入者番号をそれぞれ別の入力項目として入力する場合の精査機能。

`VariousValidationUtil.isValidJapaneseTelNum(areaCode, cityCode, subscriberNumber)`: 有効な日本の電話番号である場合はtrue。

精査仕様:
- 全ての項目が入力されていることのチェックは行わない
- 先頭が「0」で始まること
- ハイフンと数字のみで構成されていること
- 桁数パターン: 3桁-3桁-4桁、3桁-4桁-4桁、4桁-2桁-4桁、5桁-1桁-4桁、2桁-4桁-4桁の5パターン

> **警告**: 全ての引数がnullまたは空文字列の場合、trueを返却する。市外局番・市内局番・加入者番号の3項目が全て未入力のケースを許容しない場合は、呼び出し元で必須精査を行うこと。

実装例:
```java
@ValidateFor("registerCompany")
public static void validateForRegisterCompany(
                      ValidationContext<CompanyEntity> context) {
    ValidationUtil.validateWithout(context, REGISTER_COMPANY_SKIP_PROPS);
    if (!context.isValid()) {
        return;
    }
    CompanyEntity companyEntity = context.createObject();
    if (StringUtil.isNullOrEmpty(companyEntity.getAreaCode,
                                 companyEntity.getCityCode,
                                 companyEntity.getSubscriberNumber)) {
        // コンテキストにメッセージ追加（省略）
    }
    if (!VariousValidationUtil.isValidJapaneseTelNum(
                                 companyEntity.getAreaCode,
                                 companyEntity.getCityCode,
                                 companyEntity.getSubscriberNumber)) {
        // コンテキストにメッセージ追加（省略）
    }
}
```

<details>
<summary>keywords</summary>

VariousValidationUtil, isValidJapaneseTelNum, @ValidateFor, ValidationContext, ValidationUtil, StringUtil, 市外局番, 市内局番, 加入者番号, 複数項目電話番号精査

</details>

## MS932エンコーディングでのバイト長精査

精査対象文字列をMS932エンコーディングでエンコードした場合のバイト長を精査する。

> **重要**: 本機能を使用する場合、別途必ず文字種精査を行うこと。MS932エンコーディングの範囲外の文字があった場合でも精査エラーとならないため。

**クラス**: `MS932ByteLengthValidator`
**アノテーション**: `@MS932ByteLength`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| length | ○ | バイト長 |
| messageId | | バイト長が指定された長さを超えた場合のメッセージID（例: "{0}は{1}バイト以下で入力してください。"） |

<details>
<summary>keywords</summary>

MS932ByteLengthValidator, @MS932ByteLength, length, messageId, MS932バイト長精査, 文字種精査

</details>
