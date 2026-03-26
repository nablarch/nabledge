# 出力するHTMLの文字コードを変更したいのですが

## HTML文字コードの変更設定

HTML出力の文字コードをUTF-8から変更するには、コンポーネント定義ファイルの以下の箇所を変更する。

**HttpCharacterEncodingHandler**（Nablarch Application Framework）

**クラス**: `nablarch.fw.web.handler.HttpCharacterEncodingHandler`

`HttpServletRequest`/`HttpServletResponse`のエンコーディング設定を変更する。`defaultEncoding`プロパティに使用する文字コードを指定する。

```xml
<component name="httpCharacterEncodingHandler"
            class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
  <property name="defaultEncoding" value="Windows-31J"/>
</component>
```

**ファイルダウンロード**（Nablarch Application Framework）

ダウンロードファイル名のエンコーディングに使用する文字コードを変更する。`charset`プロパティを変更する。

**クラス**: `nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder`, `nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder`

```xml
<!-- MIME-Bエンコーダの設定 -->
<component name="mimeBEncoder" class="nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder">
  <property name="charset" value="Windows-31J" />
</component>

<!-- URLエンコーダの設定 -->
<component name="urlEncoder" class="nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder">
  <property name="charset" value="Windows-31J" />
</component>
```

**HttpTestConfiguration**（Nablarch Testing Framework）

静的リソースの文字コード設定を変更する。`htmlResourcesCharset`プロパティを変更する。

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

```xml
<component name="httpTestConfiguration"
    class="nablarch.test.core.http.HttpTestConfiguration">
  <property name="htmlResourcesCharset" value="Windows-31J" />
</component>
```

<details>
<summary>keywords</summary>

HttpCharacterEncodingHandler, MimeBDownloadFileNameEncoder, UrlDownloadFileNameEncoder, HttpTestConfiguration, defaultEncoding, charset, htmlResourcesCharset, HTML文字コード変更, ファイルダウンロードエンコーディング, Windows-31J設定, テスト設定文字コード

</details>
