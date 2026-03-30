package nablarch.sample.ss11AC;

import java.util.Map;

import nablarch.core.validation.PropertyName;
import nablarch.core.validation.ValidateFor;
import nablarch.core.validation.ValidationContext;
import nablarch.core.validation.ValidationTarget;
import nablarch.core.validation.ValidationUtil;
import nablarch.core.validation.validator.AsciiChar;
import nablarch.core.validation.validator.Length;
import nablarch.core.validation.validator.Required;

import nablarch.sample.ss11.entity.SystemAccountEntity;
import nablarch.sample.ss11.entity.UgroupSystemAccountEntity;
import nablarch.sample.ss11.entity.UsersEntity;

/**
 * ユーザ情報入力フォーム（登録機能）。
 *
 * @author Koichi Asano 
 * @since 1.1
 */
public class W11AC02Form {

    /**
     * ユーザテーブルの情報。
     */
    private UsersEntity users;
    /**
     * システムアカウントテーブルの情報。
     */
    private SystemAccountEntity systemAccount;
    /**
     * グループシステムアカウントテーブルの情報。
     */
    private UgroupSystemAccountEntity ugroupSystemAccount;

    /** 新しいパスワード */
    private String newPassword;

    /** 確認用パスワード */
    private String confirmPassword;

    /**
     * コンストラクタ。
     */
    public W11AC02Form() {
    }

    /**
     * Mapを引数にとるコンストラクタ。
     *
     * @param params 項目名をキーとし、項目値を値とするMap
     */
    public W11AC02Form(Map<String, Object> params) {
        users = (UsersEntity) params.get("users");
        systemAccount = (SystemAccountEntity) params.get("systemAccount");
        ugroupSystemAccount = (UgroupSystemAccountEntity) params.get("ugroupSystemAccount");
        newPassword = (String) params.get("newPassword");
        confirmPassword = (String) params.get("confirmPassword");
    }

    /**
     * 新(変更後)パスワードを取得する。
     *
     * @return 新(変更後)パスワード
     */
    public String getNewPassword() {
        return newPassword;
    }

    /**
     * 新(変更後)パスワードを設定する。
     *
     * @param newPassword 設定する新(変更後)パスワード
     */
    @PropertyName("パスワード")
    @Required
    @AsciiChar
    @Length(max = 20)
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    /**
     * 確認用パスワードを取得する。
     *
     * @return 確認用パスワード
     */
    public String getConfirmPassword() {
        return confirmPassword;
    }

    /**
     * 確認用パスワードを設定する。
     *
     * @param confirmPassword 設定する確認用パスワード
     */
    @PropertyName("パスワード")
    @Required
    @AsciiChar
    @Length(max = 20)
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    /**
     * ユーザテーブルの情報を取得する。
     * @return ユーザテーブルの情報
     */
    public UsersEntity getUsers() {
        return users;
    }

    /**
     * ユーザテーブルの情報を設定する。
     * @param users ユーザテーブルの情報
     */
    @ValidationTarget
    public void setUsers(UsersEntity users) {
        this.users = users;
    }

    /**
     * システムアカウントテーブルの情報を取得する。
     * 
     * @return システムアカウントテーブルの情報
     */
    public SystemAccountEntity getSystemAccount() {
        return systemAccount;
    }

    /**
     * システムアカウントテーブルの情報を設定する。。
     * 
     * @param systemAccount システムアカウントテーブルの情報
     */
    @ValidationTarget
    public void setSystemAccount(SystemAccountEntity systemAccount) {
        this.systemAccount = systemAccount;
    }

    /**
     * グループシステムアカウントテーブルの情報を取得する。
     * 
     * @return グループシステムアカウントテーブルの情報
     */
    public UgroupSystemAccountEntity getUgroupSystemAccount() {
        return ugroupSystemAccount;
    }

    /**
     * グループシステムアカウントテーブルの情報を設定する。
     * 
     * @param ugroupSystemAccountEntity グループシステムアカウントテーブルの情報
     */
    @ValidationTarget
    public void setUgroupSystemAccount(
            UgroupSystemAccountEntity ugroupSystemAccountEntity) {
        this.ugroupSystemAccount = ugroupSystemAccountEntity;
    }

    /**
     * ユーザ登録時に実施するバリデーション
     * 
     * @param context バリデーションの実行に必要なコンテキスト
     */
    @ValidateFor("registerUser")
    public static void validateForRegister(ValidationContext<W11AC02Form> context) {
        ValidationUtil.validateWithout(context, new String[0]);

        if (!context.isValid()) {
            return;
        }

        W11AC02Form form = context.createObject();
        // 新パスワードと確認用パスワードのチェック
        if (!form.newPassword.equals(form.confirmPassword)) {
            context.addResultMessage("newPassword", "MSG00003");
        }
    }
}
