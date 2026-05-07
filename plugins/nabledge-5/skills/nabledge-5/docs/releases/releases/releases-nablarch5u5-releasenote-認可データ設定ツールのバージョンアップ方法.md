# 認可データ設定ツールのバージョンアップ方法

認可データ設定ツールのバージョンアップ方法  
Nablarch 5u5 リリースノートのNo54の変更に伴い、5u5にバージョンアップする際は、以下の手順が必要になる。  
以下の二つのファイルを編集する必要がある  
１．nablarch-tools.config  
内容：設定項目のキー名、キー値の変更  
変更前  変更後  
authgen.outputBookPath  authgen.outputDirectory  
systemAccountAuthority.writer.outputSheetName  systemAccountAuthority.writer.outputFileName  
ugroupAuthority.writer.outputSheetName  ugroupAuthority.writer.outputFileName  
ugroupSystemAccount.writer.outputSheetName  ugroupSystemAccount.writer.outputFileName  
permissionUnitRequest.writer.outputSheetName  permissionUnitRequest.writer.outputFileName  
２．auth-generator.xml  
各コンポーネントから、<property name="writer">~</property>を削除する  
例：systemAccountAuthorityコンポーネント  
<component name="systemAccountAuthority" class="nablarch.tool.authgenerator.Matrix">  
  <property name="inputSheetName" value="${systemAccountAuthority.inputSheetName}"/>  
  <property name="reader">  
    <component class="nablarch.tool.util.poi.EmptyAwareTableReader">  
      <!-- ヘッダ行の位置（0オリジン） -->  
      <property name="headerRowNum" value="2"/>  
    </component>  
  </property>  
  <property name="converter">  
    <component class="nablarch.tool.authgenerator.MatrixConverter">  
      <property name="checkMark" value="${authgen.checkMark}"/>  
      <property name="mainKey" value="${systemAccountAuthority.converter.mainKey}"/>  
      <property name="subKey" value="${systemAccountAuthority.converter.subKey}"/>  
      <property name="unconcernedKeys" value="${systemAccountAuthority.converter.unconcernedKeys}"/>  
    </component>  
  </property>  
  <!-- このプロパティを削除する。  
  <property name="writer">  
    <component class="nablarch.tool.authgenerator.Writer">  
      <property name="outputSheetName" value="${systemAccountAuthority.writer.outputSheetName}"/>  
      <property name="startRowNum" value="1"/>  
    </component>  
  </property>  
  -->  
</component>  
手順中に必要となるファイルの所在、及び設定値の例については、Nablarchのドキュメントの[ツールボックス]→[解説書]→[認可データ設定ツール]を参照すること。
