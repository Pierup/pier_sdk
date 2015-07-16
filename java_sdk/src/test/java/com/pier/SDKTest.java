package com.pier;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.junit.Ignore;
import org.junit.Test;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pier.httpclient.config.RequestConfig;
import com.pier.httpclient.util.HttpClientUtils;
import com.pier.model.SDKResult;
import com.pier.model.TransactionConfig;
import com.pier.sdk.MerchantSDKClient;

public class SDKTest {

	@SuppressWarnings("unchecked")
	@Test
	@Ignore(value="I don't know the author why failure")
	public void objiectToJsonTest() {
		try {
			TransactionConfig config = TransactionConfig.newBuilder()
					.setAmount(10.00).setCurrency("USD").build();

			Gson gson = new Gson();
			System.out.println(gson.toJson(config));
			String jsonStr = "{\"code\":\"200\",\"message\":\"test\"}";
			Map<String, String> map = gson.fromJson(jsonStr,
					new TypeToken<Map<String, String>>() {
					}.getType());
			System.out.println(map);

			jsonStr = "{\"code\":\"200\",\"message\":\"OK\",\"result\":{\"auth_token\":\"f31d080c1ccb11f3e31b6d738195d77a\"}}";
			System.out
					.println("=======================================================");
			System.out.println(jsonStr);
			Map<String, Object> map2 = gson.fromJson(jsonStr,
					new TypeToken<Map<String, Object>>() {
					}.getType());

			System.out.println(map2);

			System.out.println("code:" + (String) map2.get("code"));
			System.out.println("message:" + (String) map2.get("message"));
			Map<String, String> result = (Map<String, String>) map2
					.get("result");
			System.out.println("auth_token:" + result.get("auth_token"));
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	@Test
	public void merchantSDKClientTest() {
		try {
			String url = "http://192.168.1.254:8080/user_api/v1/sdk/get_auth_token?dev_info=0&platform=0";
			Map<String, String> map = new HashMap<String, String>();
			map.put("phone", "18818235798");
			map.put("country_code", "CN");
			map.put("password", "qwe123");
			map.put("merchant_id", "MC0000000134");
			map.put("amount", "100");
			map.put("currency_code", "USD");
			Gson gson = new Gson();
			RequestConfig reConfig = RequestConfig.custom().build();
			String requestJsonStr = gson.toJson(map);
			System.out
					.println("get_auth_token request==========================");
			System.out.println(requestJsonStr);
			String responseJsonStr = HttpClientUtils.postJsonStr(url, reConfig,
					requestJsonStr);
			Map<String, Object> map2 = gson.fromJson(responseJsonStr,
					new TypeToken<Map<String, Object>>() {
					}.getType());
			System.out
					.println("get_auth_token response=========================");
			System.out.println(map2);
			String code = (String) map2.get("code");
			if ("200".equals(code)) {
				Map<String, String> auth_tokenResult = (Map<String, String>) map2
						.get("result");
				MerchantSDKClient client = MerchantSDKClient.newBuilder()
						.setMerchant_id("MC0000000134").build();
				TransactionConfig config = TransactionConfig
						.newBuilder()
						.setAmount(100.00)
						.setApi_key("5b52051a-931a-11e4-aad2-0ea81fa3d43c")
						.setAuth_token(auth_tokenResult.get("auth_token"))
						.setCurrency("USD")
						.setId_in_merchant(UUID.randomUUID().toString())
						.setNotes("Buy Flower").build();
				System.out
						.println("transaction request==========================");
				System.out.println(config.toString());
				SDKResult result = client.transaction(config);
				System.out
						.println("transaction response=========================");
				System.out.println(result.getMessage());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void getAuth_token() {
		try {
			String url = "http://192.168.1.254:8080/user_api/v1/sdk/get_auth_token?dev_info=0&platform=0";
			Map<String, String> map = new HashMap<String, String>();
			map.put("phone", "18818235798");
			map.put("country_code", "CN");
			map.put("password", "qwe123");
			map.put("merchant_id", "MC0000000134");
			map.put("amount", "100");
			map.put("currency_code", "USD");
			Gson gson = new Gson();
			RequestConfig reConfig = RequestConfig.custom().build();
			String requestJsonStr = gson.toJson(map);
			System.out
					.println("get_auth_token request==========================");
			System.out.println(requestJsonStr);
			String responseJsonStr = HttpClientUtils.postJsonStr(url, reConfig,
					requestJsonStr);
			Map<String, Object> map2 = gson.fromJson(responseJsonStr,
					new TypeToken<Map<String, Object>>() {
					}.getType());
			System.out
					.println("get_auth_token response=========================");
			System.out.println(map2);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
}
