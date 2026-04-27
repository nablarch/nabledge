# ■システムリポジトリを5u12までと同じ動作にする方法

5u13から、staticなプロパティに対するインジェクションを許容しないようになりました。
staticなプロパティに対するインジェクションの例を以下に示します。
Foo.java
public class Foo {
private static Bar bar; // staticなフィールド
public static Bar getBar() {
return bar;
}
public static void setBar(Bar bar) { // staticなsetterメソッド
Foo.bar = bar;
}
}
コンポーネント設定ファイル
<?xml version="1.0" encoding="UTF-8"?>
<component-configuration
xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration /component-configuration.xsd">
<component name="foo" class="nablarch.core.repository.di.staticprop.Foo" autowireType="None">
<!-- staticなプロパティへのインジェクション -->
<property name="bar" ref="bar"/>
</component>
<component name="bar" class="nablarch.core.repository.di.staticprop.Bar" autowireType="None"/>
</component-configuration>
5u13からは、DIコンテナ構築時に以下のような例外が発生します。
nablarch.core.repository.di.ContainerProcessException: static property injection not allowed. component=[foo] property=[bar]
at nablarch.core.repository.di.DiContainer.setProperty(DiContainer.java:499)
at nablarch.core.repository.di.DiContainer.injectObject(DiContainer.java:479)
at nablarch.core.repository.di.DiContainer.initializeComponent(DiContainer.java:441)
at nablarch.core.repository.di.DiContainer.completeInject(DiContainer.java:427)
at nablarch.core.repository.di.DiContainer.reload(DiContainer.java:222)
at nablarch.core.repository.di.DiContainer.<init>(DiContainer.java:91)
at nablarch.fw.web.servlet.NablarchServletContextListener.initializeRepository(NablarchServletContextListener.java:83)
5u12までと同じ動作としたい場合は、以下の設定をしてください。
ウェブアプリケーション、ウェブサービスの場合
ウェブアプリーケーション、ウェブサービスのように、warファイルを作成しAPサーバにデプロイするアプリケーションの場合は、
web.xmlに以下の記載をしてください(黄色箇所)。
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
version="3.1">
<context-param>
<!-- DIコンテナの設定ファイルパス -->
<param-name>di.config</param-name>
<param-value>web-boot.xml</param-value>
</context-param>
<context-param>
<!-- 設定重複時の動作設定 -->
<param-name>di.duplicate-definition-policy</param-name>
<param-value>OVERRIDE</param-value>
</context-param>
<context-param>
<!-- staticなプロパティへのインジェクションを許容する設定 -->
<param-name>di.allow-static-property</param-name>
<param-value>true</param-value>
</context-param>
:
バッチアプリケーション、メッセージングの場合
バッチアプリケーション、メッセージングのように、jarファイルを作成しjavaコマンドからmainメソッドを起動するタイプのアプリケーションの場合、
javaコマンドに以下のようにシステムプロパティ nablarch.diContainer.allowStaticInjection を true に設定してください。
以下に、JSR352に準拠したバッチアプリケーションの実行例を示します。
java -Dnablarch.diContainer.allowStaticInjection=true <その他のオプション> nablarch.fw.batch.ee.Main <プログラム引数>
