# メッセージID及びメッセージ内容の変更手順

**公式ドキュメント**: [メッセージID及びメッセージ内容の変更手順](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/CustomizeMessageIDAndMessage.html)

## 概要

アーキタイプから生成したプロジェクトには、ユーザに通知するメッセージID及びメッセージについて、プロジェクト内にデフォルト設定が記述されている。内容を確認した上で変更する必要がある。

Nablarchのメッセージ管理機能については [../../libraries/message](../../component/libraries/libraries-message.md) を参照。

<details>
<summary>keywords</summary>

メッセージID設定, メッセージ変更, デフォルト設定確認, アーキタイプ生成プロジェクト

</details>

## エラー内容とメッセージIDの紐付けの変更方法

エラー内容とメッセージIDの紐付けは `src/main/resources/common.properties` で設定する。コメントに「XXXのメッセージID」と記載されている項目が紐付け設定箇所。

```text
# 全角文字以外の文字が入力された場合のメッセージID
# (TODO PJのID体系に併せて設定値を変更)
nablarch.zenkakuCharset.messageId=M000000017
```

項目の値を変更することで、エラー内容とメッセージIDの紐付けを変更できる。

<details>
<summary>keywords</summary>

エラーメッセージID紐付け, common.properties, messageId設定, nablarch.zenkakuCharset.messageId, メッセージID変更

</details>

## メッセージIDとメッセージの紐付けの変更方法

メッセージIDとメッセージの紐付けは、初期設定では `src/main/resources/messages.properties` で設定する。このファイルを編集することで紐付けを変更できる。

<details>
<summary>keywords</summary>

メッセージIDメッセージ紐付け, messages.properties, メッセージ内容変更

</details>
