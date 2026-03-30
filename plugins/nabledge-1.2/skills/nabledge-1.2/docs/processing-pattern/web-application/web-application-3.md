# 子画面を開くタグのname属性には、何を指定したらいいのでしょうか?

## popupSubmit / popupButton / popupLink の name 属性指定方法

## popupSubmit / popupButton / popupLink の name 属性指定方法

`popupSubmit`、`popupButton`、`popupLink` タグの `name` 属性にはフォーム内で一意となる名前を設定すること。重複した場合、以下の例外が発生する。

```java
java.lang.IllegalArgumentException: name attribute of submission tag has duplicated. formName = [xxxx] submissionName = [yyyy]
// xxxx -> フォーム名称
// yyyy -> name属性に設定した値
```

特に一覧画面などでこれらのタグを使用する場合は、`name` 属性に連番を付加して重複しないように注意すること。

一覧画面（`n:listSearchResult` 使用時）でこれらのタグを使用する場合は、行番号を取得できる `count` 変数を name 属性に付加することで一意の名称を設定できる。

<details>
<summary>keywords</summary>

popupSubmit, popupButton, popupLink, n:listSearchResult, count変数, name属性重複, IllegalArgumentException, サブミットタグ一意性, 一覧画面サブミット, 連番, name属性連番

</details>
