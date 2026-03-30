# 送信ボタンやリンクを押すと、IEでのみ「オブジェクトでサポートされていないプロパティまたはメソッドです」と表示され画面が遷移しません。

## IEでのみ画面遷移しない原因と対処（name属性の競合）

フォーム内の要素のname属性値がFORMオブジェクトのメソッド・プロパティ名とバッティングする場合、IEで「オブジェクトでサポートされていないプロパティまたはメソッドです」エラーが発生し画面遷移しない。

**対象ブラウザ**: InternetExplorer全般（IE6/IE7/IE8）および旧バージョンのFirefox（4以前）

**問題のある例**:
```jsp
<n:submit type="submit" uri="RW11BA0102" name="submit" value="登録"/>
```

**修正例** (name属性値を別の値に変更):
```jsp
<n:submit type="submit" uri="RW11BA0102" name="register" value="登録"/>
```

> **警告**: 以下の文字列をname属性の値として使用してはいけない。
> - `action`
> - `elements`
> - `enctype`
> - `length`
> - `method`
> - `name`
> - `target`
> - `submit`
> - `reset`
> - 数値文字列（0, 1, 2 …）

<details>
<summary>keywords</summary>

IE, Internet Explorer, オブジェクトでサポートされていないプロパティまたはメソッドです, name属性, submit, フォーム, 画面遷移しない, name属性の競合, n:submit

</details>
