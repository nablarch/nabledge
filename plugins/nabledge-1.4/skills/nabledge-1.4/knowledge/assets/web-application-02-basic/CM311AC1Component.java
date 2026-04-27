package nablarch.sample.ss11AC;

import nablarch.common.date.DateUtil;
import nablarch.core.date.BusinessDateUtil;
import nablarch.core.db.statement.ParameterizedSqlPStatement;
import nablarch.core.db.statement.SqlPStatement;
import nablarch.core.db.statement.SqlResultSet;
import nablarch.core.db.statement.exception.DuplicateStatementException;
import nablarch.core.db.support.DbAccessSupport;
import nablarch.core.message.ApplicationException;
import nablarch.core.message.MessageLevel;
import nablarch.core.message.MessageUtil;
import nablarch.core.repository.SystemRepository;
import nablarch.core.util.StringUtil;
import nablarch.sample.ss11.entity.SystemAccountAuthorityEntity;
import nablarch.sample.ss11.entity.SystemAccountEntity;
import nablarch.sample.ss11.entity.UgroupSystemAccountEntity;
import nablarch.sample.ss11.entity.UsersEntity;
import nablarch.sample.util.AuthenticationUtil;
import nablarch.sample.util.IdGeneratorUtil;

/**
 * ユーザ管理機能に関する機能内共通コンポーネント（設計書なし）
 * 
 * @author Hiroto Nitta
 * @since 1.0
 */
class CM311AC1Component extends DbAccessSupport {

    /** ユーザーIDロックの状態:アンロック */
    private static final String USER_ID_NOT_LOCKED = "0";

    /** パスワード失敗回数の初期値 */
    private static final int INITIAL_FAILED_COUNT = 0;

    /**
     * グループテーブルに登録されている全てのグループIDと名称を取得する。
     * 
     * @return 検索結果
     */
    SqlResultSet getUserGroups() {
        SqlPStatement statement = getSqlPStatement("SELECT_ALL_UGROUPS");
        return statement.retrieve();
    }

    /**
     * 認可単位テーブルに登録されている全ての認可単位IDと名称を取得する。
     * 
     * @return 検索結果。認可単位IDの昇順でソート
     */
    SqlResultSet getAllPermissionUnit() {
        SqlPStatement statement = getSqlPStatement("SELECT_ALL_PERMISSION_UNITS");
        return statement.retrieve();
    }

    /**
     * グループIDがシステムに登録されているかチェックする。
     * 
     * @param ugroupSystemAccount チェック対象の情報を保持した{@link UgroupSystemAccountEntity}
     * @return グループIDがシステムに登録されていればtrue
     */
    boolean existGroupId(UgroupSystemAccountEntity ugroupSystemAccount) {

        SqlPStatement statement = getSqlPStatement("CHECK_UGROUP");
        statement.setString(1, ugroupSystemAccount.getUgroupId());
        SqlResultSet result = statement.retrieve();
        return !result.isEmpty();
    }

    /**
     * 認可単位IDがシステムに登録されているかチェックする。
     * 
     * @param systemAccount チェック対象の上方を保持した{@link SystemAccountEntity}
     * @return 認可単位IDがシステムに登録されていればtrue
     */
    boolean existPermissionUnitId(SystemAccountEntity systemAccount) {
        SqlPStatement statement = getSqlPStatement("CHECK_PERMISSION_UNIT");
        for (String permissionUnitId : systemAccount.getPermissionUnit()) {
            statement.setString(1, permissionUnitId);
            SqlResultSet result = statement.retrieve();
            if (result.isEmpty()) {
                return false;
            }
        }
        return true;
    }

    /**
     * ユーザを登録する。
     * 
     * @param systemAccount 画面入力された情報を持つ{@link SystemAccountEntity}
     * @param plainPassword 暗号化されていないパスワード
     * @param users 画面入力された情報を持つ{@link UsersEntity}
     * @param ugroupSystemAccount 画面入力された情報を持つ{@link UgroupSystemAccountEntity}
     */
    void registerUser(SystemAccountEntity systemAccount, String plainPassword, UsersEntity users,
            UgroupSystemAccountEntity ugroupSystemAccount) {

        // 日付の取得
        // ユーザIDを採番する
        String userId = IdGeneratorUtil.generateUserId();
        // 現在(システム)日付
        String current = BusinessDateUtil.getDate();
        // 1カ月後(パスワードの有効期限)
        String passwordExpirationDate = DateUtil.addMonth(current,
                Integer.parseInt(SystemRepository.getString("passwordExpirationDate")));
        // 12カ月後(ユーザの有効期限)
        String userEffectiveDateTo = DateUtil.addMonth(current,
                Integer.parseInt(SystemRepository.getString("userEffectiveDateTo")));

        // システムアカウントの登録
        systemAccount.setPasswordExpirationDate(passwordExpirationDate);
        systemAccount.setEffectiveDateFrom(current);
        systemAccount.setEffectiveDateTo(userEffectiveDateTo);
        systemAccount.setUserId(userId);
        systemAccount.setUserIdLocked(USER_ID_NOT_LOCKED);
        systemAccount.setFailedCount(INITIAL_FAILED_COUNT);
        systemAccount.setPassword(AuthenticationUtil.encryptPassword(systemAccount.getUserId(),
                plainPassword));

        registerSystemAccount(systemAccount);

        // ユーザエンティティの登録
        users.setUserId(userId);
        registerUsers(users);

        // グループシステムアカウントの登録
        ugroupSystemAccount.setUserId(userId);
        ugroupSystemAccount.setEffectiveDateFrom(current);
        ugroupSystemAccount.setEffectiveDateTo(userEffectiveDateTo);
        registerUgroupSystemAccount(ugroupSystemAccount);

        // システムアカウント権限の登録
        if (!StringUtil.isNullOrEmpty(systemAccount.getPermissionUnit())) {
            CM311AC1Component function = new CM311AC1Component();
            function.registerSystemAccountAuthority(systemAccount);
        }
    }

    /**
     * システムアカウントテーブルに1件登録する。<br>
     * 
     * @param systemAccount 登録する情報を保持した{@link SystemAccountEntity}
     */
    private void registerSystemAccount(SystemAccountEntity systemAccount) {
        ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SYSTEM_ACCOUNT");

        try {
            // システムアカウントに同じログインIDで既に登録されていたら例外を返す。
            statement.executeUpdateByObject(systemAccount);
        } catch (DuplicateStatementException de) {
            throw new ApplicationException(
                    MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
        }
    }

    /**
     * ユーザエンティティに1件登録する。
     * 
     * @param users 登録する情報を保持した{@link UsersEntity}
     */
    private void registerUsers(UsersEntity users) {
        ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_USERS");
        statement.executeUpdateByObject(users);
    }

    /**
     * グループシステムアカウントに1件登録する。
     * 
     * @param ugroupSystemAccount 登録内容が設定されたグループシステムアカウントエンティティクラス
     */
    private void registerUgroupSystemAccount(UgroupSystemAccountEntity ugroupSystemAccount) {

        ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_UGROUP_SYSTEM_ACCOUNT");
        statement.executeUpdateByObject(ugroupSystemAccount);
    }

    /**
     * システムアカウント権限に登録する。
     * 
     * @param systemAccount システムアカウント
     */
    void registerSystemAccountAuthority(SystemAccountEntity systemAccount) {

        SystemAccountAuthorityEntity systemAccountAuthority = new SystemAccountAuthorityEntity();
        systemAccountAuthority.setUserId(systemAccount.getUserId());

        ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_SYSTEM_ACCOUNT_AUTHORITY");

        for (String permissionUnit : systemAccount.getPermissionUnit()) {
            systemAccountAuthority.setPermissionUnitId(permissionUnit);
            statement.addBatchObject(systemAccountAuthority);
        }
        statement.executeBatch();
    }

    /**
     * 対象ユーザの基本情報を検索する。
     * 
     * @param userId 検索条件（ユーザID）
     * @return 検索結果
     */
    SqlResultSet selectUserBasicInfo(String userId) {
        SqlPStatement statement = getSqlPStatement("SELECT_USER_BASIC_INFO");
        statement.setString(1, userId);

        return statement.retrieve();
    }

    /**
     * 対象ユーザの基本情報をユーザテーブルから検索する。
     * 
     * @param userId 検索条件（ユーザID）
     * @return 検索結果
     */
    SqlResultSet selectUsers(String userId) {
        SqlPStatement statement = getSqlPStatement("SELECT_USERS");
        statement.setString(1, userId);

        return statement.retrieve();
    }

    /**
     * 対象ユーザの基本情報をシステムアカウントテーブルから検索する。
     * 
     * @param userId 検索条件（ユーザID）
     * @return 検索結果
     */
    SqlResultSet selectSystemAccount(String userId) {
        SqlPStatement statement = getSqlPStatement("SELECT_SYSTEM_ACCOUNT");
        statement.setString(1, userId);

        return statement.retrieve();
    }

    /**
     * 対象ユーザに紐づいた権限情報を認可単位テーブルから検索する。<br/>
     * 取得するデータは、認可単位IDと認可単位名称
     * 
     * @param userId 検索条件（ユーザID）
     * @return 検索結果
     */
    SqlResultSet selectPermissionUnit(String userId) {
        SqlPStatement statement = getSqlPStatement("SELECT_PERMISSION_UNIT");
        statement.setString(1, userId);

        return statement.retrieve();
    }

    /**
     * 対象ユーザの権限情報をグループテーブルから検索する。<br/>
     * 取得するデータは、グループIDとグループ名称
     * 
     * @param userId 検索条件（ユーザID）
     * @return 検索結果
     */
    SqlResultSet selectUgroup(String userId) {
        SqlPStatement statement = getSqlPStatement("SELECT_UGROUP");
        statement.setString(1, userId);

        return statement.retrieve();
    }

    /**
     * 指定されたユーザIDに紐づくユーザ情報を削除する。
     * 
     * @param userId 削除対象ユーザID
     */
    void deleteUser(String userId) {

        // システムアカウントテーブルデータの削除
        SqlPStatement statement = getSqlPStatement("DELETE_SYSTEM_ACCOUNT");
        statement.setString(1, userId);
        statement.execute();

        // ユーザテーブルデータの削除
        statement = getSqlPStatement("DELETE_USERS");
        statement.setString(1, userId);
        statement.execute();

        // グループシステムアカウントテーブルデータの削除
        statement = getSqlPStatement("DELETE_UGROUP_SYSTEM_ACCOUNT");
        statement.setString(1, userId);
        statement.execute();

        // システムアカウント権限テーブルデータの削除
        deleteSystemAccountAuthority(userId);
    }

    /**
     * 指定されたユーザIDに紐づくシステムアカウント権限情報を削除する。
     * 
     * @param userId 削除対象のユーザID
     */
    void deleteSystemAccountAuthority(String userId) {
        SqlPStatement statement;
        statement = getSqlPStatement("DELETE_SYSTEM_ACCOUNT_AUTHORITY");
        statement.setString(1, userId);
        statement.execute();
    }
}
