# UserAgent情報取得機能サンプル

## インタフェース定義

HTTPヘッダ(User-Agent)より取得した値を設定ファイルの内容に従って解析し、以下の情報を取得する機能。

取得できる情報: OSタイプ、OS名称、OSバージョン、ブラウザタイプ、ブラウザ名称、ブラウザバージョン

アプリケーションから`HttpRequest#getUserAgent()`で取得できる。

**インタフェース**: `please.change.me.fw.web.useragent.UserAgentValueConvertor` — 取得した値（ブラウザ名、バージョン番号等）を変換するインタフェース。

<details>
<summary>keywords</summary>

UserAgentValueConvertor, UserAgent情報取得機能, OSタイプ, OS名称, OSバージョン, ブラウザタイプ, ブラウザ名称, ブラウザバージョン, getUserAgent

</details>

## クラス定義

**a) `nablarch.fw.web.UserAgentParser`の実装クラス**

| クラス名 | 概要 |
|---|---|
| `please.change.me.fw.web.useragent.RegexUserAgentParser` | 正規表現によりOSおよびブラウザの各種情報を取得するUserAgent解析クラス |

**b) `nablarch.fw.web.useragent.UserAgentValueConvertor`の実装クラス**

| クラス名 | 概要 |
|---|---|
| `please.change.me.fw.web.useragent.UserAgentNameConvertor` | 名称項目の整形を行うコンバータ。任意の文字列を置換する機能を持つ |
| `please.change.me.fw.web.useragent.UserAgentVersionConvertor` | バージョン項目の整形を行うコンバータ。バージョン項目を分割し、各項目を任意の文字列でパディングする機能を持つ |

**c) その他のクラス**

| クラス名 | 概要 |
|---|---|
| `nablarch.fw.web.HttpRequest` | HTTPリクエストメッセージを格納するデータオブジェクト。`getUserAgent()`メソッドでUserAgentクラスを取得する |
| `nablarch.fw.web.useragent.UserAgent` | UserAgent解析クラスにより解析された結果を保持するクラス。任意の項目を取得したい場合は本クラスを拡張する |
| `please.change.me.fw.web.useragent.UserAgentPatternSetting` | 解析パターンのリストやデフォルト値などの設定項目を保持するクラス |
| `please.change.me.fw.web.useragent.TypePattern` | 種別(OS/ブラウザ)を判定するための解析パターンの正規表現を保持するクラス |
| `please.change.me.fw.web.useragent.ItemPattern` | 項目(具体的なブラウザ名等)を判定するための解析パターンの正規表現やコンバータなどを保持するクラス |

<details>
<summary>keywords</summary>

RegexUserAgentParser, UserAgentNameConvertor, UserAgentVersionConvertor, HttpRequest, UserAgent, UserAgentPatternSetting, TypePattern, ItemPattern, ユーザエージェント解析クラス

</details>

## UserAgentVersionConvertorの設計意図

> **注意**: `UserAgentVersionConvertor`は文字列を「\D(数字以外)」で分割し、各要素をパディングし、スペース区切りで結合した値を変換値とする。（例：「34.0.1847.116」→「_34 __0 ___1847」）

変換後のブラウザバージョン番号をCSSクラス名として使用するための変換。特定のブラウザ・端末に対する表示制御をCSSクラス指定で統一する目的で使用する。アプリケーション全体でブラウザ固有の表示制御方法を統一しないと、場当たり的な判定処理・制御処理が散在して保守性が損なわれるため、この方法を提供している。

<details>
<summary>keywords</summary>

UserAgentVersionConvertor, CSSクラス名, ブラウザバージョン変換, パディング, 表示制御の統一

</details>

## 設定の記述

UserAgent情報取得機能はリポジトリ機能を利用して設定を行う。

useragent_sampleドキュメントに、より具体的な設定および利用例を示す。

<details>
<summary>keywords</summary>

リポジトリ機能, UserAgent設定, RegexUserAgentParser設定, useragent_sample

</details>

## 設定内容詳細

**RegexUserAgentParser設定例**

```xml
<component name="userAgentParser" class="please.change.me.fw.web.useragent.RegexUserAgentParser">
  <property name="osSetting">
    <component class="please.change.me.fw.web.useragent.UserAgentPatternSetting">
      <property name="typePatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.TypePattern">
            <property name="name"    value="desktop" />
            <property name="pattern" value="(?i).*(windows|mac os x).*" />
          </component>
        </list>
      </property>
      <property name="itemPatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="pattern"          value="(?i).*(windows|mac os x)[\D+]*([\d\._]*).*" />
            <property name="nameIndex"        value="1" />
            <property name="versionIndex"     value="2" />
            <property name="nameConvertor"    ref="osNameConvertor" />
            <property name="versionConvertor" ref="deviceVersionConvertor" />
          </component>
        </list>
      </property>
    </component>
  </property>
  <property name="browserSetting">
    <component class="please.change.me.fw.web.useragent.UserAgentPatternSetting">
      <property name="typePatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.TypePattern">
            <property name="name"    value="Gecko" />
            <property name="pattern" value=".*Gecko.*" />
          </component>
        </list>
      </property>
      <property name="itemPatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="pattern"          value="(?i).*(msie\s|trident.+rv:)([\d\.]*).*" />
            <property name="name"             value="ie" />
            <property name="versionIndex"     value="2" />
            <property name="versionConvertor" ref="browserVersionConvertor" />
          </component>
        </list>
      </property>
    </component>
  </property>
</component>
```

**RegexUserAgentParserのプロパティ**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| osSetting | UserAgentPatternSetting | | | OS情報の解析パターン設定。未指定時はOS情報が全てnull |
| browserSetting | UserAgentPatternSetting | | | ブラウザ情報の解析パターン設定。未指定時はブラウザ情報が全てnull |

**UserAgentPatternSettingのプロパティ**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| defaultType | String | | "UnknownType" | いずれのパターンにもマッチしない場合またはエラー発生時のデフォルト項目タイプ |
| defaultName | String | | "UnknownName" | いずれのパターンにもマッチしない場合またはエラー発生時のデフォルト項目名称 |
| defaultVersion | String | | "UnknownVersion" | いずれのパターンにもマッチしない場合またはエラー発生時のデフォルトバージョン |
| typePatternList | List | | | 項目タイプ取得用解析パターンリスト。定義順に解析しマッチした時点で終了。未指定時は解析なし |
| itemPatternList | List | | | 項目名称・バージョン取得用解析パターンリスト。定義順に解析しマッチした時点で終了。未指定時は解析なし |

**TypePatternのプロパティ**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| name | String | | | パターンの項目名（他のパターンと同値でも可） |
| pattern | String | | | 解析パターン（正規表現）。不正なパターン指定時は初期化時にIllegalArgumentExceptionが送出される |

**ItemPatternのプロパティ**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| name | String | | | パターンの項目名。nameIndex未指定時に使用。未指定時はdefaultTypeの値 |
| pattern | String | | | 解析パターン（正規表現）。nameIndex/versionIndexで値をキャプチャできるようグループ設定が必要。不正なパターン指定時は初期化時にIllegalArgumentExceptionが送出される。未指定時は解析なし |
| nameIndex | Integer | | | 項目名称キャプチャグループ番号。不正インデックス指定時は初期化時にIllegalArgumentExceptionが送出される。未指定時は項目名称が項目タイプと同値。項目タイプも指定されていない場合はdefaultNameの値 |
| versionIndex | Integer | | | バージョンキャプチャグループ番号。不正インデックス指定時は初期化時にIllegalArgumentExceptionが送出される。未指定時はdefaultVersionの値 |
| nameConvertor | UserAgentValueConvertor | | | 項目名称抽出後の変換クラス。標準実装：UserAgentNameConvertor（文字列置換、toLowerCaseで小文字化。例：「mac os x」→「mac_os_x」）。未指定時は変換なし |
| versionConvertor | UserAgentValueConvertor | | | バージョン抽出後の変換クラス。標準実装：UserAgentVersionConvertor（\D分割→パディング→スペース結合。例：「34.0.1847.116」→「_34 __0 ___1847」）。未指定時は変換なし |

<details>
<summary>keywords</summary>

RegexUserAgentParser, UserAgentPatternSetting, TypePattern, ItemPattern, osSetting, browserSetting, defaultType, defaultName, defaultVersion, typePatternList, itemPatternList, nameIndex, versionIndex, nameConvertor, versionConvertor, IllegalArgumentException

</details>

## コンバータの設定

**UserAgentNameConvertorのプロパティ**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| toLowerCase | boolean | | true（小文字化する） | 文字列の小文字化フラグ |
| replaceFrom | String | | | 置換前文字列 |
| replaceTo | String | | | 置換後文字列。replaceFromとreplaceTo両方未指定時は変換なし |

**UserAgentVersionConvertorのプロパティ**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| padding | String | | | パディング文字列。未指定時は変換なし |

<details>
<summary>keywords</summary>

UserAgentNameConvertor, UserAgentVersionConvertor, toLowerCase, replaceFrom, replaceTo, padding, コンバータプロパティ

</details>

## 使用例

```java
public HttpResponse doUserAgentJudgment(HttpRequest req, ExecutionContext context) {

    UserAgent userAgent = req.getUserAgent();

    if (userAgent.getOsType().equals("android")) {
        ... // クライアントがandroidの場合に行う処理
    }

    if (userAgent.getBrowserName().equals("chrome")) {
        ... // ブラウザがchromeの場合に行う処理
    }
}
```

`HttpRequest#getUserAgent()`でUserAgentオブジェクトを取得し、`getOsType()`でOSタイプ、`getBrowserName()`でブラウザ名を取得できる。

<details>
<summary>keywords</summary>

getUserAgent, getOsType, getBrowserName, HttpRequest, ExecutionContext, UserAgent利用

</details>
