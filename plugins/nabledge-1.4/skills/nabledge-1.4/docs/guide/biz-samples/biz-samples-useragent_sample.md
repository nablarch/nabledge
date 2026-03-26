# UserAgent情報取得機能設定サンプル

## UserAgent情報取得機能設定サンプル

## UserAgent情報取得機能設定サンプル

本節では利用ケースごとに、設定例と各種UserAgent値から取得できる値の具体例を示す。

> **注意**: 以下に示すパターンは各利用ケースにおける全てのパターンを網羅しているわけではない。利用プロジェクトにて実際に利用するパターンを十分に検討すること。

**クラス**: `please.change.me.fw.web.useragent.UserAgentVersionConvertor`, `please.change.me.fw.web.useragent.UserAgentParser`, `please.change.me.fw.web.useragent.UserAgentPatternSetting`, `please.change.me.fw.web.useragent.ItemPattern`

## ユーザエージェント値の例（ブラウザ種別・名前・バージョン）

| UserAgent | ブラウザ種別 | ブラウザ名 | ブラウザバージョン |
|---|---|---|---|
| `Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)` | MSIE | ie | 10.0 |
| `Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36` | WebKit | chrome | 34.0.1847.116 |

OSの判定も同様に設定することで判定可能。

## UserAgentValueConvertor実装クラスの設定サンプル

IEのパターンにマッチしたバージョン番号を変換するコンバータ設定。例: `Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko` の場合、`11.0` がバージョン番号としてマッチし、`UserAgentValueConvertor` によって `_11 __0 ___` に変換される。`versionConvertor` プロパティにコンバータを指定する。

```xml
<component name="browserVersionConvertor" class="please.change.me.fw.web.useragent.UserAgentVersionConvertor">
  <property name="padding" value="_" />
</component>

<component name="userAgentParser" class="please.change.me.fw.web.useragent.UserAgentParser">
  <property name="browserSetting">
    <component class="please.change.me.fw.web.useragent.UserAgentPatternSetting">
      <property name="itemPatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="name"             value="ie" />
            <property name="pattern"          value="(?i).*(msie\s|trident.+rv:)([\d\.]*).*" />
            <property name="versionIndex"     value="2" />
            <property name="versionConvertor" ref="browserVersionConvertor" />
          </component>
        </list>
      </property>
    </component>
  </property>
</component>
```

## ブラウザ種別の特定

`UserAgent#getBrowserType()` でブラウザ種別（"MSIE"/"WebKit"/"Gecko"）を取得し処理を分岐する。

```java
UserAgent userAgent = request.getUserAgent();
String browserType = userAgent.getBrowserType();
if browserType.equals("MSIE")) {
    // "MSIE"の場合の処理
} else if (browserType.equals("WebKit")) {
    // "WebKit"の場合の処理
} else if (browserType.equals("Gecko")) {
    // "Gecko"の場合の処理
}
```

## リクエストスコープへのUserAgent情報の設定

`UserAgent` からOS・ブラウザの名称とバージョンを取得し、リクエストスコープ変数に設定してJSP内で利用する。

```java
UserAgent userAgent = request.getUserAgent();
context.setRequestScopedVar("deviceName",     userAgent.getOsName());
context.setRequestScopedVar("deviceVersion",  userAgent.getOsVersion());
context.setRequestScopedVar("browserName",    userAgent.getBrowserName());
context.setRequestScopedVar("browserVersion", userAgent.getBrowserVersion());
```

## 各種UserAgent値から取得できる値の例（デバイス・ブラウザ）

| UserAgent | デバイス名 | デバイスバージョン | ブラウザ名 | ブラウザバージョン |
|---|---|---|---|---|
| `Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko` | windows | -6 --1 --- | ie | _11 __0 ___ |
| `Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0` | mac_os_x | -10 --9 --- | firefox | _28 __0 ___ |
| `Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36` | windows | -6 --1 --- | chrome | _34 __0 ___1847 |
| `Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25` | iphone | -6 --0 --- | mobile_safari | _6 __0 ___ |
| `Mozilla/5.0 (iPad; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/8536.25` | ipad | -6 --0 --- | mobile_safari | _7 __0 ___ |
| `Mozilla/5.0 (Linux; Android 4.2.2; HTC One Build/JDQ39) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.30 Mobile Safari/537.36` | android | -4 --2 ---2 | chrome | _30 __0 ___1599 |
| `Mozilla/5.0 (Linux; U; Android 4.3;ja-jp;SC-03E Build/JSS15J) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30` | android | -4 --3 --- | android_browser | _4 __0 ___ |

## 任意の解析クラスの実装

`RegexUserAgentParser` を継承してカスタムパーサーを実装し、`UserAgent` を継承したカスタムクラスを返すことで独自の判定メソッドを追加できる。

**設定例**:
```xml
<component name="userAgentParser" class="please.change.me.common.web.useragent.CustomUserAgentParser">
  <!-- 設定内容はRegexUserAgentParserと同じ -->
</component>
```

`CustomUserAgent` は `UserAgent` を継承し、`isTablet()`、`isSmartPhone()`、`isFeaturePhone()` の判定メソッドを追加する。

```java
public class CustomUserAgent extends UserAgent {
    private boolean isTablet;
    private boolean isSmartPhone;
    private boolean isFeaturePhone;

    public CustomUserAgent(UserAgent original) {
        super(original);
    }
    // getter, setter省略
}
```

`CustomUserAgentParser` は `RegexUserAgentParser` を継承し、`parse()` メソッドで `CustomUserAgent` を返す。

```java
public class CustomUserAgentParser extends RegexUserAgentParser {
    @Override
    public CustomUserAgent parse(String userAgentText) {
        UserAgent userAgent = super.parse(userAgentText);
        CustomUserAgent custom = new CustomUserAgent(userAgent);
        custom.setTablet(isTablet(userAgent));
        custom.setSmartPhone(isSmartPhone(userAgent));
        custom.setFeaturePhone(isFeaturePhone(userAgent));
        return custom;
    }

    private boolean isTablet(UserAgent userAgent) {
        // OS名が"ipad"、またはandroidでOSタイプが"tablet"の場合
        String osName = userAgent.getOsName();
        if (osName.equals("ipad")) return true;
        return osName.equals("android") && userAgent.getOsType().equals("tablet");
    }

    private boolean isSmartPhone(UserAgent userAgent) {
        // OS名が"iphone"、またはandroidでOSタイプが"mobilePhone"の場合
        String osName = userAgent.getOsName();
        if (osName.equals("iphone")) return true;
        return osName.equals("android") && userAgent.getOsType().equals("mobilePhone");
    }

    private boolean isFeaturePhone(UserAgent userAgent) {
        // タブレットでもスマートフォンでもなく、UserAgent文字列にキャリア名（DoCoMo/kddi/vodafone）が含まれる場合
        if (isTablet(userAgent) || isSmartPhone(userAgent)) return false;
        String uaText = userAgent.getText();
        return uaText.contains("DoCoMo") || uaText.contains("kddi") || uaText.contains("vodafone");
    }
}
```

**アクションクラスでの利用**:
```java
CustomUserAgent userAgent = req.getUserAgent();
if (userAgent.isTablet()) {
    // タブレットの場合の処理
} else if (userAgent.isSmartPhone()) {
    // スマートフォンの場合の処理
}
```

**カスタム判定の結果例**:

| UserAgent | isTablet | isSmartPhone | isFeaturePhone | 備考 |
|---|---|---|---|---|
| `Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)` | false | false | false | PC |
| `Mozilla/5.0 (Linux; U; Android 3.2; ja-jp; SC-01D Build/MASTER) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13` | true | false | false | タブレット |
| `Mozilla/5.0 (Linux; U; Android 2.3.3; ja-jp; SC-02C Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1` | false | true | false | スマートフォン |
| `DoCoMo/2.0 N2001(c10)` | false | false | true | フィーチャーフォン |

<details>
<summary>keywords</summary>

UserAgent情報取得機能, UserAgentParser, 設定サンプル, 利用ケース, UserAgent, UserAgentVersionConvertor, UserAgentPatternSetting, ItemPattern, RegexUserAgentParser, CustomUserAgent, CustomUserAgentParser, getBrowserType, getBrowserName, getBrowserVersion, getOsName, getOsVersion, getOsType, ユーザエージェント解析, ブラウザ種別判定, デバイス種別判定, タブレット・スマートフォン・フィーチャーフォン判定, カスタムUserAgentパーサー

</details>

## UserAgentParserの設定サンプル

## UserAgentParserの設定サンプル

**クラス**: `please.change.me.fw.web.useragent.UserAgentParser`

ブラウザの種類をMSIE・WebKit・Geckoの3種類に分別する設定例:

```xml
<component name="userAgentParser" class="please.change.me.fw.web.useragent.UserAgentParser">
  <!-- OSのパターンマッピング設定（この例ではOS判定なし） -->
  <property name="osSetting">
    <component class="please.change.me.fw.web.useragent.UserAgentPatternSetting"/>
  </property>
  <!-- ブラウザのパターンマッピング設定 -->
  <property name="browserSetting">
    <component class="please.change.me.fw.web.useragent.UserAgentPatternSetting">
      <property name="typePatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.TypePattern">
            <property name="name"    value="MSIE" />
            <property name="pattern" value=".*MSIE.*" />
          </component>
          <component class="please.change.me.fw.web.useragent.TypePattern">
            <property name="name"    value="MSIE" />
            <property name="pattern" value=".*Trident.+rv:[\d\.]+.*"/>
          </component>
          <component class="please.change.me.fw.web.useragent.TypePattern">
            <property name="name"    value="WebKit" />
            <property name="pattern" value=".*WebKit.*" />
          </component>
          <component class="please.change.me.fw.web.useragent.TypePattern">
            <property name="name"    value="Gecko" />
            <property name="pattern" value=".*Gecko.*" />
          </component>
        </list>
      </property>
      <property name="itemPatternList">
        <list>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="name"         value="ie" />
            <property name="pattern"      value="(?i).*(msie\s|trident.+rv:)([\d\.]*).*" />
            <property name="versionIndex" value="2" />
          </component>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="name"         value="android_browser" />
            <property name="pattern"      value="(?i).*android.*version/([\d\.]*).+(mobile *?safari).*" />
            <property name="versionIndex" value="1" />
          </component>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="name"         value="mobile_safari" />
            <property name="pattern"      value="(?i).*version/([\d\.]*).+(mobile.*safari).*" />
            <property name="versionIndex" value="1" />
          </component>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="name"         value="firefox_chrome" />
            <property name="pattern"      value="(?i).*(firefox|chrome)[\s/]*([\d\.]*).*" />
            <property name="nameIndex"    value="1" />
            <property name="versionIndex" value="2" />
          </component>
          <component class="please.change.me.fw.web.useragent.ItemPattern">
            <property name="name"         value="safari" />
            <property name="pattern"      value="(?i).*version/([\d\.]*).+(safari).*" />
            <property name="versionIndex" value="1" />
          </component>
        </list>
      </property>
    </component>
  </property>
</component>
```

> **注意**: typePatternList・itemPatternListは記述順に評価される。`.*Gecko.*` を先頭に置くと、ChromeやIE11もGeckoと判定される（これらのUAに `Gecko` 文字列が含まれるため）。

<details>
<summary>keywords</summary>

UserAgentParser, UserAgentPatternSetting, TypePattern, ItemPattern, please.change.me.fw.web.useragent.UserAgentParser, please.change.me.fw.web.useragent.UserAgentPatternSetting, please.change.me.fw.web.useragent.TypePattern, please.change.me.fw.web.useragent.ItemPattern, UserAgent判定, ブラウザ種別判定, typePatternList, itemPatternList, osSetting, browserSetting, versionIndex, nameIndex, MSIE, WebKit, Gecko

</details>
