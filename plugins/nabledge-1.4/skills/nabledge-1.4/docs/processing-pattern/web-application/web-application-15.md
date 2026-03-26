# 送信ボタンやリンクを押すと、IEでのみ「オブジェクトでサポートされていないプロパティまたはメソッドです」と表示され画面が遷移しません。

## IEでname属性衝突によるフォーム送信エラー

フォームの内部にname属性値がFORMオブジェクトのメソッド・プロパティ名と衝突する要素が存在する場合、InternetExplorer全般(IE6/IE7/IE8)および旧バージョンのFirefox(4以前)で「オブジェクトでサポートされていないプロパティまたはメソッドです」エラーが発生し、画面が遷移しなくなる。

> **重要**: 以下の文字列をname属性の値として使用してはならない。
> `action`, `elements`, `enctype`, `length`, `method`, `name`, `target`, `submit`, `reset`, 数値文字列 (0, 1, 2 ...)

**問題のあるコード例**:
```jsp
<n:submit type="submit" uri="RW11BA0102" name="submit" value="登録"/>
```

**修正例** (name属性を別の値に変更することで問題が解消する):
```jsp
<n:submit type="submit" uri="RW11BA0102" name="register" value="登録"/>
```

<details>
<summary>keywords</summary>

IEエラー, フォームname属性衝突, オブジェクトでサポートされていないプロパティまたはメソッドです, submit name属性, n:submit, FORMオブジェクト, ブラウザ互換性, InternetExplorer

</details>
