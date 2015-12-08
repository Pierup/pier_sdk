package com.pierup.pierpaysdk.cn.service.network;

import android.app.Activity;
import android.app.ProgressDialog;
import android.util.Log;

import com.google.gson.Gson;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.ResponseHandlerInterface;
import com.pierup.pierpaysdk.cn.business.models.PierRequest;
import com.pierup.pierpaysdk.cn.business.models.PierResponse;
import com.pierup.pierpaysdk.cn.business.PierObject;
import com.pierup.pierpaysdk.cn.business.serviceHandler.PierServiceHandler;
import com.pierup.pierpaysdk.cn.extern.PierDataSources;
import com.pierup.pierpaysdk.cn.extern.PierDeviceUtil;
import com.pierup.pierpaysdk.cn.service.utils.PierException;
import com.pierup.pierpaysdk.cn.service.utils.PierJSONObject;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Field;

import cz.msebera.android.httpclient.Header;

public class PierServiceDispatcher {
    private static final String LOG_TAG = "PierHttpClient";
    private static ProgressDialog loadingView;
    private static Gson gson = new Gson();

    public static void serverStart(final PierNetworkCallBack callBack, final PierServiceHandler handler) {
        final PierRequest request = handler.serverHandlerRequest();
        setRequestHeader(request, handler);
        setDataSourceRequest(request);
        PierHttpClient httpClient = new PierHttpClient(handler, request) {
            @Override
            public ResponseHandlerInterface getResponseHandler() {
                return new AsyncHttpResponseHandler() {

                    @Override
                    public void onProgress(long bytesWritten, long totalSize) {
                    }

                    @Override
                    public void onStart() {
                        if (handler.ifNeedLoadingView && handler.context instanceof Activity) {
                            loadingView = new ProgressDialog(handler.context);
                            loadingView.setMessage("加载中...");
                            loadingView.setCanceledOnTouchOutside(false);
                            loadingView.show();
                        }
                    }

                    @Override
                    public void onSuccess(int statusCode, Header[] headers, byte[] response) {
                        if (handler.ifNeedLoadingView) {
                            loadingView.cancel();
                        }
                        if (response != null) {
                            String result = new String(response);

                            Log.d(LOG_TAG, result);
                            PierJSONObject jsonObject = null;
                            String message = "";
                            int code = 0;
                            String result_json;
                            PierException pierException = new PierException();
                            try {
                                jsonObject = new PierJSONObject(result);
                                if (jsonObject != null) {
                                    code = jsonObject.getInt("code");
                                    message = jsonObject.getString("message");
                                    result_json = jsonObject.getString("result").toString();
                                    PierResponse resultObject = null;
                                    if (code == 200) {
                                        setDataSourceResponse(jsonObject);
                                        Class resultClass = Class.forName(handler.serverTag.getOutput());
                                        resultObject = (PierResponse) gson.fromJson(result_json, resultClass);
                                        resultObject.resultJsonObject = jsonObject.getJSONObject("result");
                                        handler.serverHandlerResponse(callBack, resultObject, null);
                                    } else {
                                        pierException.setCode(code);
                                        pierException.setCodeMessage(message);
                                        callBack.checkErrorResponseStatus(code, message, result, pierException);
                                    }

//                                    if (code == 200 || handler.serverTag instanceof PierServiceEnumCustom) {
//                                        if (!(handler.serverTag instanceof PierServiceEnumCustom)) {
//                                            setDataSourceResponse(jsonObject);
//                                            Class resultClass = Class.forName(handler.serverTag.getOutput());
//                                            resultObject = (PierResponse) gson.fromJson(result_json, resultClass);
//                                            resultObject.resultJsonObject = jsonObject.getJSONObject("result");
//                                        }else {
//                                            Class resultClass = Class.forName(handler.serverTag.getOutput());
//                                            resultObject = (PierResponse) resultClass.newInstance();
//                                            resultObject.resultJsonObject = jsonObject;
//                                        }
//
//                                        handler.serverHandlerResponse(callBack, resultObject, null);
//                                    } else {
////                                        Toast.makeText(handler.context, message, Toast.LENGTH_SHORT).show();
//                                        pierException.setCode(code);
//                                        pierException.setCodeMessage(message);
//                                        callBack.checkErrorResponseStatus(code, message, result, pierException);
////                                        callBack.onFailure(bean, result, pierException);
//                                    }
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            } catch (ClassNotFoundException e) {
                                callBack.checkErrorResponseStatus(code, message, result, null);
//                                callBack.onFailure(bean, result, pierException);
                                e.printStackTrace();
                            }
                        }
                    }

                    @Override
                    public void onFailure(int statusCode, Header[] headers, byte[] errorResponse, Throwable e) {
                        if (handler.ifNeedLoadingView && handler.context instanceof Activity) {
                            loadingView.cancel();
                        }
                        if (errorResponse != null) {
                            String errorResult = new String(errorResponse);
                            Log.d(LOG_TAG, errorResult);
                            PierException pierException = new PierException();
                            JSONObject jsonObject;
                            String message = "";
                            int code = 0;
                            try {
                                jsonObject = new JSONObject(errorResult);
                                message = jsonObject.getString("message");
                                code = jsonObject.getInt("code");
                                pierException.setCode(code);
                                pierException.setCodeMessage(message);
                            } catch (JSONException e1) {
                                e1.printStackTrace();
                            }
                            e = pierException;
//                            Toast.makeText(handler.context, pierException.getCodeMessage(), Toast.LENGTH_SHORT).show();
                            callBack.checkErrorResponseStatus(code, message, errorResult, pierException);
//                            callBack.onFailure(handler.bean, errorResult, e);
                        } else {
//                            Toast.makeText(handler.context, R.string.alert_error, Toast.LENGTH_SHORT).show();
                        }
                    }
                };
            }
        };
        httpClient.onRunHttpRequest();
    }

    private static void setRequestHeader(PierRequest request, final PierServiceHandler handler) {
        if (request == null) try {
            Class requestClass = Class.forName(handler.serverTag.getInput());
            request = (PierRequest) requestClass.newInstance();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        if (request != null ) {
            request.session_token = PierDataSources.instance.getSession_token();
            if (request.device_token == null || request.device_token.length() < 1) {
                request.device_token = PierDataSources.instance.getDevice_token();
            }
            request.user_id = PierDataSources.instance.getUser_id();
            request.country_code = PierDataSources.instance.getCountry_code();
            request.metadata = PierDeviceUtil.getDeviceInfoDict();
            if (request.phone == null || request.phone.length() == 0) {
                request.phone = PierDataSources.instance.getPhone();
            }
        }
    }

    private static void setDataSourceRequest(PierObject requestModel) {
        try {
            Field fieldPhone = requestModel.getClass().getField("phone");
            if (fieldPhone != null) {
                String phone = (String) fieldPhone.get(requestModel);
                PierDataSources.instance.setPhone(phone);
            }
            Field fieldCountryCode = requestModel.getClass().getField("country_code");
            if (fieldCountryCode != null) {
                String countryCode = (String) fieldCountryCode.get(requestModel);
                PierDataSources.instance.setCountry_code(countryCode);
            }
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

    private static void setDataSourceResponse(PierJSONObject responseJson) {
        PierJSONObject resultObj = null;
        resultObj = responseJson.getJSONObject("result");
        if (resultObj != null) {
            PierDataSources.instance.setSession_token(resultObj.getString("session_token"));
        }
    }


}

