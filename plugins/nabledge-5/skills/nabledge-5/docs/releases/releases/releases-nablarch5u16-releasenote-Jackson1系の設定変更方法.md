# ■Jackson1系の設定変更方法

ここでは、Jackson1系から2系への設定変更方法について説明します。
◆概要
以下の２つの作業を行います。
・依存ライブラリの変更(pom.xml)
・Nablarchのコンポーネント設定ファイルの変更
◆依存ライブラリの変更
Jackson1系のライブラリをdependenciesから削除します。
<dependency>
<groupId>org.codehaus.jackson</groupId>
<artifactId>jackson-mapper-asl</artifactId>
<version>1.9.13</version>
</dependency>
◆Nablarchのコンポーネント設定ファイルの変更
nablarch.fw.jaxrs.JaxRsMethodBinderFactoryのプロパティhandlerListに設定する
nablarch.fw.jaxrs.JaxRsHandlerListFactoryを差し替えます。
【例：修正前】
以下のように、nablarch.integration.jaxrs.jackson.Jackson1BodyConverterを使用するnablarch.fw.jaxrs.JaxRsHandlerListFactory実装クラスが使用されています。
<!--パッケージマッピングの設定 -->
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
<property name="basePackage" value="${nablarch.commonProperty.basePackage}" />
<property name="methodBinderFactory">
<component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
<property name="handlerList">
<component class="myproject.Jackson1HandlerListFactory"/>
</property>
</component>
</property>
</component>
【例：修正後】
nablarch.integration.jaxrs.jackson.Jackson2BodyConverterを使用するnablarch.fw.jaxrs.JaxRsHandlerListFactory実装クラスを使用するように変更します。
<!--パッケージマッピングの設定 -->
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
<property name="basePackage" value="${nablarch.commonProperty.basePackage}" />
<property name="methodBinderFactory">
<component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
<property name="handlerList">
<component class="nablarch.integration.jaxrs.jersey.JerseyJaxRsHandlerListFactory"/>
</property>
</component>
</property>
</component>
