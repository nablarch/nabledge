# 画像表示ウィジェット

## コードサンプル

**実装例 (JSP)**:
```jsp
<box:img id="imageSample"
         file="sample.png">
</box:img>
```

<details>
<summary>keywords</summary>

box:img, 画像表示ウィジェット, JSPタグ, imgタグ

</details>

## 仕様

業務画面内に画像を表示する場合に使用する。なお、共通ヘッダ内のロゴは対象外である。

id属性を設定した要素を出力し、CSSの`background-image`プロパティを使用して画像を切替・出力する。ローカル動作とサーバ動作の挙動は同じ。

**解像度の切替**

デバイスピクセル比が1.25:1より大きいデバイスでは高解像度画像、それ以下では低解像度画像を使用する。

**画像ファイルパス構成**

画面の表示モード(narrow/wide)と解像度(high/low)の組合せで以下4パスを使用する:

| パス | 用途 |
|---|---|
| img/wide/high | wide/compactモード＋高解像度 |
| img/wide/low | wide/compactモード＋低解像度 |
| img/narrow/high | narrowモード＋高解像度 |
| img/narrow/low | narrowモード＋低解像度 |

**静的ファイルの用意**

- リソース切替が不要な場合は`img/wide/high`配下にファイルを配置し、`img展開.bat`で各ディレクトリに展開する（同一ファイルを各表示モード領域に展開し、実質同一画像を参照させる）。
- 高解像度向け画像等に切り替える場合は、基点パス配下のファイルを上書きする。

**imgファイル展開の優先順位** (基本はファイルを`img/wide/high`に配置する)

1. 対象フォルダにすでにファイルが存在する場合、展開されない。
2. 対象フォルダに存在しない場合、同一表示モード(wide/narrow)の高解像度画像が展開される。
3. 同一表示モードにも存在しない場合、`img/wide/high`の画像が展開される。

**属性値一覧** (◎=必須 ○=任意)

| 属性名 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|
| cssClass | 文字列 | ○ | ○ | 定義領域のclass属性 |
| id | 文字列 | ◎ | ◎ | ウィジェットを定義する要素のid属性 |
| file | 文字列 | ◎ | ◎ | 表示する画像の相対パス。`img/(wide\|narrow)/(high\|low)/`からの相対パスを指定 |

<details>
<summary>keywords</summary>

box:img, cssClass, id, file, デバイスピクセル比, 高解像度, 低解像度, 表示モード, wide, narrow, img展開, background-image, 共通ヘッダ, 業務画面

</details>

## 内部構造・改修時の留意点

CSS Media Queryを利用して静的ファイルへのリクエストを切替える。

**参照される画像のパス**

`file`属性に指定したパスは以下のように解決される:

`{contextPath}/{表示モード対応ディレクトリ}/{file属性のパス}`

**ブレークポイントや表示モードの拡張方法**

- ブレークポイントや画像URLはtemplateで指定されるstyleに依存。改修時は基本的にtemplateを変更する。
- デバイスピクセル比の値(`-webkit-min-device-pixel-ratio`等)を変更する場合は、サポート対象デバイスのピクセル比を確認すること。
- templateに渡すパラメータが増える場合、tagファイルの`-{placeholder名}`で指定する。

> **注意**: デフォルト設定ではデバイスピクセル比1.25以下を低解像度、それより大きいものを高解像度とする。IEではresolutionの単位にdppxが使用できないため、1dppx=96dpiで換算して指定している。

**tagコード例**:
```jsp
<div id="<n:write name="id" withHtmlFormat="false"/>"
   class="nablarch_ResponsibleImage
          -filepath    '<n:write name="file" withHtmlFormat="false" />'
          -id          '<n:write name="id" withHtmlFormat="false"/>'
          -contextPath '<n:write name="contextPath" withHtmlFormat="false"/>'">
</div>
```

**templateコード例** (ブレークポイント640px/639px、ベンダープレフィックス付きDPI条件):
```css
@media screen and (min-width: 640px) and (-webkit-min-device-pixel-ratio:1.25)
     , screen and (min-width: 640px) and (-moz-min-device-pixel-ratio:1.25)
     , screen and (min-width: 640px) and (min-resolution:120dpi) {
   #{id} > div {
      background-image : url("{contextPath}/img/wide/high/{filepath}");
   }
}
@media screen and (max-width: 639px) and (-webkit-min-device-pixel-ratio:1.25)
     , screen and (min-width: 639px) and (-moz-min-device-pixel-ratio:1.25)
     , screen and (max-width: 639px) and (min-resolution:120dpi) {
   #{id} > div {
      background-image : url("{contextPath}/img/narrow/high/{filepath}");
   }
}
```

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/box/img.tag | box_img の実体となるタグファイル |
| /include/html_head.jsp | contextPathを解決 |
| /js/ui/nablarch/ResponsibleImage.js | 画像パスを解決するJS |
| /js/ui/nablarch/ResponsibleImage.template | 背景画像のスタイル定義テンプレート |
| /js/ui/nablarch/ResponsibleImageUnsupportRatio.template | ピクセル比が判定できないブラウザ向けテンプレート |
| /js/ui/nablarch/ResponsibleImageUnsupportMatchMedia.template | メディアクエリが効かないブラウザ向けテンプレート |
| /css/img/base.less | 画像表示のless |
| /css/img/wide.less | ワイド画像指定less |
| /css/img/narrow.les | ナロー画像指定less |
| /js/jsp/taglib/box.js | box_img をローカルレンダリングするスタブファイル |
| /tools/img展開.bat | /WEB-INF/img/配下ファイルを表示モードディレクトリに配置するスクリプト |
| /img/resource | 配下の画像を各表示モード対応ディレクトリに配置 |
| /img/wide/high, /img/wide/low, /img/narrow/high, /img/narrow/low | 表示モード対応ディレクトリ（wide=compact/wide向け、narrow=narrow向け、high=高解像度向け、low=低解像度向け） |

<details>
<summary>keywords</summary>

CSS Media Query, Media Query, contextPath, ResponsibleImage, ResponsibleImageUnsupportRatio, ResponsibleImageUnsupportMatchMedia, テンプレート拡張, 部品一覧, 画像パス解決, ブレークポイント, 640px, -webkit-min-device-pixel-ratio, -moz-min-device-pixel-ratio, min-resolution

</details>
