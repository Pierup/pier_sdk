package com.pierup.pierpaysdk.cn.widget.h5;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.pierup.pierpaysdk.cn.extern.PierResourceIdUtil;

public class PierH5Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_pier_h5);
        setContentView(PierResourceIdUtil.getResourseIdByName(this, "layout", "activity_pier_h5"));

        setupWebView();
    }

    private void setupWebView() {
//        WebView webView = (WebView) findViewById(R.id.h5_webView);
        WebView webView = (WebView) findViewById(PierResourceIdUtil.getResourseIdByName(this, "id", "h5_webView"));
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        Bundle bundle = getIntent().getExtras();
        String URL = bundle.getString("url");
        webView.loadUrl(URL);

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // TODO Auto-generated method stub
                view.loadUrl(url);
                return true;
            }
        });
    }


}
