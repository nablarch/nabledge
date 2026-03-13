# 確認ダイアログ表示イベントアクション

**公式ドキュメント**: [確認ダイアログ表示イベントアクション](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_confirm.html)

## 確認ダイアログ表示イベントアクション

[event_confirm](testing-framework-event_confirm.md) は [event_listen](testing-framework-event_listen.md) で定義したイベント発生時に確認ダイアログを表示するイベントアクション。

- **キャンセル選択時**: イベントのプロパゲーションおよびデフォルトアクションを抑止。発生元イベントが `change` の場合、変更内容を元の入力内容に戻す。
- **OK選択時**: イベントプロパゲーションを継続し、他のイベントハンドラでキャンセルされなければデフォルトアクションを実行。

> **注意**: ダイアログはブラウザのネイティブ部品を使用するため、CSSによる見た目の制御やタイトル文字列の変更はできない。

**コードサンプル**:

```jsp
<event:listen event="select.amount change">
  <event:confirm
    message="この商品の注文をキャンセルしますがよろしいですか？"
    condition=":is-blank">
  </event:confirm>
</event:listen>
```

**属性値一覧** (◎ 必須 / ○ 任意 / × 無効)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 処理内容の簡単な説明 | 文字列 | × | × | 設計書表示用 |
| message | ダイアログに表示する文言 | 文字列 | ◎ | ◎ | |
| condition | ダイアログを表示させる条件を表すセレクタ式 | 文字列 | ○ | ○ | 省略した場合は必ず表示される |
| target | condition属性の条件判定対象要素を表すセレクタ式 | 文字列 | ○ | ○ | 省略した場合はイベント発生元要素 |
| stop | キャンセル時のプロパゲーションおよびデフォルトアクション抑制フラグ | 真偽値 | ○ | ○ | デフォルト: `true` |
| revert | キャンセル時に入力値をイベント発生前の状態に戻すかどうか | 真偽値 | ○ | ○ | changeイベント時のみ有効。デフォルト: `true` |

> **補足**: `stop` 属性はローカルでの動作に制約がある。詳細は [event:confirmタグの制約事項](testing-framework-inbrowser_jsp_rendering.md) を参照。

**部品一覧**:

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/event/confirm.tag` | イベントアクションの実体となるタグファイル |
| `/WEB-INF/tags/widget/event/dialog.tag` | [event_alert](testing-framework-event_alert.md) と [event_confirm](testing-framework-event_confirm.md) で共通の内容を実装するタグファイル |
| `/js/nablarch/ui/event/ShowDialogAction.js` | ダイアログ表示機能を実装するJS部品 |

<details>
<summary>keywords</summary>

event:confirm, event:listen, 確認ダイアログ, イベントアクション, ダイアログキャンセル, changeイベント, title属性, message属性, condition属性, target属性, stop属性, revert属性, ShowDialogAction.js, JSPタグウィジェット

</details>
