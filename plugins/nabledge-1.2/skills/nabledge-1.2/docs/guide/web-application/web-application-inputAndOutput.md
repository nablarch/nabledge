# フォーム内の入力要素を出力するカスタムタグ

## フォーム内の入力要素を出力するカスタムタグ

Form内の各入力要素(`<input>`, `<textarea>`, `<select>`)に対応するカスタムタグ:

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| textタグ | inputタグ(type=text) |
| textareaタグ | textareaタグ |
| passwordタグ | inputタグ(type=password) |
| hiddenタグ | inputタグ(type=hidden) |
| radioButtonタグ | inputタグ(type=radio) |
| checkboxタグ | inputタグ(type=checkbox) |
| compositeKeyRadioButtonタグ | inputタグ(type=radio)（複合キー使用時） |
| compositeKeyCheckboxタグ | inputタグ(type=checkbox)（複合キー使用時） |
| selectタグ | selectタグ（List型変数の各要素ごとにoptionタグを出力） |
| radioButtonsタグ | 複数のinputタグ(type=radio)（List型変数の各要素ごとにラジオボタンを出力） |
| checkboxesタグ | 複数のinputタグ(type=checkbox)（List型変数の各要素ごとにチェックボックスを出力） |

`n:codeCheckbox`タグでコード値が2件の場合の実装。

- `value`属性のデフォルト値: `1`
- `labelPattern`属性のデフォルト値: `$NAME$`
- `id`属性は自動指定（形式: `nablarch_checkbox<連番>`）

**JSP実装例**（`value`・`labelPattern`はデフォルト使用）:
```jsp
<n:codeCheckbox name="W11AF01.canUpdate" codeId="0001" />
```

JSPへ遷移する前にActionクラスでリクエストスコープにデータを設定する。カスタムタグの`name`属性の値とリクエストスコープの名前を一致させる必要がある。JSP側での特別な実装は不要（初期値なしの場合と同じコード）。

対象タグ: :ref:`howto_single_input`, :ref:`code_select`

**登録画面: Mapを使用する場合**

Mapのキーにプロパティ名を明示的に指定する必要がある。

```java
Map<String, String> map = new HashMap<String, String>();
map.put("effectiveDateFrom", new Date());
ctx.setRequestScopedVar("W11AC02", map);
```

JSP:
```jsp
<n:text name="W11AC02.effectiveDateFrom" size="22" maxlength="20" />
```

**更新画面: SqlRow/フォーム/エンティティを使用する場合**

SqlRowやフォーム/エンティティを使用するとMapを使わずに初期値設定が可能。SqlRowはプロパティ名を含むため明示的なキー指定が不要。

```java
SqlResultSet userInfo = component.selectUserInfo(form);
ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
```

JSP:
```jsp
<n:text name="W11AC03.name" size="22" maxlength="20" />
```

**複数選択項目**

初期値だけでなく、選択候補リストもリクエストスコープに設定する必要がある。

```java
ctx.setRequestScopedVar("allGroups", ugroupList);  // 選択候補リスト

String[] defaultGroups = {"group2", "group3"};
form.put("groupIds", defaultGroups);
ctx.setRequestScopedVar("W11AC02", form);  // 初期値（複数）
```

JSP:
```jsp
<n:select name="W11AC02.groupIds" multiple="true"
       listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
       elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

<details>
<summary>keywords</summary>

textタグ, textareaタグ, passwordタグ, hiddenタグ, radioButtonタグ, checkboxタグ, compositeKeyRadioButtonタグ, compositeKeyCheckboxタグ, selectタグ, radioButtonsタグ, checkboxesタグ, フォーム入力要素, カスタムタグ, 複合キー, n:codeCheckbox, codeCheckboxタグ, codeId属性, value属性 デフォルト, labelPattern デフォルト, チェックボックス コード値2件, nablarch_checkbox, 初期値設定, リクエストスコープ, Map, HashMap, SqlRow, SqlResultSet, setRequestScopedVar, n:text, n:select, 登録画面, 更新画面, 複数選択項目

</details>

## コード値の表示方法 - codeSelectタグ

コード値を選択/表示するタグ（CODE_PATTERNテーブルとCODE_NAMEテーブルを使用）:
- codeSelectタグ: selectタグ出力（選択項目）
- codeRadioButtonsタグ: 複数のinputタグ(type=radio)出力（選択項目）
- codeCheckboxesタグ: 複数のinputタグ(type=checkbox)出力（選択項目）
- codeCheckboxタグ: 単一のinputタグ(type=checkbox)出力（選択項目）
- codeタグ: 表示用

## codeSelectタグ

selectタグに対応。CODE_PATTERNテーブルとCODE_NAMEテーブルのIDとPATTERNを指定して選択項目リストを取得する。

| 属性 | 説明 |
|---|---|
| withNoneOption | リスト先頭に選択なしのオプションを追加するか。true: 追加、false: 追加しない（デフォルト） |
| noneOptionLabel | 選択なしのラベル。withNoneOption="true"の場合のみ有効。デフォルト: "" |

labelPatternプレースホルダ:
- `$VALUE$`: コード値（VALUE）
- `$NAME$`: コード名称（NAME）
- `$SHORTNAME$`: コード略称（SHORT_NAME）
- `$OPTIONALNAME$`: コードのオプション名称（OPTION01）。使用するにはoptionColumnName属性の指定が必要。

pattern属性には、使用するパターンのカラム名を指定する（例: `pattern="PATTERN2"`）。CODE_PATTERNテーブルのうち、pattern属性で指定したカラム名の値が1の行から選択項目リストを作成する。

```jsp
<n:codeSelect name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

`n:codeCheckbox`タグでコード値が2件以上の場合の実装。

> **重要**: コード値が2件以上の場合、`codeId`属性からの検索で`offCodeValue`が見つからないため、`offCodeValue`属性を明示的に指定する必要がある。また、デフォルト値（`1`）と異なる場合は`value`属性も明示的に指定する。

**JSP実装例**:
```jsp
<n:codeCheckbox name="W11AF01.join" codeId="0002"
                value="Y" offCodeValue="N"
                labelPattern="$SHORTNAME$($OPTIONALNAME$)"
                optionColumnName="OPTION01" />
```

入力項目のカスタムタグを使用して確認画面用の出力が可能。確認画面では`confirmationPage`タグを使い、入力画面にフォワードする。

対象タグ: :ref:`howto_single_input`, :ref:`code_select`

<details>
<summary>keywords</summary>

codeSelectタグ, codeRadioButtonsタグ, codeCheckboxesタグ, codeCheckboxタグ, codeタグ, withNoneOption, noneOptionLabel, labelPattern, codeId, pattern, optionColumnName, コード値, CODE_PATTERNテーブル, CODE_NAMEテーブル, コードリスト, n:codeCheckbox, offCodeValue属性, コード値2件以上, value属性, labelPattern属性, optionColumnName属性, チェックボックス, confirmationPage, 確認画面用出力, 入力項目, フォワード

</details>

## codeRadioButtonsタグ

codeRadioButtonsタグは、HTMLの複数のinputタグ(type=radio)に対応している。CODE_PATTERNテーブルとCODE_NAMEテーブルのIDとPATTERNを指定して選択項目リストを取得する。pattern属性には、使用するパターンのカラム名を指定する（例: `pattern="PATTERN2"`）。id属性は`nablarch_radio<連番>`形式で自動付与される。

```jsp
<n:codeRadioButtons name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

`n:code`タグは、指定したフォーマットにあわせてコード値を出力する。登録画面や更新画面で選択可能なコード値を表示する場合、通常`codeSelect`タグ、`codeRadioButtons`タグ、`codeCheckboxes`タグ、`codeCheckbox`タグのいずれかを使用する。しかし、選択可能なコード値を一覧表示し、テキストボックスに入力する仕様の場合は`n:code`タグを使用する。

`n:code`タグで詳細・一覧画面にコードの選択項目を表示する場合、Actionクラスでリクエストスコープにデータを設定する必要がある。

CODE_NAMEテーブルの表示項目選択条件:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルの`pattern`属性で指定したカラム名の値が`1`
3. VALUEカラムの値 = `name`属性の参照値

`labelPattern`属性の変数:
- `$VALUE$`: コード値（VALUEカラム）
- `$NAME$`: コード名称（NAMEカラム）
- `$SHORTNAME$`: コード略称（SHORT_NAMEカラム）
- `$OPTIONALNAME$`: コードのオプション名称（OPTION01）— 使用する場合は`optionColumnName`属性でカラム名を指定する必要がある

**Actionクラス実装例**:
```java
W11AC02Form form = new W11AC02Form();
form.setBatchStatus(Batch.WAITING);
context.setRequestScopedVar("W11AC02", form);
```

**JSP実装例**:
```jsp
<n:code name="W11AC02.batchStatus"
        codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

単項目精査エラーや業務エラー発生時のエラーメッセージ表示のために以下のタグが提供されている:

- `errors`タグ
- `error`タグ

エラーの原因となった入力項目のハイライト表示機能も提供されている。

<details>
<summary>keywords</summary>

codeRadioButtonsタグ, codeId, pattern, optionColumnName, labelPattern, CODE_PATTERNテーブル, CODE_NAMEテーブル, nablarch_radio, コード値, n:code, codeタグ, labelPattern属性, pattern属性, optionColumnName属性, $VALUE$ $NAME$ $SHORTNAME$ $OPTIONALNAME$, 詳細画面 一覧画面 コード表示, リクエストスコープ, listFormat, W11AC02Action, W11AC02Form, errors タグ, error タグ, エラーメッセージ表示, エラー項目ハイライト, バリデーションエラー

</details>

## codeCheckboxesタグ

codeCheckboxesタグは、HTMLの複数のinputタグ(type=checkbox)に対応している。CODE_PATTERNテーブルとCODE_NAMEテーブルのIDとPATTERNを指定して選択項目リストを取得する。pattern属性には、使用するパターンのカラム名を指定する（例: `pattern="PATTERN2"`）。id属性は`nablarch_checkbox<連番>`形式で自動付与される。

```jsp
<n:codeCheckboxes name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

`n:code`タグで登録・更新画面にコード値を一覧形式で表示する場合。`codeId`属性と`pattern`属性のみからコード値を取得するため、Actionクラスでのリクエストスコープ設定は不要。

CODE_NAMEテーブルの表示項目選択条件:
1. `codeId`属性で指定したID
2. CODE_PATTERNテーブルの`pattern`属性で指定したカラム名の値が`1`

- `name`属性は記述しない（特定の値への絞り込みなし）

**JSP実装例**:
```jsp
<n:code codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

国際化対応アプリケーションで言語に応じた画面文言切り替えを行うための`message`タグ。メッセージ機能のテーブルで言語毎に管理された文言を表示する。

**スレッドコンテキストの言語に応じたメッセージ表示**

```jsp
<n:message messageId="M7770001" />
```

**指定した言語のメッセージ表示**

`language`属性に言語を指定すると、スレッドコンテキストの設定に関わらず常に指定言語のメッセージが出力される。

```jsp
<n:message messageId="M7770001" language="ja" />
```

**埋め込み文字のフォーマット**

`var`属性でmessageタグの結果を変数に格納し、`option0`～`option9`属性に埋め込み文字として指定する。埋め込み文字もメッセージ機能で管理する場合は、まず`var`属性で取得してから`option`属性に指定する。

```jsp
<n:message var="title" messageId="M7770001" />
<n:message var="appName" messageId="M7770099" />
<n:message messageId="M7770008" option0="${title}" option1="${appName}" />
```

<details>
<summary>keywords</summary>

codeCheckboxesタグ, codeId, pattern, optionColumnName, labelPattern, CODE_PATTERNテーブル, CODE_NAMEテーブル, nablarch_checkbox, コード値, n:code, codeタグ, codeId属性, pattern属性, 登録画面 更新画面 コード値一覧, name属性なし, Actionクラス不要, listFormat, n:message, messageId, language属性, var属性, option0, option1, option2, option3, option4, option5, option6, option7, option8, option9, 国際化, 多言語対応, メッセージ表示

</details>

## codeCheckboxタグ

codeCheckboxタグは、HTMLの単一のinputタグ(type=checkbox)に対応している。コード値のデータ件数に応じて下記の属性を指定する。

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| value | | "1" | チェックありの場合に使用するコード値 |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | "$NAME$" | ラベルを整形するパターン（$NAME$/$SHORTNAME$/$OPTIONALNAME$/$VALUE$）。$OPTIONALNAME$使用時はoptionColumnName属性が必須 |
| offCodeValue | | | チェックなしの場合のコード値。未指定時はcodeIdからチェックなしのコード値を検索し、結果が2件かつ1件がvalue属性の値の場合に残りの1件を使用 |

日付や金額などの値をフォーマットして出力する場合、`write`タグや`text`タグの`valueFormat`属性を指定する。

<details>
<summary>keywords</summary>

codeCheckboxタグ, value, codeId, optionColumnName, labelPattern, offCodeValue, コード値, CODE_NAMEテーブル, valueFormat属性, write タグ, text タグ, 日付フォーマット, 金額フォーマット, 出力フォーマット

</details>

## HTMLエスケープせずに値を出力する方法

`prettyPrint`タグまたは`rawWrite`タグを使用する。

> **警告**: HTMLのソースコードを表示する場合など、HTMLエスケープをどうしても避けられない場合にのみ使用すること。それ以外の場合は必ずHTMLエスケープを行うこと。

<details>
<summary>keywords</summary>

prettyPrint タグ, rawWrite タグ, HTMLエスケープ無効化, XSS, セキュリティ

</details>

## hiddenタグの暗号化機能の解除

hiddenタグの値の改ざん・参照を防ぐためにhiddenタグの暗号化機能が提供されている。デフォルトで有効。使用しない場合はカスタムタグのデフォルト値を変更する必要がある。

**クラス**: `nablarch.common.web.tag.CustomTagConfig`

| プロパティ名 | 型 | デフォルト値 | 説明 |
|---|---|---|---|
| useHiddenEncryption | boolean | true | `true`で暗号化有効、`false`で無効 |

```xml
<component name="customTagConfig"
           class="nablarch.common.web.tag.CustomTagConfig">
    <property name="useHiddenEncryption" value="false" />
</component>
```

<details>
<summary>keywords</summary>

CustomTagConfig, useHiddenEncryption, hidden タグ暗号化, 暗号化解除, カスタムタグ設定

</details>
