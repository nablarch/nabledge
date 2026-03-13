# 画像表示ウィジェット

**公式ドキュメント**: [画像表示ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/box_img.html)

## コードサンプル

**実装成果物(サーバ動作)**

```jsp
<box:img id="imageSample"
         file="sample.png">
</box:img>
```

<details>
<summary>keywords</summary>

box_img, 画像表示ウィジェット, JSPウィジェット, box:img, サンプルコード

</details>

## 仕様

業務画面内に画像を表示する場合に使用するウィジェット。**共通ヘッダ内のロゴには使用しないこと**（対象外）。

id属性を設定した要素を出力し、CSSの`background-image`プロパティを使用して画像を切替・出力する。ローカル動作とサーバ動作の挙動は同じ。

**高解像度・低解像度の位置づけ**

- 低解像度画像: 一般的なPCディスプレイ（デバイスピクセル比=1:1）向け
- 高解像度画像: retinaディスプレイ（デバイスピクセル比=2:1）などの高解像度ディスプレイ向け

> **補足**: デバイスピクセル比が1.25:1より大きいデバイスでは高解像度画像、それ以下では低解像度画像を使用する。

**表示する画像ファイルパス**

画面の表示モード（narrow or wide）と解像度（high or low）の組合せで画像を切替える。4つのパスが使われる:

- `img/wide/high` — wide,compactモードかつ高解像度
- `img/wide/low` — wide,compactモードかつ低解像度
- `img/narrow/high` — narrowモードかつ高解像度
- `img/narrow/low` — narrowモードかつ低解像度

**静的ファイルの用意**

リソース切替が不要な場合は`img/wide/high`配下にファイルを配置し、`img展開.bat`で各ディレクトリに配置する。高解像度向け画像などに切り替える場合は、基点となるパス配下のファイルを上書きする。

**imgファイルの展開優先順位（img展開.bat）**

1. 対象フォルダにすでにファイルが存在する場合、展開されない
2. 対象フォルダに存在しない場合、同一の表示モード（wide, narrow）の高解像度画像が展開される
3. 同一の表示モードにも存在しない場合、`img/wide/high`の画像が展開される

**属性値一覧** （◎ 必須属性 / ○ 任意属性）

| 属性名 | タイプ | サーバ | ローカル | 説明 |
|---|---|---|---|---|
| cssClass | 文字列 | ○ | ○ | 定義領域のclass属性を指定する |
| id | 文字列 | ◎ | ◎ | ウィジェットを定義する要素のid属性 |
| file | 文字列 | ◎ | ◎ | 表示する画像の相対パス。`img/(wide|narrow)/(high|low)/`からの相対パスを指定する |

<details>
<summary>keywords</summary>

box_img, id属性, file属性, cssClass, 画像切替, 解像度対応, 表示モード, img展開.bat, デバイスピクセル比, 高解像度, 低解像度, narrow, wide, 属性値一覧, 共通ヘッダ対象外, 業務画面

</details>

## 内部構造・改修時の留意点

静的ファイルへのリクエストをCSS Media Queryを使用して切替える。

**参照される画像のパス**

`file`属性に指定したパスは下記のように解決される:

```
{contextPath}/{表示モード対応ディレクトリ}/{指定したfile属性のパス}
```

**ブレークポイントや表示モードの拡張方法**

- ブレークポイントや画像URLはtemplateで指定されるstyleに依存している。改修する場合はtemplateを変更する
- デバイスピクセル比の値（`-webkit-min-device-pixel-ratio`など）を変更する場合、サポート対象デバイスのピクセル比を確認すること
- templateに渡すパラメータが増える場合、tagファイルの`-{placeholder名}`で指定する
- IEではresolutionの単位としてdppxが使えないため、1dppx=96dpiで換算して指定している

**tagとテンプレートのコード例**

tag:
```html
<div id="<n:write name='id' withHtmlFormat='false'/>"
   class="nablarch_ResponsibleImage
          -filepath    '<n:write name="file" withHtmlFormat="false" />'
          -id          '<n:write name="id" withHtmlFormat="false"/>'
          -contextPath '<n:write name="contextPath" withHtmlFormat="false"/>'">
</div>
```

template:
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

> **tip**: デフォルトの設定では、デバイスピクセル比が1:1のものを低解像度とし、それ以上のものを高解像度用の画像を表示する設定としている。実際の端末ではデバイスピクセル比が1.25以下のものは存在しないため、境界値を1.25としている。ただし、IEではresolutionの単位としてデバイスピクセル比(dppx)を使用することが出来ないため、1dppx=96dpiで換算して指定している。

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/box/img.tag` | box_img の実体となるタグファイル |
| `/WEB-INF/include/html_head.jsp` | contextPathを解決する |
| `/js/ui/nablarch/ResponsibleImage.js` | 画像のパスを解決するためのJS |
| `/js/ui/nablarch/ResponsibleImage.template` | 背景画像のスタイルを定義するためのテンプレート |
| `/js/ui/nablarch/ResponsibleImageUnsupportRatio.template` | ピクセル比が判定できないブラウザ向けのテンプレート |
| `/js/ui/nablarch/ResponsibleImageUnsupportMatchMedia.template` | メディアクエリが効かないブラウザ用テンプレート |
| `/css/img/base.less` | 画像表示のless |
| `/css/img/wide.less` | ワイド画像指定less |
| `/css/img/narrow.les` | ナロー画像指定less |
| `/js/jsp/taglib/box.js` | box_img をローカルレンダリングするスタブファイル |
| `/tools/img展開.bat` | `/WEB-INF/img/`配下のファイルを表示モードディレクトリに配置するスクリプト |
| `/img/resource` | 配下の画像を各表示モード対応ディレクトリに配置する |
| `/img/wide/high`, `/img/wide/low`, `/img/narrow/high`, `/img/narrow/low` | 表示モード対応ディレクトリ。wide=compact/wide表示モード、narrow=narrow表示モード、high=高解像度向け、low=低解像度向け |

<details>
<summary>keywords</summary>

CSS Media Query, contextPath, 画像パス解決, ResponsibleImage, ResponsibleImageUnsupportRatio, ResponsibleImageUnsupportMatchMedia, img.tag, box.js, ブレークポイント, テンプレート, 部品一覧, placeholder, 1.25境界値, デバイスピクセル比rationale

</details>
