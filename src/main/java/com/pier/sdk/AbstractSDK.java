package com.pier.sdk;

import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pier.config.ConfigUtil;
import com.pier.httpclient.client.DefaultDisableJsClient;
import com.pier.httpclient.client.DisableJsClient;
import com.pier.httpclient.config.ClientConfig;
import com.pier.httpclient.config.RequestConfig;
import com.pier.httpclient.util.HttpClientFactory;
import com.pier.model.SDKResult;
import com.pier.model.TransactionConfig;

public abstract class AbstractSDK implements SDKService {
	protected String merchant_id;
	protected static DisableJsClient client;
	protected static String serverUrl;;

	static {
		ClientConfig config = ClientConfig.custom()
				.setConnectionRequestTimeout(1000).setConnectTimeout(1000)
				.setSocketTimeout(60 * 1000).build();
		client = HttpClientFactory.getDisableJsClient(config,
				DefaultDisableJsClient.class);
		serverUrl = ConfigUtil.getString("pier.pay.server.host", "")
				+ "merchant_api/v1/transaction/pay_by_pier";
	}

	public AbstractSDK(String merchant_id) {
		this.merchant_id = merchant_id;
	}

	@SuppressWarnings("unchecked")
	@Override
	public SDKResult transaction(TransactionConfig config) {
		// TODO Auto-generated method stub
		SDKResult result = new SDKResult();
		try {
			config.setMerchant_id(merchant_id);
			Gson gson = new Gson();
			String requestJosnStr = gson.toJson(config);
			RequestConfig requestConfig = RequestConfig.custom()
					.setConnectionRequestTimeout(1000).setConnectTimeout(1000)
					.setSocketTimeout(60 * 1000).build();
			String responseJsonStr = client.postJsonStr(serverUrl,
					requestConfig, requestJosnStr);
			System.out.println(responseJsonStr);
			Map<String, Object> map = gson.fromJson(responseJsonStr,
					new TypeToken<Map<String, Object>>() {
					}.getType());
			if ("200".equals(map.get("code"))) {
				result.setStatus(true);
				result.setCode((String) map.get("code"));
				result.setMessage((String) map.get("message"));
				result.setResult((Map<String, String>) map.get("result"));
			} else {
				result.setStatus(false);
				result.setCode((String) map.get("code"));
				result.setMessage((String) map.get("message"));
				result.setResult((Map<String, String>) map.get("result"));
			}
		} catch (Exception e) {
			// TODO: handle exception
			result.setStatus(false);
			result.setMessage(e.getMessage());
		}
		return result;
	}
}
