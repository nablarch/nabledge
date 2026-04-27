# FormBaseクラスの自動生成

外部設計時に作成されている業務画面JSPから、以下のステップで作業を行い、FormBaseクラスの自動生成を行う。

FormBaseクラスは、Nablarch UI開発基盤のフォーム自動生成機能を使用して、業務画面JSPから自動生成する。
このクラスは、画面入力項目に対応したプロパティを持ち、それらの入力項目に対する精査を行う。

* 業務画面JSPの修正
* 業務画面JSPからFormBaseクラスを自動生成

## 業務画面JSPの修正

業務画面JSPの修正を行うために、まず、外部設計で作成されている以下のJSPファイルを `main/web/ss11AC` ディレクトリに移動する。

* `main/web/W11AC0201.jsp`
* `main/web/W11AC0202.jsp`
* `main/web/W11AC0203.jsp`

外部設計で作成された業務画面JSPでは、外部設計時に最低限必要な項目のみ設定されているため、
フォームの自動生成に必要な以下の修正を行う。

1. `n:form` タグで囲み、ウィンドウスコーププレフィックスを指定する。
2. 入力項目・表示項目の `name` 属性の設定

本機能では、修正対象となるのは `W11AC0201.jsp` のみである。

**1. n:formタグの追加**

この画面では、formは一つしかないため、業務領域(`<jsp:attribute name="contentHtml">`)の内側
すべてを `n:form` で囲み、windowScopePrefixesに値を設定する。

なお、すでにformが `n:form` で囲まれている場合には、windowScopePrefixesに値を設定するだけで良い。

ここでは登録取引を行う取引IDから"W11AC02"というプレフィックスを使用する。

```jsp
<n:form windowScopePrefixes="W11AC02">
```

> **Note:**
> ウィンドウスコープについては、以下のリンク先を参照

> * >   [ウィンドウスコープの概念](../../../fw/reference/architectural_pattern/concept.html#windowscope)
> * >   カスタムタグ実装例集 - [ウィンドウスコープの使用法](../../guide/web-application/web-application-basic.md#howto-window-scope)

**2. 入力項目・出力項目のname属性を指定する。**

入力項目・出力項目に表示する内容を指定するための `name` 属性を指定する。

この画面の情報はすべてウィンドウスコープで持回るため、 `name` 属性は以下のルールに従って指定する。

```
"ウィンドウスコーププレフィックス"."フォーム内のプロパティ名"
```

なお、フォーム内のプロパティ名と、データベースのカラム名をキャメルケースに変換した文字列とを一致させることで、
データベースへの登録処理の実装が容易になることが多いため、本ガイドでは、フォーム内のプロパティ名を
データベースのカラム名をキャメルケースに変換した文字列に統一する。

漢字氏名の入力エリアのタグ修正例を以下に示す。

＜修正前＞

```jsp
<field:text title="漢字氏名"
            domain="KANJI_NAME"
            required="true"
            maxlength="50"
            hint="全角50文字以内"
            dataFrom="USERS.KANJI_NAME"
            name=""
            sample="名部　楽太郎">
</field:text>
```

＜修正後＞

```jsp
<%-- 【説明】field:textのname属性を修正する --%>
<field:text title="漢字氏名"
            domain="KANJI_NAME"
            required="true"
            maxlength="50"
            hint="全角50文字以内"
            dataFrom="USERS.KANJI_NAME"
            name="W11AC02.kanjiName"
            sample="名部　楽太郎">
</field:text>
```

## 業務画面JSPからFormBaseクラスを自動生成

Nablarch UI開発基盤のForm自動生成機能を使用して、業務画面JSPからFormBaseクラスを自動生成する。

まず、 `main/web/tools/ローカル画面確認.bat` を起動し、ブラウザに表示される画面で `ss11AC/W11AC0201.jsp`
を選択してユーザ情報登録画面を表示する。

表示されたユーザ情報登録画面を右クリックすると、以下のようなメニューが表示される。

![local_right_click.png](../../../knowledge/assets/web-application-04-generate-form-base/local_right_click.png)

このメニューで「フォームクラスを生成する」を選択すると、 `W11AC02FormBase.java` が生成・ダウンロードされるので、
同ファイルを `main/java/nablarch/sample/ss11AC` にコピーする。
