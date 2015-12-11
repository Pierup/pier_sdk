package com.pierup.pierpaysdk.cn;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.pierup.pierpaysdk.cn.security.PierHttpClientUtil;
import com.pierup.pierpaysdk.cn.security.network.HttpClient;
import com.pierup.pierpaysdk.cn.security.network.HttpHandler;
import com.pierup.pierpaysdk.cn.security.network.HttpMethod;
import com.pierup.pierpaysdk.cn.security.network.HttpParams;
import com.pierup.pierpaysdk.cn.security.network.HttpResponse;
import com.pierup.pierpaysdk.cn.security.service.PierNetwork;
import com.pierup.pierpaysdk.cn.security.service.PierServiceConfig;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;

public class PierBaseActivity extends AppCompatActivity implements View.OnClickListener {

    private String https_get_url = "/common_api_cn/v1/query/all_provinces";
    private String https_post_url = "/user_api_cn/v1/user/user_info";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pier_base);

        setupView();
    }

    private void setupView() {
        Button localButton = (Button) findViewById(R.id.login_button);
        localButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.login_button: {
                requestService();
                break;
            }
        }
    }

    private void requestService() {
        HttpParams httpParams = new HttpParams();
        httpParams.put("session_token", "test");
        httpParams.put("user_id", "UR0000008537");
        httpParams.put("device_token", "test");
        new PierNetwork(HttpMethod.GET, https_get_url, httpParams, this) {

            @Override
            public void onSuccess(HttpResponse response) {
                String message = response.responseMessage;
                String body = response.responseBody;

                Toast.makeText(getApplicationContext(), body, Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onFailure(HttpResponse response) {
                String message = response.responseMessage;
                String body = response.responseBody;

                Toast.makeText(getApplicationContext(), body, Toast.LENGTH_SHORT).show();
            }
        }.start();
    }














    private String http_get_url = "http://api.map.baidu.com/telematics/v3/weather";
    private String http_post_url = "http://www.baidu.com/s";

    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            String test = "Succeed";
        };
    };

    private void requestHTTPService() {
        new Thread(){
            public void run() {
                HashMap<String, String> params = new HashMap<String, String>();
                try {
                    params.put("location", URLEncoder.encode("上海", PierHttpClientUtil.QUERY_ENCODING));
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                params.put("output", "json");
                params.put("ak", "wl82QREF9dNMEEGYu3LAGqdU");
                String result = PierHttpClientUtil.get(http_get_url, params);
                Toast.makeText(getApplicationContext(), result, Toast.LENGTH_SHORT).show();
                mHandler.sendEmptyMessage(1);
            };
        }.start();
    }

    private void requestHTTPS_GET_Service() {
        new Thread(){
            public void run() {
                HashMap<String, String> params = new HashMap<String, String>();
                params.put("wd", "android");
                String result = PierHttpClientUtil.get(PierServiceConfig.host_production_sdk + https_get_url, params);
                Toast.makeText(getApplicationContext(), result, Toast.LENGTH_SHORT).show();
                mHandler.sendEmptyMessage(1);
            };
        }.start();
    }

    private void requestHTTPS_POST_Service() {
        new Thread(){
            public void run() {
                HashMap<String, String> params = new HashMap<String, String>();
                params.put("session_token", "test");
                params.put("user_id", "UR0000008537");
                params.put("device_token", "test");
                String result = PierHttpClientUtil.post(https_post_url, params);
                Toast.makeText(getApplicationContext(), result, Toast.LENGTH_SHORT).show();
                mHandler.sendEmptyMessage(1);
            };
        }.start();
    }

    protected void onDestroy() {
        super.onDestroy();
        mHandler.removeCallbacksAndMessages(null);
    };

    public int getResourseIdByName(String className, String name) {
        Class r = null;
        int id = 0;
        try {
            r = Class.forName(getApplicationContext().getPackageName() + ".R");

            Class[] classes = r.getClasses();
            Class desireClass = null;

            for (int i = 0; i < classes.length; i++) {
                if (classes[i].getName().split("\\$")[1].equals(className)) {
                    desireClass = classes[i];
                    break;
                }
            }

            if (desireClass != null)
                id = desireClass.getField(name).getInt(desireClass);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }

        return id;
    }

}
