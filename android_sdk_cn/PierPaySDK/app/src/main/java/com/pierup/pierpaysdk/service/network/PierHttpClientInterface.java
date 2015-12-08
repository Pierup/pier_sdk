package com.pierup.pierpaysdk.service.network;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.RequestHandle;
import com.loopj.android.http.RequestParams;
import com.loopj.android.http.ResponseHandlerInterface;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpEntity;


public interface PierHttpClientInterface {
    cz.msebera.android.httpclient.Header[] getRequestHeaders();

    cz.msebera.android.httpclient.HttpEntity getRequestEntity();

    public RequestParams getRequestParams();

    RequestHandle executeRequest(AsyncHttpClient client,
                                 String URL,
                                 Header[] headers,
                                 HttpEntity entity,
                                 ResponseHandlerInterface responseHandler,
                                 RequestParams requestParams);

    ResponseHandlerInterface getResponseHandler();
}
