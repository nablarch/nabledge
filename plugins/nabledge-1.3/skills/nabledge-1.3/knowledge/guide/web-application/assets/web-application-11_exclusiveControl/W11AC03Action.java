package nablarch.sample.ss11AC;

import java.util.ArrayList;
import java.util.List;

import nablarch.common.exclusivecontrol.OptimisticLockException;
import nablarch.common.web.exclusivecontrol.HttpExclusiveControlUtil;
import nablarch.common.web.token.OnDoubleSubmission;
import nablarch.core.db.statement.ParameterizedSqlPStatement;
import nablarch.core.db.statement.SqlResultSet;
import nablarch.core.db.support.DbAccessSupport;
import nablarch.core.message.ApplicationException;
import nablarch.core.message.Message;
import nablarch.core.message.MessageLevel;
import nablarch.core.message.MessageUtil;
import nablarch.core.util.StringUtil;
import nablarch.core.validation.ValidationContext;
import nablarch.core.validation.ValidationUtil;
import nablarch.fw.ExecutionContext;
import nablarch.fw.web.HttpRequest;
import nablarch.fw.web.HttpResponse;
import nablarch.fw.web.interceptor.OnError;
import nablarch.fw.web.interceptor.OnErrors;
import nablarch.sample.exclusive.ExclusiveCtrlSystemAccountContext;
import nablarch.sample.ss11.entity.SystemAccountEntity;
import nablarch.sample.ss11.entity.UgroupSystemAccountEntity;
import nablarch.sample.ss11.entity.UsersEntity;

/**
 * ユーザ更新機能のアクションクラス。
 * 
 * @author Ryo Asato
 * @since 1.0
 */
public class W11AC03Action extends DbAccessSupport {

    /** 認可単位選択有無フラグ：選択していない場合に設定 */
    private static final String EMPTY = "EMPTY";

    /** 認可単位選択有無フラグ：選択している場合に設定 */
    private static final String NOT_EMPTY = "NOT_EMPTY";

    /**
     * ユーザ情報更新画面を表示する。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = ApplicationException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
    public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
        
        // 引継いだユーザIDの取得
        ValidationContext<W11AC03Form> userSearchFormContext =
            ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
        if (!userSearchFormContext.isValid()) {
            // hidden暗号化を行っていれば発生しないエラー
            throw new ApplicationException(userSearchFormContext.getMessages());
        }
        
        String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();

        // バージョン番号の準備(楽観的ロック)
        HttpExclusiveControlUtil.prepareVersion(ctx, new ExclusiveCtrlSystemAccountContext(userId));
        
        // 更新対象ユーザ情報の取得
        CM311AC1Component comp = new CM311AC1Component();
        SqlResultSet sysAcct = comp.selectSystemAccount(userId);
        SqlResultSet users = comp.selectUsers(userId);
        SqlResultSet permissionUnit = comp.selectPermissionUnit(userId);
        SqlResultSet ugroup = comp.selectUgroup(userId);
        
        // 対象ユーザの詳細情報が取得できなければエラー（認可単位の割り当ては必須ではない）
        if (sysAcct.isEmpty() || users.isEmpty() 
                || ugroup.isEmpty()) {
            throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00029"));
        }
        
        // 更新画面表示に必要なリストデータ設定
        setUpViewData(ctx);
        
        // 検索結果をウィンドウスコープに設定
        ctx.setRequestScopedVar("W11AC03", getWindowScopeObject(sysAcct, users, permissionUnit, ugroup));
        
        return new HttpResponse("/ss11AC/W11AC0301.jsp");
    }
    
    /**
     * ユーザ情報更新画面の「確認」イベントの処理を行う。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnErrors({
        @OnError(type = OptimisticLockException.class,
                 path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
        @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0301.jsp")
    })
    public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
        
        // バージョン番号のチェック(楽観的ロック)
        HttpExclusiveControlUtil.checkVersions(req, ctx);
        
        // 画面表示に必要なリストデータ設定
        setUpViewData(ctx);
        
        // 入力項目のバリデーション
        W11AC03Form inputDataObject = validateUpdateValue(req);
        
        // 認可単位選択有無フラグの設定
        setPermissionUnitEmptyFlg(ctx, inputDataObject);
        
        return new HttpResponse("/ss11AC/W11AC0302.jsp");
    }
    
    /**
     * ユーザ情報更新確認画面の「更新画面へ」イベントの処理を行う。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnError(type = OptimisticLockException.class, path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
    public HttpResponse doRW11AC0303(HttpRequest req, ExecutionContext ctx) {
        
        // バージョン番号のチェック(楽観的ロック)
        HttpExclusiveControlUtil.checkVersions(req, ctx);
        
        // 画面表示に必要なリストデータ設定
        setUpViewData(ctx);
        
        return new HttpResponse("/ss11AC/W11AC0301.jsp");
    }
    
    /**
     * 更新確認画面の「確定」イベントの処理を行う。
     * 
     * @param req リクエストコンテキスト
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @return HTTPレスポンス
     */
    @OnErrors({
        @OnError(type = OptimisticLockException.class,
                 path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
        @OnError(type = ApplicationException.class, path = "forward://RW11AC0303")
    })
    @OnDoubleSubmission(path = "forward://RW11AC0303", statusCode = 400)
    public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
        
        // バージョン番号の更新(楽観的ロック)
        HttpExclusiveControlUtil.updateVersionsWithCheck(req);
        
        // 更新データの取得
        W11AC03Form form;
        try {
            form = validateUpdateValue(req);
        } catch (ApplicationException e) {
            // hidden暗号化を行っていれば発生しないエラー
            throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG90002"));
        }
        SystemAccountEntity systemAccount = form.getSystemAccount();
        UsersEntity users = (UsersEntity) form.getUsers();
        UgroupSystemAccountEntity ugroup = form.getUgroupSystemAccount();
        
        // 更新処理の実行
        updateUserInfo(users, systemAccount, ugroup);
        
        return new HttpResponse("/ss11AC/W11AC0303.jsp");
    }

    /**
     * ユーザ情報の更新を行う。
     * 
     * @param users ユーザTの更新情報
     * @param systemAccount システムアカウント権限Tの更新情報
     * @param ugroup グループシステムアカウントTの更新情報
     */
    private void updateUserInfo( UsersEntity users, SystemAccountEntity systemAccount,
            UgroupSystemAccountEntity ugroup) {
        // ユーザテーブルの更新
        ParameterizedSqlPStatement updateUsers = super.getParameterizedSqlStatement("UPDATE_USERS");
        users.setUserId(systemAccount.getUserId());
        updateUsers.executeUpdateByObject(users);
        
        // グループシステム権限テーブルの更新
        ParameterizedSqlPStatement updateUgroupSystemAccount = super.getParameterizedSqlStatement("UPDATE_UGROUP_SYSTEM_ACCOUNT");
        ugroup.setUserId(systemAccount.getUserId());
        updateUgroupSystemAccount.executeUpdateByObject(ugroup);
        
        // システム権限テーブルの更新
        CM311AC1Component comp = new CM311AC1Component();
        comp.deleteSystemAccountAuthority(systemAccount.getUserId());
        if (!StringUtil.isNullOrEmpty(systemAccount.getPermissionUnit())) {
            comp.registerSystemAccountAuthority(systemAccount);
        }
    }
    
    /**
     * 認可単位選択有無フラグをコンテキストに設定する。<br/>
     * 選択がない場合は"empty"、選択がある場合は"notEmpty"を設定。
     * 
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     * @param userForm ユーザ情報入力フォーム
     */
    private void setPermissionUnitEmptyFlg(ExecutionContext ctx,
            W11AC03Form userForm) {
        SystemAccountEntity sysAcct = userForm.getSystemAccount();
        String permissionUnitEmptyFlg = NOT_EMPTY;
        if (StringUtil.isNullOrEmpty(sysAcct.getPermissionUnit())) {
            permissionUnitEmptyFlg = EMPTY;
        }
        ctx.setRequestScopedVar("permissionUnitEmptyFlg", permissionUnitEmptyFlg);
    }
    
    /**
     * 更新対象ユーザの検索結果を設定したMapを返す。
     * 
     * @param sysAcct システムアカウント情報
     * @param users ユーザ情報
     * @param permissionUnit 認可単位情報
     * @param ugroup グループ情報
     * @return 引数のデータを設定したMap
     */
    private W11AC03Form getWindowScopeObject(SqlResultSet sysAcct, SqlResultSet users,
            SqlResultSet permissionUnit, SqlResultSet ugroup) {
        W11AC03Form userForm = new W11AC03Form();
        SystemAccountEntity systemAccountEntity = new SystemAccountEntity(sysAcct.get(0));
        
        String[] permissions = new String[permissionUnit.size()];
        for (int i = 0; i < permissionUnit.size(); i++) {
            permissions[i] = permissionUnit.get(i).getString("PERMISSION_UNIT_ID");
        }
        systemAccountEntity.setPermissionUnit(permissions);
        UsersEntity usersEntity = new UsersEntity(users.get(0));
        UgroupSystemAccountEntity ugroupSystemAccountEntity = new UgroupSystemAccountEntity(ugroup.get(0));

        userForm.setSystemAccount(systemAccountEntity);
        userForm.setUsers(usersEntity);
        userForm.setUgroupSystemAccount(ugroupSystemAccountEntity);
        return userForm;
    }

    /**
     * 入力データの精査と生成を行う。<br/>
     * 精査エラーの場合はApplicationExceptionを送出する。
     * 
     * @param req リクエストコンテキスト
     * @return 精査対象のデータを設定したマップ
     */
    private W11AC03Form validateUpdateValue(HttpRequest req) {
                
        // 入力項目の単項目精査
        ValidationContext<W11AC03Form> formContext = 
            ValidationUtil.validateAndConvertRequest("W11AC03",
                    W11AC03Form.class, req, "updateUser");

        if (!formContext.isValid()) {
            throw new ApplicationException(formContext.getMessages());
        }
        
        W11AC03Form form = formContext.createObject();
        // エンティティの生成
        UgroupSystemAccountEntity ugroupSystemAccount = form.getUgroupSystemAccount();
        SystemAccountEntity systemAccount = form.getSystemAccount();
        
        // グループID、認可単位の順に存在チェック
        List<Message> errorMessages = new ArrayList<Message>();
        CM311AC1Component comp = new CM311AC1Component();
        if (!comp.existGroupId(ugroupSystemAccount)) {
            errorMessages.add(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00033",
                            MessageUtil.getStringResource("S0020001")));
        }
        if (!StringUtil.isNullOrEmpty(systemAccount.getPermissionUnit()) 
                && !comp.existPermissionUnitId(systemAccount)) {
            errorMessages.add(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00033",
                            MessageUtil.getStringResource("S0030001")));
        }
        if (errorMessages.size() > 0) {
            throw new ApplicationException(errorMessages);
        }
        
        return form;
    }

    /**
     * 画面表示に必要なグループリストと認可単位リストをコンテキストに設定する。
     * 
     * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
     */
    private void setUpViewData(ExecutionContext ctx) {
        CM311AC1Component comp = new CM311AC1Component();
        SqlResultSet ugroupList = comp.getUserGroups();
        SqlResultSet permissionUnitList = comp.getAllPermissionUnit();
        ctx.setRequestScopedVar("ugroupList", ugroupList);
        ctx.setRequestScopedVar("permissionUnitList", permissionUnitList);
    }
}
