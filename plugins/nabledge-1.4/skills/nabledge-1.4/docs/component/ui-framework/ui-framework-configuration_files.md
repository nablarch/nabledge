# UI開発基盤設定ファイル

## タグ定義

## タグ定義

**配置場所**: `/js/devtool/resource/タグ定義.js`

JSPウィジェットのローカル表示および設計書ビュー表示に必要な捕捉情報を記述する設定ファイル。JSPウィジェットを追加した場合は必ずここに定義を追加すること。

**記述書式** (JavaScriptオブジェクトリテラル形式):

```javascript
'【タグ名】' : [ '【UI要素名】', {【オプション】} ]
```

**記述例**:
```javascript
, 'field:label'         : ['テキスト表示',   {ignoredInForm:true}]
, 'field:listbuilder'   : ['リストビルダー', {multiple:true}]
```

**各フィールドの説明**:
- **タグ名**: JSPタグの名称 (例: `'field:code_checkbox'`)
- **UI要素名**: タグのUI部品名。設計書ビューの「画面項目種類」欄に表示される (例: `'チェックボックス'`)

**オプション一覧**:

| オプション | デフォルト | 説明 |
|---|---|---|
| `multiple` | false | 同一name属性のinput要素を複数持ちうる場合（複数選択項目）にtrueを指定 |
| `ignoreInForm` | false | 単なる表示項目である場合にtrueを指定 |
| `defaultLabel` | | button:タグにデフォルトで表示する文言を指定 |
| `complex` | | 複数のinput要素で構成される場合、項目名とname属性を`|`区切りで記述 |

**complexオプションの記述例**:
```javascript
, 'tutorial:extension_number' : ['内線番号入力', {complex: 'ビル番号(builName)|個人番号(personalName)'}]
, 'tutorial:tel'              : ['電話番号入力', {complex: '市外局番(areaName)|市内局番(localName)|加入者局番(subscriberName)'}]
```

<details>
<summary>keywords</summary>

タグ定義, JSPウィジェット, 設計書ビュー, multiple, ignoreInForm, complex, defaultLabel, UI開発基盤設定ファイル, 画面項目種類, タグ定義.js

</details>
