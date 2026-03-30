# 画面に表示するエラーメッセージを途中で改行することは出来ますか?

## 画面表示メッセージの改行方法

## 画面表示メッセージの改行方法

メッセージに `<br />` を直接含めてもサニタイジングされるため、HTMLタグとして機能せず `<br />` がそのまま画面表示される。

メッセージに物理的な改行（`\r\n`）を含めること。taglibは表示対象データに改行が含まれている場合、`<br />` タグに置換して出力する。

DBでメッセージを管理する場合のSQL例:

```sql
-- CHR(13) || CHR(10)は「\r\n」を表す
INSERT INTO MESSAGE (MESSAGE_ID, MESSAGE_TEXT) VALUES ('ID01', 'line 1' || CHR(13) || CHR(10) || 'line2');
```

<details>
<summary>keywords</summary>

エラーメッセージ改行, メッセージ改行, 物理改行, サニタイジング, br タグ置換, taglib, CHR(13), CHR(10)

</details>
