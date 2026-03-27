# テストケース毎に言語を設定する方法を教えてください

## テストケース毎に言語を設定する方法

リクエスト単体テストでケースごとに言語を変更するには、Cookieに設定される言語を変更する。テストデータシートにCookieに設定する値を準備し、Cookie名称は設定ファイルの `cookieName` プロパティのvalue値を使用すること。

> **注意**: Cookieから言語を設定するためのハンドラーがリポジトリに設定されている必要がある（各プロジェクトのアーキテクトが実施）。

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`

```xml
<component name="threadContextHandler"
    class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <component name="languageAttribute"
          class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
        <property name="cookieName" value="lang" />
        <property name="defaultLanguage" value="ja" />
        <property name="supportedLanguages" value="ja,en" />
        <property name="cookieMaxAge" value="7776000" />
      </component>
    </list>
  </property>
</component>
```

| プロパティ名 | 説明 |
|---|---|
| cookieName | 言語を保持しているCookie名称 |

<details>
<summary>keywords</summary>

LanguageAttributeInHttpCookie, ThreadContextHandler, cookieName, defaultLanguage, supportedLanguages, cookieMaxAge, リクエスト単体テスト言語設定, Cookie言語変更, テストケース言語切り替え, 多言語テスト

</details>
