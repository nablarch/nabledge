package nablarch.sample.ss11AC;

import nablarch.common.web.token.OnDoubleSubmission;
import nablarch.core.db.statement.SqlPStatement;
import nablarch.core.db.statement.SqlResultSet;
import nablarch.core.db.support.DbAccessSupport;
import nablarch.core.message.ApplicationException;
import nablarch.core.message.MessageLevel;
import nablarch.core.message.MessageUtil;
import nablarch.core.validation.ValidationContext;
import nablarch.core.validation.ValidationUtil;
import nablarch.fw.ExecutionContext;
import nablarch.fw.web.HttpRequest;
import nablarch.fw.web.HttpResponse;
import nablarch.fw.web.interceptor.OnError;

import nablarch.sample.ss11.entity.SystemAccountEntity;
import nablarch.sample.ss11.entity.UgroupSystemAccountEntity;
import nablarch.sample.ss11.entity.UsersEntity;

/**
 * ユーザー登録機能のアクションクラス。
 * 
 * @author Tsuyoshi Kawasaki
 * @since 1.0
 */
public class W11AC02Action extends DbAccessSupport {

    /**
     * ユーザ情報登録画面を表示する。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {

        // 表示に必要なグループの情報、認可単位の情報をリクエストスコープに格納
        setUpViewData(ctx);

        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }

    /**
     * ユーザ情報登録画面の「確認」イベントの処理を行う。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
    public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {

        // 精査
        validate(req);

        // 表示に必要なグループの情報、認可単位の情報をリクエストスコープに格納
        setUpViewData(ctx);

        return new HttpResponse("/ss11AC/W11AC0202.jsp");
    }

    /**
     * ユーザ情報登録確認画面の「登録画面へ」イベントの処理を行う。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
    public HttpResponse doRW11AC0203(HttpRequest req, ExecutionContext ctx) {

        // 精査
        validate(req);

        // 表示に必要なグループの情報、認可単位の情報をリクエストスコープに格納
        setUpViewData(ctx);

        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }

    /**
     * ユーザ情報登録確認画面の「確定」イベントの処理を行う。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
    @OnDoubleSubmission(path = "forward://RW11AC0201")
    public HttpResponse doRW11AC0204(HttpRequest req, ExecutionContext ctx) {

        // 精査とエンティティ生成
        W11AC02Form form = validate(req);

        // エンティティ取得
        SystemAccountEntity systemAccount = form.getSystemAccount();
        UsersEntity users = form.getUsers();
        UgroupSystemAccountEntity ugroupSystemAccount = form.getUgroupSystemAccount();

        // 登録実行
        CM311AC1Component component = new CM311AC1Component();
        component.registerUser(systemAccount, form.getNewPassword(), users, ugroupSystemAccount);

        // 引き継ぎ項目を格納
        W11AC01SearchForm successionForm = new W11AC01SearchForm();
        successionForm.setSystemAccount(systemAccount);
        ctx.setRequestScopedVar("11AC_W11AC01", successionForm);

        return new HttpResponse("/ss11AC/W11AC0203.jsp");
    }

    /**
     * 表示に必要なグループの情報、認可単位の情報をリクエストスコープに格納する。
     * 
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     */
    private void setUpViewData(ExecutionContext ctx) {

        // 表示に必要なグループの情報、認可単位の情報を取得
        CM311AC1Component function = new CM311AC1Component();
        SqlResultSet groupInfo = function.getUserGroups();
        SqlResultSet permissionUnitInfo = function.getAllPermissionUnit();

        // 結果をリクエストスコープに格納
        ctx.setRequestScopedVar("allGroup", groupInfo);
        ctx.setRequestScopedVar("allPermissionUnit", permissionUnitInfo);
    }

    /**
     * 入力データの精査と生成を行う。<br>
     * <br>
     * 精査エラーの場合はApplicationExceptionを送出する。
     * 
     * @param req リクエスト
     * @return 精査済みの入力データから生成したフォーム
     */
    private W11AC02Form validate(HttpRequest req) {

        // 精査
        ValidationContext<W11AC02Form> context = 
            ValidationUtil.validateAndConvertRequest("W11AC02",
                    W11AC02Form.class, req, "registerUser");
        if (!context.isValid()) {
            throw new ApplicationException(context.getMessages());
        }

        // 生成
        W11AC02Form form = context.createObject();
        SystemAccountEntity systemAccount = form.getSystemAccount();
        CM311AC1Component function = new CM311AC1Component();

        // ログインIDのチェック
        checkLoginId(systemAccount.getLoginId());

        // グループIDのチェック
        if (!function.existGroupId(form.getUgroupSystemAccount())) {
            throw new ApplicationException(
                    MessageUtil.createMessage(MessageLevel.ERROR, "MSG00002",
                            MessageUtil.getStringResource("S0020001")));
        }

        // 認可単位IDのチェック
        if (systemAccount.getPermissionUnit() != null 
                && !function.existPermissionUnitId(systemAccount)) {
            throw new ApplicationException(
                    MessageUtil.createMessage(MessageLevel.ERROR,
                            "MSG00002", MessageUtil.getStringResource(
                            "S0030001")));
        }

        return form;
    }

    /**
     * ログインIDが既に登録されていないかチェックする。
     *
     * @param loginId チェック対象のログインID
     */
    private void checkLoginId(String loginId) {
        SqlPStatement statement = getSqlPStatement("SELECT_SYSTEM_ACCOUNT");
        statement.setString(1, loginId);

        if (!statement.retrieve().isEmpty()) {
            throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
        }
    }


}
