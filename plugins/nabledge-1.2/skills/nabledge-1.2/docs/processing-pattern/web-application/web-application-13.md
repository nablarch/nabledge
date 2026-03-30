# テストケース毎に言語を設定する方法を教えてください

## テストケース毎に言語を設定する方法

テストケースごとに言語を変更するには、Cookieに設定される言語を変更する。

**テストデータシートでのCookie設定**:
リクエスト単体テスト用のテストデータシートに、Cookieに設定する値を準備することができる。この機能を使用して、Cookieに言語を設定してテストを実施すること。

Cookieに設定する際のCookie名称は、設定ファイルの`cookieName`プロパティのvalue値（下記設定例では `lang`）を使用すること。

Excelへの準備データの設定方法等は **[プログラミング・単体テストガイド]** > **[単体テスト実施方法]** > **[リクエスト単体テストの実施方法]** を参照。

---

> **注意**: Cookieから言語を設定するためのハンドラー（`LanguageAttributeInHttpCookie`）がリポジトリのハンドラー構成に設定されている必要がある。この設定は各プロジェクトのアーキテクトが実施するものなので、個々の開発者が実施する必要はない。

**クラス**: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`

```xml
<!-- 見やすさの問題で、ThreadContextHandlerへのその他の設定は省略しています。 -->

<component name="threadContextHandler"
    class="nablarch.common.handler.threadcontext.ThreadContextHandler">
  <property name="attributes">
    <list>
      <component name="languageAttribute"
          class="nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie">
        <!-- 言語を保持しているCookie名称 -->
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

LanguageAttributeInHttpCookie, ThreadContextHandler, cookieName, テストデータシート, Cookie言語設定, リクエスト単体テスト言語変更, テストケース言語切替, 言語設定

</details>
