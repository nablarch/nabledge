# 出力するHTMLの文字コードを変更したいのですが

## HTMLの出力文字コード変更方法

HTMLの出力文字コードはデフォルトUTF-8。Windows-31J等に変更するにはコンポーネント定義ファイルの以下3箇所を修正する。

**WebFrontController** (`nablarch.fw.web.servlet.WebFrontController`)

`defaultEncoding` プロパティを変更する。

```xml
<component name="webFrontController"
            class="nablarch.fw.web.servlet.WebFrontController">
  <property name="defaultEncoding" value="Windows-31J"/>
</component>
```

**ファイルダウンロードのエンコーダ設定**

ダウンロードファイル名のエンコーディングに使用する文字コード設定を変更する。

```xml
<!-- MIME-Bエンコーダ -->
<component name="mimeBEncoder" class="nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder">
  <property name="charset" value="Windows-31J" />
</component>

<!-- URLエンコーダ -->
<component name="urlEncoder" class="nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder">
  <property name="charset" value="Windows-31J" />
</component>
```

**HttpTestConfiguration** (`nablarch.test.core.http.HttpTestConfiguration`)

テスティングフレームワークの静的リソースの文字コード設定を変更する。

```xml
<component name="httpTestConfiguration"
    class="nablarch.test.core.http.HttpTestConfiguration">
  <property name="htmlResourcesCharset" value="Windows-31J" />
</component>
```

<details>
<summary>keywords</summary>

WebFrontController, MimeBDownloadFileNameEncoder, UrlDownloadFileNameEncoder, HttpTestConfiguration, defaultEncoding, charset, htmlResourcesCharset, 文字コード変更, HTML出力エンコーディング, ファイルダウンロード文字コード

</details>
