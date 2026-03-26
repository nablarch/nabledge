<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- <%/* --> <script src="js/devtool.js"></script><meta charset="utf-8"><body> <!-- */%> -->
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@ taglib prefix="button" tagdir="/WEB-INF/tags/widget/button" %>
<%@ taglib prefix="field" tagdir="/WEB-INF/tags/widget/field" %>
<%@ taglib prefix="tutorial" tagdir="/WEB-INF/tags/widget/tutorial" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<t:page_template title="ユーザ情報詳細">
  <jsp:attribute name="contentHtml">
  <field:block title="ユーザ基本情報">
    <field:label title="ログインID" name="" sample="login-id"></field:label>
    <field:label title="漢字氏名" name="" sample="てすと ゆーざ"></field:label>
    <field:label title="カナ氏名" name="" sample="テスト ユーザ"></field:label>
    <field:label title="メールアドレス" name="" sample="test@mail.com"></field:label>
    <tutorial:label_extension_number
        title="内線番号"
        builName=""
        personalName=""
        sample="01-1111">
    </tutorial:label_extension_number>
    <tutorial:label_tel
        title="携帯電話番号"
        areaName=""
        localName=""
        subscriberName=""
        sample="090-1234-1234">
    </tutorial:label_tel>
  </field:block>
  <field:block title="権限情報">
    <field:label_id_value
        title="グループ"
        idName=""
        valueName=""
        sample="0000000000: お客様グループ">
    </field:label_id_value>
  </field:block>
  <n:form>
    <button:block>
      <button:back uri="" label="検索画面へ" dummyUri="W11AC0101.jsp">
      </button:back>
      <button:delete uri="" dummyUri="W11AC0401.jsp">
      </button:delete>
      <button:update
          dummyUri="W11AC0301.jsp"
          uri="/action/ss11AC/W11AC03Action/RW11AC0301">
      </button:update>
    </button:block>
  </n:form>
  </jsp:attribute>
</t:page_template>

