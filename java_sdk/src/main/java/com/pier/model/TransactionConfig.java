package com.pier.model;

import java.lang.reflect.Field;

import org.apache.commons.lang3.StringUtils;

public class TransactionConfig {
	private String auth_token;
	private Double amount;
	private String currency;
	private String id_in_merchant;
	private String notes;
	private String api_key;
	private String key_name;
	private String platform = "1";
	private String merchant_id;

	private TransactionConfig(Builder builder) {
		this.amount = builder.amount;
		this.key_name = builder.key_name;
		this.api_key = builder.api_key;
		this.auth_token = builder.auth_token;
		this.currency = builder.currency;
		this.id_in_merchant = builder.id_in_merchant;
		this.notes = builder.notes;
	}

	public String getMerchant_id() {
		return merchant_id;
	}

	public void setMerchant_id(String merchant_id) {
		this.merchant_id = merchant_id;
	}

	public String getAuth_token() {
		return auth_token;
	}

	public Double getAmount() {
		return amount;
	}

	public String getCurrency() {
		return currency;
	}

	public String getId_in_merchant() {
		return id_in_merchant;
	}

	public String getNotes() {
		return notes;
	}
	
	public String getApi_key() {
		return api_key;
	}

	public String getKey_name() {
		return key_name;
	}

	public String getPlatform() {
		return platform;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		StringBuilder builder = new StringBuilder();
		try {
			Field[] fields = this.getClass().getDeclaredFields();
			builder.append("{");
			for (Field field : fields) {
				field.setAccessible(true);
				builder.append("\"").append(field.getName()).append("\":")
					   .append("\"").append(field.get(this)).append("\"")
				       .append(",");
			}
			builder.deleteCharAt(builder.length() - 1);
			builder.append("}");
		} catch (Exception e) {
			// TODO: handle exception
		}
		return builder.toString();
	}

	public static Builder newBuilder() {
		return new Builder();
	}

	public static class Builder {
		private String auth_token;
		private Double amount;
		private String currency;
		private String id_in_merchant;
		private String notes;
		private String api_key;
		private String key_name;

		public Builder() {
			super();
		}

		public Builder setAuth_token(String auth_token) {
			this.auth_token = auth_token;
			return this;
		}

		public Builder setAmount(Double amount) {
			this.amount = amount;
			return this;
		}

		public Builder setCurrency(String currency) {
			this.currency = currency;
			return this;
		}

		public Builder setId_in_merchant(String id_in_merchant) {
			this.id_in_merchant = id_in_merchant;
			return this;
		}

		public Builder setNotes(String notes) {
			this.notes = notes;
			return this;
		}

		public Builder setApi_key(String api_key) {
			this.api_key = api_key;
			return this;
		}

		public Builder setKey_name(String key_name) {
			this.key_name = key_name;
			return this;
		}

		public TransactionConfig build() throws Exception {
			if (StringUtils.isBlank(this.api_key)
					|| StringUtils.isBlank(this.auth_token)) {
				throw new Exception("Required param is missing.");
			}
			if (this.amount<=0) {
				throw new Exception("Amount must be greater than zero.");
			}
			if (StringUtils.isBlank(this.currency)) {
				this.currency = "USD";
			}
			return new TransactionConfig(this);
		}
	}
}
