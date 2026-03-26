<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- <%/* --> <script src="js/devtool.js"></script><meta charset="utf-8"><body> <!-- */%> -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@ taglib prefix="field"  tagdir="/WEB-INF/tags/widget/field" %>
<%@ taglib prefix="button" tagdir="/WEB-INF/tags/widget/button" %>
<%@ taglib prefix="table"  tagdir="/WEB-INF/tags/widget/table" %>
<%@ taglib prefix="column" tagdir="/WEB-INF/tags/widget/column" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<t:page_template title="ユーザ情報一覧照会">

  <jsp:attribute name="contentHtml">
  <n:form>
    <field:block title="検索条件">
      <field:text
        title     = "ログインID"
        domain    = "LOGIN_ID"
        maxlength = "20"
        name      = "">
      </field:text>

      <field:text
        title     = "漢字氏名"
        domain    = "KANJI_NAME"
        maxlength = "20"
        name      = "">
      </field:text>

      <field:text
        title     = "カナ氏名"
        domain    = "KANA_NAME"
        maxlength = "20"
        name      = "">
      </field:text>

      <field:pulldown
        title                = "グループ"
        name                 = ""
        sample               = "[お客様グループ]|一般グループ"
        listName             = ""
        elementLabelProperty = ""
        elementValueProperty = "">
      </field:pulldown>


        <%----------------------------------------------------------------------------------
         【説明】

         コードを利用してプルダウンを表示する場合は、field:code_pulldownを利用する。

         画面に出力されるコード名称は、"codeId"属性および"pattern"属性、"optionColumnName"に指定された値を元に、
         「js/devtool/resource/コード値定義.js」から該当する名称が取得される。
        ----------------------------------------------------------------------------------%>
      <field:code_pulldown
        title            = "ユーザIDロック"
        name             = ""
        codeId           = "C0000001"
        pattern          = "PATTERN01"
        optionColumnName = "OPTION01"
        withNoneOption   = "true">
      </field:code_pulldown>
    </field:block>

    <button:block>
      <button:search dummyUri="W11AC0101.jsp" uri="">
      </button:search>
    </button:block>
  </n:form>

  <n:form>
    <%----------------------------------------------------------------------------------
     【説明】

     検索結果などを表示する表は以下のように作成する。

     columnタグのkey属性は必須となっているが、PG・UT工程で実装されるため空として定義しておけばよい。

     表に表示するダミーの値は、各columnタグのsample属性に指定する。複数行分表示したい場合、
     ダミーの値を「|」で区切って指定する。
    ----------------------------------------------------------------------------------%>
    <table:search_result
      title               = "検索結果"
      listSearchInfoName  = ""
      resultSetName       = ""
      searchUri           = ""
      sampleResults       = "2">

      <column:checkbox
        title    = "選択"
        key      = ""
        name     = "">
      </column:checkbox>

      <column:link
        title  = "ログインID"
        sample = "user001|user002|user003"
        key    = ""
        uri    = ""
        dummyUri="W11AC0102.jsp">
      </column:link>

      <column:label
        title    = "漢字氏名"
        key      = ""
        sortable = "true"
        sample   = "名部　楽太郎|名部　楽次郎|名部　楽三郎|田嶋　岩魚">
      </column:label>

      <column:label
        title    = "カナ氏名"
        key      = ""
        sortable = "true"
        sample   = "ナブ　ラクタロウ|ナブ　ラクジロウ|ナブ　ラクサブロウ|タジマ　イワウオ">
      </column:label>

      <column:label
        title  = "グループ"
        key    = ""
        sample = "-|お客様グループ|一般グループ">
      </column:label>

      <column:label
        title = "内線番号"
        key   = ""
        value = ""
        sample = "12-3456|98-7654">
      </column:label>

      <column:label
        title  = "メールアドレス"
        key    = ""
        sample = "nablarch@example.com|nabu@example.co.jp">
      </column:label>

      <column:code
        title        = "ロック"
        key          = ""
        codeId       = "C0000001"
        sample       = "-">
      </column:code>

      <column:link
        title = "更新"
        value = "更新"
        uri   = ""
        dummyUri="W11AC0301.jsp">
      </column:link>

      <column:link
        title = "削除"
        value = "削除"
        uri   = ""
        dummyUri="W11AC0401.jsp">
      </column:link>

    </table:search_result>

    <button:block>

      <button:submit
        label = "一括削除"
        dummyUri="W11AC0501.jsp"
        uri   = "">
      </button:submit>

      <button:download
        label = "ダウンロード"
        dummyUri = ""
        size  = "4"
        uri   = "">
      </button:download>

      <button:submit
        label = "新規登録"
        dummyUri="W11AC0201.jsp"
        uri   = "">
      </button:submit>

    </button:block>


  </n:form>
  </jsp:attribute>
</t:page_template>

