package com.pierup.pierpaysdk.cn.service.network;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.pierup.pierpaysdk.cn.business.bean.PierRootBean;
import com.pierup.pierpaysdk.cn.business.PierObject;
import com.pierup.pierpaysdk.cn.extern.PierDataSources;

public class PierSessionManager {
    private int reConnectionCount = 1;
    public static final PierSessionManager instance = new PierSessionManager();
    private OnAutoLoginResult autoLoginResult;

    public static PierSessionManager getInstance() {
        return instance;
    }

    public OnAutoLoginResult getAutoLoginResult() {
        return autoLoginResult;
    }

    public void setAutoLoginResult(OnAutoLoginResult autoLoginResult) {
        this.autoLoginResult = autoLoginResult;
    }

    public interface OnAutoLoginResult {
        void loginSuccess();

        void loginFailed();
    }

//    public void executeActionLogin(Context context) {
//        autoLogin(context);
//    }

    public boolean isLogin() {
        return true ? (PierDataSources.instance.getSession_token() != null &&
                PierDataSources.instance.getSession_token().length() > 0) :
                false;
    }

//    public void showLoginPage(Context context) {
//        Bundle bundle = new Bundle();
//        bundle.putBoolean(PierLoginActivity.IF_NOT_AUTO_LOGIN, true);
//        Intent intent = new Intent(context, PierLoginActivity.class);
//        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//        intent.putExtras(bundle);
//        context.startActivity(intent);
//    }
//
//    private void autoLogin(Context context) {
//        if (PierDataSources.instance.getSessionRepeatCount == reConnectionCount ||
//                PierDataSources.instance.getSessionRepeatCount > reConnectionCount) {
//            PierDataSources.instance.getSessionRepeatCount = 0;
//            PierSessionManager.this.autoLoginResult.loginFailed();
//            return;
//        }
//
//        UserEntity userEntity = DataManagerUtil.getInstance().getUser();
//        String phone = userEntity.getPhone();
//        String password = userEntity.getPassword();
//        if (PierStringUtil.isNull(password)){
//            password = PierDataSources.instance.getSigin_password();
//        }
//        if ((phone != null && phone.length() > 0)
//                && (password != null && password.length() > 0)) {
//            UserConfigEntity userConfigEntity = UserDBUtil.getUserConfigEntityByPhone(phone);
//            PierDataSources.instance.setPhone(phone);
//            PierDataSources.instance.setCountry_code(userConfigEntity.getCountry_code());
//            loginService(context, phone, password);
//        } else {
//            Intent intent = new Intent(context, PierLoginActivity.class);
//            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//            context.startActivity(intent);
////            PierSessionManager.this.autoLoginResult.loginFailed();
//        }
//    }
//
//    private void loginService(Context context, final String phoneNumber, final String password) {
//        final PierUserBean userBean = new PierUserBean();
//        userBean.ifNeedLoadingView = false;
//        userBean.ifNeedErrorAlert = false;
//        String countryCode = PierDataSources.instance.getCountry_code();
//        userBean.siginRequest = new PierUserSigninRequest(phoneNumber, countryCode, password);
//
//        PierDataSources.instance.getSessionRepeatCount += 1;
//        new PierNetwork(signIn, context, userBean) {
//
//            @Override
//            public void onSuccess(PierRootBean bean, PierObject result) {
//                PierSessionManager.this.autoLoginResult.loginSuccess();
//                PierDataSources.instance.getSessionRepeatCount = 0;
//            }
//
//            @Override
//            public void onFailure(PierRootBean bean, String result, Throwable error) {
//                PierSessionManager.this.autoLoginResult.loginFailed();
//
//            }
//        }.start();
//    }
}
