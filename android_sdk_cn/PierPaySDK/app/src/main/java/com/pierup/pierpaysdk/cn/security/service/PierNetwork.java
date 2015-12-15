package com.pierup.pierpaysdk.cn.security.service;

import android.app.ProgressDialog;
import android.content.Context;

import com.pierup.pierpaysdk.cn.extern.PierDeviceUtil;
import com.pierup.pierpaysdk.cn.security.network.HttpClient;
import com.pierup.pierpaysdk.cn.security.network.HttpHandler;
import com.pierup.pierpaysdk.cn.security.network.HttpMethod;
import com.pierup.pierpaysdk.cn.security.network.HttpParams;
import com.pierup.pierpaysdk.cn.security.network.HttpResponse;

/**
 * Created by wangbei on 12/11/15.
 */
public abstract class PierNetwork implements PierNetworkCallback {

    private Context context;
    private HttpMethod method;
    private String url;
    private HttpParams httpParams;
    private static ProgressDialog loadingView;

    public PierNetwork(HttpMethod method, String url, HttpParams httpParams, Context context) {
        this.method = method;
        this.url = PierServiceConfig.host_production_sdk + url;
        this.httpParams = httpParams;
        this.context = context;
    }

    public void start() {
        HttpHandler httpHandler = new HttpHandler() {

            @Override
            public void onSuccess(HttpResponse response) {
                loadingView.cancel();
                PierNetwork.this.onSuccess(response);
            }

            @Override
            public void onError(HttpResponse response) {
                loadingView.cancel();
                PierNetwork.this.onFailure(response);
            }

            @Override
            public void onCancel(HttpResponse response) {
                loadingView.cancel();
                PierNetwork.this.onFailure(response);
            }

            @Override
            public void onRetry(HttpResponse response) {
                loadingView.cancel();
                PierNetwork.this.onFailure(response);
            }

            @Override
            public void onStart(HttpResponse response) {
                loadingView = new ProgressDialog(context);
                loadingView.setMessage("请稍等...");
                loadingView.setCanceledOnTouchOutside(false);
                loadingView.show();
            }
        };

        sendDispatcher(httpHandler);
    }

    private void sendDispatcher(HttpHandler httpHandler) {
        HttpClient httpClient = new HttpClient();
        switch (method) {
            case POST: {
                httpClient.post(url, httpParams, httpHandler);
                break;
            }
            case GET: {
                httpClient.get(url, httpHandler);
                break;
            }
        }
    }
}
