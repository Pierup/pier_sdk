package com.pierup.pierpaysdk.cn;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.pierup.pierpaysdk.cn.business.PierObject;
import com.pierup.pierpaysdk.cn.business.bean.PierRootBean;
import com.pierup.pierpaysdk.cn.business.bean.PierSDKBean;
import com.pierup.pierpaysdk.cn.security.PierHttpClientUtil;
import com.pierup.pierpaysdk.cn.service.network.PierNetwork;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;

import static com.pierup.pierpaysdk.cn.business.PierServiceEnumSDK.getProvince;

public class PierBaseActivity extends AppCompatActivity implements View.OnClickListener {

    private String result;

    private String https_get_url = "https://api.pierup.cn/common_api_cn/v1/query/all_provinces";
    private String https_post_url = "https://api.pierup.cn/user_api_cn/v1/user/user_info";

    private String http_get_url = "http://api.map.baidu.com/telematics/v3/weather";
    private String http_post_url = "http://www.baidu.com/s";

    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            String test = "Succeed";
        };
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pier_base);
//        setContentView(getResourseIdByName("layout", "activity_pier_base"))
        setupView();

        requestProvinceService();
    }

    private void setupView() {
        Button localButton = (Button) findViewById(R.id.login_button);
        localButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.login_button: {
                requestHTTPS_POST_Service();
                break;
            }
        }
    }

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
                result = PierHttpClientUtil.get(http_get_url, params);
                mHandler.sendEmptyMessage(1);
            };
        }.start();
    }

    private void requestHTTPS_GET_Service() {
        new Thread(){
            public void run() {
                HashMap<String, String> params = new HashMap<String, String>();
                params.put("wd", "android");
                result = PierHttpClientUtil.get(https_get_url, params);
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
                result = PierHttpClientUtil.post(https_post_url, params);
                mHandler.sendEmptyMessage(1);
            };
        }.start();
    }

    protected void onDestroy() {
        super.onDestroy();
        mHandler.removeCallbacksAndMessages(null);
    };

//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.menu_pier_home, menu);
////        getMenuInflater().inflate(getResourseIdByName("menu", "menu_pier_home"), menu);
//        return true;
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//        // Handle action bar item clicks here. The action bar will
//        // automatically handle clicks on the Home/Up button, so long
//        // as you specify a parent activity in AndroidManifest.xml.
//        int id = item.getItemId();
//
//        //noinspection SimplifiableIfStatement
//        if (id == R.id.action_settings) {
//            return true;
//        }
////        if (id == getResourseIdByName("id", "action_settings")) {
////            return true;
////        }
//
//        return super.onOptionsItemSelected(item);
//    }

    private void requestProvinceService() {
        PierSDKBean sdkBean = new PierSDKBean();
        new PierNetwork(getProvince, this, sdkBean) {
            @Override
            public void onSuccess(PierRootBean bean, PierObject result) {
                PierObject response = (PierObject) result;

            }

            @Override
            public void onFailure(PierRootBean bean, String result, Throwable error) {

            }
        }.start();
    }

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
