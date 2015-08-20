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
        pierBtn.classList.add( 'pier-payment-btn' );
        pierBtn.onclick = function(){
        	var temp_form = document.createElement("form");      
            temp_form.action = _urlAction;      
            temp_form.target = "_blank";
            temp_form.method = "post";      
            temp_form.style.display = "none"; 
            var PARAMS = {
            	merchant_name: _merchantName,
			  	amount: _pierAmount,
			  	currency: _currency,
                order_id: _orderId,
                api_id: _apiKey,
                api_secret_key: _apiSecretKey,
                merchant_id: _merchantId,
                order_detail: _orderDetail
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
        }
    }
})()

