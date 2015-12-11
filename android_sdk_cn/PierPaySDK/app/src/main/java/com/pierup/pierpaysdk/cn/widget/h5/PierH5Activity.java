package com.pierup.pierpaysdk.cn.widget.h5;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.pierup.pierpaysdk.cn.R;

public class PierH5Activity extends AppCompatActivity {

    private WebView webView;
    private Bundle bundle;
    private String htmlData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pier_h5);

//        setupWebView();
    }

    private void setupWebView() {
        bundle = getIntent().getExtras();
        boolean loadData = bundle.getBoolean("load_data");
        htmlData = bundle.getString("data");
        String title = bundle.getString("title");


        webView = (WebView) findViewById(R.id.h5_webView);
        String URL = bundle.getString("url");
        webView.loadUrl(URL);
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        webSettings.setBuiltInZoomControls(true);
        webSettings.supportMultipleWindows();
        webSettings.setAppCacheEnabled(false);

        if (!loadData && !(htmlData != null && htmlData.length() > 0)) {
            webView.setWebViewClient(new WebViewClient() {
                @Override
                public boolean shouldOverrideUrlLoading(WebView view, String url) {
                    view.loadUrl(url);
                    return true;
                }
            });
        } else {
            if (htmlData != null && htmlData.length() > 0) {
                webView.loadData(htmlData, "text/html; charset=UTF-8", null);
            }
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && webView.canGoBack()) {
            webView.goBack();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.menu_pier_h5, menu);
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
//
//        return super.onOptionsItemSelected(item);
//    }
}
