package nablarch.sample.ss11AC;

import java.util.HashMap;
import java.util.Map;

import nablarch.common.code.CodeUtil;
import nablarch.common.web.download.DataRecordResponse;
import nablarch.core.db.statement.SqlResultSet;
import nablarch.core.db.statement.SqlRow;
import nablarch.core.db.support.DbAccessSupport;
import nablarch.core.db.support.TooManyResultException;
import nablarch.core.message.ApplicationException;
import nablarch.core.message.MessageLevel;
import nablarch.core.message.MessageUtil;
import nablarch.core.validation.ValidationContext;
import nablarch.core.validation.ValidationUtil;
import nablarch.fw.ExecutionContext;
import nablarch.fw.web.HttpRequest;
import nablarch.fw.web.HttpResponse;
import nablarch.fw.web.interceptor.OnError;

/**
 * ユーザ検索機能のアクションクラス
 * @author Miki Habu
 * @since 1.0
 */
public class W11AC01Action extends DbAccessSupport {
    /**
     * ユーザ一覧照会画面を表示する。<br/>
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx) {
        CM311AC1Component function = new CM311AC1Component();
        SqlResultSet ugroupList = function.getUserGroups();
        ctx.setRequestScopedVar("ugroupList", ugroupList);
        return new HttpResponse("/ss11AC/W11AC0101.jsp");
    }

    /**
     * ユーザ一覧照会結果を表示する。<br/>
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class,
             path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {

        CM311AC1Component function = new CM311AC1Component();
        SqlResultSet ugroupList = function.getUserGroups();
        ctx.setRequestScopedVar("ugroupList", ugroupList);   // 部署一覧

        // 検索条件入力チェック
        ValidationContext<W11AC01SearchForm> searchConditionCtx =
            ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
        if (!searchConditionCtx.isValid()) {
            throw new ApplicationException(searchConditionCtx.getMessages());
        }
        
        // 検索条件はページングの画面表示で使用する
        W11AC01SearchForm condition = searchConditionCtx.createObject();
        ctx.setRequestScopedVar("11AC_W11AC01", condition);

        // 検索実行
        SqlResultSet searchResult;
        try {
            searchResult = selectByCondition(condition);
        } catch (TooManyResultException e) {
            throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00035", e.getMaxResultCount()));
        }

        // 検索結果をリクエストスコープに設定
        ctx.setRequestScopedVar("searchResult", searchResult);
        ctx.setRequestScopedVar("resultCount", condition.getResultCount());

        
        W11AC05Form form = new W11AC05Form();
        form.setSystemAccountEntityArraySize(searchResult.size());
        
        ctx.setRequestScopedVar("W11AC05", form);

        
        // ユーザIDロックのコード名称を取得、リクエストスコープに設定
        //（コード管理機能の使用例、実用上はActionでの取得処理は行わずJSPで<n:code>タグを使用すること）
        String[] userIdLockedNames = new String[searchResult.size()];
        for (int i = 0; i < searchResult.size(); i++) {
            userIdLockedNames[i] = CodeUtil.getOptionalName("C0000001", searchResult.get(i).getString("userIdLocked"), "OPTION01");
        }
        ctx.setRequestScopedVar("userIdLockedNameArray", userIdLockedNames);

        return new HttpResponse("/ss11AC/W11AC0101.jsp");
    }
    
    /**
     * ユーザ情報詳細を表示する。<br/>
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class,
            path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
    public HttpResponse doRW11AC0103(HttpRequest req, ExecutionContext ctx) {
        
        // 引継いだユーザIDの取得
        ValidationContext<W11AC01SearchForm> formCtx = 
            ValidationUtil.validateAndConvertRequest("11AC_W11AC01", 
                    W11AC01SearchForm.class, req, "selectUserInfo");
        if (!formCtx.isValid()) {
            // 精査エラー時の処理（hidden暗号化をしているので、本エラーは生じない）
            throw new ApplicationException(formCtx.getMessages());
        }
        String userId = formCtx.createObject().getSystemAccount().getUserId();
        
        // 検索実行
        CM311AC1Component function = new CM311AC1Component();
        SqlResultSet sysAcctInfo = function.selectSystemAccount(userId);
        SqlResultSet usersInfo = function.selectUsers(userId);
        SqlResultSet permissionUnitInfo = function.selectPermissionUnit(userId);
        SqlResultSet ugroupInfo = function.selectUgroup(userId);
        
        // 対象ユーザの詳細情報が取得できなければエラー（認可単位の割り当ては必須ではない）
        if (sysAcctInfo.isEmpty() || usersInfo.isEmpty() 
                || ugroupInfo.isEmpty()) {
            throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00029"));
        }
        
        // 検索結果をリクエストスコープに設定。認可単位は1ユーザに0～複数紐づく。
        ctx.setRequestScopedVar("sysAcctInfo", sysAcctInfo.get(0));
        ctx.setRequestScopedVar("usersInfo", usersInfo.get(0));
        ctx.setRequestScopedVar("ugroupInfo", ugroupInfo.get(0));
        ctx.setRequestScopedVar("permissionUnitInfo", permissionUnitInfo);
        
        return new HttpResponse("/ss11AC/W11AC0102.jsp");
    }

    /**
     * ユーザ一覧照会結果をダウンロードする。<br/>
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class,
             path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0104(HttpRequest req, ExecutionContext ctx) {

        CM311AC1Component function = new CM311AC1Component();
        SqlResultSet ugroupList = function.getUserGroups();
        ctx.setRequestScopedVar("ugroupList", ugroupList);   // 部署一覧

        // 検索条件入力チェック
        ValidationContext<W11AC01SearchForm> searchConditionCtx =
            ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
        if (!searchConditionCtx.isValid()) {
            throw new ApplicationException(searchConditionCtx.getMessages());
        }
        W11AC01SearchForm condition = searchConditionCtx.createObject();

        // 検索実行
        SqlResultSet searchResult;
        try {
            searchResult = selectByCondition(condition);
        } catch (TooManyResultException e) {
            throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00035", e.getMaxResultCount()));
        }

        // ダウンロード
        DataRecordResponse response = new DataRecordResponse("format", "N11AC001");
        response.setContentType("text/csv; charset=Shift_JIS");
        response.setContentDisposition("N11AC001.csv");

        // ヘッダ
        Map<String, String> header = new HashMap<String, String>();
        response.write("header", header); // デフォルトのヘッダー情報を使用するため空マップを指定する。

        // データ
        for (SqlRow record : searchResult) {

            // データの加工
            String group = String.format("%s:%s",
                                         record.getString("ugroupId"),
                                         record.getString("ugroupName"));
            String extensionNumber = String.format("%s - %s",
                                                   record.getString("extensionNumberBuilding"),
                                                   record.getString("extensionNumberPersonal"));
            String userIdLockedName = CodeUtil.getOptionalName("C0000001",
                                                               record.getString("userIdLocked"),
                                                               "OPTION01");
            record.put("extensionNumber", extensionNumber);
            record.put("group", group);
            record.put("userIdLockedName", userIdLockedName);

            // データの書き込み
            response.write("data", record);
        }

        return response;
    }

    /**
     * 条件検索を行う。<br/>
     * 引数で検索条件を指定することにより条件検索ができる。<br/>
     * 検索条件をしない場合は、引数にnullまたは空文字を渡すようにする。<br/>
     * これにより、その引数に関する検索条件を外すことができる。<br/>
     *
     * @param condition 検索条件
     * @return 検索結果
     */
    private SqlResultSet selectByCondition(W11AC01SearchForm condition) {
        return search("SELECT_USER_BY_CONDITION", condition);
    }    
}
