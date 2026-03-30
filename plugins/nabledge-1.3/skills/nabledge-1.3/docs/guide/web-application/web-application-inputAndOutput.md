# フォーム内の入力要素を出力するカスタムタグ

## フォーム内の入力要素を出力するカスタムタグ

フォーム内の入力要素を出力するカスタムタグ一覧:

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| textタグ | inputタグ(type=text) |
| textareaタグ | textareaタグ |
| passwordタグ | inputタグ(type=password) |
| hiddenタグ | inputタグ(type=hidden) |
| radioButtonタグ | inputタグ(type=radio) |
| checkboxタグ | inputタグ(type=checkbox) |
| compositeKeyRadioButtonタグ | inputタグ(type=radio)（複合キーを使用する場合） |
| compositeKeyCheckboxタグ | inputタグ(type=checkbox)（複合キーを使用する場合） |
| selectタグ | selectタグ（List型変数の各要素ごとにoptionタグを出力） |
| radioButtonsタグ | 複数のinputタグ(type=radio)（List型変数の各要素ごとにラジオボタンを出力） |
| checkboxesタグ | 複数のinputタグ(type=checkbox)（List型変数の各要素ごとにチェックボックスを出力） |

`n:codeCheckbox`タグでコードIDに対応するコード値が2件の場合、value属性（デフォルト: `1`）とlabelPattern属性（デフォルト: `$NAME$`）のデフォルト値をそのまま使用できる。

**JSP実装例**（codeId="0001"、コード値: 1=許可、0=不許可）:
```jsp
<n:codeCheckbox name="W11AF01.canUpdate" codeId="0001" />
```

id属性は自動で`nablarch_checkbox<連番>`形式（例: `nablarch_checkbox1`）で設定される。

入力/選択項目に初期値を設定するには、JSP遷移前にActionクラスでリクエストスコープにデータを設定する必要がある。カスタムタグのname属性の値とリクエストスコープへの設定名を一致させること。JSP側では特別な実装は不要。

**登録画面（Mapを使用する場合）**

Mapを使用する場合、Mapのキーにプロパティ名を明示的に指定する必要がある。

```java
public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
    Map<String, String> map = new HashMap<String, String>();
    map.put("effectiveDateFrom", new Date());
    ctx.setRequestScopedVar("W11AC02", map);
    return new HttpResponse("/ss11AC/W11AC0201.jsp");
}
```

```jsp
<n:text name="W11AC02.effectiveDateFrom" size="22" maxlength="20" />
```

**更新画面（SqlRow/フォームを使用する場合）**

SqlRowやフォーム/エンティティを使用するとMapを使わずに初期値設定できる。SqlResultSetの要素であるSqlRowはプロパティ名が設定済みのため、明示的なキー指定が不要。

```java
public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
    W11AC03Form form = formCtx.createObject();
    CM311AC1Component component = new CM311AC1Component();
    SqlResultSet userInfo = component.selectUserInfo(form);
    ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
    return new HttpResponse("/ss11AC/W11AC0301.jsp");
}
```

```jsp
<n:text name="W11AC03.name" size="22" maxlength="20" />
```

**複数選択項目の初期値設定**

複数選択項目に初期値を設定する場合、初期値だけでなく選択候補となるリストもリクエストスコープに設定する必要がある。

```java
// 選択候補リストをリクエストスコープに設定
SqlResultSet ugroupList = component.selectUserGroups();
ctx.setRequestScopedVar("allGroups", ugroupList);

// 複数の初期値（配列）を設定
Map<String, String> form = new HashMap<String, String>();
String[] defaultGroups = {"group2", "group3"};
form.put("groupIds", defaultGroups);
ctx.setRequestScopedVar("W11AC02", form);
```

```jsp
<n:select name="W11AC02.groupIds" multiple="true"
       listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
       elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

<details>
<summary>keywords</summary>

textタグ, textareaタグ, passwordタグ, hiddenタグ, radioButtonタグ, checkboxタグ, compositeKeyRadioButtonタグ, compositeKeyCheckboxタグ, selectタグ, radioButtonsタグ, checkboxesタグ, フォーム入力要素, カスタムタグ一覧, n:codeCheckbox, codeCheckbox, コード値2件, value属性デフォルト, labelPattern, チェックボックス, nablarch_checkbox, 初期値設定, リクエストスコープ, Map, HashMap, SqlResultSet, SqlRow, setRequestScopedVar, ExecutionContext, n:text, n:select, multiple, 複数選択項目, listName, elementLabelProperty, elementValueProperty, ValidationUtil, ValidationContext, elementLabelPattern, listFormat, HttpResponse, HttpRequest

</details>

## コード値の表示方法（概要）

コード値を選択/表示するためのタグ（CODE_PATTERNテーブルとCODE_NAMEテーブルを使用）:

- `codeSelect`: selectタグ（選択項目）
- `codeRadioButtons`: 複数input[type=radio]（選択項目）
- `codeCheckboxes`: 複数input[type=checkbox]（選択項目）
- `codeCheckbox`: 単一input[type=checkbox]（選択項目）
- `code`: 表示用カスタムタグ

codeタグは表示用、それ以外は選択項目用のカスタムタグ。

コード値が2件以上存在する場合、codeId属性から検索してもoffCodeValue属性が特定できないため、`offCodeValue`属性を明示的に指定する必要がある。デフォルト値（`1`）と異なる場合は`value`属性も明示的に指定する。

**JSP実装例**（codeId="0002"、コード値: Y=はい、N=いいえ、Z=未設定）:
```jsp
<n:codeCheckbox name="W11AF01.join" codeId="0002"
                value="Y" offCodeValue="N"
                labelPattern="$SHORTNAME$($OPTIONALNAME$)"
                optionColumnName="OPTION01" />
```

- `value`: チェックON時のコード値
- `offCodeValue`: チェックOFF時のコード値（2件以上の場合は明示指定必須）
- `optionColumnName`: `$OPTIONALNAME$`使用時は対象カラム名を指定する

入力項目のカスタムタグを使用して確認画面用の出力ができる。確認画面では`confirmationPage`タグを使い、入力画面にフォワードする。

対象タグ: :ref:`howto_single_input`、:ref:`code_select`

<details>
<summary>keywords</summary>

codeSelectタグ, codeRadioButtonsタグ, codeCheckboxesタグ, codeCheckboxタグ, codeタグ, コード値選択, CODE_PATTERNテーブル, CODE_NAMEテーブル, n:codeCheckbox, codeCheckbox, offCodeValue, コード値2件以上, value属性, optionColumnName, labelPattern, チェックボックス, 確認画面, confirmationPage, 入力項目確認, フォワード

</details>

## codeSelectタグ

codeSelectタグはHTMLのselectタグに対応。

**選択項目リストの絞り込みロジック:**
CODE_NAMEテーブルの中で、以下の条件を満たすIDを持つ行から選択項目リストを作成する:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルのうち、`pattern`属性で指定したカラム名の値が1

つまり`pattern`属性でCODE_PATTERNテーブルのどのカラムを使って絞り込むかを指定する。

| 属性 | デフォルト値 | 説明 |
|---|---|---|
| withNoneOption | false | リスト先頭に選択なしオプションを追加するか（trueで追加） |
| noneOptionLabel | "" | 選択なし時にリスト先頭に追加するラベル（withNoneOption="true"の場合のみ有効） |

labelPattern属性のプレースホルダ:
- `$VALUE$`: コード値（VALUE）
- `$NAME$`: コード名称（NAME）
- `$SHORTNAME$`: コード略称（SHORT_NAME）
- `$OPTIONALNAME$`: コードのオプション名称（OPTION01）。使用時はoptionColumnName属性の指定が必須。

```jsp
<n:codeSelect name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

`n:code`タグは指定したフォーマットにあわせてコード値を出力する。登録・更新画面でコード値をリスト表示する場合、通常はcodeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeCheckboxタグのいずれかを使用する。コード値一覧を表示してテキストボックスで入力する仕様では :ref:`list-of-codes-searched-by-codeId-and-pattern` の実装を参照。

詳細画面や一覧画面でコードの選択項目を表示する場合、Actionクラスでリクエストスコープにデータを設定する必要がある。

CODE_NAMEテーブルの選択条件:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルの`pattern`属性で指定したカラム名の値が1
3. VALUEカラムの値 = `name`属性の参照値

**labelPatternのプレースホルダ**:
- `$VALUE$`: コード値（VALUEカラム）
- `$NAME$`: コード名称（NAMEカラム）
- `$SHORTNAME$`: コード略称（SHORT_NAMEカラム）
- `$OPTIONALNAME$`: オプション名称（OPTION01等）— 使用時は`optionColumnName`属性でカラム名を指定する

**Actionクラス実装例**（`W11AC02Action`）:
```java
form.setBatchStatus(Batch.WAITING); // "02"を設定
context.setRequestScopedVar("W11AC02", form);
```

**JSP実装例**（W11AC0201.jsp）:
```jsp
<n:code name="W11AC02.batchStatus"
        codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

単項目精査エラーや業務エラーなどが発生したときのエラーメッセージ表示のために以下のタグを提供する:

- `errors`タグ
- `error`タグ

エラーの原因となった入力項目をハイライト表示させる機能も提供している。

<details>
<summary>keywords</summary>

codeSelectタグ, codeId, pattern, withNoneOption, noneOptionLabel, labelPattern, optionColumnName, CODE_PATTERNテーブル, CODE_NAMEテーブル, selectタグ, コード値フィルタリング, n:code, codeタグ, pattern属性, $VALUE$, $NAME$, $SHORTNAME$, $OPTIONALNAME$, 詳細画面, 一覧画面, コード選択項目表示, listFormat, W11AC02Action, エラーメッセージ表示, エラー項目ハイライト, errorsタグ, errorタグ, 単項目精査エラー, 業務エラー

</details>

## codeRadioButtonsタグ

codeRadioButtonsタグはHTMLの複数のinputタグ(type=radio)に対応。id属性は`nablarch_radio<連番>`の形式で自動設定。

**選択項目リストの絞り込みロジック:**
CODE_NAMEテーブルの中で、以下の条件を満たすIDを持つ行から選択項目リストを作成する:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルのうち、`pattern`属性で指定したカラム名の値が1

つまり`pattern`属性でCODE_PATTERNテーブルのどのカラムを使って絞り込むかを指定する。

labelPattern属性のプレースホルダはcodeSelectタグと同様（$VALUE$/$NAME$/$SHORTNAME$/$OPTIONALNAME$）。

```jsp
<n:codeRadioButtons name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

登録画面や更新画面でcodeタグを使ってコード値を一覧表示する場合（:ref:`list-of-codes-searched-by-codeId-and-pattern`）、`codeId`属性と`pattern`属性のみからコード値を取得する。Actionクラスでリクエストスコープにデータを設定する必要はない。

CODE_NAMEテーブルの選択条件:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルの`pattern`属性で指定したカラム名の値が1

この場合、`name`属性は記述しない。

**JSP実装例**:
```jsp
<n:code codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

`n:message`タグはメッセージ機能で管理されているメッセージを表示する。メッセージ機能が管理するテーブルに言語毎の文言を準備することで、ユーザが選択した言語に応じた画面の文言切り替えが可能となる。

**主要属性**:
- `messageId`: 表示するメッセージID
- `language`: 言語指定（省略時はスレッドコンテキストに設定された言語を使用）
- `var`: 変数名（変数に格納して他のタグで参照可能）
- `option0`〜`option9`: 埋め込み文字

**スレッドコンテキストの言語でメッセージ表示**:
```jsp
<n:message messageId="M7770001" />
```

**言語を指定してメッセージ表示（スレッドコンテキストの言語に関わらず指定言語で出力）**:
```jsp
<n:message messageId="M7770001" language="ja" />
```

**埋め込み文字をメッセージ機能から取得してフォーマット表示**:
```jsp
<%-- (1) var属性でメッセージを変数に格納 --%>
<n:message var="title" messageId="M7770001" />
<n:message var="appName" messageId="M7770099" />
<%-- (2) 取得した文言をoption属性に指定 --%>
<n:message messageId="M7770008" option0="${title}" option1="${appName}" />
```

<details>
<summary>keywords</summary>

codeRadioButtonsタグ, codeId, pattern, labelPattern, optionColumnName, CODE_PATTERNテーブル, CODE_NAMEテーブル, radioボタン, nablarch_radio, n:code, codeタグ, codeId属性, pattern属性, コード値一覧表示, 登録画面, 更新画面, name属性不要, list-of-codes-searched-by-codeId-and-pattern, listFormat, $VALUE$, $NAME$, $SHORTNAME$, $OPTIONALNAME$, メッセージ表示, 多言語対応, 国際化, n:message, messageId, language, var, option0, option1, 埋め込み文字

</details>

## codeCheckboxesタグ

codeCheckboxesタグはHTMLの複数のinputタグ(type=checkbox)に対応。id属性は`nablarch_checkbox<連番>`の形式で自動設定。

**選択項目リストの絞り込みロジック:**
CODE_NAMEテーブルの中で、以下の条件を満たすIDを持つ行から選択項目リストを作成する:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルのうち、`pattern`属性で指定したカラム名の値が1

つまり`pattern`属性でCODE_PATTERNテーブルのどのカラムを使って絞り込むかを指定する。

labelPattern属性のプレースホルダはcodeSelectタグと同様（$VALUE$/$NAME$/$SHORTNAME$/$OPTIONALNAME$）。

```jsp
<n:codeCheckboxes name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

日付や金額などをフォーマットして出力する場合、`write`タグや`text`タグの`valueFormat`属性を指定する。

<details>
<summary>keywords</summary>

codeCheckboxesタグ, codeId, pattern, labelPattern, optionColumnName, CODE_PATTERNテーブル, CODE_NAMEテーブル, チェックボックス, nablarch_checkbox, 出力フォーマット, valueFormat, writeタグ, textタグ, 日付フォーマット, 金額フォーマット

</details>

## codeCheckboxタグ

codeCheckboxタグはHTMLの単一のinputタグ(type=checkbox)に対応。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| value | | "1" | チェックありの場合に使用するコード値 |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | "$NAME$" | ラベルを整形するパターン（$NAME$/$SHORTNAME$/$OPTIONALNAME$/$VALUE$）。$OPTIONALNAME$使用時はoptionColumnName属性の指定が必須 |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定時はcodeIdから検索し、結果が2件かつ1件がvalue属性の値の場合は残り1件を使用 |

HTMLエスケープを行わず値をそのまま出力する場合、`prettyPrint`タグまたは`rawWrite`タグを使用する。

> **警告**: 本機能はHTMLのソースコードを表示したい場合など、HTMLエスケープをどうしても避けたい場合にのみ使用すること。それ以外の場合は必ずHTMLエスケープを行うこと。

<details>
<summary>keywords</summary>

codeCheckboxタグ, codeId, value, offCodeValue, labelPattern, optionColumnName, 単一チェックボックス, HTMLエスケープなし, prettyPrint, rawWrite

</details>

## hiddenタグの暗号化機能の解除

hiddenタグの値の改ざん・参照防止のため、hiddenタグの暗号化機能をデフォルトで提供している。使用しない場合はカスタムタグのデフォルト値を変更する必要がある。

**クラス**: `nablarch.common.web.tag.CustomTagConfig`

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| useHiddenEncryption | true | hiddenタグの暗号化機能の有効（true）/無効（false） |

暗号化を無効にする設定例（tag.xml）:
```xml
<component name="customTagConfig"
           class="nablarch.common.web.tag.CustomTagConfig">
    <property name="useHiddenEncryption" value="false" />
</component>
```

<details>
<summary>keywords</summary>

hiddenタグ暗号化, CustomTagConfig, nablarch.common.web.tag.CustomTagConfig, useHiddenEncryption

</details>
