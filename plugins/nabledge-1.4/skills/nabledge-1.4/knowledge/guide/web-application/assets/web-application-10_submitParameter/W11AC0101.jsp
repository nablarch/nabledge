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
  <n:form windowScopePrefixes="11AC_W11AC01">
    <field:block title="検索条件">
      <field:text
        title     = "ログインID"
        domain    = "ログインID"
        maxlength = "20"
        name      = "11AC_W11AC01.loginId">
      </field:text>
      
      <field:text
        title     = "漢字氏名"
        domain    = "氏名"
        maxlength = "20"
        name      = "11AC_W11AC01.kanjiName">
      </field:text>
      
      <field:text
        title     = "カナ氏名"
        domain    = "カナ氏名"
        maxlength = "20"
        name      = "11AC_W11AC01.kanaName">
      </field:text>
      
      <field:pulldown
        title                = "グループ"
        name                 = "11AC_W11AC01.ugroupId"
        listName             = "ugroupList"
        elementLabelProperty = "ugroupName"
        elementValueProperty = "ugroupId"
        withNoneOption       = "true"
        sample               = "[お客様グループ]|一般グループ">
      </field:pulldown>

      <field:code_pulldown
        title            = "ユーザIDロック"
        codeName         = "ユーザステータス区分(パターン01)"
        name             = "11AC_W11AC01.userIdLocked"
        codeId           = "C0000001"
        pattern          = "PATTERN01"
        optionColumnName = "OPTION01"
        labelPattern     = "$OPTIONALNAME$"
        withNoneOption   = "true">
      </field:code_pulldown>
    </field:block>

    <button:block>
      <button:search uri="/action/ss11AC/W11AC01Action/RW11AC0102">
        <n:param paramName="11AC_W11AC01.pageNumber" value="1"></n:param>
        <n:param paramName="11AC_W11AC01.sortId" value="1"></n:param>
      </button:search>
    </button:block>
  </n:form>

  <n:form windowScopePrefixes="11AC_W11AC01">
    <%-- 削除データ用カウント --%>
    <n:hidden name="W11AC05.systemAccountEntityArraySize"></n:hidden>

    <table:search_result
      title               = "検索結果"
      searchUri           = "/action/ss11AC/W11AC01Action/RW11AC0102"
      listSearchInfoName  = "11AC_W11AC01"
      resultSetName       = "searchResult"
      sampleResults       = "15">

      <column:checkbox
        title    = "選択"
        key      = "userId"
        name     = "W11AC05.systemAccountEntityArray[${count-1}].userId"
        offValue = "0000000000">
      </column:checkbox>

      <column:link
        title  = "ログインID"
        key    = "loginId"
        uri    = "/action/ss11AC/W11AC01Action/RW11AC0103"
        sample = "user001|user002|user003">
        <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId"></n:param>
      </column:link>
      
      <column:label
        title    = "漢字氏名"
        key      = "kanjiName"
        sortable = "true"
        sample   = "名部　楽太郎|名部　楽次郎|名部　楽三郎|田嶋　岩魚">
      </column:label>
      
      <column:label
        title    = "カナ氏名"
        key      = "kanaName"
        sortable = "true"
        sample   = "ナブ　ラクタロウ|ナブ　ラクジロウ|ナブ　ラクサブロウ|タジマ　イワウオ">
      </column:label>
      
      <column:label
        title  = "グループ"
        key    = "ugroupName"
        sample = "-|お客様グループ|一般グループ">
      </column:label>
      
      <column:label
        title = "内線番号"
        key   = "extensionNumber"
        value = "${row.extensionNumberBuilding} - ${row.extensionNumberPersonal}"
        sample = "12-3456|98-7654">
      </column:label>
      
      <column:label
        title  = "メールアドレス"
        key    = "mailAddress"
        sample = "nablarch@example.com|nabu@example.co.jp">
      </column:label>

      <column:code
        title        = "ロック"
        key          = "userIdLocked"
        codeId       = "C0000001"
        codeName     = "ユーザステータス区分(パターン01)"
        labelPattern = "$OPTIONALNAME$"
        sample       = "-">
      </column:code>
      
      <column:link
        title = "更新"
        value = "更新"
        uri   = "/action/ss11AC/W11AC03Action/RW11AC0301">
        <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId"></n:param>
        <n:param paramName="W11AC03.systemAccount.userId"      name="row.userId"></n:param>
      </column:link>
      
      <column:link
        title = "削除"
        value = "削除"
        uri   = "/action/ss11AC/W11AC04Action/RW11AC0401">
        <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId"></n:param>
        <n:param paramName="W11AC04.systemAccount.userId"      name="row.userId"></n:param>
      </column:link>
      
    </table:search_result>
    
    <c:if test="${not empty resultCount}">
    <button:block>
    
      <c:if test="${resultCount > 0}">
      
      <button:submit
        label = "一括削除"
        uri   = "/action/ss11AC/W11AC05Action/RW11AC0501">
      </button:submit>
      
      <button:download
        label = "ダウンロード"
        size  = "4"
        uri   = "/action/ss11AC/W11AC01Action/RW11AC0104">
      </button:download>
      
      </c:if>
    
      <button:submit
        label = "新規登録"
        uri   = "/action/ss11AC/W11AC02Action/RW11AC0201">
      </button:submit>
      
    </button:block>
    </c:if>

    
  </n:form>
  </jsp:attribute>
</t:page_template>

