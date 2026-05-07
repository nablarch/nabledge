# Content-Typeの互換性維持方法

### Content-Typeの互換性維持方法

#### Bodyが空の場合に自動でContent-Typeにtext/plain;charset=UTF-8を付与する方法を以下に示します。

#### ◆5u18のリリースノートNo.6「ボディがないレスポンスにContent-Typeを設定しないように変更」の「システムへの影響の可能性の内容と対処」を実施している場合

JaxRsResponseHandlerのコンポーネント定義から、setContentTypeForResponseWithNoBodyプロパティを削除してください。このプロパティは廃止になりました。

5u18リリースノート抜粋

#### ◆Content-Typeの互換性維持の設定方法

webConfigコンポーネントを定義し、addDefaultContentTypeForNoBodyResponseプロパティにtrueを設定してください。
