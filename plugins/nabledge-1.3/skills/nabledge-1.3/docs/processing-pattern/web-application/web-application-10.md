# 出力するHTMLの文字コードを変更したいのですが

## HTMLの文字コード変更方法

HTMLのデフォルト文字コードはUTF-8。変更にはコンポーネント定義ファイルの以下を修正する。

**WebFrontController** (`nablarch.fw.web.servlet.WebFrontController`): `defaultEncoding` プロパティを変更

```xml
<component name="webFrontController"
            class="nablarch.fw.web.servlet.WebFrontController">
  <property name="defaultEncoding" value="Windows-31J"/>
  <!-- 省略 -->
</component>
```

**ファイルダウンロード**: ダウンロードファイル名エンコーディング用の `charset` プロパティを変更（MIME-BエンコーダとURLエンコーダの両方）

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

**Nablarch Testing Framework — HttpTestConfiguration** (`nablarch.test.core.http.HttpTestConfiguration`): 静的リソースの `htmlResourcesCharset` プロパティを変更

```xml
<component name="httpTestConfiguration"
    class="nablarch.test.core.http.HttpTestConfiguration">
  <property name="webBaseDir" value="${webBaseDir}" />
  <property name="htmlResourcesCharset" value="Windows-31J" />
  <property name="dumpVariableItem" value="false" />
</component>
```

<details>
<summary>keywords</summary>

WebFrontController, nablarch.fw.web.servlet.WebFrontController, MimeBDownloadFileNameEncoder, nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder, UrlDownloadFileNameEncoder, nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder, HttpTestConfiguration, nablarch.test.core.http.HttpTestConfiguration, defaultEncoding, charset, htmlResourcesCharset, 文字コード変更, HTMLエンコーディング, Windows-31J, ファイルダウンロード文字コード, テスト設定

</details>
