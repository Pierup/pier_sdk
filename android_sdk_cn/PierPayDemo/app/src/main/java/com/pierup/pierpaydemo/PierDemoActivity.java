package com.pierup.pierpaydemo;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import com.pierup.pierpaysdk.cn.PierBaseActivity;
import com.pierup.pierpaysdk.cn.PierPaySDK;

public class PierDemoActivity extends AppCompatActivity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pier_demo);

        Button nativeButton = (Button)findViewById(R.id.native_button);
        nativeButton.setOnClickListener(this);

        Button h5Button = (Button)findViewById(R.id.h5_button);
        h5Button.setOnClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_pier_demo, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.native_button: {
                PierPaySDK.startPierPayAction(this);
                break;
            }
            case R.id.h5_button: {
                PierPaySDK.startPierPayAction(this, "http://www.baidu.com");
                break;
            }
        }
    }
}
