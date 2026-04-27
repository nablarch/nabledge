# 出力するHTMLの文字コードを変更したいのですが

> **question:**
> HTML出力時、デフォルトではUTF-8が使われるそうですが、
> Windows-31J等に変更するにはどういう設定変更が必要でしょうか？

> **answer:**
> コンポーネント定義ファイルの以下の箇所を変更する必要があります。

> **Nablarch Application Framework**

> *HttpCharacterEncodingHandler*

> HttpServletRequest、HttpServletResponseに対するエンコーディング設定を変更します。

> ```xml
> <component name="httpCharacterEncodingHandler"
>             class="nablarch.fw.web.handler.HttpCharacterEncodingHandler">
>   <!-- ここを変更-->
>   <property name="defaultEncoding" value="Windows-31J"/>
>   <!-- 省略 -->
> </component>
> ```

> *ファイルダウンロード*

> ダウンロードファイル名のエンコーディングに使用する文字コード設定を変更します。

> ```xml
> <!-- MIME-Bエンコーダの設定 -->
> <component name="mimeBEncoder" class="nablarch.fw.web.download.encorder.MimeBDownloadFileNameEncoder">
>   <!-- ここを変更-->
>   <property name="charset" value="Windows-31J" />
> </component>
> 
> <!-- URLエンコーダの設定 -->
> <component name="urlEncoder" class="nablarch.fw.web.download.encorder.UrlDownloadFileNameEncoder">
>   <!-- ここを変更-->
>   <property name="charset" value="Windows-31J" />
> </component>
> ```

> **Nablarch Testing Framework**

> *HttpTestConfiguration*

> 静的リソースの文字コード設定を変更します。

> ```xml
> <component name="httpTestConfiguration"
>     class="nablarch.test.core.http.HttpTestConfiguration">
>   <property name="webBaseDir" value="${webBaseDir}" />
> 
>   <!-- 中略 -->
> 
>   <!-- ここを変更-->
>   <property name="htmlResourcesCharset" value="Windows-31J" />
> 
>   <!-- ダンプHTMLへの可変項目の出力可否 -->
>   <property name="dumpVariableItem" value="false" />
> </component>
> ```

> 詳細については以下のドキュメントを参照してください。

> * >   **[Nablarch Application Framework解説書]** -> **[リファレンス]** -> **[ハンドラリファレインス]** -> **[HTTP文字エンコード制御ハンドラ]**
> * >   **[Nablarch Application Framework解説書]** -> **[NAF実行制御基盤]** -> **[画面オンライン実行制御基盤]** -> **[ファイルダウンロード]**
> * >   **[プログラミング・単体テストガイド]** -> **[自動テストフレームワークの使用方法]** -> **[リクエスト単体テスト（画面オンライン処理）]**
