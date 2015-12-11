package com.pierup.pierpaysdk.cn.security.service;

import com.pierup.pierpaysdk.cn.security.network.HttpResponse;

/**
 * Created by wangbei on 12/11/15.
 */
public interface PierNetworkCallback {

    void onSuccess(HttpResponse response);

    void onFailure(HttpResponse response);
}
