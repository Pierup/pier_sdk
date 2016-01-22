/**
 * 品而中国版支付SDK
 * @version regular1.1.0
 * @return PIER    PIER对象，用于支付的实例对象
 * @author Flower
 * @date
 */
(function(w){
	//for stylesheet and container
    var styleSheet, styleElem, _OPTIONS, _callback;
    var _pierPayBtn, _pierOverlay, _flipWrap, _flipContainer, 
    _loginContainer,
    _cfmContainer,
    _payRstContainer,
    _regContainer,
    _applyContainer,
    _applyRstContainer;

    var modules = {},
	cache = {},
	_bind = function(fn, me) {
		return function() {
			return fn.apply(me, arguments)
		}
	};

    /**api**/
    function Api(){ this.getHost = _bind( this.getApi().getHost, this ); };
    Api.prototype.host = 'http://pierup.asuscomm.com:8686';
    Api.prototype.getApi = function(){
    	var apiConfig = {
	        regCode: this.host + '/sdk_register_cn/v1/register/activation_code',
	        regUser: this.host + '/sdk_register_cn/v1/register/register_user',
	        setPin: this.host + '/sdk_register_cn/v1/register/forget_payment_password_reset',
	        signIn: this.host + '/sdk_register_cn/v1/register/signin',
	        bindCard: this.host + '/payment_api/bind_card',
	        verifyCard: this.host + '/payment_api/verify_card?platform=1',
	        express:{
	            prepay: this.host + '/payment_api/prepay_by_card?platform=1',
	            payByCard: this.host + '/payment_api/pay_by_card?platform=1'
	        },
	        savePaymentOrder: this.host + '/payment_api/save_payment_order?platform=1',
	        applyCredit: this.host + '/sdk_register_cn/v1/credit/apply_promotion_credit',
	        getHost: function(){
	        	return this.host;
	        }
	    };
	    return apiConfig;
    };
	/**util**/
    function Util(){};
    Util.

})(window)