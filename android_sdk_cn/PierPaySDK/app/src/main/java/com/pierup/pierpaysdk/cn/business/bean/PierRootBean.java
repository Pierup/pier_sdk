package com.pierup.pierpaysdk.cn.business.bean;

import com.loopj.android.http.RequestParams;

public class PierRootBean {
    protected RequestParams requestParams;
    public Boolean ifNeedLoadingView = true;
    public Boolean ifNeedErrorAlert = true;
    public String contentEncoding = "utf-8";


    public PierRootBean() {
    }

    public RequestParams getRequestParams() {
        return requestParams;
    }

    public void setRequestParams(RequestParams requestParams) {
        this.requestParams = requestParams;
    }
}
