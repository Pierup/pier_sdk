function TransactionConfig(amount, api_id, api_secret_key, auth_token, currency, id_in_merchant, notes) {
	this.platform = '1'
	this.amount = parseFloat(amount)
	this.api_id = api_id
	this.api_secret_key = api_secret_key
	this.auth_token = auth_token
	this.currency = currency
	this.id_in_merchant = id_in_merchant
	this.notes = notes
}

module.exports = TransactionConfig;