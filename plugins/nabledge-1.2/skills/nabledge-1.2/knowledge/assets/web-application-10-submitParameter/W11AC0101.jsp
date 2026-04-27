<?xml version="1.0" encoding="UTF-8" ?>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <n:noCache />

    <n:set var="title" value="ユーザ情報一覧照会" />
    <jsp:include page="/html_header.jsp">
        <jsp:param name="title" value="${title}" />
    </jsp:include>
    
    <style type="text/css">
        div.search {
            width: 550px;
            margin:auto;
        }
        
        div.placeButton {
            padding-top: 0.4em;
            text-align:right;
        }
        
        div.nablarch_listSearchResultWrapper {
            width: 800px;
            margin:auto;
        }
        
        div.nablarch_resultCount {
            text-align: left;
            font-weight: bold;
        }
        
        div.nablarch_paging {
            text-align: right;
            font-weight: bold;
        }
        
        div.hrArea {
            margin-top: 1.5em;
            margin-bottom: 1.5em;
        }
        
        select.selectGroup {
            width: 20em;
        }
        
        div.resultArea {
            width: 800px;
            margin: auto;
        }
        
        table.resultList {
            width: 800px;
            table-layout: fixed;
            word-wrap: break-word;
            border: double 2px #000000;
            font-size: 10px;
            margin-bottom: 7.8px;
            clear: both;
        }
        
        .resultList th {
            border: double 2px #000000;
            background-color:#ffff99;
            padding:3.9px 12px;
            text-align:left;
            font-weight: bold;
        }
        
        .resultList td {
            border: double 2px #000000;
            padding:3px 10px;
            text-align:left;
        }
        
        .select {
            width : 22px;
        }
        
        .loginId {
            width : 70px;
        }
        
        .kanjiName {
            width : 70px;
        }
        
        .kanaName {
            width : 70px;
        }
        
        .group {
            width : 71px;
        }
        
        .extendedNumber {
            width : 60px;
        }
        
        .mailAddress {
            width : 70px;
        }
        
        .userIdLocked {
            width : 50px;
        }
        
        .link {
            width : 28px;
        }

        table.conditionArea th {
            width:300px;
        }

        table.conditionArea td {
            width:400px;
        }
        
        .nablarch_resultCount {
           float: left;
        }
        
        .nablarch_paging {
            float: right;
        }
        
        .nablarch_paging div {
        float: left;
        padding: 0 0.3em 0.3em 0;
        }
        
    </style>
    
    
</head>

<body>

<div id="wrapper">
<jsp:include page="/app_header.jsp">
    <jsp:param name="title" value="${title}" />
</jsp:include>

<div id="mainContents">
<jsp:include page="/app_error.jsp" />
<div id="mainContentsInner" >
<n:form>
    <div class="search">
        <table class="data conditionArea" width="100%">
            <tr>
                <th>ログインID</th>
                <td>
                    <n:text name="11AC_W11AC01.loginId" size="25" maxlength="20" />
                    <n:error name="11AC_W11AC01.loginId"/>
                </td>
            </tr>
            <tr>
                <th>漢字氏名</th>
                <td>
                    <n:text name="11AC_W11AC01.kanjiName" size="25" maxlength="20" />
                    <n:error name="11AC_W11AC01.kanjiName"/>
                </td>
            </tr>
            <tr>
                <th>カナ氏名</th>
                <td>
                    <n:text name="11AC_W11AC01.kanaName" size="25" maxlength="20" />
                    <n:error name="11AC_W11AC01.kanaName"/>
                </td>
            </tr>
            <tr>
                <th>グループ</th>
                <td>
                    <n:select name="11AC_W11AC01.ugroupId" cssClass="selectGroup"
                              listName="ugroupList" elementLabelProperty="ugroupName" elementValueProperty="ugroupId"
                              withNoneOption="true" />
                    <n:error name="11AC_W11AC01.ugroupId"/>
                </td>
            </tr>
            <tr>
                <th>ユーザIDロック</th>
                <td>
                    <n:codeSelect name="11AC_W11AC01.userIdLocked" 
                                  codeId="C0000001" pattern="PATTERN01" optionColumnName="OPTION01" labelPattern="$OPTIONALNAME$" 
                                  cssClass="selectUserIdLocked" withNoneOption="true"/>
                    <n:error name="11AC_W11AC01.userIdLocked"/>
                </td>
            </tr>
        </table>
        <div id="buttons" class="placeButton">
            <n:submit cssClass="cbuttons" type="submit" uri="/action/ss11AC/W11AC01Action/RW11AC0102" name="search" value="検索">
                <n:param paramName="11AC_W11AC01.pageNumber" value="1"/>
                <n:param paramName="11AC_W11AC01.sortId" value="1"/>
            </n:submit>
        </div>
    </div>
    <div class="hrArea">
    <hr />
    </div>

    <%-- 削除データ用カウント --%>
    <n:hidden name="W11AC05.systemAccountEntityArraySize" />
    <div class="resultArea">
    <n:listSearchResult listSearchInfoName="11AC_W11AC01"
                        searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                        resultSetName="searchResult"
                        resultSetCss="resultList" >
                   
        <jsp:attribute name="headerRowFragment">
            <tr>
                <th class="select">選択</th>
                <th class="loginId">
                    <n:listSearchSortSubmit ascSortId="1" descSortId="2"
                                            label="ログインID" uri="/action/ss11AC/W11AC01Action/RW11AC0102" 
                                            name="loginIdSort" listSearchInfoName="11AC_W11AC01" />
                </th>
                <th class="kanjiName">
                    <n:listSearchSortSubmit ascSortId="3" descSortId="4"
                                            label="漢字氏名" uri="/action/ss11AC/W11AC01Action/RW11AC0102" 
                                            name="kanjiNameSort" listSearchInfoName="11AC_W11AC01" />
                </th>
                <th class="kanaName">
                    <n:listSearchSortSubmit ascSortId="5" descSortId="6"
                                            label="カナ氏名" uri="/action/ss11AC/W11AC01Action/RW11AC0102" 
                                            name="kanaNameSort" listSearchInfoName="11AC_W11AC01" />
                </th>
                <th class="group">グループ</th>
                <th class="extendedNumber">内線番号</th>
                <th class="mailAddress">メールアドレス</th>
                <th class="userIdLocked">ユーザIDロック</th>
                <th class="link">更新</th>
                <th class="link">削除</th>
            </tr>
        </jsp:attribute>
        
        <jsp:attribute name="bodyRowFragment">
            <tr>
                <td><n:checkbox name="W11AC05.systemAccountEntityArray[${count-1}].userId" value="${row.userId}" offValue="0000000000"/></td>
                <td><n:submitLink uri="/action/ss11AC/W11AC01Action/RW11AC0103" name="showDetail_${count}">
                                <n:write name="row.loginId" />
                                <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId" />
                                <n:param paramName="11AC_W11AC01.loginId" name="11AC_W11AC01.loginId" />
                                <n:param paramName="11AC_W11AC01.kanjiName" name="11AC_W11AC01.kanjiName" />
                                <n:param paramName="11AC_W11AC01.kanaName" name="11AC_W11AC01.kanaName" />
                                <n:param paramName="11AC_W11AC01.ugroupId" name="11AC_W11AC01.ugroupId" />
                                <n:param paramName="11AC_W11AC01.userIdLocked" name="11AC_W11AC01.userIdLocked" />
                                <n:param paramName="11AC_W11AC01.pageNumber" name="11AC_W11AC01.pageNumber" />
                                <n:param paramName="11AC_W11AC01.sortId" name="11AC_W11AC01.sortId" />
                            </n:submitLink></td>
                <td><n:write name="row.kanjiName" /></td>
                <td><n:write name="row.kanaName" /></td>
                <td><n:write name="row.ugroupId" />:<n:write name="row.ugroupName" /></td>
                <td><n:write name="row.extensionNumberBuilding" />&nbsp;-&nbsp;<n:write name="row.extensionNumberPersonal" /></td>
                <td><n:write name="row.mailAddress" /></td>
                <td>
                    <n:write name="userIdLockedNameArray[${count-1}]" />
                </td>
                <td><n:submitLink uri="/action/ss11AC/W11AC03Action/RW11AC0301" name="showUpdate_${count}">
                                更新
                                <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId" />
                                <n:param paramName="11AC_W11AC01.loginId" name="11AC_W11AC01.loginId" />
                                <n:param paramName="11AC_W11AC01.kanjiName" name="11AC_W11AC01.kanjiName" />
                                <n:param paramName="11AC_W11AC01.kanaName" name="11AC_W11AC01.kanaName" />
                                <n:param paramName="11AC_W11AC01.ugroupId" name="11AC_W11AC01.ugroupId" />
                                <n:param paramName="11AC_W11AC01.userIdLocked" name="11AC_W11AC01.userIdLocked" />
                                <n:param paramName="11AC_W11AC01.pageNumber" name="11AC_W11AC01.pageNumber" />
                                <n:param paramName="11AC_W11AC01.sortId" name="11AC_W11AC01.sortId" />
                                <n:param paramName="W11AC03.systemAccount.userId" name="row.userId" />
                            </n:submitLink></td>
                <td class="link"><n:submitLink uri="/action/ss11AC/W11AC04Action/RW11AC0401" name="showDelete_${count}">
                                削除
                                <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId" />
                                <n:param paramName="11AC_W11AC01.loginId" name="11AC_W11AC01.loginId" />
                                <n:param paramName="11AC_W11AC01.kanjiName" name="11AC_W11AC01.kanjiName" />
                                <n:param paramName="11AC_W11AC01.kanaName" name="11AC_W11AC01.kanaName" />
                                <n:param paramName="11AC_W11AC01.ugroupId" name="11AC_W11AC01.ugroupId" />
                                <n:param paramName="11AC_W11AC01.userIdLocked" name="11AC_W11AC01.userIdLocked" />
                                <n:param paramName="11AC_W11AC01.pageNumber" name="11AC_W11AC01.pageNumber" />
                                <n:param paramName="11AC_W11AC01.sortId" name="11AC_W11AC01.sortId" />
                                <n:param paramName="W11AC04.systemAccount.userId" name="row.userId" />
                            </n:submitLink></td>
            </tr>
        </jsp:attribute>
    </n:listSearchResult>
    <c:if test="${not empty resultCount}">
        <table class="btnTbl" >
            <tr>
                <c:if test="${resultCount != 0}">
                 <td align="left">
                     <n:submit cssClass="mainBtn" type="button" name="back" value="一括削除確認画面へ" uri="/action/ss11AC/W11AC05Action/RW11AC0501">
                       <n:param paramName="11AC_W11AC01.loginId" name="11AC_W11AC01.loginId" />
                       <n:param paramName="11AC_W11AC01.kanjiName" name="11AC_W11AC01.kanjiName" />
                       <n:param paramName="11AC_W11AC01.kanaName" name="11AC_W11AC01.kanaName" />
                       <n:param paramName="11AC_W11AC01.ugroupId" name="11AC_W11AC01.ugroupId" />
                       <n:param paramName="11AC_W11AC01.userIdLocked" name="11AC_W11AC01.userIdLocked" />
                       <n:param paramName="11AC_W11AC01.pageNumber" name="11AC_W11AC01.pageNumber" />
                       <n:param paramName="11AC_W11AC01.sortId" name="11AC_W11AC01.sortId" />
                     </n:submit>
                 </td>
                </c:if>
                <td align="right">
                    <c:if test="${resultCount != 0}">
                    <n:downloadSubmit cssClass="mainBtn" type="button" name="download" value="CSVダウンロード" uri="/action/ss11AC/W11AC01Action/RW11AC0104">
                       <n:param paramName="11AC_W11AC01.loginId" name="11AC_W11AC01.loginId" />
                       <n:param paramName="11AC_W11AC01.kanjiName" name="11AC_W11AC01.kanjiName" />
                       <n:param paramName="11AC_W11AC01.kanaName" name="11AC_W11AC01.kanaName" />
                       <n:param paramName="11AC_W11AC01.ugroupId" name="11AC_W11AC01.ugroupId" />
                       <n:param paramName="11AC_W11AC01.userIdLocked" name="11AC_W11AC01.userIdLocked" />
                       <n:param paramName="11AC_W11AC01.pageNumber" name="11AC_W11AC01.pageNumber" />
                       <n:param paramName="11AC_W11AC01.sortId" name="11AC_W11AC01.sortId" />
                    </n:downloadSubmit>
                    </c:if>
                    <n:submit cssClass="mainBtn" type="button" name="register" value="登録画面へ" uri="/action/ss11AC/W11AC02Action/RW11AC0201">
                       <n:param paramName="11AC_W11AC01.loginId" name="11AC_W11AC01.loginId" />
                       <n:param paramName="11AC_W11AC01.kanjiName" name="11AC_W11AC01.kanjiName" />
                       <n:param paramName="11AC_W11AC01.kanaName" name="11AC_W11AC01.kanaName" />
                       <n:param paramName="11AC_W11AC01.ugroupId" name="11AC_W11AC01.ugroupId" />
                       <n:param paramName="11AC_W11AC01.userIdLocked" name="11AC_W11AC01.userIdLocked" />
                       <n:param paramName="11AC_W11AC01.pageNumber" name="11AC_W11AC01.pageNumber" />
                       <n:param paramName="11AC_W11AC01.sortId" name="11AC_W11AC01.sortId" />
                    </n:submit>
                </td>
            </tr>
        </table>
    </c:if>
    </div>
</n:form>
</div><%-- mainContentsInner --%>
</div><%-- mainContents --%>
<div id="footer">
    <n:form>
    <ul class="footerList">
        <li><n:submitLink name="top" uri="/action/ss11AB/W11AB01Action/RW11AB0101">トップメニュー</n:submitLink></li>
        <li><n:submitLink name="searchTop" uri="/action/ss11AC/W11AC01Action/RW11AC0101">ユーザ情報一覧照会</n:submitLink></li>
        <li><n:submitLink name="registerTop" uri="/action/ss11AC/W11AC02Action/RW11AC0201">ユーザ情報登録</n:submitLink></li>
    </ul>
    </n:form>
</div>
</div><%-- wrapper --%>
</body>
</html>
