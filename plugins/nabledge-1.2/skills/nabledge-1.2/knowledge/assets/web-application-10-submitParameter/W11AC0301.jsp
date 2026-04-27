<?xml version="1.0" encoding="UTF-8" ?>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <n:noCache />

    <n:forInputPage><n:set var="title" value="ユーザ情報更新" /></n:forInputPage>
    <n:forConfirmationPage><n:set var="title" value="ユーザ情報更新確認" /></n:forConfirmationPage>
    <jsp:include page="/html_header.jsp">
        <jsp:param name="title" value="${title}" />
    </jsp:include>
</head>

<body>
<div id="wrapper">
    <jsp:include page="/app_header.jsp">
        <jsp:param name="title" value="${title}" />
    </jsp:include>

    <div id="mainContents">
    <jsp:include page="/app_error.jsp" />
        <div id="mainContentsInner">
            <n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
                <table class="zero" width="710">
                    <tr>
                        <td>
                            <table class="subtitleWithAttention">
                                <tr>
                                    <td>
                                        <p class="areaTitle">ユーザ基本情報</p>
                                    </td>
                                    <td>
                                        <n:forInputPage><p class="attention">*は必ず入力してください</p></n:forInputPage>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
                            <table class="data inputArea" width="100%">
                                <tr>
                                    <th>
                                        ログインID
                                    </th>
                                    <td>
                                        <n:set var="loginId" name="W11AC03.systemAccount.loginId"/>
                                        <n:write name="loginId" />
                                        <n:hidden name="W11AC03.systemAccount.loginId" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        漢字氏名<n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
                                        <n:forInputPage>(全角50文字以内)</n:forInputPage>
                                        <n:error name="W11AC03.users.kanjiName"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        カナ氏名<n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC03.users.kanaName" size="52" maxlength="50" />
                                        <n:forInputPage>(全角カナ50文字以内)</n:forInputPage>
                                        <n:error name="W11AC03.users.kanaName" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        メールアドレス<n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:text name="W11AC03.users.mailAddress" size="52" maxlength="50" />
                                        <n:forInputPage>(半角英数記号100文字以内)</n:forInputPage>
                                        <n:error name="W11AC03.users.mailAddress" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        内線番号<n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                       <n:text name="W11AC03.users.extensionNumberBuilding" size="4" maxlength="2" /> -
                                       <n:text name="W11AC03.users.extensionNumberPersonal" size="6" maxlength="4" />
                                          <n:forInputPage>
                                              <br/>(半角数字2文字以内 - 半角数字4文字以内)
                                          </n:forInputPage>
                                       <n:error name="W11AC03.users.extensionNumberBuilding" />
                                       <n:error name="W11AC03.users.extensionNumberPersonal" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        携帯電話番号
                                    </th>
                                    <td>
                                        <n:forInputPage>
                                            <n:text name="W11AC03.users.mobilePhoneNumberAreaCode" size="5" maxlength="3" /> -
                                            <n:text name="W11AC03.users.mobilePhoneNumberCityCode" size="6" maxlength="4" /> -
                                            <n:text name="W11AC03.users.mobilePhoneNumberSbscrCode" size="6" maxlength="4" />
                                            <n:forInputPage>
                                                <br/>(半角数字3文字以内 - 半角数字4文字以内 - 半角数字4文字以内)
                                                <br/>(「全項目入力」または「全項目未入力」のいずれか)
                                            </n:forInputPage>
                                            <n:error name="W11AC03.users.mobilePhoneNumberAreaCode" />
                                            <n:error name="W11AC03.users.mobilePhoneNumberCityCode" />
                                            <n:error name="W11AC03.users.mobilePhoneNumberSbscrCode" />
                                        </n:forInputPage>
                                        <n:forConfirmationPage>
                                            <n:set var="areaCode" name="W11AC03.users.mobilePhoneNumberAreaCode"/>
                                            <n:set var="cityCode" name="W11AC03.users.mobilePhoneNumberCityCode"/>
                                            <n:set var="sbscrCode" name="W11AC03.users.mobilePhoneNumberSbscrCode"/>
                                            <c:choose>
                                                <c:when test="${empty areaCode or empty cityCode or empty sbscrCode}" >
                                                    -
                                                </c:when>
                                                <c:otherwise>                                                    
                                                    <n:text name="areaCode" /> -
                                                    <n:text name="cityCode" /> -
                                                    <n:text name="sbscrCode" />
                                                </c:otherwise>
                                            </c:choose>
                                        </n:forConfirmationPage>
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
                            <table class="data inputArea" width="100%">
                                <tr>
                                    <th>
                                        グループ<n:forInputPage><span class="essential">*</span></n:forInputPage>
                                    </th>
                                    <td>
                                        <n:select name="W11AC03.ugroupSystemAccount.ugroupId"
                                              listName="ugroupList"  
                                              elementValueProperty="ugroupId" 
                                              elementLabelProperty="ugroupName" 
                                              cssClass="longSelectBox" />
                                        <n:error name="W11AC03.ugroupSystemAccount.ugroupId" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        認可単位
                                    </th>
                                    <td>
                                        <n:forInputPage>
                                            <n:select name="W11AC03.systemAccount.permissionUnit"
                                                     multiple="true" size="5" 
                                                     listName="permissionUnitList"
                                                     elementValueProperty="permissionUnitId" 
                                                     elementLabelProperty="permissionUnitName"
                                                     cssClass="longSelectBox" />
                                            <n:error name="W11AC03.systemAccount.permissionUnit" />
                                        </n:forInputPage>
                                        <n:forConfirmationPage>
                                            <c:choose>
                                                <c:when test="${permissionUnitEmptyFlg == 'EMPTY'}">
                                                    -
                                                </c:when>
                                                <c:otherwise>
                                                        <n:select name="W11AC03.systemAccount.permissionUnit" 
                                                            listName="permissionUnitList"
                                                            elementValueProperty="permissionUnitId" 
                                                            elementLabelProperty="permissionUnitName"
                                                            cssClass="longSelectBox" />
                                                </c:otherwise>
                                            </c:choose>
                                        </n:forConfirmationPage>
                                    </td>
                                </tr>
                            </table>
                            <table class="btnTbl" >
                                <tr>
                                <n:forInputPage>
                                    <td align="left">
                                        <n:submit cssClass="buttons" 
                                                  type="button" name="search" value="一覧照会画面へ" 
                                                  uri="/action/ss11AC/W11AC01Action/RW11AC0102" />
                                        <n:submit cssClass="buttons" 
                                                  type="button" name="showDetail" value="詳細画面へ" 
                                                  uri="/action/ss11AC/W11AC01Action/RW11AC0103" />
                                    </td>
                                    <td align="right">
                                        <n:submit cssClass="buttons" 
                                                  type="button" name="update" value="確認" 
                                                  uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
                                    </td>
                                </n:forInputPage>
                                <n:forConfirmationPage>
                                    <td align="left">
                                        <n:submit cssClass="buttons" 
                                                  type="button" name="return" value="更新画面へ" 
                                                  uri="/action/ss11AC/W11AC03Action/RW11AC0303" />                                        
                                    </td>
                                    <td align="right">
                                        <n:submit cssClass="buttons" 
                                                  type="button" name="confirm" value="確定" 
                                                  uri="/action/ss11AC/W11AC03Action/RW11AC0304" 
                                                  allowDoubleSubmission="false" />
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
                <li><n:submitLink name="top" uri="/action/ss11AB/W11AB01Action/RW11AB0101">トップメニュー</n:submitLink></li>
                <li><n:submitLink name="user" uri="/action/ss11AC/W11AC01Action/RW11AC0101">ユーザ情報一覧照会</n:submitLink></li>
                <li><n:submitLink name="register" uri="/action/ss11AC/W11AC02Action/RW11AC0201">ユーザ情報登録</n:submitLink></li>
            </ul>
        </n:form>
    </div>
</div>
</body>
</html>
