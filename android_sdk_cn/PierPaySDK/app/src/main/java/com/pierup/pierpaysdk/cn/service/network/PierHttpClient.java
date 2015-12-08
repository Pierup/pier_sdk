package com.pierup.pierpaysdk.cn.service.network;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpRequest;
import com.loopj.android.http.RequestHandle;
import com.loopj.android.http.RequestParams;
import com.loopj.android.http.ResponseHandlerInterface;
import com.pierup.pierpaysdk.cn.business.PierServiceConfig;
import com.pierup.pierpaysdk.cn.business.PierServiceEnum;
import com.pierup.pierpaysdk.cn.business.bean.PierRootBean;
import com.pierup.pierpaysdk.cn.business.models.PierRequest;
import com.pierup.pierpaysdk.cn.business.serviceHandler.PierServiceHandler;
import com.pierup.pierpaysdk.cn.extern.PierDataSources;


import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.entity.StringEntity;
import cz.msebera.android.httpclient.message.BasicHeader;

import static com.pierup.pierpaysdk.cn.business.PierServiceConfig.HTTPMethodEnum.GET;
import static com.pierup.pierpaysdk.cn.business.PierServiceConfig.HTTPMethodEnum.UploadFile;


public abstract class PierHttpClient implements PierHttpClientInterface {
    private PierServiceEnum serverTag;
    private Context context;
    public PierRootBean bean;
    public PierRequest requestModel;
    private static final String LOG_TAG = "PierHttpClient";
    private Gson gson = new Gson();

    private AsyncHttpClient asyncHttpClient = new AsyncHttpClient() {
        @Override
        protected AsyncHttpRequest newAsyncHttpRequest(cz.msebera.android.httpclient.impl.client.DefaultHttpClient client, cz.msebera.android.httpclient.protocol.HttpContext httpContext, cz.msebera.android.httpclient.client.methods.HttpUriRequest uriRequest, String contentType, ResponseHandlerInterface responseHandler, Context context) {
            AsyncHttpRequest httpRequest = getHttpRequest(client, httpContext, uriRequest, contentType, responseHandler, context);

            return httpRequest == null
                    ? super.newAsyncHttpRequest(client, httpContext, uriRequest, contentType, responseHandler, context)
                    : httpRequest;
        }
    };

    private final List<RequestHandle> requestHandles = new LinkedList<RequestHandle>();

    public PierHttpClient(PierServiceHandler handler, PierRequest requestModel) {
        this.serverTag = handler.serverTag;
        this.context = handler.context;
        this.bean = handler.bean;
        this.requestModel = requestModel;
    }

    public void onRunHttpRequest() {
        addRequestHandle(executeRequest(getAsyncHttpClient(),
                serverTag.getUrl(),
                getRequestHeaders(),
                getRequestEntity(),
                getResponseHandler(),
                getRequestParams()));
    }

    public void onCancelHttpRequest() {
        asyncHttpClient.cancelRequests(null, true);
    }

    public List<Header> getRequestHeadersList() {
        List<Header> headers = new ArrayList<Header>();
        headers.add(new BasicHeader("Accept-Encoding", "gzip, deflate"));
        headers.add(new BasicHeader("user-agent", PierDataSources.instance.getUser_agent()));
        return headers;
    }

    public List<RequestHandle> getRequestHandles() {
        return requestHandles;
    }

    public void addRequestHandle(RequestHandle handle) {
        if (null != handle) {
            requestHandles.add(handle);
        }
    }

    public AsyncHttpClient getAsyncHttpClient() {
        if (serverTag.getMethod() == UploadFile) {
            this.asyncHttpClient.setTimeout(PierServiceConfig.PIER_HTTP_UPDATE_TIMEOUT);
        } else {
            this.asyncHttpClient.setTimeout(PierServiceConfig.PIER_HTTP_DEFAULT_TIMEOUT);
        }
        return this.asyncHttpClient;
    }

    public AsyncHttpRequest getHttpRequest(cz.msebera.android.httpclient.impl.client.DefaultHttpClient client, cz.msebera.android.httpclient.protocol.HttpContext httpContext, cz.msebera.android.httpclient.client.methods.HttpUriRequest uriRequest, String contentType, ResponseHandlerInterface responseHandler, Context context) {
        return null;
    }

    @Override
    public RequestParams getRequestParams() {
        RequestParams params = bean.getRequestParams();
        if (serverTag.getMethod() == GET || serverTag.getMethod() == UploadFile) {
            if (params == null) {
                params = new RequestParams();
                bean.setRequestParams(params);
            }
//            if (!(serverTag instanceof PierServiceEnumCustom)) {
//                params.put("user_id", PierDataSources.instance.getUser_id());
//                params.put("session_token", PierDataSources.instance.getSession_token());
//                params.put("device_token", PierDataSources.instance.getDevice_token());
//                params.put("platform", PierServiceConfig.PLATFORM);
//            }
        }
        return params;
    }

    @Override
    public Header[] getRequestHeaders() {
        List<Header> headers = getRequestHeadersList();
        return headers.toArray(new Header[headers.size()]);
    }

    @Override
    public HttpEntity getRequestEntity() {
        if (serverTag.getMethod() == UploadFile) {

        } else {
            String str = gson.toJson(this.requestModel);
            try {
                JSONObject jsonObject = new JSONObject(str);
                jsonObject.toString();
            } catch (JSONException e) {
                e.printStackTrace();
            }

            String bodyText = str;
            Log.d(LOG_TAG, bodyText);
            if (bodyText != null) {
                return new StringEntity(bodyText, PierServiceConfig.CHARSET);
            }
        }
        return null;
    }

    @Override
    public RequestHandle executeRequest(AsyncHttpClient client, String URL, Header[] headers, HttpEntity entity, ResponseHandlerInterface responseHandler, RequestParams requestParams) {
        RequestHandle requestHandle = null;
        URL = URL + PierServiceConfig.api_query;
        Log.d(LOG_TAG, URL);
        switch (serverTag.getMethod()) {
            case POST_JSON:
                requestHandle = client.post(context, URL, headers, entity, RequestParams.APPLICATION_JSON, responseHandler);
                break;
            case POST:
                requestHandle = client.post(context, URL, headers, entity, "text/html", responseHandler);
                break;
            case GET:
                requestHandle = client.get(context, URL, headers, requestParams, responseHandler);
                break;
            case UploadFile: {
                requestParams.setForceMultipartEntityContentType(true);
                try {
                    HttpEntity entity1 = requestParams.getEntity(responseHandler);
                    requestHandle = client.post(context, URL, headers, entity1, entity1.getContentType().getValue(), responseHandler);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            }
            default:
                requestHandle = client.post(context, URL, headers, entity, RequestParams.APPLICATION_JSON, responseHandler);
                break;
        }
        return requestHandle;
    }
}
