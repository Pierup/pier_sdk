package com.pierup.pierpaysdk.service.network;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.pierup.pierpaysdk.R;
import com.pierup.pierpaysdk.business.PierServiceEnum;
import com.pierup.pierpaysdk.business.bean.PierRootBean;
import com.pierup.pierpaysdk.business.serviceHandler.PierServiceHandler;

import static com.pierup.pierpaysdk.business.PierServiceConfig.ACCOUNT_LOCKED;
import static com.pierup.pierpaysdk.business.PierServiceConfig.DEVICE_TOKEN_EXPIRE;
import static com.pierup.pierpaysdk.business.PierServiceConfig.PASSWORD_ERROR;
import static com.pierup.pierpaysdk.business.PierServiceConfig.SESSION_EXPIRE;
import static com.pierup.pierpaysdk.service.network.PierServiceDispatcher.serverStart;

public abstract class PierNetwork implements PierNetworkCallBack {
    private PierServiceEnum serverTag;
    private Context context;
    private PierRootBean bean;
    private PierServiceHandler handler = null;

    public PierNetwork(PierServiceEnum serverTag, Context context, PierRootBean bean) {
        this.serverTag = serverTag;
        this.context = context;
        this.bean = bean;
    }

    public void start() {
        Class handle_class = null;
        try {
            String name = serverTag.getHandler();
            handle_class = Class.forName(serverTag.getHandler());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            handler = (PierServiceHandler) handle_class.newInstance();
            handler.bean = bean;
            handler.context = context;
            handler.serverTag = serverTag;
            handler.ifNeedLoadingView = bean.ifNeedLoadingView;
            handler.ifNeedErrorAlert = bean.ifNeedErrorAlert;
            serverStart(PierNetwork.this, handler);
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void checkErrorResponseStatus(final int code, String codeMessage, final String result, final Throwable error) {
        switch (code) {
            case SESSION_EXPIRE: {
                PierSessionManager sessionManager = PierSessionManager.getInstance();
                sessionManager.setAutoLoginResult(new PierSessionManager.OnAutoLoginResult() {
                    @Override
                    public void loginSuccess() {
                        serverStart(PierNetwork.this, handler);
                    }

                    @Override
                    public void loginFailed() {
                        PierNetwork.this.onFailure(bean, result, error);
                    }
                });
//                sessionManager.executeActionLogin(context);
                break;
            }
            case DEVICE_TOKEN_EXPIRE: {
//                if (context != null && context instanceof Activity && !(context instanceof PierLoginActivity)) {
//                    new PierAlertWidget(context).builder().setMsg(context.getResources().getString(R.string.alert_device_changed)).setPositiveButton(context.getResources().getString(R.string.alert_ok), new View.OnClickListener() {
//                        @Override
//                        public void onClick(View v) {
//                            Intent intent = new Intent(context, PierLoginActivity.class);
//                            Bundle bundle = new Bundle();
//                            bundle.putBoolean("IF_NOT_AUTO_LOGIN", true);
//                            bundle.putBoolean("IS_CHANGE_DEVICE", true);
//                            intent.putExtras(bundle);
//                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//                            ((Activity) context).startActivityForResult(intent, DEVICE_TOKEN_EXPIRE);
//                        }
//                    }).setNegativeButton(context.getResources().getString(R.string.alert_cancel), new View.OnClickListener() {
//                        @Override
//                        public void onClick(View v) {
//                            PierNetwork.this.onFailure(bean, result, error);
//                        }
//                    }).show();
//                } else {
                    PierNetwork.this.onFailure(bean, result, error);
//                }

                break;
            }
            case PASSWORD_ERROR: {
                this.onFailure(bean, result, error);
                break;
            }
            case ACCOUNT_LOCKED: {
                this.onFailure(bean, result, error);
                break;
            }
            default: {
                this.onFailure(bean, result, error);
                break;
            }
        }
        if (handler.ifNeedErrorAlert) {
            if (context != null
                    && context instanceof Activity
                    && code != SESSION_EXPIRE
                    && code != DEVICE_TOKEN_EXPIRE) {
//                new PierAlertWidget(context).builder().setMsg(codeMessage).show();
            }
        }
    }
}
