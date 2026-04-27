<?xml version="1.0" encoding="UTF-8" ?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <n:noCache />

    <n:forInputPage><n:set var="title" value="ユーザ情報登録"/></n:forInputPage>
    <n:forConfirmationPage><n:set var="title"
            value="ユーザ情報登録確認"/></n:forConfirmationPage>
    <jsp:include page="/html_header.jsp">
        <jsp:param name="title" value="${title}"/>
    </jsp:include>
</head>

<body>
<div id="wrapper">
    <jsp:include page="/app_header.jsp">
        <jsp:param name="title" value="${title}"/>
    </jsp:include>
    <div id="mainContents">
        <jsp:include page="/app_error.jsp"/>
        <div id="mainContentsInner">
            <n:form windowScopePrefixes="W11AC02,11AC_W11AC01">
                <table class="zero">
                    <tr>
                        <td>
                            <table class="subtitleWithAttention">
                                <tr>
                                    <td>
                                        <p class="areaTitle">ユーザ基本情報</p>
                                    </td>
                                    <n:forInputPage>
                                        <td>
                                            <p class="attention">*は必ず入力してください</p>
                                        </td>
                                    </n:forInputPage>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
                            <table class="data inputArea">
                                <tr>
                                    <th>
                                        ログインID <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC02.systemAccount.loginId"
                                                size="50" maxlength="20"/>
                                        <n:forInputPage>
                                            (半角英数記号20文字以内)
                                        </n:forInputPage>
                                        <n:error name="W11AC02.systemAccount.loginId"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        パスワード <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:password name="W11AC02.newPassword"
                                                size="50" maxlength="20"/>
                                        <n:forInputPage>
                                            (半角英数記号20文字以内) <br/> 
                                            <n:password name="W11AC02.confirmPassword"
                                                size="50" maxlength="20"/> (確認用)
                                        </n:forInputPage> 
                                        <n:error name="W11AC02.newPassword"/>
                                        <n:error name="W11AC02.confirmPassword" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        漢字氏名 <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC02.users.kanjiName" size="52"
                                                maxlength="50"/>
                                        <n:forInputPage>
                                            (全角50文字以内)
                                        </n:forInputPage>
                                        <n:error name="W11AC02.users.kanjiName"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        カナ氏名 <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC02.users.kanaName" size="52"
                                                maxlength="50"/>
                                        <n:forInputPage>
                                            (全角カナ50文字以内)
                                        </n:forInputPage>
                                        <n:error name="W11AC02.users.kanaName"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        メールアドレス <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC02.users.mailAddress"
                                                size="52" maxlength="100"/>
                                        <n:forInputPage>
                                           (半角英数記号100文字以内)
                                        </n:forInputPage>
                                        <n:error name="W11AC02.users.mailAddress"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        内線番号 <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC02.users.extensionNumberBuilding"
                                                size="2" maxlength="2"/> -
                                        <n:text name="W11AC02.users.extensionNumberPersonal"
                                                size="4" maxlength="4"/>
                                        <n:forInputPage>
                                            <br/>(半角数字2文字以内 - 半角数字4文字以内)
                                            <br/>(「全項目入力」または「全項目未入力」のいずれか)
                                        </n:forInputPage>
                                        <n:error name="W11AC02.users.extensionNumberBuilding"/>
                                        <n:error name="W11AC02.users.extensionNumberPersonal"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        携帯電話番号
                                    </th>
                                    <td>
                                        <n:forInputPage> 
                                            <n:text name="W11AC02.users.mobilePhoneNumberAreaCode"
                                                    nameAlias="W11AC02.users.mobilePhoneNumber"
                                                    size="5" maxlength="3"/> -
                                            <n:text name="W11AC02.users.mobilePhoneNumberCityCode"
                                                    nameAlias="W11AC02.users.mobilePhoneNumber"
                                                    size="6" maxlength="4"/> -
                                            <n:text name="W11AC02.users.mobilePhoneNumberSbscrCode"
                                                    nameAlias="W11AC02.users.mobilePhoneNumber"
                                                    size="6" maxlength="4"/>
                                            <br/>(半角数字3文字以内 - 半角数字4文字以内 - 半角数字4文字以内)
                                            <br/>(「全項目入力」または「全項目未入力」のいずれか)
                                        </n:forInputPage>
                                        <n:forConfirmationPage> 
                                            <n:set var="mobilePhoneNumberAreaCode"
                                                   name="W11AC02.users.mobilePhoneNumberAreaCode"/>
                                            <c:if test="${not empty mobilePhoneNumberAreaCode}">
                                                <n:text name="W11AC02.users.mobilePhoneNumberAreaCode"
                                                        size="5"
                                                        maxlength="3"/> -
                                                <n:text name="W11AC02.users.mobilePhoneNumberCityCode"
                                                        size="6"
                                                        maxlength="4"/> -
                                                <n:text name="W11AC02.users.mobilePhoneNumberSbscrCode"
                                                        size="6" maxlength="4"/>
                                            </c:if>
                                            <c:if test="${empty mobilePhoneNumberAreaCode}">
                                                -
                                            </c:if>
                                        </n:forConfirmationPage>
                                        <n:error name="W11AC02.users.mobilePhoneNumberAreaCode"/>
                                        <n:error name="W11AC02.users.mobilePhoneNumberCityCode"/>
                                        <n:error name="W11AC02.users.mobilePhoneNumberSbscrCode"/>
                                        <n:error name="W11AC02.users.mobilePhoneNumber"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <p class="areaTitle">権限情報</p>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
                            <table class="data inputArea">
                                <tr>
                                    <th>
                                        グループ <n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:select
                                                name="W11AC02.ugroupSystemAccount.ugroupId"
                                                listName="allGroup"
                                                elementLabelProperty="ugroupName"
                                                elementValueProperty="ugroupId" cssClass="longSelectBox"/>
                                        <n:error
                                                name="W11AC02.ugroupSystemAccount.ugroupId"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <span class="leftSpace">認可単位</span>
                                    </th>
                                    <td>
                                        <n:select name="W11AC02.systemAccount.permissionUnit"
                                                multiple="true" size="4"
                                                listName="allPermissionUnit"
                                                elementLabelProperty="permissionUnitName"
                                                elementValueProperty="permissionUnitId" cssClass="longSelectBox"/>
                                        <n:forConfirmationPage>
                                            <n:set var="permissionUnit"
                                                   name="W11AC02.systemAccount.permissionUnit" bySingleValue="false" />
                                            <c:if test="${empty permissionUnit}">
                                                -
                                            </c:if>
                                        </n:forConfirmationPage>
                                        <n:error name="W11AC02.systemAccount.permissionUnit"/>
                                    </td>
                                </tr>
                            </table>
                            <table class="btnTbl" >         
                                <tr>
                                    <n:forInputPage> 
                                        <td align="left">
                                        <n:set var="searchCondition" name="11AC_W11AC01.loginId"/>
                                        <n:set var="searchRequestId" value="RW11AC0101"/>
                                        <c:if test="${searchCondition != null}">
                                            <n:set var="searchRequestId" value="RW11AC0102"/>
                                        </c:if>
                                        <n:submit cssClass="buttons"
                                                  type="button" name="search" value="一覧照会画面へ"
                                                  uri="/action/ss11AC/W11AC01Action/${searchRequestId}"/>
                                        </td>
                                        <td align="right">                                      
                                            <n:submit cssClass="buttons"
                                                      type="button" name="confirm" value="確認"
                                                      uri="/action/ss11AC/W11AC02Action/RW11AC0202"/> 
                                        </td>
                                    </n:forInputPage>
                                    <n:forConfirmationPage> 
                                        <td align="left">
                                        <n:submit cssClass="buttons"
                                                  type="button" name="back" value="登録画面へ"
                                                  uri="/action/ss11AC/W11AC02Action/RW11AC0203"/>
                                        </td>
                                        <td align="right">                                      
                                            <n:submit
                                                cssClass="buttons" type="button"
                                                name="register" value="確定"
                                                uri="/action/ss11AC/W11AC02Action/RW11AC0204"
                                                allowDoubleSubmission="false"/>
                                        </td>
                                    </n:forConfirmationPage>
                                </tr>
                             </table>   
                        </td>
                    </tr>
                </table>
            </n:form>
        </div>
    </div>
    <div id="footer">
        <n:form>
            <ul class="footerList">
                <li><n:submitLink name="top"
                        uri="/action/ss11AB/W11AB01Action/RW11AB0101">トップメニュー</n:submitLink></li>
                <li><n:submitLink name="user"
                        uri="/action/ss11AC/W11AC01Action/RW11AC0101">ユーザ情報一覧照会</n:submitLink></li>
                <li><n:submitLink name="register"
                        uri="/action/ss11AC/W11AC02Action/RW11AC0201">ユーザ情報登録</n:submitLink></li>
            </ul>
        </n:form>
    </div>
</div>
</body>
</html>
