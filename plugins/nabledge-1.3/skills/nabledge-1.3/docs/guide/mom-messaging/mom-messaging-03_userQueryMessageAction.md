# 同期応答型メッセージ受信処理

## 電文受信時の処理

**クラス**: `RM11AC0101Action` (`MessagingAction` を継承)

**`onReceive` メソッドの処理フロー**:
1. `validate(request.getParamMap())` で要求電文を精査し `UserInfoTempEntity` に変換
2. `registerRecord(entity)` でデータベースに登録
3. `request.reply().setStatusCodeHeader("200").addRecord(resultRecord)` で応答電文を返却

**バリデーション処理 (`validate` メソッド)**:
```java
ValidationContext<UserInfoTempEntity> validationContext =
    ValidationUtil.validateAndConvertRequest(
        UserInfoTempEntity.class, userRecord, "validateRegister");
validationContext.abortIfInvalid();  // 精査エラー時に業務例外を送出
return validationContext.createObject();
```

**応答電文フィールド**:
- `dataKbn`: `"0"`（正常）
- `userInfoId`: 登録ユーザID

<details>
<summary>keywords</summary>

RM11AC0101Action, MessagingAction, ValidationUtil, validateAndConvertRequest, UserInfoTempEntity, ValidationContext, onReceive, RequestMessage, ExecutionContext, ResponseMessage, 同期応答型メッセージ受信処理, 要求電文バリデーション, 応答電文作成

</details>

## エラー時の処理

**`onError` メソッドのエラー応答仕様**:

| 終了コード | 障害コード | 原因 |
|---|---|---|
| 200 | (空白) | 正常終了 |
| 400 | NR11AC4001 | 要求電文のデータレコード部項目精査エラー |
| 500 | NR11AC5001 | 要求電文のデータレコード部レイアウト不正 |
| 500 | NR11AC5000 | その他の意図しないエラー |

例外の種別による分岐:
- `InvalidDataFormatException` → ステータスコード `500` / 障害コード `NR11AC5001`
- `ApplicationException` → ステータスコード `400` / 障害コード `NR11AC4001`
- その他 → ステータスコード `500` / 障害コード `NR11AC5000`

**エラー応答電文フィールド**:
- `dataKbn`: `0`（エラー）
- `failureCode`: 障害コード

<details>
<summary>keywords</summary>

InvalidDataFormatException, ApplicationException, onError, エラー応答, ステータスコード, 障害コード, NR11AC4001, NR11AC5001, NR11AC5000, NR11AA4001, NR11AA5001, NR11AA5000

</details>
