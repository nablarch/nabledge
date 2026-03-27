# ページ内イベント定義

## コードサンプル

[event_listen](ui-framework-event_listen.md) は、画面内で発生するイベントを監視し、登録済みのJavaScript処理をイベント発生時に実行するウィジェット。

対応するイベントアクション:
- ダイアログ表示
- 入力項目の活性・非活性制御
- Ajaxリクエスト送信とその結果表示
- 入力値の差し戻し
- チェックボックス、ラジオボタンの一括ON/OFF

> **警告**: 本ウィジェットは抽象度が低いため、業務画面JSP内に直接記述すると複雑化しやすい。「Ajax入力補完機能付き入力部品」のような共通化できるものはプロジェクトのカスタムウィジェットとして提供し、業務画面JSPへの直接記述は避けること。やむなく使用する場合はプロジェクトのアーキテクトに確認すること。

プルダウンで特定の項目を選択した場合に確認ダイアログを表示する例:

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

event:listen, event:confirm, イベントアクション, ダイアログ表示, 活性・非活性制御, Ajaxリクエスト送信, カスタムウィジェット, ページ内イベント定義

</details>

## 仕様

**イベントの監視と捕捉**

`event`属性に以下の書式でイベントを指定する:
1. `[イベント名]` — 親要素内で発生するイベントを監視
2. `[セレクタ式] [イベント名]` — セレクタに合致する要素のイベントに限定

書式1の例 (フォーム内の変更イベントを監視):

```jsp
<form id="usrForm">
  <event:listen event="change">
    <event:alert
      message="変更を反映するには「確定ボタン」を押してください。"
      revert="false">
    </event:alert>
  </event:listen>
</form>
```

上記のイベント定義に相当するJavaScript:

```javascript
$(function()  {
  $('#usrForm').on('change', function() {
    // ダイアログ表示処理の実装コード
  });
});
```

書式2の例 (サブミットボタンのクリックイベントに限定):

```jsp
<form id="usrForm">
  <event:listen event="input[type='submit'] click">
    <event:confirm message="設定を変更します。よろしいですか。">
    </event:confirm>
  </event:listen>
</form>
```

上記のイベント定義に相当するJavaScript:

```javascript
$(function()  {
  $('#usrForm').on('click', "input[type='submit']", function() {
    // ダイアログ表示処理の実装コード
  });
});
```

**イベントの捕捉とアクションの実行**

`event`要素に合致するイベントを捕捉すると、子要素のイベントアクションを順次実行する。すべてのアクション完了後、親要素へのイベントバブリングを再開する。一部のアクション（[event_confirm](ui-framework-event_confirm.md) など）は後続アクションの実行中止やバブリング/デフォルトアクションの停止が可能。

> **注意**: サブミットイベントを監視する場合は `click` イベントを使用すること。**Nablarchカスタムサブミットイベント** を監視するとイベント停止時に他の機能が動作しなくなる可能性があるため、サポートしていない。

**コンテキストの指定**

`context`属性でイベント発生を監視する要素をセレクタ式で指定できる（デフォルト: このタグの親要素内）。他のインクルードJSP上の要素を監視する場合などに使用する。

```jsp
<event:listen
  event="input[type='submit'] click"
  context="form">
  <event:confirm message="設定を変更します。よろしいですか。">
  </event:confirm>
</event:listen>
```

> **警告**: `context`属性は`event`属性内のセレクタ式の代替として使用できるが、パフォーマンス面でセレクタ式の方が優れているため、そのような用途では使用しないこと。
>
> 例えば、以下の2つのコードはほぼ同じ挙動となる:
>
> ```jsp
> <event:listen
>   event="#usrForm input[type='submit'] click"
>   context="">
>   <event:confirm message="設定を変更します。よろしいですか。">
>   </event:confirm>
> </event:listen>
> ```
>
> ```jsp
> <event:listen
>   event="click"
>   context="#usrForm input[type='submit']">
>   <event:confirm message="設定を変更します。よろしいですか。">
>   </event:confirm>
> </event:listen>
> ```
>
> しかし、後者（context属性使用）と等価なJavaScriptは以下のようになり、画面内のすべてのサブミットボタンに直接イベントを登録するため、対象ノード数に比例してメモリ使用量と画面ロード時間が増加する。
>
> ```javascript
> $(function()  {
>   $("#usrForm input[type='submit']").on('click', function() {
>     // ダイアログ表示処理の実装コード
>   });
> });
> ```

**属性値一覧**

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| event | 監視対象イベントの定義式 | 文字列 | ◎ | ◎ | |
| context | イベント発生を監視する要素を指定するセレクタ式 | 文字列 | ○ | ○ | デフォルト: このタグの親要素内 |
| title | 監視するイベントの簡単な説明 | 文字列 | × | × | 設計書表示用 |
| operation | 監視イベントが発生する画面操作の説明 | 文字列 | × | × | 設計書表示用 |
| comment | このイベントに対する補足説明 | 文字列 | × | × | 設計書表示用 |

<details>
<summary>keywords</summary>

event属性, context属性, イベント監視, イベントバブリング, セレクタ式, サブミットイベント, click, Nablarchカスタムサブミットイベント, 属性値一覧, event:alert, event:confirm

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/event/listen.tag | このウィジェットの実体となるタグファイル |
| /js/nablarch/ui/event/Listener.js | イベント監視機能を実装するJS部品 |

<details>
<summary>keywords</summary>

listen.tag, Listener.js, タグファイル, 内部構造

</details>
