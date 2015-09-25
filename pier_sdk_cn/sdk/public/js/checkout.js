/**
 * @author Cheng Cong
 * @description add register
 * @util.isDate( 2015-09-21 );
 */
(function( window ){
	window = this ;
    PIER = window.PIER = {
    	version: '1.0.0'
    };
    PIER.initSDK = function( options, callback ){
    	var _options = options || {};
        var _orderDetailTemp = [];
        var _pierAmount = _options.amount || ''; //*
        var _merchantId = _options.merchant_id || ''; //*
        var _currency = _options.currency || '';
        var _orderId = _options.order_id || '';
        var _apiKey = _options.api_id || '';
        var _orderDetail = _options.order_detail || {};
        var _returnUrl = _options.return_url || '';
        var _sign = _options.sign || '';
        var _signType = _options.sign_type || '';
        var _charset = _options.charset || '';
        var _callBack = callback;
        var _callbackDefault = _options.callback_default || false;
        var _payBtnId = _options.pay_button_id || '';
        var notEmpty = function( array ){
            var _array = array;
            if ( typeof _array != 'object' ){
                throw new Error( "参数错误！" );
                return;
            }else{
                for( var i in _array ){
                    if( _array[i] == '' || _array[i] == undefined || _array[i] == null ){
                        throw new Error( '参数错误！ '+i+'不能为空' );
                        return;
                    }
                }
            }
        }
        notEmpty( { amount: _pierAmount, merchant_id: _merchantId, currency: _currency, api_key: _apiKey, return_url: _returnUrl,sign: _sign,sign_type: _signType,charset: _charset, pay_button_id: _payBtnId } );
        //For constant
        var CONSTANT = {
            HTTP_PROXY: 'http:',
            ACTION_POST_URL: '/checkout/login',///'//pierup.cn:4000/checkout/login',
            ORDER_DETAIL_ATTR: [ 'product', 'logo', 'detail', 'type', 'price', 'count', 'total' ]
        }
        if( _orderId == '' || _orderId == undefined || _orderId == null ){
            for( _detail in _orderDetail ){
                var _obj = _orderDetail[_detail];
                _orderDetailTemp[_detail] = {};
                for( var m = 0; m<CONSTANT.ORDER_DETAIL_ATTR.length; m++ ){
                    if( _obj.hasOwnProperty( CONSTANT.ORDER_DETAIL_ATTR[m] ) ){
                        _orderDetailTemp[_detail][CONSTANT.ORDER_DETAIL_ATTR[m]] = _orderDetail[_detail][CONSTANT.ORDER_DETAIL_ATTR[m]];
                    }else{
                        throw new Error( '对不起，您传的第'+(parseFloat(_detail)+1)+'个商品的属性：'+CONSTANT.ORDER_DETAIL_ATTR[m]+'不能为空' );
                        return;
                    }
                }
            }
        }else{
            for( _detail in _orderDetail ){
                var _obj = _orderDetail[_detail];
                _orderDetailTemp[_detail] = {};
                for( var m = 0; m<CONSTANT.ORDER_DETAIL_ATTR.length; m++ ){
                    if( _obj.hasOwnProperty( CONSTANT.ORDER_DETAIL_ATTR[m] ) ){
                        _orderDetailTemp[_detail][CONSTANT.ORDER_DETAIL_ATTR[m]] = _orderDetail[_detail][CONSTANT.ORDER_DETAIL_ATTR[m]];
                    }else{
                        _orderDetailTemp[_detail][CONSTANT.ORDER_DETAIL_ATTR[m]]  = '';
                    }
                }
            }
        }
        if( _orderDetail != '' ){
            _orderDetail = JSON.stringify( _orderDetailTemp );
        }
 
        var pierBtn = document.querySelector('[id="'+_payBtnId+'"]');
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

        ss.addRule( '.pier-overlay', 'position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:rgba(0,0,0,0.3);visibility:visible;opacity:1;font-size:10px;');
        ss.addRule( '.pier-checkout-check', 'margin:0 auto; width:380px;height:220px;background: transparent; border:1px solid #ccc;margin-top: 80px;border-top: 0px;')
        ss.addRule( '.pier-checkout-check button', 'width: 120px;height: 38px; text-align: center;border:1px solid #ccc;margin-top:100px;cursor:pointer;')
        ss.addRule( '.pier-checkout-check button:hover', 'background: #fff;');
        ss.addRule( '.mL-20', 'margin-left:20px;')

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
            temp_form.action = CONSTANT.HTTP_PROXY+CONSTANT.ACTION_POST_URL;      
            temp_form.target = "_blank";
            temp_form.method = "post";      
            temp_form.style.display = "none"; 
            var PARAMS = {
			  	amount: _pierAmount,
			  	currency: _currency,
                order_id: _orderId,
                api_id: _apiKey,
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
            if( !_callbackDefault ){
                _callBack.call(this);
            }else{
                parentElem.appendChild( overlay );
            }
        }
    }
})( window )

