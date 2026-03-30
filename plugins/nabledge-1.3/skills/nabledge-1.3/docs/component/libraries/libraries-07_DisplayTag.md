# 値のフォーマット出力

## 値のフォーマット出力

:ref:`WebView_WriteTag` と :ref:`WebView_TextTag` はvalueFormat属性でフォーマット出力可能。valueFormat属性なし → フォーマットせずに値を出力。

valueFormat属性形式: `"データタイプ{パターン}"`

> **注意**: データタイプは `アプリケーションでのフォーマットの変更方法` で設定するデータタイプ名を使用すること。

**dateTimeはwriteタグのみで使用できる。**

### yyyymmdd (年月日フォーマット)

- 値: yyyyMMdd形式またはパターン形式の文字列
- パターン: java.text.SimpleDateFormat構文
- **パターン文字はy(年)、M(月)、d(月における日)のみ指定可能**
- パターン省略時: :ref:`WebView_CustomTagConfig` のデフォルトパターンを使用
- ロケール: "|"区切りで付加可。省略時はThreadContextのロケール設定値を使用。ThreadContextも未設定の場合はシステムデフォルトロケール。
- textタグでvalueFormat属性を指定した場合、入力画面にもフォーマット出力。アクションで取得には :ref:`ExtendedValidation_yyyymmddConvertor` を使用。

```bash
valueFormat="yyyymmdd"                    # デフォルトパターン + ThreadContextロケール
valueFormat="yyyymmdd{yyyy/MM/dd}"        # 指定パターン + ThreadContextロケール
valueFormat="yyyymmdd{|ja}"               # デフォルトパターン + ロケールja指定
valueFormat="yyyymmdd{yyyy年MM月d日|ja}"  # パターン・ロケール両方指定
```

### yyyymm (年月フォーマット)

- 値: yyyyMM形式またはパターン形式の文字列
- 使用方法はyyyymmddと同様
- textタグ使用時は :ref:`ExtendedValidation_yyyymmConvertor` を使用

### dateTime (日時フォーマット) — writeタグのみ

- 値: java.util.Date型
- パターン: java.text.SimpleDateFormat構文
- デフォルト: ThreadContextのロケールとタイムゾーンを使用
- "|"区切りでロケール・タイムゾーンを明示的に指定可
- :ref:`WebView_CustomTagConfig` でパターンのデフォルト値設定と区切り文字変更可

```bash
valueFormat="dateTime"                                             # デフォルト
valueFormat="dateTime{|ja|Asia/Tokyo}"                            # ロケール・タイムゾーン指定
valueFormat="dateTime{||Asia/Tokyo}"                               # タイムゾーンのみ
valueFormat="dateTime{yyyy年MMM月d日(E) a hh:mm|ja|America/New_York}}" # 全指定
valueFormat="dateTime{yy/MM/dd HH:mm:ss||Asia/Tokyo}"             # パターン・タイムゾーン指定
```

### decimal (10進数フォーマット)

- 値: java.lang.Number型または数字文字列（文字列の場合は言語に対応する1000区切り文字を除去してからフォーマット）
- パターン: java.text.DecimalFormat構文
- デフォルト: ThreadContextの言語を使用
- "|"区切りで言語を明示的に指定可
- :ref:`WebView_CustomTagConfig` で区切り文字変更可
- **桁区切りと小数点を指定する場合は言語に関係なく常に桁区切りにカンマ、小数点にドットを使用**
- textタグ使用時は [数値コンバータ(BigDecimalConvertor、IntegerConvertor、LongConvertor)](libraries-validation_basic_validators.md) を使用

```bash
valueFormat="decimal{###,###,###.000}"       # ThreadContext言語使用
valueFormat="decimal{###,###,###.000|ja}"    # 言語ja指定
valueFormat="decimal{###,###,###.000|es}"    # es(スペイン語)指定 - 正しい指定
# valueFormat="decimal{###.###.###,000|es}" は不正: 実行時例外がスローされる
```

## errorタグ

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | ○ | | エラーメッセージを表示する入力項目のname属性 |
| errorCss | | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| messageFormat | | div | メッセージ表示フォーマット。`div`（divタグ）または`span`（spanタグ） |

JSP使用例（入力項目直下にエラーメッセージを表示）:

```jsp
<n:text name="systemAccount.loginId" size="22" maxlength="20" />
<n:error name="systemAccount.loginId" />
```

## 共通属性

4つのタグ（codeSelect/codeRadioButtons/codeCheckboxes/code）の共通属性:

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| name | 選択項目のみ必須 | | 選択項目: 選択コード値をリクエストパラメータ/変数スコープから取得するname属性。表示項目: 変数スコープから取得する名前 |
| codeId | ○ | | コードID |
| pattern | | 指定なし | 使用するパターンのカラム名 |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | $NAME$ | ラベル整形パターン。プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称、optionColumnName指定必須)、`$VALUE$`(コード値) |
| listFormat | | br | リスト表示フォーマット。`br`/`div`/`span`/`ul`/`ol`/`sp`(スペース区切り) |

> **注意**: listFormatの適用範囲はタグにより異なる。codeSelectタグ: 確認画面のみ。codeRadioButtonsタグ・codeCheckboxesタグ: 入力・確認画面両方。codeタグ: 常に適用。

## codeCheckboxタグ

XHTMLの属性に加え、以下の属性をサポートする。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| value | | `"1"` | チェックありの場合に使用するコード値 |
| codeId | ○ | | コードID |
| optionColumnName | | | 取得するオプション名称のカラム名 |
| labelPattern | | `"$NAME$"` | ラベル整形パターン。プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称、optionColumnName指定必須)、`$VALUE$`(コード値) |
| offCodeValue | | | チェックなしの場合に使用するコード値。未指定時はcodeId属性値から検索し、検索結果が2件かつ1件がvalue属性値の場合、残り1件をチェックなしのコード値として使用する |

チェックなしに対応する値をリクエストパラメータに設定する仕組みは :ref:`WebView_SingleCheckBoxTag` と同じ。

value属性・offCodeValue属性・labelPattern属性のデフォルト値は、:ref:`WebView_CustomTagConfig` の `onCheckboxValue`プロパティ、`offCheckboxValue`プロパティ、`codeLabelPattern`プロパティで設定する。

**動作仕様:**
- ラベルはブランクでない場合のみ出力する
- id属性未指定時は、フレームワークが `nablarch_<checkbox><連番>` 形式でid属性値を生成する（連番は画面内でのcheckboxタグ出現順に1から）
- codeCheckboxタグはフラグ値を扱うため、コード管理のパターン指定は使用しない

**コード値2件(codeId:0001)の使用例 — offCodeValue自動解決:**

```jsp
<%-- offCodeValue未指定。codeId:0001の検索結果が2件(1,0)で1件がvalue値(=1)のため、残り(=0)を自動使用 --%>
<n:codeCheckbox name="user.canUpdate" codeId="0001" />
```

出力HTML:

```html
<input id="nablarch_checkbox1" type="checkbox" name="user.canUpdate" value="1" />
    <label for="nablarch_checkbox1">許可</label>
```

確認画面: チェックあり→「許可」（コード値:1のNAME列）、チェックなし→「不許可」（コード値:0のNAME列）

**コード値2件以上(codeId:0002)の使用例 — offCodeValue明示指定:**

コード値が2件以上存在する場合はcodeIdから自動解決できないため、offCodeValue属性を明示指定する。

```jsp
<n:codeCheckbox name="user.join" codeId="0002"
                value="Y" offCodeValue="N"
                labelPattern="$VALUE$:$SHORTNAME$($OPTIONALNAME$)"
                optionColumnName="OPTION01" />
```

出力HTML:

```html
<input id="nablarch_checkbox1" type="checkbox" name="user.join" value="Y" />
    <label for="nablarch_checkbox1">Y:YES(イエス)</label>
```

確認画面: チェックあり→「Y:YES(イエス)」、チェックなし→「N:NO(ノー)」

<details>
<summary>keywords</summary>

valueFormat, yyyymmdd, yyyymm, dateTime, decimal, YYYYMMDDFormatter, DateTimeFormatter, DecimalFormatter, フォーマット出力, 日付フォーマット, 数値フォーマット, WebView_WriteTag, WebView_TextTag, SimpleDateFormat, DecimalFormat, ExtendedValidation_yyyymmddConvertor, ExtendedValidation_yyyymmConvertor, WebView_CustomTagConfig, ThreadContext, errorタグ, name, errorCss, messageFormat, エラーメッセージ表示, nablarch_error, バリデーションエラー表示, codeSelect, codeRadioButtons, codeCheckboxes, code, 共通属性, codeId, pattern, optionColumnName, labelPattern, listFormat, コード値表示, ラベルパターン, codeCheckbox, offCodeValue, onCheckboxValue, offCheckboxValue, codeLabelPattern, $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$, コードチェックボックス, チェックボックスタグ, フラグ値入力, コード値チェックボックス

</details>

## フォーマット出力の使用例

年月日フォーマット `yyyymmdd{yyyy/M/d}` を使用したn:writeタグの例:

```jsp
<tr>
    <td class="boldTd" width="300" bgcolor="#ffff99">
        有効期限
    </td>
    <td width="400">
        <n:write name="systemAccount.effectiveDateFrom" valueFormat="yyyymmdd{yyyy/M/d}" />
        ～
        <n:write name="systemAccount.effectiveDateTo" valueFormat="yyyymmdd{yyyy/M/d}" />
    </td>
</tr>
```

出力結果（入力値"20101203"の場合）:

```html
<tr>
    <td class="boldTd" width="300" bgcolor="#ffff99">
        有効期限
    </td>
    <td width="400">
        2010/12/3
        ～
        2011/12/3
    </td>
</tr>
```

## errorタグの出力動作

エラーがある入力項目はデフォルトでdivタグでメッセージが出力される。エラーがない項目は何も出力されない。

HTML出力例（エラーあり）:

```html
<div class="nablarch_error">パスワードを入力してください。</div>
```

> **注意**: errorタグで表示するエラーメッセージは通常 [バリデーションの機能](libraries-validation-core_library.md) で自動的に設定される。バリデーション機能以外から任意のメッセージを表示させる場合は :ref:`validation-message-creation` の方法でエラーメッセージを作成すること。

共通属性の使用例:

**CODE_PATTERN テーブル例:**

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 01 | 1 | 0 | 0 |
| 0001 | 02 | 1 | 0 | 0 |
| 0002 | 01 | 1 | 0 | 0 |
| 0002 | 02 | 1 | 0 | 0 |
| 0002 | 03 | 0 | 1 | 0 |
| 0002 | 04 | 0 | 1 | 0 |
| 0002 | 05 | 1 | 0 | 0 |

**CODE_NAME テーブル例:**

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 01 | 1 | ja | 男性 | 男 | 0001-01-ja |
| 0001 | 02 | 2 | ja | 女性 | 女 | 0001-02-ja |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | 0002-01-ja |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | 0002-02-ja |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | 0002-03-ja |
| 0002 | 04 | 4 | ja | 処理実行完了 | 完了 | 0002-04-ja |
| 0002 | 05 | 5 | ja | 処理結果確認完了 | 確認 | 0002-05-ja |
| 0001 | 01 | 2 | en | Male | M | 0001-01-en |
| 0001 | 02 | 1 | en | Female | F | 0001-02-en |
| 0002 | 01 | 1 | en | Initial State | Initial | 0002-01-en |
| 0002 | 02 | 2 | en | Waiting For Batch Start | Waiting | 0002-02-en |
| 0002 | 03 | 3 | en | Batch Running | Running | 0002-03-en |
| 0002 | 04 | 4 | en | Batch Execute Completed Checked | Completed | 0002-04-en |
| 0002 | 05 | 5 | en | Batch Result Checked | Checked | 0002-05-en |

Javaアクション実装例:

```java
// アクションの実装例
BatchEntity batch = new BatchEntity();
batch.setStatus("03"); // "03"を設定
context.setRequestScopedVar("batch", batch);
```

JSP使用例（codeSelectタグ）:

```jsp
<n:codeSelect name="batch.status"
              codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
              labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
              listFormat="div" />
```

HTML出力例（入力画面）:

```html
<select name="batch.status">
    <option value="">選択なし</option>
    <option value="03" selected="selected">03:処理実行中-実行-0002-03-ja</option>
    <option value="04">04:処理実行完了-完了-0002-04-ja</option>
</select>
```

HTML出力例（確認画面）:

```html
<div>03:処理実行中-実行-0002-03-ja</div>
```

<details>
<summary>keywords</summary>

yyyymmdd, valueFormat, n:write, フォーマット出力, 使用例, 有効期限, errorタグ, HTML出力, nablarch_error, エラーメッセージ, バリデーション連携, validation-message-creation, 共通属性使用例, CODE_PATTERN, CODE_NAME, コードテーブル, codeSelect, 入力画面, 確認画面, labelPattern使用例

</details>

## 入力画面でのフォーマット出力

> **注意**: 入力画面でフォーマット出力する際の注意点

入力項目に指定されたフォーマットはウィンドウスコープで管理される。**入力値をウィンドウスコープに設定しないと、ウィンドウスコープにフォーマットが設定されずフォーマット編集が行えない。**

入力画面でフォーマット出力を行う際は、`n:form`の`windowScopePrefixes`属性に入力値のプレフィックスを設定すること。

```jsp
<n:form windowScopePrefixes="searchCondition">
  <n:text name="searchCondition.yyyymmdd" valueFormat="yyyymmdd{yyyy年MM月dd日|ja}" />
  <n:text name="searchCondition.yyyymm" valueFormat="yyyymm{yyyy年MM月|ja}" />
</n:form>
```

## エラーの原因となった入力項目のハイライト表示

エラーの原因となった入力項目のclass属性に、CSSクラス名（デフォルト: `nablarch_error`）が追記される。CSSクラス名は入力項目カスタムタグの`errorCss`属性で変更可能。

CSSでスタイルを指定してハイライト表示する例:

```css
input.nablarch_error, select.nablarch_error { background-color: #FFFF00; }
```

- 追加属性は共通属性( :ref:`WebView_CodeSelectCommon` )のみ
- ラベル出力時、id属性は`nablarch_<radio|checkbox><連番>`形式で自動生成（連番=画面内出現順、1から）
- tabindex属性の値はすべてのinputタグに出力される

JSP使用例:

```jsp
<n:codeRadioButtons name="team.color" tabindex="3"
          codeId="0001" labelPattern="$VALUE$:$NAME$" />
<n:codeCheckboxes name="team.titles" tabindex="5"
          codeId="0002" labelPattern="$VALUE$:$NAME$" />
```

HTML出力例（入力画面）:

```html
<input id="nablarch_radio1" tabindex="3" type="radio" name="team.color" value="001"><label for="nablarch_radio1">001:red</label><br>
<input id="nablarch_radio2" tabindex="3" type="radio" name="team.color" value="002"><label for="nablarch_radio2">002:blue</label><br>
...
<input id="nablarch_checkbox1" tabindex="5" type="checkbox" name="team.titles" value="01"><label for="nablarch_checkbox1">01:地区優勝</label><br>
<input id="nablarch_checkbox2" tabindex="5" type="checkbox" name="team.titles" value="02"><label for="nablarch_checkbox2">02:リーグ優勝</label><br>
<input id="nablarch_checkbox3" tabindex="5" type="checkbox" name="team.titles" value="03"><label for="nablarch_checkbox3">03:ファイナル優勝</label><br>
```

<details>
<summary>keywords</summary>

ウィンドウスコープ, windowScopePrefixes, n:form, n:text, フォーマット, 入力画面, ハイライト表示, nablarch_error, errorCss, CSSクラス, エラー入力項目強調, 背景色, codeRadioButtons, codeCheckboxes, nablarch_radio, nablarch_checkbox, id属性自動生成, tabindex, ラジオボタン, チェックボックス, labelタグ

</details>

## アプリケーションでのフォーマットの変更方法

フォーマットは **`nablarch.common.web.tag.ValueFormatter`** インタフェースを実装したクラスが行う。実装クラスをリポジトリに登録することでフォーマットを変更できる。

- リポジトリへの登録: Map型でデータタイプ名をキー、ValueFormatter実装クラスを値に指定
- マップ登録名: `"valueFormatters"`
- リポジトリに未登録の場合はフレームワークのデフォルトフォーマットを使用

> **注意**: データタイプ名(Map型のキー値)は、valueFormat属性に指定するデータタイプ名となる。

```xml
<map name="valueFormatters">
    <entry key="yyyymmdd">
        <value-component class="nablarch.common.web.tag.YYYYMMDDFormatter" />
    </entry>
    <entry key="dateTime">
        <value-component class="nablarch.common.web.tag.DateTimeFormatter" />
    </entry>
    <entry key="decimal">
        <value-component class="nablarch.common.web.tag.DecimalFormatter" />
    </entry>
</map>
```

## nameAlias属性の使用方法

エラーの原因が複数の入力項目にまたがる場合、nameAlias属性を使用することで複数の入力項目を同時にハイライト表示できる。入力項目カスタムタグのname属性のエイリアスをnameAlias属性に指定する。

```jsp
<n:text name="users.mobilePhoneNumberAreaCode" nameAlias="users.mobilePhoneNumber" size="5" maxlength="3" />
<n:text name="users.mobilePhoneNumberCityCode" nameAlias="users.mobilePhoneNumber" size="6" maxlength="4" />
<n:text name="users.mobilePhoneNumberSbscrCode" nameAlias="users.mobilePhoneNumber" size="6" maxlength="4" />
```

エラーメッセージはエイリアス名で登録する:

```java
context.addResultMessage("mobilePhoneNumber", "MSG00004");
```

共通属性( :ref:`WebView_CodeSelectCommon` )に加えて以下の属性を追加:

| 属性 | デフォルト値 | 説明 |
|---|---|---|
| withNoneOption | false | リスト先頭に「選択なし」オプションを追加するか。true=追加、false=追加しない |
| noneOptionLabel | "" | withNoneOptionがtrueの場合のみ有効。「選択なし」オプションのラベル |

使用例は :ref:`WebView_MultiSelectCustomTag` を参照。

<details>
<summary>keywords</summary>

ValueFormatter, valueFormatters, YYYYMMDDFormatter, DateTimeFormatter, DecimalFormatter, フォーマットカスタマイズ, nameAlias, 複数入力項目ハイライト, addResultMessage, 項目間精査, エイリアス, codeSelect, withNoneOption, noneOptionLabel, 選択なしオプション, プルダウン

</details>

## エラー表示

エラー表示のカスタムタグ:

| カスタムタグ | 説明 |
|---|---|
| :ref:`WebView_ErrorsTag` | 複数のエラーメッセージをリスト表示する場合に使用する。 |
| :ref:`WebView_ErrorTag` | エラーの原因となった入力項目の近くにエラーメッセージを個別に表示する場合に使用する。 |

errorsタグとerrorタグはリクエストスコープからApplicationExceptionを取得してエラーメッセージを出力する。ApplicationExceptionはWebフロントコントローラの例外制御(OnErrorアノテーション)を使用してリクエストスコープに設定する。

**アノテーション**: `@OnError`

```java
@OnError(type = ApplicationException.class, path = "forward://MENUS00103")
public HttpResponse doUSERS00201(HttpRequest req, ExecutionContext ctx) {
    // 省略
}
```

## コード値の表示

コード管理機能から取得したコード値の選択項目・表示項目を出力する機能（[../../03_Common/02_CodeManager](libraries-02_CodeManager.md) 参照）。

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| :ref:`WebView_CodeSelectTag` | selectタグ |
| :ref:`WebView_CodeRadiobuttonsTag` | 複数のinputタグ(type=radio) |
| :ref:`WebView_CodeCheckboxesTag` | 複数のinputタグ(type=checkbox) |
| :ref:`WebView_CodeCheckboxTag` | 単一のinputタグ(type=checkbox) |
| :ref:`WebView_CodeTag` | 指定されたフォーマットに対応するタグ |

- codeタグ以外は選択項目、codeタグは表示項目を出力する
- codeタグは :ref:`WebView_WriteTag` と同様に一覧表示や参照画面でコード値を出力する場合に使用
- codeCheckboxタグは :ref:`WebView_SingleCheckBoxTag` と同様に単一のinputタグ(type=checkbox)を出力する。データベース上でフラグ(1or0)で表されるデータ項目に対してコード管理機能でチェック有無のラベルを管理する場合に使用

- 追加属性は共通属性( :ref:`WebView_CodeSelectCommon` )のみ
- name属性省略可。省略した場合はcodeIdとpatternで取得できる全コード値を表示
- 表示専用タグのため、name属性指定時は変数スコープから値を取得する

Javaアクション実装例:

```java
// アクションの実装例
BatchEntity batch = new BatchEntity();
batch.setStatus("03"); // "03"を設定
context.setRequestScopedVar("batch", batch);
```

JSP使用例:

```jsp
<%-- name属性を指定した場合 --%>
<n:code name="batch.status"
        codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />

<%-- name属性を省略した場合 --%>
<n:code codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
        labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
        listFormat="div" />
```

HTML出力例:

```html
<%-- name属性を指定した場合 --%>
<div>03:処理実行中-実行-0002-03-ja</div>

<%-- name属性を省略した場合 --%>
<div>03:処理実行中-実行-0002-03-ja</div>
<div>04:処理実行完了-完了-0002-04-ja</div>
```

<details>
<summary>keywords</summary>

WebView_ErrorsTag, WebView_ErrorTag, ApplicationException, OnError, errorsタグ, errorタグ, エラーメッセージ, コード値の表示, WebView_CodeSelectTag, WebView_CodeRadiobuttonsTag, WebView_CodeCheckboxesTag, WebView_CodeCheckboxTag, WebView_CodeTag, コード管理機能, codeCheckboxタグ, code_tag, code, name属性省略, 全コード値表示, 表示専用タグ, コード値, コード値表示

</details>

## errorsタグ

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| cssClass | nablarch_errors | リスト表示においてulタグに使用するCSSクラス名 |
| infoCss | nablarch_info | 情報レベルのメッセージに使用するCSSクラス名 |
| warnCss | nablarch_warn | 警告レベルのメッセージに使用するCSSクラス名 |
| errorCss | nablarch_error | エラーレベルのメッセージに使用するCSSクラス名 |
| filter | all | リストに含めるメッセージのフィルタ条件: `all`(全て) / `global`(ValidationResultMessageのプロパティ名がないメッセージのみ) |

使用例:

```jsp
<n:errors />
```

HTML出力例:

```html
<ul class="nablarch_errors">
    <li class="nablarch_error">パスワードを入力してください。</li>
    <li class="nablarch_error">漢字氏名を入力してください。</li>
    <li class="nablarch_error">内線番号(ビル番号)を入力してください。</li>
    <li class="nablarch_error">内線番号(個人番号)を入力してください。</li>
    <li class="nablarch_error">カナ氏名を入力してください。</li>
    <li class="nablarch_error">メールアドレスを入力してください。</li>
</ul>
```

![errorsタグの表示例](../../../knowledge/component/libraries/assets/libraries-07_DisplayTag/WebView_Errors.jpg)

<details>
<summary>keywords</summary>

cssClass, infoCss, warnCss, errorCss, filter, nablarch_errors, nablarch_error, nablarch_info, nablarch_warn, errorsタグ, ValidationResultMessage, エラーリスト表示

</details>

## errorタグ

errorタグ (:ref:`WebView_ErrorTag`) は、エラーの原因となった入力項目の近くにエラーメッセージを個別に表示する場合に使用する。errorsタグがフィルタ条件に従ってエラーメッセージをリスト表示するのに対し、errorタグは特定の入力項目に対するエラーメッセージを個別に出力する。

<details>
<summary>keywords</summary>

WebView_ErrorTag, errorタグ, WebView_ErrorViewErrorTag, エラーメッセージ個別表示

</details>
