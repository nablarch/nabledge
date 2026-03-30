# 子画面を開くタグのname属性には、何を指定したらいいのでしょうか?

## popupSubmit / popupButton / popupLink の name 属性の設定方法

## popupSubmit / popupButton / popupLink の name 属性の設定方法

`popupSubmit`、`popupButton`、`popupLink` タグの必須属性 `name` には、**フォーム内で一意となる名前**を設定する。

一覧画面でこれらのタグを使用する際に固定の名称を設定すると、以下の例外が発生する：

```java
java.lang.IllegalArgumentException: name attribute of submission tag has duplicated. formName = [xxxx] submissionName = [yyyy]
// xxxx -> フォーム名称
// yyyy -> name属性に設定した値
```

> **重要**: name属性が重複するとIllegalArgumentExceptionが発生する。一覧画面などでこれらのタグを使用する場合は、name属性に連番を付加して重複しないようにすること。

**対処方法**: 一覧画面では行番号を取得してname属性に付加することで、一意の名称を設定できる。

<details>
<summary>keywords</summary>

popupSubmit, popupButton, popupLink, IllegalArgumentException, name属性一意化, 一覧画面 重複エラー, サブミットタグ, 子画面 ポップアップ

</details>
