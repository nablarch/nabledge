# 子画面を開くタグのname属性には、何を指定したらいいのでしょうか?

## popupSubmit / popupButton / popupLink のname属性設定

## popupSubmit / popupButton / popupLink のname属性設定

`popupSubmit`、`popupButton`、`popupLink` タグのname属性には、**フォーム内で一意となる名前**を設定する。

一覧画面でこれらのタグを使用する場合、固定の名称を設定すると以下の例外が発生する:

```java
java.lang.IllegalArgumentException: name attribute of submission tag has duplicated.
formName = [xxxx] submissionName = [yyyy]

// xxxx -> フォーム名称
// yyyy -> name属性に設定した値
```

> **重要**: 一覧画面では、行番号を取得してname属性に付加することで一意の名称を設定できる。連番を付加して重複しないようにすること。

<details>
<summary>keywords</summary>

popupSubmit, popupButton, popupLink, IllegalArgumentException, サブミットタグ name属性, 一覧画面 連番, name属性重複エラー, 子画面 name属性

</details>
