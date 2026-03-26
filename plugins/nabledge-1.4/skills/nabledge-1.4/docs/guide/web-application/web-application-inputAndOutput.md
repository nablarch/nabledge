# フォーム内の入力要素を出力するカスタムタグ

## フォーム内の入力要素を出力するカスタムタグ

Nablarchフレームワークが提供するForm内入力要素用カスタムタグ一覧。

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
| radioButtonsタグ | 複数のinputタグ(type=radio)（List型変数の各要素ごと） |
| checkboxesタグ | 複数のinputタグ(type=checkbox)（List型変数の各要素ごと） |

コード値が2件の場合の `n:codeCheckbox` タグの実装。value属性（デフォルト: `1`）・labelPattern属性（デフォルト: `$NAME$`）のデフォルト値がそのまま使用できる。

id属性は `nablarch_checkbox<連番>` 形式で自動付与される。

**JSP実装例**:
```jsp
<n:codeCheckbox name="W11AF01.canUpdate" codeId="0001" />
```

**出力HTML**:
```html
<input id="nablarch_checkbox1" type="checkbox" name="W11AF01.canUpdate" value="1" />
<label for="nablarch_checkbox1">許可</label>
```

入力フォームの入力/選択項目に初期値を設定する場合、JSPへ遷移する前にActionクラスでリクエストスコープにデータを設定する必要がある。カスタムタグのname属性で指定する値と、アクションでリクエストスコープに初期値を設定する際に使用する名前を合わせること。JSP側では初期値設定のための特別な実装は不要。

対象タグ: :ref:`howto_single_input`, :ref:`code_select`

**登録画面: Mapを使用した初期値設定**

Mapを使用して初期値を設定できる。Mapのキーにプロパティ名を明示的に指定する必要がある。

```java
Map<String, String> map = new HashMap<String, String>();
map.put("effectiveDateFrom", new Date());
ctx.setRequestScopedVar("W11AC02", map);
```

JSP (`W11AC02.effectiveDateFrom` の値が初期値として入力フォームに表示される):
```jsp
<n:text name="W11AC02.effectiveDateFrom" size="22" maxlength="20" />
```

**更新画面: SqlRow/フォーム/エンティティを使用した初期値設定**

SqlRowやフォーム/エンティティを使用すると、Mapを使用せずに初期値を設定できる。SqlResultSetのSqlRowにはプロパティ名が指定されているため、明示的にプロパティ名を指定する必要はなく、SqlRowをそのままリクエストスコープに設定できる。

```java
SqlResultSet userInfo = component.selectUserInfo(form);
ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
```

JSP (`W11AC03.name` の値が初期値として入力フォームに表示される):
```jsp
<n:text name="W11AC03.name" size="22" maxlength="20" />
```

**複数選択項目の初期値設定**

複数選択項目に初期値を設定する場合、初期値だけでなく、選択候補となる選択項目のリストもリクエストスコープに設定する必要がある。

```java
// 選択項目リストをリクエストスコープに設定
SqlResultSet ugroupList = component.selectUserGroups();
ctx.setRequestScopedVar("allGroups", ugroupList);

// 複数の初期値を配列で設定
Map<String, String> form = new HashMap<String, String>();
String[] defaultGroups = {"group2", "group3"};
form.put("groupIds", defaultGroups);
ctx.setRequestScopedVar("W11AC02", form);
```

JSP (`W11AC02.groupIds` に設定された値が初期選択される。選択される要素は `W11AC02.groupIds` に含まれる値 = `allGroups.id` の値に対応するラベル):
```jsp
<n:select name="W11AC02.groupIds" multiple="true"
       listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
       elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
```

<details>
<summary>keywords</summary>

textタグ, textareaタグ, passwordタグ, hiddenタグ, radioButtonタグ, checkboxタグ, compositeKeyRadioButtonタグ, compositeKeyCheckboxタグ, selectタグ, radioButtonsタグ, checkboxesタグ, フォーム入力要素, カスタムタグ一覧, 入力フォーム, 複合キー, n:codeCheckbox, codeCheckbox, コード値2件, チェックボックス, codeId, value属性デフォルト, labelPattern, nablarch_checkbox連番, 初期値設定, リクエストスコープ, Map, SqlRow, SqlResultSet, 複数選択項目, n:select, n:text, HttpRequest, ExecutionContext

</details>

## コード値の表示方法

コード値を選択/表示するためのカスタムタグ。codeタグは表示用、codeSelect・codeRadioButtons・codeCheckboxes・codeCheckboxは選択項目用。いずれもCODE_PATTERNテーブルとCODE_NAMEテーブルを使用する。

**labelPatternプレースホルダー**（codeSelect/codeRadioButtons/codeCheckboxes/codeCheckbox共通）:
- `$VALUE$`: コード値（VALUE）
- `$NAME$`: コード名称（NAME）
- `$SHORTNAME$`: コード略称（SHORT_NAME）
- `$OPTIONALNAME$`: コードのオプション名称。使用時はoptionColumnName属性の指定が必須。

コード値が2件以上の場合の `n:codeCheckbox` タグの実装。

コード値が2件以上存在するため、codeId属性から検索してもoffCodeValue属性が見つからない。そのため、**offCodeValue属性を明示的に指定する必要がある**。デフォルト値（`1`）と異なる場合はvalue属性も明示的に指定する。

**JSP実装例**:
```jsp
<n:codeCheckbox name="W11AF01.join" codeId="0002"
                value="Y" offCodeValue="N"
                labelPattern="$SHORTNAME$($OPTIONALNAME$)"
                optionColumnName="OPTION01" />
```

**出力HTML**:
```html
<input id="nablarch_checkbox1" type="checkbox" name="W11AF01.join" value="Y" />
<label for="nablarch_checkbox1">YES(イエス)</label>
```

入力項目のカスタムタグを使用して確認画面用の出力ができる。確認画面でconfirmationPageタグを使い、入力画面にフォワードする。

入力項目タグ: :ref:`howto_single_input`, :ref:`code_select`

<details>
<summary>keywords</summary>

codeSelectタグ, codeRadioButtonsタグ, codeCheckboxesタグ, codeCheckboxタグ, codeタグ, CODE_PATTERNテーブル, CODE_NAMEテーブル, コード値選択, コードマスタ, labelPattern, $VALUE$, $NAME$, $SHORTNAME$, $OPTIONALNAME$, optionColumnName, n:codeCheckbox, codeCheckbox, コード値2件以上, offCodeValue, offCodeValue明示指定, チェックボックス, codeId, 確認画面, confirmationPageタグ, フォワード, 入力項目確認画面

</details>

## codeSelectタグ

HTMLのselectタグに対応。codeId・patternを指定してCODE_PATTERNテーブルとCODE_NAMEテーブルから選択項目リストを取得する。

| 属性 | 説明 |
|---|---|
| withNoneOption | リスト先頭に選択なしのオプションを追加するかどうか。trueで追加、falseで追加しない（デフォルト）。 |
| noneOptionLabel | 選択なしのラベル。withNoneOption="true"の場合のみ有効。デフォルトは""。 |

```jsp
<n:codeSelect name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

`n:code` タグ（codeタグ）は、指定したフォーマットにあわせてコード値を出力する。

詳細画面・一覧画面でコードの選択項目を表示する場合（→ s4）と、登録・更新画面で選択可能なコード値を一覧形式で表示する場合（→ s5）の2つのユースケースがある。

> **タグ選択の指針**: 登録画面や更新画面で選択可能なコード値を表示する場合、通常は `codeSelectタグ`・`codeRadioButtonsタグ`・`codeCheckboxesタグ`・`codeCheckboxタグ` のいずれかを使用する。ただし、選択可能なコード値を一覧表示してテキストボックスに入力する仕様の場合は `n:code` タグを使用する（→ `list-of-codes-searched-by-codeId-and-pattern`）。

単項目精査エラーや業務エラーなどが発生したときのエラーメッセージ表示のために以下のタグを提供する:

- errorsタグ
- errorタグ

エラーの原因となった入力項目をハイライト表示させる機能も提供している。

<details>
<summary>keywords</summary>

codeSelectタグ, withNoneOption, noneOptionLabel, selectタグ, コード値ドロップダウン, codeId, pattern, listFormat, n:code, codeタグ, コード値出力, codeRadioButtonsタグ, codeCheckboxesタグ, テキストボックス入力, list-of-codes-searched-by-codeId-and-pattern, タグ選択, errorsタグ, errorタグ, エラーメッセージ表示, ハイライト表示, 単項目精査エラー, 業務エラー

</details>

## codeRadioButtonsタグ

HTMLの複数inputタグ(type=radio)に対応。codeId・patternを指定してCODE_PATTERNテーブルとCODE_NAMEテーブルから選択項目リストを取得する。id属性は`nablarch_radio<連番>`の形式で自動設定される。

```jsp
<n:codeRadioButtons name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

詳細・一覧画面でコード選択項目を表示する場合、Actionクラスでリクエストスコープにデータを設定する必要がある。

- `pattern` 属性: CODE_PATTERNテーブルのカラム名を指定。そのカラムの値が `1` の行のみ表示対象（name属性の参照値とVALUEカラムが一致する行）
- `labelPattern` 属性: ラベル表示形式。`$VALUE$`（コード値）、`$NAME$`（コード名称）、`$SHORTNAME$`（コード略称）、`$OPTIONALNAME$`（オプション名称）を組み合わせ可能
- `$OPTIONALNAME$` を使用する場合は `optionColumnName` 属性でカラム名を指定する必要がある

**Actionクラス実装例**:
```java
W11AC02Form form = new W11AC02Form();
form.setBatchStatus(Batch.WAITING); // 定数が"02"を表す
context.setRequestScopedVar("W11AC02", form);
```

**JSP実装例**:
```jsp
<n:code name="W11AC02.batchStatus"
        codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

**出力HTML**:
```html
<div>02:処理開始待ち-待ち-0002-02-ja</div>
```

国際化アプリケーションで言語に応じた画面の文言切り替えのためにmessageタグ（`<n:message>`）を提供する。messageタグはメッセージ機能で管理されているメッセージを表示する。メッセージ機能が管理するテーブルに言語毎の文言を準備することで切り替えが可能。

**スレッドコンテキストの言語に応じたメッセージ表示**

`messageId`属性のみ指定する:
```jsp
<n:message messageId="M7770001" />
```
スレッドコンテキストに設定された言語が`en`なら`User Registration`、`ja`なら`ユーザ登録`が出力される。

**指定言語のメッセージ表示**

`language`属性に言語を指定すると、スレッドコンテキストの言語設定に関わらず常に指定言語のメッセージが出力される:
```jsp
<n:message messageId="M7770001" language="ja" />
```

**埋め込み文字のフォーマット表示**

埋め込み文字もメッセージ機能で管理されたリソースから取得する場合は、まず`var`属性付きmessageタグで埋め込み文字を取得し、`option0`〜`option9`属性に指定する:
```jsp
<n:message var="title" messageId="M7770001" />
<n:message var="appName" messageId="M7770099" />
<n:message messageId="M7770008" option0="${title}" option1="${appName}" />
```
JSP上で埋め込み文字を直接指定する場合は`option0`〜`option9`属性に直接指定すればよい。

<details>
<summary>keywords</summary>

codeRadioButtonsタグ, nablarch_radio, ラジオボタン, コード値ラジオボタン, codeId, pattern, listFormat, n:code, codeタグ, 詳細画面, 一覧画面, コード選択項目表示, labelPattern, optionColumnName, Actionクラス, リクエストスコープ, $VALUE$, $NAME$, $SHORTNAME$, $OPTIONALNAME$, messageタグ, n:message, 国際化, 多言語対応, messageId, language属性, var属性, option0, スレッドコンテキスト, 埋め込み文字

</details>

## codeCheckboxesタグ

HTMLの複数inputタグ(type=checkbox)に対応。codeId・patternを指定してCODE_PATTERNテーブルとCODE_NAMEテーブルから選択項目リストを取得する。id属性は`nablarch_checkbox<連番>`の形式で自動設定される。

```jsp
<n:codeCheckboxes name="W11AF01.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

`n:code` タグで登録・更新画面にコード値一覧を表示する場合（:ref:`list-of-codes-searched-by-codeId-and-pattern`）。

JSPに指定した `codeId` 属性・`pattern` 属性のみでコード値を取得するため、**Actionクラスでリクエストスコープにデータを設定する必要はない**。また `name` 属性は記述しない。

- `pattern` 属性: CODE_PATTERNテーブルのカラム名の値が `1` の行のみ表示対象
- `labelPattern`、`optionColumnName` 属性の使用方法はs4と同様

**JSP実装例**:
```jsp
<n:code codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

**出力HTML**:
```html
<div>01:初期状態-初期-0002-01-ja</div>
<div>02:処理開始待ち-待ち-0002-02-ja</div>
```

日付や金額の値をフォーマットして出力したい場合、writeタグやtextタグの`valueFormat`属性を指定する。

<details>
<summary>keywords</summary>

codeCheckboxesタグ, nablarch_checkbox, チェックボックス複数, コード値チェックボックス複数, codeId, pattern, listFormat, n:code, codeタグ, 登録画面, 更新画面, コード値一覧表示, Actionクラス不要, name属性なし, list-of-codes-searched-by-codeId-and-pattern, labelPattern, optionColumnName, valueFormat属性, writeタグ, textタグ, フォーマット出力, 日付フォーマット, 金額フォーマット

</details>

## codeCheckboxタグ

HTMLの単一inputタグ(type=checkbox)に対応。コードIDに対応するコード値の件数に応じて属性を指定する。

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| value | | 1 | チェックありの場合に使用するコード値。 |
| codeId | ○ | | コードID。 |
| optionColumnName | | | 取得するオプション名称のカラム名。 |
| labelPattern | | $NAME$ | ラベル整形パターン。プレースホルダー: $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$。 |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定時はcodeId属性の値からコード値を検索し、2件かつ1件がvalue属性の値である場合に残りの1件をチェックなしのコード値として使用する。 |

HTMLエスケープを行わず値をそのまま出力したい場合、prettyPrintタグまたはrawWriteタグを使用する。

> **警告**: 本機能はHTMLのソースコードを表示したい場合など、HTMLエスケープをどうしても避けたい場合にのみ使用すること。それ以外の場合は必ずHTMLエスケープを行うこと。

<details>
<summary>keywords</summary>

codeCheckboxタグ, value, codeId, offCodeValue, optionColumnName, labelPattern, 単一チェックボックス, コード値チェックボックス単一, prettyPrintタグ, rawWriteタグ, HTMLエスケープなし, XSS対策

</details>

## hiddenタグの暗号化機能の解除

hiddenタグの値を改ざん・参照させないための暗号化機能がデフォルトで有効になっている。使用しない場合はカスタムタグのデフォルト値を変更する必要がある。

`useHiddenEncryption`プロパティで制御する（デフォルト: `true`）:

```xml
<component name="customTagConfig"
           class="nablarch.common.web.tag.CustomTagConfig">
    <!-- useHiddenEncryption="true"で暗号化を行う（デフォルト） -->
    <!-- useHiddenEncryption="false"で暗号化を行わない -->
    <property name="useHiddenEncryption" value="false" />
</component>
```

<details>
<summary>keywords</summary>

hiddenタグ, 暗号化, useHiddenEncryption, CustomTagConfig, nablarch.common.web.tag.CustomTagConfig

</details>
