# 使用可能文字の追加手順

**公式ドキュメント**: [使用可能文字の追加手順](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/CustomizeAvailableCharacters.html)

## 文字集合の包含関係

使用可能な文字集合は複数の文字集合から構成される（包含関係が存在する）。

![](../../../knowledge/setup/setting-guide/assets/setting-guide-CustomizeAvailableCharacters/charset.png)

<details>
<summary>keywords</summary>

文字集合, 包含関係, 使用可能文字, 文字種別

</details>

## 文字集合定義の所在

以下の文字集合は、デフォルトコンフィギュレーション(jar)内の環境設定ファイルにリテラルで定義されている。

- 全角英字, 全角数字, 全角ギリシャ文字, 全角ロシア文字, 全角ひらがな, 全角カタカナ, 全角スペース, 第1水準全角記号, 全角罫線, 第1水準漢字, 第2水準漢字, NEC選定IBM拡張, NEC特殊文字, IBM拡張文字, 半角数字, 半角英小文字, 半角英大文字, ASCII記号, 半角カナ

> **補足**: 定義場所: `nablarch/core/validation/charset-definition.config`

以下の文字集合は、コンポーネント設定ファイルにUnicodeコードポイントで定義されている。

- halfWidthWhitespace

> **補足**: 定義場所: `nablarch/core/validation/charset-definition.xml`

<details>
<summary>keywords</summary>

charset-definition.config, charset-definition.xml, 文字集合定義, halfWidthWhitespace, デフォルトコンフィギュレーション

</details>

## メッセージIDを設定するだけで使用できる使用可能文字

以下の使用可能文字はメッセージIDを設定するだけで使用できる。

- システム許容文字
- 全角文字
- 半角英数
- ASCII文字
- 半角数字
- 全角カタカナ

プレースホルダは :download:`デフォルト設定一覧 <../../configuration/デフォルト設定一覧.xlsx>` を参照。

メッセージID及びメッセージ内容の変更手順は [./CustomizeMessageIDAndMessage](setting-guide-CustomizeMessageIDAndMessage.md) を参照。

<details>
<summary>keywords</summary>

メッセージID設定, システム許容文字, 全角文字, 半角英数, ASCII文字, 半角数字, 全角カタカナ, バリデーション設定

</details>

## メッセージIDを指定するだけでは使用できない使用可能文字

以下の使用可能文字はメッセージIDだけでなく、コンポーネント定義が必要（メッセージIDのみでは使用不可）。

- 全角英字, 全角数字, 全角ギリシャ文字, 全角ロシア文字, 全角ひらがな, 第1水準全角記号, 全角罫線, 第1水準漢字, 第2水準漢字, 全角スペース, 半角英小文字, 半角英大文字, ASCII記号, 半角カナ, NEC選定IBM拡張, NEC特殊文字, IBM拡張文字

> **補足**: メッセージIDを定義していない場合、Nablarchアプリケーション起動時に警告が出力される。

Nablarchの設定ファイル（ウェブプロジェクトでは `web-component-configuration.xml` など）に以下を追加する。`nablarch/core.xml` のimport後に定義すること。使用するもののみ設定すればよい。

**クラス**: `nablarch.core.validation.validator.unicode.LiteralCharsetDef`

```xml
<import file="nablarch/core.xml"/>

<component name="全角英字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuAlphaCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuAlphaCharset.messageId}"/>
</component>
<component name="全角数字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuNumCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuNumCharset.messageId}"/>
</component>
<component name="全角ギリシャ文字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuGreekCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuGreekCharset.messageId}"/>
</component>
<component name="全角ロシア文字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuRussianCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuRussianCharset.messageId}"/>
</component>
<component name="全角ひらがな" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuHiraganaCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuHiraganaCharset.messageId}"/>
</component>
<component name="第1水準全角記号" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.jisSymbolCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.jisSymbolCharset.messageId}"/>
</component>
<component name="全角罫線" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuKeisenCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuKeisenCharset.messageId}"/>
</component>
<component name="第1水準漢字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.level1KanjiCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.level1KanjiCharset.messageId}"/>
</component>
<component name="第2水準漢字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.level2KanjiCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.level2KanjiCharset.messageId}"/>
</component>
<component name="全角スペース" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.zenkakuSpaceCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.zenkakuSpaceCharset.messageId}"/>
</component>
<component name="半角英小文字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.lowerAlphabetCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.lowerAlphabetCharset.messageId}"/>
</component>
<component name="半角英大文字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.upperAlphabetCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.upperAlphabetCharset.messageId}"/>
</component>
<component name="ASCII記号" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.asciiSymbolCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.asciiSymbolCharset.messageId}"/>
</component>
<component name="半角カナ" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.hankakuKanaCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.hankakuKanaCharset.messageId}"/>
</component>
<component name="NEC選定IBM拡張" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.necExtendedCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.necExtendedCharset.messageId}"/>
</component>
<component name="NEC特殊文字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.necSymbolCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.necSymbolCharset.messageId}"/>
</component>
<component name="IBM拡張文字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="${nablarch.ibmExtendedCharset.allowedCharacters}"/>
  <property name="messageId" value="${nablarch.ibmExtendedCharset.messageId}"/>
</component>
```

メッセージID及びメッセージ内容の変更手順は [./CustomizeMessageIDAndMessage](setting-guide-CustomizeMessageIDAndMessage.md) を参照。

<details>
<summary>keywords</summary>

LiteralCharsetDef, nablarch.core.validation.validator.unicode.LiteralCharsetDef, コンポーネント定義, 全角英字, 全角ひらがな, 起動時警告, 文字バリデーション設定, allowedCharacters, messageId

</details>

## 単独で使用できない使用可能文字

以下の文字は単独では使用できない。

- halfWidthSpace

<details>
<summary>keywords</summary>

halfWidthSpace, 半角スペース, 単独使用不可

</details>
