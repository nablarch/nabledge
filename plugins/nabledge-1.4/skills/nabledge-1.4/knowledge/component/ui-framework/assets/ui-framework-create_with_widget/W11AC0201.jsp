<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- <%/* --> <script src="js/devtool.js"></script><meta charset="utf-8"><body> <!-- */%> -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="field" tagdir="/WEB-INF/tags/widget/field" %>
<%@ taglib prefix="button" tagdir="/WEB-INF/tags/widget/button" %>
<%@ taglib prefix="tutorial" tagdir="/WEB-INF/tags/widget/tutorial" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<t:page_template
    title="ユーザ情報登録"
    confirmationPageTitle="ユーザ情報登録確認">
  <jsp:attribute name="contentHtml">
  <n:form>
    <field:block title="ユーザ基本情報">
      <field:text title="ログインID"
                  domain="LOGIN_ID"
                  required="true"
                  maxlength="20"
                  hint="半角英数記号20文字以内"
                  name=""
                  sample="test01">
      </field:text>
      <field:password title="パスワード"
                      domain="PASSWORD"
                      required="true"
                      maxlength="20"
                      name=""
                      sample="password">
      </field:password>
      <field:password title="パスワード（確認用）"
                      domain="PASSWORD"
                      required="true"
                      maxlength="20"
                      name=""
                      sample="password">
      </field:password>
      <field:hint>半角英数記号20文字以内</field:hint>

      <field:text title="漢字氏名"
                  domain="KANJI_NAME"
                  required="true"
                  maxlength="50"
                  hint="全角50文字以内"
                  name=""
                  sample="名部　楽太郎">
      </field:text>
      <field:text title="カナ氏名"
                  domain="KANA_NAME"
                  required="true"
                  maxlength="50"
                  hint="全角カナ50文字以内"
                  name=""
                  sample="ナブ　ラクタロウ">
      </field:text>
      <field:text title="メールアドレス"
                  domain="MAIL_ADDRESS"
                  required="true"
                  maxlength="100"
                  hint="半角英数記号100文字以内"
                  name=""
                  sample="nabla@example.com">
      </field:text>
      <tutorial:extension_number
          title="内線番号"
          builName=""
          personalName=""
          hint="半角数字2文字以内 - 半角数字4文字以内"
          required="true">
      </tutorial:extension_number>
      <tutorial:tel title="携帯電話番号"
                 areaName=""
                 localName=""
                 subscriberName=""
                 nameAlias=""
                 hint="半角数字3文字以内 - 半角数字4文字以内 - 半角数字4文字以内">
      </tutorial:tel>
    </field:block>
    <field:block title="権限情報">
      <field:pulldown title="グループ"
                      required="true"
                      name=""
                      listName=""
                      elementLabelProperty=""
                      elementValueProperty=""
                      hint="所属グループを選択してください。"
                      sample="[お客様グループ]|一般グループ">
      </field:pulldown>
    </field:block>

    <button:block>
      <n:forInputPage>
       <button:back
            label="検索画面へ"
            dummyUri="W11AC0101.jsp"
            uri="">
        </button:back>
        <button:check
            uri=""
            dummyUri="W11AC0202.jsp">
        </button:check>
      </n:forInputPage>
      <n:forConfirmationPage>
        <button:cancel
            uri=""
            dummyUri="W11AC0201.jsp">
        </button:cancel>
        <button:confirm
            uri=""
            allowDoubleSubmission="false"
            dummyUri="W11AC0203.jsp">
        </button:confirm>
        <button:submit
            label="メッセージ送信"
            dummyUri="W11AC0203.jsp"
            uri=""
            allowDoubleSubmission="false">
        </button:submit>
      </n:forConfirmationPage>
    </button:block>
  </n:form>
  </jsp:attribute>
</t:page_template>

