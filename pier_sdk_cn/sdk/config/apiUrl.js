// var hostName = ;
var apiurl = {
	hostName: 'https://121.40.19.24:8443',//'https://121.40.19.24:8443',//'http://pierup.asuscomm.com:8686',
	port:'8686',
	getCountries: {url: '/common_api/v1/query/get_countries', method: 'GET' },
	
	//forget password
	sdkSMSPsdForget: {url: '/user_api_cn/v1/user/sms_password_forget?platform=1' },
	sdkSMSPsdCheck: {url: '/user_api_cn/v1/user/sms_password_check?platform=1'},
	sdkResetPsd: {url: '/user_api_cn/v1/user/sms_password_reset?platform=1'},

	//register flow
	regActivationCode: {url: '/user_api_cn/v1/user/activation_code?platform=3' },
	regActivate: {url: '/user_api_cn/v1/user/activate?platform=3' },
	regUser: {url: '/user_api_cn/v1/user/register_user?platform=3' },
	regSaveUserBasic: {url:'/user_api_cn/v1/user/save_user_basic?platform=3' },
	regUserInfo: {url:'/user_api_cn/v1/user/user_info?platform=3'},
	regUpdateUser: {url: '/user_api_cn/v1/user/update_user?platform=3'},
	regLinkBankCard: {url: '/user_api_cn/v1/user/link_bank_card?platform=3'},
	regVerifyBank: {url:'/user_api_cn/v1/user/verify_bank_card?platform=3'},
	regSetPayPsd: {url:'/user_api_cn/v1/user/set_pay_password?platform=3'},
	bankCardInfo: {url: '/common_api_cn/v1/query/bank_card_info?platform=3', method: 'GET'},
	regGetBankCards :{url: '/user_api_cn/v1/user/bank_cards?platform=3' },
	regApplyCredit: {url: '/user_api_cn/v1/user/apply_credit?platform=3' },

	//checkout flow
	checkoutLogin: {url:'/user_api_cn/v1/user/signin?platform=3'},
	checkoutSMS: {url: '/user_api_cn/v1/user/transaction_sms?platform=3'},
	checkoutPay: {url: '/user_api_cn/v1/user/pay_by_pier?platform=3'},

	//reset pay password
	forgetPaymentPassword: {url:'/user_api_cn/v1/user/forget_payment_password?platform=3'},
	forgetPaymentPasswordValidate: {url: '/user_api_cn/v1/user/forget_payment_password_validate?platform=3'},
	forgetPaymentPasswordReset: {url: '/user_api_cn/v1/user/forget_payment_password_reset?platform=3'},

	//order information
    saveOrderInfo: {url: '/user_api_cn/v1/user/save_order_info?platform=3'},
    orderInfo: {url: '/user_api_cn/v1/user/order_info?platform=3' },

    //prepay
    prePay: {url: '/user_api_cn/v1/user/pay_prepare?platform=3' },
    checkPayPassword: {url: '/user_api_cn/v1/user/check_pay_password?platform=3' },

    //get sign for test
    getDigitalSign: { url: '/pier-merchant-cn/demo/pay/sign/MC0000001409?platform=3' },

    //add bank account by lianlian
    cardValidation: { url: '/user_api_cn/v1/lianlian/card_validation?platform=3' },
    payCallback: { url: '/user_api_cn/v1/lianlian/callback_validation?platform=3'}

}
module.exports = apiurl;