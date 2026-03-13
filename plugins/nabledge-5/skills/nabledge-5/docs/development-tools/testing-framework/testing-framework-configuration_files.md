# UI開発基盤設定ファイル

**公式ドキュメント**: [UI開発基盤設定ファイル](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/configuration_files.html)

## タグ定義

## タグ定義

**配置場所**: `/js/devtool/resource/タグ定義.js`

各JSPウィジェットのローカル表示・設計書ビュー表示に必要な捕捉情報を記述する設定ファイル。JSPウィジェットを追加した場合は、ここの定義を追加する必要がある。

### 記述書式

JavaScriptのオブジェクトリテラル形式で記述する。各ウィジェットごとに以下の形式でエントリを追加する。

```javascript
'【タグ名】' : [ '【UI要素名】', {【オプション】} ]
```

```javascript
, 'field:label'         : ['テキスト表示',       {ignoredInForm:true}]
, 'field:listbuilder'   : ['リストビルダー',     {multiple:true}]
```

- **【タグ名】**: 当該JSPタグの名称（例: `'field:code_checkbox'`）
- **【UI要素名】**: 当該タグのUI部品名。設計書ビューの「画面項目種類」欄に表示される（例: `'チェックボックス'`）

### オプション一覧

| オプション | デフォルト | 説明 |
|---|---|---|
| multiple | false | 複数選択項目（同一name属性のinput要素を複数持ちうる）の場合にtrue |
| ignoreInForm | false | 単なる表示項目である場合にtrue |
| defaultLabel | | button:タグにデフォルトで表示する文言 |
| complex | | 複数のinput要素で構成される場合、項目名とname属性を`|`区切りで記述 |

**complexの記述例**:

```javascript
, 'field:extension_number' : ['内線番号入力', {complex: 'ビル番号(builName)|個人番号(personalName)'}]
, 'field:tel'              : ['電話番号入力', {complex: '市外局番(areaName)|市内局番(localName)|加入者局番(subscriberName)'}]
```

<details>
<summary>keywords</summary>

タグ定義, JSPウィジェット, UI開発基盤設定ファイル, multiple, ignoreInForm, defaultLabel, complex, 設計書ビュー, ウィジェット設定

</details>
