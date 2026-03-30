# テストケース毎に言語を設定する方法を教えてください

## テストケース毎に言語を設定する方法

Cookieに設定される言語を変更することで、テストケースごとに言語を変更できる。

リクエスト単体テスト用のテストデータシートでCookieに設定する値を準備できる。Cookie名称は設定ファイルの `cookieName` プロパティの値を使用すること。

> **注意**: Cookieから言語を設定するためのハンドラーがリポジトリに設定されている必要がある。この設定は各プロジェクトのアーキテクトが実施するものであり、個々の開発者が実施する必要はない。

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`

```xml
<!-- 見やすさの問題で、ThreadContextHandlerへのその他の設定は省略しています。 -->

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
| defaultLanguage | デフォルト言語 |
| supportedLanguages | サポートする言語一覧（カンマ区切り） |
| cookieMaxAge | CookieのMax-Age値 |

<details>
<summary>keywords</summary>

LanguageAttributeInHttpCookie, ThreadContextHandler, cookieName, defaultLanguage, supportedLanguages, cookieMaxAge, 言語設定, Cookie言語, リクエスト単体テスト, テストケース言語変更

</details>
