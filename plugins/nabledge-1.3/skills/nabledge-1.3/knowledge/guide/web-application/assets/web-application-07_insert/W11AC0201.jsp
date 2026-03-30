<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- <%/* --> <script src="js/devtool.js"></script><meta charset="utf-8"><body> <!-- */%> -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="field" tagdir="/WEB-INF/tags/widget/field" %>
<%@ taglib prefix="button" tagdir="/WEB-INF/tags/widget/button" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<t:page_template
    title="ユーザ情報登録"
    confirmationPageTitle="ユーザ情報登録確認">
  <jsp:attribute name="contentHtml">
  <n:form windowScopePrefixes="W11AC02,11AC_W11AC01">
    <field:block title="ユーザ基本情報">
      <field:text title="ログインID"
          domain="ログインID"
          required="true"
          maxlength="20"
          hint="半角英数記号20文字以内"
          name="W11AC02.systemAccount.loginId"
          sample="test01">
      </field:text>
      <field:password title="パスワード"
          domain="パスワード"
          required="true"
          maxlength="20"
          name="W11AC02.newPassword"
          sample="password">
      </field:password>
      <field:password title="パスワード（確認用）"
          domain="パスワード"
          required="true"
          maxlength="20"
          name="W11AC02.confirmPassword"
          sample="password">
      </field:password>
      <field:hint>半角英数記号20文字以内</field:hint>

      <field:text title="漢字氏名"
          domain="氏名"
          required="true"
          maxlength="50"
          hint="全角50文字以内"
          name="W11AC02.users.kanjiName"
          sample="名部　楽太郎">
      </field:text>
      <field:text title="カナ氏名"
          domain="カナ氏名"
          required="true"
          maxlength="50"
          hint="全角カナ50文字以内"
          name="W11AC02.users.kanaName"
          sample="ナブ　ラクタロウ">
      </field:text>
      <field:text title="メールアドレス"
          domain="メールアドレス"
          required="true"
          maxlength="100"
          hint="半角英数記号100文字以内"
          name="W11AC02.users.mailAddress"
          sample="nabla@example.com">
      </field:text>
      <field:extension_number
          title="内線番号"
          builName="W11AC02.users.extensionNumberBuilding"
          personalName="W11AC02.users.extensionNumberPersonal"
          hint="半角数字2文字以内 - 半角数字4文字以内"
          required="true">
      </field:extension_number>
      <field:tel title="携帯電話番号"
          areaName="W11AC02.users.mobilePhoneNumberAreaCode"
          localName="W11AC02.users.mobilePhoneNumberCityCode"
          subscriberName="W11AC02.users.mobilePhoneNumberSbscrCode"
          nameAlias="W11AC02.users.mobilePhoneNumber"
          hint="半角数字3文字以内 - 半角数字4文字以内 - 半角数字4文字以内">
      </field:tel>
    </field:block>
    <field:block title="権限情報">
      <field:pulldown title="グループ"
          required="true"
          name="W11AC02.ugroupSystemAccount.ugroupId"
          listName="allGroup"
          elementLabelProperty="ugroupName"
          elementValueProperty="ugroupId"
          hint="所属グループを選択してください。"
          sample="[お客様グループ]|一般グループ">
      </field:pulldown>
    </field:block>

    <button:block>
      <n:set var="searchCondition" name="11AC_W11AC01.loginId"></n:set>
      <n:set var="searchRequestId" value="RW11AC0101"></n:set>
      <c:if test="${searchCondition != null}">
        <n:set var="searchRequestId" value="RW11AC0102"></n:set>
      </c:if>
      <n:forInputPage>
        <button:back
            label="一覧照会画面へ"
            uri="/action/ss11AC/W11AC01Action/${searchRequestId}">
        </button:back>
        <button:check
            uri="/action/ss11AC/W11AC02Action/RW11AC0202">
        </button:check>
      </n:forInputPage>
      <n:forConfirmationPage>
        <button:cancel
            uri="/action/ss11AC/W11AC02Action/RW11AC0203">
        </button:cancel>
        <button:confirm
            uri="/action/ss11AC/W11AC02Action/RW11AC0204"
            allowDoubleSubmission="false">
        </button:confirm>
        <button:submit
            label="メッセージ送信"
            uri="/action/ss11AC/W11AC02Action/RW11AC0205"
            allowDoubleSubmission="false">
        </button:submit>
      </n:forConfirmationPage>
    </button:block>
  </n:form>
  </jsp:attribute>
</t:page_template>

