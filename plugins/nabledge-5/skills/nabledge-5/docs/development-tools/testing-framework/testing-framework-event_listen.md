# ページ内イベント定義

**公式ドキュメント**: [ページ内イベント定義](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/event_listen.html)

## コードサンプル

`event:listen` ウィジェット: 画面内で発生するイベントを監視し、登録したJavaScript処理（イベントアクション）をイベント発生時に実行する。

登録可能なイベントアクション:
- ダイアログ表示
- 入力項目の活性・非活性制御
- Ajaxリクエスト送信とその結果表示
- 入力値の差し戻し
- チェックボックス、ラジオボタンの一括ON/OFF

> **重要**: 本ウィジェットは抽象度が低く汎用的な実装のため、業務画面JSP内に直接使用すると記述が複雑化しやすい。Ajax入力補完機能付き入力部品のような共通化できるものはプロジェクトのカスタムウィジェットとして提供し、業務画面JSPにイベント系ウィジェットを直接記述しない形にすることが望ましい。やむなく直接記述する際はプロジェクトのアーキテクトに確認すること。

**コードサンプル（プルダウン選択時に確認ダイアログを表示）**:

```jsp
<event:listen event="select.amount change">
  <event:confirm
    message="この商品の注文をキャンセルしますがよろしいですか？"
    condition=":is-blank">
  </event:confirm>
</event:listen>
```

<details>
<summary>keywords</summary>

event:listen, イベントアクション, ページ内イベント定義, ダイアログ表示, Ajaxリクエスト, カスタムウィジェット, event_confirm

</details>

## 仕様

**event属性の書式:**

監視するイベントは `event` 属性に以下のいずれかの書式で指定する:
1. `[イベント名]`
2. `[セレクタ式] [イベント名]` - セレクタ式でイベント発生元を限定

書式1の例（フォーム内の変更イベント監視）:
```jsp
<form id="usrForm">
  <event:listen event="change">
    <event:alert message="変更を反映するには「確定ボタン」を押してください。" revert="false">
    </event:alert>
  </event:listen>
</form>
```

書式2の例（サブミットボタンのクリックを監視）:
```jsp
<form id="usrForm">
  <event:listen event="input[type='submit'] click">
    <event:confirm message="設定を変更します。よろしいですか。">
    </event:confirm>
  </event:listen>
</form>
```

**イベントの捕捉とアクションの実行:**

- イベントバブリングおよびデフォルトアクションは通常のJavaScriptイベントモデルに従う
- `event` 属性に合致するイベントを捕捉すると、子要素のイベントアクションを順次実行
- すべてのアクション完了後、親要素へのバブリングを再開
- [event_confirm](testing-framework-event_confirm.md) など一部のアクションでは後続アクションの実行中止やバブリング停止が可能

> **重要**: サブミットイベントを監視する場合は `click` イベントを監視すること。Nablarchカスタムサブミットイベントを監視すると、イベント停止時に他の機能が動作しなくなる可能性があるため非サポート。

**context属性（コンテキストの指定）:**

デフォルトは親要素内のイベントを監視対象とするが、`context` 属性で画面内の任意の要素を監視対象に指定可能。画面内の他のインクルードJSP上の要素を監視する場合などに使用する。

```jsp
<event:listen
  event="input[type='submit'] click"
  context="form">
  <event:confirm message="設定を変更します。よろしいですか。">
  </event:confirm>
</event:listen>
```

> **重要**: `context` 属性は `event` 属性内のセレクタ式の代替として使用できるが、`event` 属性のセレクタ式の方が性能的に優れているため、そのような用途では `context` 属性を使用しないこと。`context` 属性を使うと、対象ノード数に比例してメモリ使用量と画面ロード時の処理時間が増加する。

**属性値一覧:**

◎=必須 ○=任意 ×=無効（指定しても効果なし）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| event | 監視対象イベントの定義式 | 文字列 | ◎ | ◎ | |
| context | イベントの発生を監視する要素を指定するセレクタ式 | 文字列 | ○ | ○ | デフォルトはこのタグの親要素内のイベントを監視 |
| title | 監視するイベントの簡単な説明 | 文字列 | × | × | 設計書表示用 |
| operation | 監視イベントが発生する画面操作の説明 | 文字列 | × | × | 設計書表示用 |
| comment | このイベントに対する補足説明 | 文字列 | × | × | 設計書表示用 |

<details>
<summary>keywords</summary>

event属性, context属性, イベント監視, セレクタ式, イベントバブリング, サブミットイベント, event_confirm, clickイベント, event_alert

</details>

## 内部構造・改修時の留意点

**部品一覧:**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/listen.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/Listener.js | イベント監視機能を実装するJS部品 |

<details>
<summary>keywords</summary>

listen.tag, Listener.js, 内部構造, タグファイル, イベント監視部品

</details>
