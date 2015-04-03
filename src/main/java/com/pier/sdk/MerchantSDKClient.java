package com.pier.sdk;

import org.apache.commons.lang3.StringUtils;

/**
 * 
 * @ClassName: MerchantSDK
* @Description: merchant sdk service
* @author Caliph.Chen clp_job@163.com
* @date 2015年1月21日 下午8:03:26
 */
public class MerchantSDKClient extends AbstractSDK{
	
	private MerchantSDKClient(Builder builder)
	{
		super(builder.merchant_id);
	}
	
	public static Builder newBuilder()
	{
		return new Builder();
	}
	
	public static class Builder{
		private String merchant_id;
		
		public Builder()
		{
			super();
		}

		public Builder setMerchant_id(String merchant_id) {
			this.merchant_id = merchant_id;
			return this;
		}
		
		public MerchantSDKClient build()throws Exception
		{
			if (StringUtils.isBlank(this.merchant_id)) {
				throw new Exception("Required param is missing.");
			}
			return new MerchantSDKClient(this);
		}
	}
}
