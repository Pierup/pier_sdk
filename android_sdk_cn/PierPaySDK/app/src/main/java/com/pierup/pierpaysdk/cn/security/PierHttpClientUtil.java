package com.pierup.pierpaysdk.cn.security;

import android.util.Log;
import android.widget.Toast;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import org.apache.http.HttpStatus;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

/**
 * Created by wangbei on 12/9/15.
 */
public class PierHttpClientUtil {

    private static String TAG = "PierHttpClientUtil";

    //设置URLConnection的连接超时时间
    private final static int CONNET_TIMEOUT = 5 * 1000;
    //设置URLConnection的读取超时时间
    private final static int READ_TIMEOUT = 5 * 1000;
    //设置请求参数的字符编码格式
    public final static String QUERY_ENCODING = "UTF-8";
    //设置返回请求结果的字符编码格式
    private final static String ENCODING = "UTF-8";

    /**
     *
     * @param url
     * 		请求链接
     * @return
     * 		HTTP GET请求结果
     */
    public static String get(String url) {
        return get(url, null);
    }

    /**
     *
     * @param url
     * 		请求链接
     * @param params
     * 		HTTP GET请求的QueryString封装map集合
     * @return
     * 		HTTP GET请求结果
     */
    public static String get(String url, Map<String, String> params) {
        InputStream is = null;
        try {
            StringBuffer queryString = null;
            if (params != null && params.size() > 0) {
                queryString = new StringBuffer("?");
                queryString = joinParam(params, queryString);
            }
            if (queryString != null) {
//                url = url + URLEncoder.encode(queryString.toString(), QUERY_ENCODING);
                url = url + queryString.toString();
            }
//            URL localURL = new URL(url);
//            HttpURLConnection localConnection = (HttpURLConnection) localURL.openConnection();
            URL localURL = new URL(url);
            HttpURLConnection localConnection = null;
            if (localURL.getProtocol().toLowerCase().equals("https")) {
                localConnection = (HttpsURLConnection)localURL.openConnection();
            } else {
                localConnection = (HttpURLConnection)localURL.openConnection();
            }
            localConnection.setUseCaches(false);
            localConnection.setConnectTimeout(CONNET_TIMEOUT);
            localConnection.setReadTimeout(READ_TIMEOUT);
            localConnection.setRequestMethod("GET");
            if (localConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                is = localConnection.getInputStream();
                return PierStreamUtil.readStreamToString(is, ENCODING);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    /**
     *
     * @param url
     * 		请求链接
     * @param params
     * 		HTTP POST请求body的封装map集合
     * @return
     *
     */
    public static String post(String url, Map<String, String> params) {
        if (params == null || params.size() == 0) {
            return null;
        }
        OutputStream os = null;
        InputStream is = null;
        StringBuffer body = new StringBuffer();
        body = joinParam(params, body);
        byte[] data = body.toString().getBytes();
        try {
            URL localURL = new URL(url);
            HttpsURLConnection localConnection = null;
            if (localURL.getProtocol().toLowerCase().equals("https")) {
                SSLContext sslcontext = SSLContext.getInstance("TLS");
                sslcontext.init(null, new TrustManager[]{new MyX509TrustManager()}, new SecureRandom());
                HttpsURLConnection.setDefaultSSLSocketFactory(sslcontext.getSocketFactory());
                HttpsURLConnection.setDefaultHostnameVerifier(new MyHostnameVerifier());

//                trustAllHosts();
                // 创建HttpsURLConnection对象，并设置其SSLSocketFactory对象
                localConnection = (HttpsURLConnection)localURL.openConnection();
                //设置套接工厂
                localConnection.setSSLSocketFactory(sslcontext.getSocketFactory());
            } else {
//                localConnection = (HttpURLConnection)localURL.openConnection();
            }
            localConnection.setConnectTimeout(CONNET_TIMEOUT);
            localConnection.setReadTimeout(READ_TIMEOUT);
            localConnection.setRequestMethod("POST");

            // 请求头, 必须设置
            localConnection.setRequestProperty("Content-Type", "application/json");
            localConnection.setRequestProperty("Content-Length", String.valueOf(data.length));
            // post请求必须允许输出
            localConnection.setDoOutput(true);
            localConnection.setDoInput(true);
            // 向服务器写出数据
            os = localConnection.getOutputStream();
            os.write(data);
            if (localConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                // 取得该连接的输入流，以读取响应内容
                is = localConnection.getInputStream();
                String message = PierStreamUtil.readStreamToString(is, ENCODING);
                // 读取服务器的响应内容并显示
                return message;
            } else {
                InputStream errorStream = localConnection.getErrorStream();
                String message = PierStreamUtil.readStreamToString(errorStream, ENCODING);
                return message;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (os != null) {
                try {
                    os.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    /**
     *
     * @param url
     * 		请求链接
     * @param params
     * 		HTTP POST请求文本参数map集合
     * @param files
     * 		HTTP POST请求文件参数map集合
     * @return
     * 		HTTP POST请求结果
     * @throws IOException
     */
    public static String post(String url, Map<String, String> params, Map<String, File> files) throws IOException {
        String BOUNDARY = UUID.randomUUID().toString();
        String PREFIX = "--", LINEND = "\r\n";
        String MULTIPART_FROM_DATA = "multipart/form-data";

        URL localURL = new URL(url);
        HttpURLConnection localConnection = (HttpURLConnection) localURL.openConnection();
        // 缓存的最长时间
        localConnection.setReadTimeout(READ_TIMEOUT);
        // 允许输入
        localConnection.setDoInput(true);
        // 允许输出
        localConnection.setDoOutput(true);
        // 不允许使用缓存
        localConnection.setUseCaches(false);
        localConnection.setRequestMethod("POST");
        localConnection.setRequestProperty("connection", "keep-alive");
        localConnection.setRequestProperty("charset", QUERY_ENCODING);
        localConnection.setRequestProperty("Content-Type", MULTIPART_FROM_DATA + ";boundary=" + BOUNDARY);

        // 首先组拼文本类型的参数
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            sb.append(PREFIX);
            sb.append(BOUNDARY);
            sb.append(LINEND);
            sb.append("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"" + LINEND);
            sb.append("Content-Type: text/plain; charset=" + ENCODING + LINEND);
            sb.append("Content-Transfer-Encoding: 8bit" + LINEND);
            sb.append(LINEND);
            sb.append(entry.getValue());
            sb.append(LINEND);
        }

        DataOutputStream outStream = new DataOutputStream(localConnection.getOutputStream());
        outStream.write(sb.toString().getBytes());
        // 发送文件数据
        if (files != null)
            for (Map.Entry<String, File> file : files.entrySet()) {
                StringBuilder sb1 = new StringBuilder();
                sb1.append(PREFIX);
                sb1.append(BOUNDARY);
                sb1.append(LINEND);
                sb1.append("Content-Disposition: form-data; name=\"uploadfile\"; filename=\""
                        + file.getValue().getName() + "\"" + LINEND);
                sb1.append("Content-Type: application/octet-stream; charset=" + ENCODING + LINEND);
                sb1.append(LINEND);
                outStream.write(sb1.toString().getBytes());

                InputStream is = new FileInputStream(file.getValue());
                byte[] buffer = new byte[1024];
                int len = 0;
                while ((len = is.read(buffer)) != -1) {
                    outStream.write(buffer, 0, len);
                }
                is.close();
                outStream.write(LINEND.getBytes());
            }

        // 请求结束标志
        byte[] end_data = (PREFIX + BOUNDARY + PREFIX + LINEND).getBytes();
        outStream.write(end_data);
        outStream.flush();
        StringBuilder sb2 = new StringBuilder();
        if (localConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
            InputStream in = localConnection.getInputStream();
            int ch;
            while ((ch = in.read()) != -1) {
                sb2.append((char) ch);
            }
        }
        outStream.close();
        localConnection.disconnect();
        return sb2.toString();
    }

    /**
     *
     * @param params
     * @param queryString
     * @return
     * 	返回拼接后的StringBuffer
     */
    private static StringBuffer joinParam(Map<String, String> params, StringBuffer queryString) {
        Iterator<Entry<String, String>> iterator = params.entrySet().iterator();
        while (iterator.hasNext()) {
            Entry<String, String> param = iterator.next();
            String key = param.getKey();
            String value = param.getValue();
            queryString.append(key).append('=').append(value);
            if (iterator.hasNext()) {
                queryString.append('&');
            }
        }
        return queryString;
    }



    /**
     * Trust every server - dont check for any certificate
     */
    private static void trustAllHosts() {
        final String TAG = "trustAllHosts";
        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {

            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return new java.security.cert.X509Certificate[] {};
            }

            public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                Log.i(TAG, "checkClientTrusted");
            }

            public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                Log.i(TAG, "checkServerTrusted");
            }
        } };

        // Install the all-trusting trust manager
        try {
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 实现用于主机名验证的基接口。
     * 在握手期间，如果 URL 的主机名和服务器的标识主机名不匹配，则验证机制可以回调此接口的实现程序来确定是否应该允许此连接。
     */
    private static class MyHostnameVerifier implements HostnameVerifier{

        @Override
        public boolean verify(String hostname, SSLSession session) {
            // TODO Auto-generated method stub
            if("api.pierup.cn".equals(hostname)){
                System.out.println("Warning: URL Host: " + hostname + " vs. "
                        + session.getPeerHost());
                return true;
            } else {
                return false;
            }
        }
    }

    private static class MyX509TrustManager implements X509TrustManager {

        @Override
        public void checkClientTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {
            // TODO Auto-generated method stub
            System.out.println("cert: " + chain[0].toString() + ", authType: "
                    + authType);
        }

        @Override
        public void checkServerTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {
            // TODO Auto-generated method stub
            System.out.println("cert: " + chain[0].toString() + ", authType: "
                    + authType);
        }

        @Override
        public X509Certificate[] getAcceptedIssuers() {
            // TODO Auto-generated method stub
            return null;
        }
    }
}