# フォーム内の入力要素を出力するカスタムタグ

本フレームワークでは、Form内の各入力要素(<input>, <textarea>, <select>) に対応する、下記のタグを提供している。

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| [textタグ](../../component/libraries/libraries-07-TagReference.md#textタグ) | inputタグ(type=text) |
| [textareaタグ](../../component/libraries/libraries-07-TagReference.md#textareaタグ) | textareaタグ |
| [passwordタグ](../../component/libraries/libraries-07-TagReference.md#passwordタグ) | inputタグ(type=password) |
| [hiddenタグ](../../component/libraries/libraries-07-TagReference.md#hiddenタグ) | HTMLタグの出力を行わず、ウィンドウスコープに値を出力する。 |
| [plainHiddenタグ](../../component/libraries/libraries-07-TagReference.md#plainhiddenタグ) | inputタグ(type=hidden) |
| [radioButtonタグ](../../component/libraries/libraries-07-TagReference.md#radiobuttonタグ) | inputタグ(type=radio) |
| [checkboxタグ](../../component/libraries/libraries-07-TagReference.md#checkboxタグ) | inputタグ(type=checkbox) |
| [compositeKeyRadioButtonタグ](../../component/libraries/libraries-07-TagReference.md#compositekeyradiobuttonタグ) | inputタグ(type=radio) ※ 複合キーを使用する場合 |
| [compositeKeyCheckboxタグ](../../component/libraries/libraries-07-TagReference.md#compositekeycheckboxタグ) | inputタグ(type=checkbox) ※ 複合キーを使用する場合 |
| [selectタグ](../../component/libraries/libraries-07-TagReference.md#selectタグ) | selectタグ ※ List型変数の各要素ごとにoptionタグを出力する。 |
| [radioButtonsタグ](../../component/libraries/libraries-07-TagReference.md#radiobuttonsタグ) | 複数のinputタグ(type=radio) ※ List型変数の各要素ごとにラジオボタンを出力する。 |
| [checkboxesタグ](../../component/libraries/libraries-07-TagReference.md#checkboxesタグ) | 複数のinputタグ(type=checkbox) ※ List型変数の各要素ごとにチェックボックスを出力する。 |

XHTMLの属性以外に、本機能で属性を追加しているカスタムタグについて解説する。

## passwordタグ

passwordタグでは、下記の属性を追加している。

| 属性 | 説明 |
|---|---|
| restoreValue | 入力画面の再表示時に入力データを復元するか否か。 復元する場合はtrue、復元しない場合はfalse。 デフォルトはfalse。 |
| replacement | 確認画面用の出力時に使用する置換文字。 デフォルトは'*'。 |

replacement属性の使用例を下記に示す。
置換文字を"#"に変更している。

```jsp
<n:password name="systemAccount.newPassword" replacement="#" />
```

入力画面と確認画面のHTML出力例を下記に示す。

```html
<%-- 入力画面 --%>
<input type="password" name="systemAccount.newPassword" value="password" />

<%-- 確認画面 --%>
########
```

> **Note:**
> passwordタグでは、入力データと同じ数の置換文字が出力される。
> 入力データに関係なく固定文字列を出力したい場合は、固定文字列をJSPに直接記述する。

## radioButtonタグ

radiobButtonタグでは、下記の属性を追加している。

| 属性 | 説明 |
|---|---|
| label(必須) | ラベル。 |

label属性の使用例を下記に示す。

```jsp
<n:radiobutton name="user.sex" value="0" label="0:男性" />
<n:radiobutton name="user.sex" value="1" label="1:女性" />
```

```html
<%-- user.sex = 1 の場合 --%>
<input id="nablarch_radio1" type="radio" name="user.sex" value="0" /><label for="nablarch_radio1">0:男性</label>
<input id="nablarch_radio2" type="radio" name="user.sex" value="1" checked="checked" /><label for="nablarch_radio2">1:女性</label>
```

radiobButtonタグは、ラベルを出力する際にlabelタグを出力する。
id属性の指定がない場合は、フレームワークで「nablarch_<radio><連番>」形式でid属性の値を生成して使用する。
<連番>部分には、画面内でradioタグの出現順に1から番号を振る。

## checkboxタグ

checkboxタグでは、下記の属性を追加している。
説明のために、下記ではXHTMLのvalue属性を含めている。

| 属性 | 説明 |
|---|---|
| value | XHTMLのvalue属性。 チェックありの場合に使用する値。 デフォルトは"1"。 |
| label | チェックありの場合に使用するラベル。 入力画面では、このラベルが表示される。 |
| useOffValue | チェックなしの値設定を使用するか否か。 デフォルトはtrue。 |
| offLabel | チェックなしの場合に使用するラベル。 |
| offValue | チェックなしの場合に使用する値。 デフォルトは"0"。 |

HTMLのcheckboxタグは、チェックなしの場合にリクエストパラメータが送信されない。
単一入力項目としてcheckboxタグを使用する場合は、データベース上でフラグとして表現されたデータ項目に対応することが多く、
通常はチェックなしの場合にも何らかの値を設定する。
このため、本機能では、チェックなしに対応する値をリクエストパラメータに設定する機能を提供する。

フレームワークは、checkboxタグ出力時にチェックなしに対応する値をhiddenタグとして出力する。
そして、NablarchTagHandlerがリクエスト受付時に、checkboxタグがチェックされていない場合のみ、
リクエストパラメータにチェックなしに対応する値を設定する。
NablarchTagHandlerの設定方法については、 [NablarchTagHandlerの設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#nablarchtaghandlerの設定) を参照。

value属性とoffValue属性のデフォルト値の設定方法については、 [カスタムタグのデフォルト値の設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#カスタムタグのデフォルト値の設定) を参照。

checkboxタグの使用例を下記に示す。

```jsp
<n:checkbox name="user.useEmail" label="使用する" offLabel="使用しない" />
```

入力画面の出力例を下記に示す。

```html
<%-- user.useEmail = 1 の場合 --%>
<%-- checked属性が出力される。 --%>
<input id="nablarch_checkbox1" type="checkbox" name="user.useEmail" value="1" checked="checked" />
    <label for="nablarch_checkbox1">使用する</label>
```

checkboxタグは、ラベルを出力する際にlabelタグを出力する。
checkboxタグのラベルは、ラベルがブランクでない場合のみ出力する。
id属性の指定がない場合は、フレームワークで「nablarch_<checkbox><連番>」形式でid属性の値を生成して使用する。
<連番>部分には、画面内でcheckboxタグの出現順に1から番号を振る。

確認画面の出力例を下記に示す。

```html
<%-- チェックありの場合 --%>
<%-- リクエストパラメータのuser.useEmailには、"1"が設定されている。 --%>
使用する

<%-- チェックなしの場合 --%>
<%-- リクエストパラメータのuser.useEmailには、"0"が設定されている。 --%>
使用しない
```

> **Note:**
> チェックなしの値設定が不要な場合は、useOffValue属性にfalseを指定する。
> 一括削除などで、checkboxタグを使用して複数選択させる場合などが該当する。

## compositeKeyRadioButtonタグ、compositeKeyCheckboxタグ

compositeKeyRadioButtonタグと compositeKeyCheckboxTagタグでは、下記の属性を追加している。
説明のために、下記ではXHTMLのvalue属性を含めている。

| 属性 | 説明 |
|---|---|
| namePrefix | 選択している名称のプレフィクス。 通常の name 属性と異なり、この名称に "." と keyNames で指定したキー名と合致する値を 通常の name 属性と同様に取り扱う。 例えば namePrefix に "form" 、 keyNames に "key1,key2" を指定した場合、表示時には form.key1、form.key2 でリクエストスコープに含まれる値を使用してこのチェックボックスの 値を出力する。 また、このチェックボックスを選択してサブミットしたリクエストの処理では、 form.key1 form.key2 というリクエストパラメータから選択された値が取得できる。  なお、本タグの name 属性には namePrefix 属性と keyNames 属性で指定したキーの組み合わせ と異なる名称にしなければならない特殊な制約がある。実装時はこの点に十分注意すること。 |
| keyNames | 複合キーのプロパティのリスト。 |
| valueObject | 複合キーを表すオブジェクト。 このオブジェクトは keyNames で指定したキー名を必ずプロパティに持つ必要がある。 |

compositeKeyRadioButtonタグと compositeKeyCheckboxタグは、それぞれ radioButtonタグと checkboxタグで実現できない
複合キーを持つ値の選択に使用する。

これらのタグを使用する際は、Form 上で複合キーをキーの数と同じだけのプロパティ、または CompositeKey クラスのプロパティで保持することを前提としている。
また、キーの値は valueObject 属性で指定するオブジェクトに保持されている必要がある。

以下に例を示す。

**キーの数と同じだけのプロパティで保持する場合。**

Form は下記のように実装する。

```java
public class SampleForm {
  /** 選択された複合キーの1つ目のキー */
  private String[] compositeKeyCheckboxValue1;
  /** 選択された複合キーの2つ目のキー */
  private String[] compositeKeyCheckboxValue2;
  // setter, getter, コンストラクタは省略
}
```

JSP は下記のように実装する。

```jsp
<table>
    <tr>
        <%-- ヘッダ出力は省略 --%>
    </tr>
    <c:forEach var="row" items="･･･">
    <tr>
        <td>
            <%--
              ※row には compositeKeyCheckboxValue1 と compositeKeyCheckboxValue2 が必須。
              ※name の名称は任意だが、 keyNames の名称と選択された複合キーのプロパティ名は一致させる必要がある。
            --%>
            <n:compositeKeyCheckbox
               namePrefix="sampleForm"
               label=""
               valueObject="${row}"
               keyNames="compositeKeyCheckboxValue1,compositeKeyCheckboxValue2"
               name="form.compositeKeyCheckboxValue" />
        </td>
        <%-- 以下略 --%>
    </tr>
    </c:forEach>
</table>
```

**CompositeKey クラスのプロパティで保持する場合。**

Form は下記のように実装する。

```java
public class CompositeKeyForm {

    /** 選択された複合キー */
    private CompositeKey[] compositeKeys;
// setter, getter, コンストラクタは省略
}
```

JSP は下記のように実装する。

```jsp
<table>
    <tr>
        <%-- ヘッダ出力は省略 --%>
    </tr>
    <c:forEach var="row" items="･･･">
    <tr>
        <td>
            <%--
              ※row には key1 と key2 が必須。
              ※name は必ず CompositeKey を表す名称とする。
             --%>
            <n:compositeKeyCheckbox
               namePrefix="compositeKeyForm"
               label=""
               valueObject="${row}"
               keyNames="key1,key2"
               name="form.compositeKeys" />
        </td>
        <%-- 以下略 --%>
    </tr>
    </c:forEach>
</table>
```

## List型変数に対応するカスタムタグの共通属性

[selectタグ](../../component/libraries/libraries-07-TagReference.md#selectタグ) 、 [radioButtonsタグ](../../component/libraries/libraries-07-TagReference.md#radiobuttonsタグ) 、 [checkboxesタグ](../../component/libraries/libraries-07-TagReference.md#checkboxesタグ) の3つのカスタムタグは、
List型変数の各要素ごとにタグを出力する仕様となっている。
ここでは、これら3つのタグに共通する属性について解説する。

| 属性 | 説明 |
|---|---|
| name(必須) | 選択された値をリクエストパラメータ又は変数スコープから取得する際に使用するname属性。 |
| listName(必須) | 選択項目のリストの属性名。 |
| elementLabelProperty(必須) | リスト要素からラベルを取得するためのプロパティ名。 |
| elementValueProperty(必須) | リスト要素から値を取得するためのプロパティ名。 |
| elementLabelPattern | ラベルを整形するためのパターン。  プレースホルダを下記に示す。 $LABEL$: ラベル $VALUE$: 値  "$VALUE$ - $LABEL$"と指定した場合、ラベル＝グループ1、値＝G001とすると、整形後のラベルは"G001 - グループ1"となる。 デフォルトは"$LABEL$"。 |
| listFormat | リスト表示時に使用するフォーマット。 下記のいずれかを指定する。 br(brタグ) div(divタグ) span(spanタグ) ul(ulタグ) ol(olタグ) sp(スペース区切り) デフォルトはbr。  > **Note:** > listFormat属性は、タグにより適用範囲が異なる。 > selectタグの場合は、確認画面用の出力時のみ使用する。 > radioButtonsタグとcheckboxesタグの場合は、リスト要素をまとめるタグが元々存在しないため、入力画面と確認画面の両方で使用する。 |

共通属性の使用例を下記に示す。
はじめに選択項目に使用するGroupクラスと選択項目リストの擬似コードを下記に示す。

```java
// 選択項目に使用するクラス
public class Group {
    private String id;
    private String name;
    public Group(String id, String name) { // 省略。 }
    // アクセッサは省略。
}
```

```java
// アクションの実装例

// 選択項目リストをリクエストスコープに設定する。
List<Group> groups = Arrays.asList(new Group("G001", "グループA"),
                                   new Group("G002", "グループB"),
                                   new Group("G003", "グループC"),
                                   new Group("G004", "グループD"),
                                   new Group("G005", "グループE"));
ctx.setRequestScoped("allGroups", groups);
```

上記の選択項目リストをselectタグで出力する例を示す。
ラベル(optionタグのコンテンツ)には、"値 - ラベル"となるようにパターンを指定している。

```jsp
<n:select name="user.groupIds" multiple="true"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

入力画面と確認画面のHTML出力例を下記に示す。

```html
<%-- 入力画面 --%>
<%-- リクエストスコープにuser.groupIds = "G002", "G003", "G004" が設定されている場合。--%>
<select name="user.groupIds">
  <option value="G001">G001 - グループA</option>
  <option value="G002" selected="selected">G002 - グループB</option>
  <option value="G003" selected="selected">G003 - グループC</option>
  <option value="G004" selected="selected">G004 - グループD</option>
  <option value="G005">G005 - グループE</option>
</select>

<%-- 確認画面 --%>
<ul>
  <li>G002 - グループB</li>
  <li>G003 - グループC</li>
  <li>G004 - グループD</li>
</ul>
```

## radioButtonsタグ、checkboxesタグ

radioButtonsタグとcheckboxesタグの追加属性は、上記の [List型変数に対応するカスタムタグの共通属性](../../component/libraries/libraries-07-FormTagList.md#list型変数に対応するカスタムタグの共通属性) のみである。

radioButtonsタグとcheckboxesタグでは、radiobButtonタグとcheckboxタグと同様に、ラベルを出力する際にlabelタグを出力する。
フレームワークで「nablarch_<radio|checkbox><連番>」形式でid属性の値を生成して使用する。
<連番>部分には、画面内でradioタグ(又はcheckboxタグ)の出現順に1から番号を振る。

また、tabindex属性で指定された値はそのまますべてのinputタグに出力する。

radioButtonsタグおよびcheckboxesタグの使用例を下記に示す。

```jsp
<tr>
  <td>
    <n:radioButtons name="team.color" tabindex="3"
              listName="allColors" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
  </td>
  <td>
    <n:checkboxes name="team.titles" tabindex="5"
              listName="allTitles" elementLabelProperty="label" elementValueProperty="value" elementLabelPattern="$VALUE$:$LABEL$" />
  </td>
</tr>
```

入力画面の出力例を下記に示す。

```html
<tr>
  <td>
    <input id="nablarch_radio1" tabindex="3" type="radio" name="team.color" value="001"><label for="nablarch_radio1">001:red</label><br>
    <input id="nablarch_radio2" tabindex="3" type="radio" name="team.color" value="002"><label for="nablarch_radio2">002:blue</label><br>
    <input id="nablarch_radio3" tabindex="3" type="radio" name="team.color" value="003"><label for="nablarch_radio3">003:green</label><br>
    <input id="nablarch_radio4" tabindex="3" type="radio" name="team.color" value="004"><label for="nablarch_radio4">004:yellow</label><br>
    <input id="nablarch_radio5" tabindex="3" type="radio" name="team.color" value="005"><label for="nablarch_radio5">005:pink</label><br>
  </td>
  <td>
    <input id="nablarch_checkbox1" tabindex="5" type="checkbox" name="team.titles" value="01"><label for="nablarch_checkbox1">01:地区優勝</label><br>
    <input id="nablarch_checkbox2" tabindex="5" type="checkbox" name="team.titles" value="02"><label for="nablarch_checkbox2">02:リーグ優勝</label><br>
    <input id="nablarch_checkbox3" tabindex="5" type="checkbox" name="team.titles" value="03"><label for="nablarch_checkbox3">03:ファイナル優勝</label><br>
  </td>
</tr>
```

## selectタグ

selectタグは、 [List型変数に対応するカスタムタグの共通属性](../../component/libraries/libraries-07-FormTagList.md#list型変数に対応するカスタムタグの共通属性) に加えて、下記の属性を追加している。

| 属性 | 説明 |
|---|---|
| withNoneOption | リスト先頭に選択なしのオプションを追加するか否か。 追加する場合はtrue、追加しない場合はfalse。 デフォルトはfalse。 |
| noneOptionLabel | リスト先頭に選択なしのオプションを追加する場合に使用するラベル。 この属性は、withNoneOptionにtrueを指定した場合のみ有効となる。 デフォルトは""。 |

共通属性の例と同じ選択項目リストを使用して、属性の使用例を下記に示す。

```jsp
<n:select name="user.groupIds"
          listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
          elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul"
          withNoneOption="true" noneOptionLabel="選択なし" />
```

「選択なし」オプションのvalue属性は、常に空文字となる。

```html
<%-- 入力画面 --%>
<%-- リクエストスコープにuser.groupIds = "G002" が設定されている場合。--%>
<select name="user.groupIds">
  <option value="">選択なし</option>
  <option value="G001">G001 - グループA</option>
  <option value="G002" selected="selected">G002 - グループB</option>
  <option value="G003">G003 - グループC</option>
  <option value="G004">G004 - グループD</option>
  <option value="G005">G005 - グループE</option>
</select>
```
