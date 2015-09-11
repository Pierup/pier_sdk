/**
 * @author Cheng Cong
 * @description add register
 */
(function(){
	window = this ;
    PIER = window.PIER = {
    	version: '0.0.1'
    };
    PIER.initSDK = function( options ){
    	var options = options || {};
        var _pierAmount = options.amount || ''; //*
        var _merchantId = options.merchant_id || ''; //*
        var _currency = options.currency || '';
        var _cssStyle = options.css_style || ''; 
        var _orderId = options.order_id || '';
        var _apiKey = options.api_id || '';
        var _orderDetail = options.order_detail || '';
        var _apiSecretKey = options.api_secret_key || '';
        var _merchantName = options.merchant_name || '';
        var _urlAction = options.data_action || '';
        var _returnUrl = options.return_url || '';
        var _callBack = options.callBack || '';
        var _sign = options.sign || '';
        var _signType = options.sign_type || '';
        var _charset = options.charset || '';
 
        var pierBtn = document.querySelector('div[id="pierPay"]');
        console.log( pierBtn );
        // create  CSS styles
		var styleElem = document.createElement( 'style' );
		// for WebKit
		// styleElem.appendChild( document.createTextNode( '' ) );
		document.head.appendChild( styleElem );

		var ss = styleElem.sheet;
		//for firefox not support addRule, instead of insertRule.
        if( !ss.addRule ){
        	ss.addRule = function( selector, style ){
        		var index = ss.cssRules.length; 
        		ss.insertRule( selector+'{'+style+'}', index );
        	}
        }
        ss.addRule( '.pier-payment-btn', 'width:120px;height:32px;border:1px solid #ccc; cursor:pointer;');
        ss.addRule( '.pier-payment-btn:hover', 'width:120px;height:32px;border:1px solid #7b37a6; cursor:pointer;');
        ss.addRule( '.pier-payment-btn img', 'width:24px;height:24px;display:inline-block;margin-top:4px;margin-left:14px;margin-right:4px;');
        ss.addRule( '.pier-payment-btn span', ' font-size:14px;display:inline-block;float:right;margin-top:8px;margin-right:14px;');
        ss.addRule( '.pier-overlay', 'position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:rgba(0,0,0,0.4);visibility:visible;opacity:1;font-size:10px;');
        ss.addRule( '.pier-checkout-check', 'margin:0 auto; width:380px;height:220px;background: transparent; border:1px solid #ccc;margin-top: 80px;border-top: 0px;')
        ss.addRule( '.pier-checkout-check button', 'width: 120px;height: 38px; text-align: center;border:1px solid #ccc;margin-top:100px;cursor:pointer;')
        ss.addRule( '.pier-checkout-check button:hover', 'background: #fff;');
        ss.addRule( '.mL-20', 'margin-left:20px;')
        pierBtn.classList.add( 'pier-payment-btn' );
        // shadow mask
        var overlay = document.createElement( 'div' );
        var pierCheckoutCheck = document.createElement( 'div' );
        pierCheckoutCheck.classList.add( 'pier-checkout-check');
        var btn1 = document.createElement( 'button' );
        var btn2 = document.createElement( 'button' );
        btn2.classList.add('mL-20');
        btn1.innerHTML = '支付成功';
        btn2.innerHTML = '支付遇到问题';

        pierCheckoutCheck.appendChild( btn1 );
        pierCheckoutCheck.appendChild( btn2 );

        // overlay mask setting
        overlay.classList.add( 'pier-overlay' );
        var parentElem = pierBtn.parentElement;
        overlay.appendChild( pierCheckoutCheck );

        btn1.onclick=function(){
            window.location.href = _returnUrl;
        }
        btn2.onclick=function(){
            window.location.href = _returnUrl;
        }


        pierBtn.onclick = function(){
        	var temp_form = document.createElement("form");      
            temp_form.action = _urlAction;      
            temp_form.target = "_blank";
            temp_form.method = "post";      
            temp_form.style.display = "none"; 
            var PARAMS = {
			  	amount: _pierAmount,
			  	currency: _currency,
                order_id: _orderId,
                api_id: _apiKey,
                api_secret_key: _apiSecretKey,
                merchant_id: _merchantId,
                order_detail: _orderDetail,
                return_url: _returnUrl,
                sign: _sign,
                sign_type:_signType,
                charset: _charset
            };
            for (var x in PARAMS) 
            {   
            	var opt = document.createElement("textarea");      
                opt.name = x;      
                opt.value = PARAMS[x];      
                temp_form .appendChild(opt);      
            }      
            document.body.appendChild(temp_form);      
            temp_form.submit(); 
            if( _callBack == '' ){
                parentElem.appendChild( overlay );
            }else{
                _callBack.call(this);
            }
        }
    }
})()

