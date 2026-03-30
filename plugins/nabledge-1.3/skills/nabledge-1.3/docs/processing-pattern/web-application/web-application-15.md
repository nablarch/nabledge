# 送信ボタンやリンクを押すと、IEでのみ「オブジェクトでサポートされていないプロパティまたはメソッドです」と表示され画面が遷移しません。

## IEでのみ画面遷移エラーが発生する原因と対処

**原因**: フォーム内の要素のname属性値がFORMオブジェクトのメソッド・プロパティ名とバッティングすると、IEでのみ「オブジェクトでサポートされていないプロパティまたはメソッドです」エラーが発生し画面遷移しない。

**対象ブラウザ**: InternetExplorer全般 (IE6/IE7/IE8) および旧バージョンのFirefox (4以前)

**問題のあるコード例** (`name="submit"` がバッティング):
```jsp
<n:submit type="submit" uri="RW11BA0102" name="submit" value="登録"/>
```

**修正**: name属性の値を別の名前に変更する。
```jsp
<n:submit type="submit" uri="RW11BA0102" name="register" value="登録"/>
```

> **警告**: 以下の文字列はname属性の値として使用してはならない:
> - `action`
> - `elements`
> - `enctype`
> - `length`
> - `method`
> - `name`
> - `target`
> - `submit`
> - `reset`
> - 数値文字列 (`0`, `1`, `2` ...)

<details>
<summary>keywords</summary>

name属性, FORMオブジェクト, submit, InternetExplorer, n:submit, IEエラー, 画面遷移エラー, フォーム要素名バッティング

</details>
