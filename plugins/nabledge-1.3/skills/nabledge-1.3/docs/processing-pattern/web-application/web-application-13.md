# テストケース毎に言語を設定する方法を教えてください

> **question:**
> ケースごとに言語を変更してリクエスト単体テストを実施したいです。
> 言語の変更（設定）方法を教えてください。

> **answer:**
> Cookieに設定される言語を変更することにより、ケースごとに変更することが可能となります。

> Cookieに言語を設定する方法:

> ```
> リクエスト単体テスト用のテストデータシートに、Cookieに設定する値を準備することができます。
> この機能を使用して、Cookieに言語を設定してテストを実施してください。
> 
> Cookieに設定する際のCookie名称は、下記の設定ファイル例のCookie名称(プロパティ名がcookieNameのvalue値)を設定してください。
> ```

> ※Cookieから言語を設定するためのハンドラーがリポジトリに設定されている必要があります。
> 以下に設定例を示します。（本設定は、各プロジェクトのアーキテクトが実施するものなので、個々の開発者が実施する必要はありません。)

> ```xml
> <!-- 見やすさの問題で、ThreadContextHandlerへのその他の設定は省略しています。 -->
> 
> <component name="threadContextHandler"
>     class="nablarch.common.handler.threadcontext.ThreadContextHandler">
>   <property name="attributes">
>     <list>
>       <!-- 言語 -->
>       <component name="languageAttribute"
>           class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
>         <!-- 言語を保持しているCookie名称 -->
>         <property name="cookieName" value="lang" />
>         <property name="defaultLanguage" value="ja" />
>         <property name="supportedLanguages" value="ja,en" />
>         <property name="cookieMaxAge" value="7776000" />
>       </component>
>     </list>
>   </property>
> </component>
> ```

> Excelへの準備データの設定方法等は、以下のドキュメントを参照してください。

> * >   **[プログラミング・単体テストガイド]** -> **[単体テスト実施方法]** -> **[リクエスト単体テストの実施方法]**
