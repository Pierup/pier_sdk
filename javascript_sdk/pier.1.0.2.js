( function() {
	this.Pier = function() {
		// pier-button as anchor to find attach point
		var me = document.querySelector( 'script[class="pier-button"]' );

		if ( me === null ) {
			console.error( 'Class attribute in script must be "pier-button"' );
			return;
		}
			// merchant ID
		var merchantId = me.getAttribute( 'data-merchant-id' ),
			// text displayed in Pier button
			buttonText = me.getAttribute( 'data-button-text' ) || 'Pay with Pier',
			buttonWidth = '120px',
			buttonHeight = '40px',
			name = me.getAttribute( 'data-name' ),
			description = me.getAttribute( 'data-description' ),
			amount = me.getAttribute( 'data-amount' ),
			// endpoint URL at merchant server
			merchantAction = me.getAttribute( 'data-action' ),
			successBackUrl = me.getAttribute( 'data-success-back' ),
			merchantLogo = me.getAttribute( 'data-logo' )
			merchantCurrency = me.getAttribute( 'data-currency' );
			merchantOrderId = me.getAttribute( 'data-order-id' );

		if ( merchantId === null ) {
			console.error( 'Missing data-merchant-id attribute' );
			return;
		} else if ( merchantAction === null ) {
			console.error( 'Missing data-action attribute' );
			return;
		}
	  //CONSTANCE
		// API call
		var URL_PREFIX =  'http://pierup.ddns.net:8686';
		var URL_PREFIX2 = 'https://user-api.elasticbeanstalk.com';
		var URL = {
			getTransactionSMS: URL_PREFIX2 + '/user_api/v2/sdk/transaction_sms',//get SMS message on checkout--getCode
			getAuthToken: URL_PREFIX2 + '/user_api/v2/sdk/get_auth_token',
			getCountries: URL_PREFIX2 + '/user_api/v2/sdk/get_countries',
			loginApiUrl: URL_PREFIX2 + '/user_api/v2/sdk/signin?platform=3'
		};

		var GLOBAL_COUNTRY_CODE = 'US',
		CURRENCY_CODE = merchantCurrency,
		PASS_TYPE = 1,
		PASS_TYPE2 = 2,
		HEAD_DESCRIPTION = 'Simple credit for living a better live',
		PASS_CODE = 'Get Code',
		PASS_CODE_INPUT = 'Enter Code',
		PHONE_NUMBER = 'Phone Number',
		REGISTER_TEXT = 'New Account',
		VALIDATE_CODE = 'Validation Code',
		CREDIT_BACK_BTN = 'Back to make a payment',
		PHONE_NUMBER_ERROR = 'You must enter a validate phone number!',
		RESEND = 'Resend',
		BROWSER_NOT_SUPPORT = 'Your browser is too old to support pay with Pier...',
		PASSWORD_FORMAT_ERROR = 'Password should contain at least 1 number, 1 character and at least 6-digit',
		PASSWORD_MATCH_ERROR = 'Password is not match',
		INFOMATION_NOT_COMPLETED = 'Please complete all infomation in correct way!',
		SEND = 'Get Code',
		REGISTER_FINISHED = 13,
		UPDATE_INFO_FINIESHED = 141,
		APPLY_CREDIT_FINISHED = 6285,
		SIGN_UP = 'Sign Up',
		PAYMENT_SUCCESS = 'Payment Successful!',
		SUCCESS_BACK_PAGE = '< Back to the shop!',
		DATE_OF_BIRTH = 'Date of Birth(MM/dd/YYYY)',
		CHECK_TIME_TEMP = 120,
		REGISTER_TIME_TEMP = 120,
		COUNTRY_TYPE = undefined,
		PAYMENT_DONE = 'Done',
		SUCCESS_PAYMENT_IMAGE = URL_PREFIX+'/resource/image/successful.png',
		CHECK_LOGIN_NEXT = 'NEXT',
		PASSCODE_PAYMENT_INPUT = 'Enter your passcode in your app',
		CHECK_CODE_LOADING = '/resource/image/sdk_loading.gif',
		OFFICIAL_WEBSITE = 'http://www.pierup.com/#/user/userRegister',
		error = {
			hasNoCredit:  "Sorry, your account has no credit, please apply before you checkout.",
			invalidAccount:  "Sorry, your account is not pier's account!"
		};

		//get countries type from server
		this.getCountries = function(){
			var url = URL.getCountries;
			// var pCountries = templateApiCallGet( url, function( httpObj ){
			// 	var msg = JSON.parse( httpObj.responseText );
			//     COUNTRY_TYPE = msg.result.items;
			//     // checkout_country_select = [];
			//     for( var i = 0; i<COUNTRY_TYPE.length; i++ ){
			//     	var option = document.createElement( 'option' );
			//     	var optionReg = document.createElement( 'option' );
			//     	option.value = JSON.stringify(COUNTRY_TYPE[i]);
			//     	option.text = '+'+COUNTRY_TYPE[i].phone_prefix;
			//     	optionReg.value = JSON.stringify(COUNTRY_TYPE[i]);
			//     	optionReg.text = '+'+COUNTRY_TYPE[i].phone_prefix;

			//     	checkout_country_select.options.add( option );
			//     	console.log( 'getCountries', COUNTRY_TYPE );

			// 	    //select add countries options in payment and register
				    
			// 	    // console.log("checkout_country_select.options",checkout_country_select.options);
			//     }
			// } );

		    COUNTRY_TYPE = [
			    {
			    	"name":"UNITED STATES",
			    	"phone_prefix":"1",
			    	"code":"US",
			    	"phone_size":"10"
			    }, {
			    	"name":"CHINA",
			    	"phone_prefix":"86",
			    	"code":"CN",
			    	"phone_size":"11"
			    }
		    ];

		    for( var i = 0; i<COUNTRY_TYPE.length; i++ ){
		    	var option = document.createElement( 'option' );
		    	var optionReg = document.createElement( 'option' );
		    	option.value = JSON.stringify(COUNTRY_TYPE[i]);
		    	option.text = '+'+COUNTRY_TYPE[i].phone_prefix;
		    	optionReg.value = JSON.stringify(COUNTRY_TYPE[i]);
		    	optionReg.text = '+'+COUNTRY_TYPE[i].phone_prefix;
		    	checkout_country_select.options.add( option );
		    }
		}

		//Variable
		var status_bit = 0;
		var user_id = null, device_id = null, session_token = null;
		
        var checkoutHasSendCode = false;
        var checkoutT = null;
        var passCode = undefined;
        var authToken = undefined;
        var registerTimeTemp = REGISTER_TIME_TEMP;
	    var registerHasSendCode = false;
	    var registerT = null;
	    var token = '';
	    var creditLimit = 0;
	    var creditNote = null;
	    var checkTimetemp = CHECK_TIME_TEMP;
	    var wayOfPayment = 0;
	    var globalPaymentAmount = 0;

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
		//checkout layout
		ss.addRule( '.pier-btn', 'background-color:#7b37a6;border-color:#357ebd;color:#fff;text-align:center;white-space:nowrap;vertical-align:middle;cursor:pointer;padding:10px 16px;font-size:14px;border-radius:6px;border:1px solid transparent;' );
		ss.addRule( '.overlay', 'position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:rgba(0,0,0,0.6);visibility:hidden;opacity:1;');
		ss.addRule( '.pier-body', 'visibility:hidden;' );
		ss.addRule( '.checkout', 'text-align:center;width:302px;height:auto;margin:100px auto;z-index:998;background:#ffffff;color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;' );
		ss.addRule( '.checkout-head', 'width:300px;height:120px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.8));');
		ss.addRule( '.checkout-body', 'width:300px;height:auto;background:#ffffff;border-radius:0 0 5px 5px;transition: width 2s;-moz-transition: width 2s;-webkit-transition: width 2s; -o-transition: width 2s; ');
		ss.addRule( '.divider', 'width:100%;height:1px;background:#fff;box-shadow:1px 1px 0.5px #888888;');
		ss.addRule( '.close', "margin-top:7px;margin-left:90%;width:22px;height:23px;cursor:pointer;background-size:100% 100%;background-image: url('data:image/png;base64,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');")
		ss.addRule( '.checkout-close', 'margin-top:-33px;' );
		ss.addRule( '.checkout-title', 'text-align:center;margin-bottom:5px;font-size:18px;font-weight:bold;' );
		ss.addRule( '.checkout-description', 'text-align:center;margin-top:0;font-size:13px;color:#5b5b65;font-family:"HelveticaNeueMedium","HelveticaNeue-Medium","Helvetica Neue Medium","HelveticaNeue","Helvetica Neue",Helvetica,Arial;' );
		ss.addRule( '.checkout-input', 'width:228px;height:32px;border:1px solid #CCC;font-size:16px;margin-left:0%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;font-size:14px;' );
		ss.addRule( '.checkout-input-code', 'width:42%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:0%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;font-size:14px;' );
		ss.addRule( '.checkout-dynamic-code-btn', 'font-size:14px;cursor:pointer;width:32%;height:32px;border:1px solid #CCC;margin-left:2%;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;')
		ss.addRule( '.checkout-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.pay-btn', 'width:228px;height:40px;margin-left:0%;font-size:16px;background:#7b37a6;color:#FFFFFF;border:1px solid #CCC;cursor:pointer;');
		ss.addRule( '.checkout-logo', 'width:80px;height:80px;margin-left:0px; margin-top:-40px;border-radius:40px;background:#fff;')
        ss.addRule( '.checkout-country-select', 'text-align:center;width:24%;height:32px;border:1px solid #CCC;font-size:16px;' );
        ss.addRule( '.checkout-input-phone', 'width:50%;margin-left:2%;height:32px;border:1px solid #CCC;font-size:16px;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;font-size:14px;' );
        ss.addRule( '.none', 'display:none' );
        ss.addRule( '.checkout-code-loading', 'width:16px;margin-left:2px;display:none;')
        ss.addRule( '.checkout-error-msg', 'color:red;padding-left:10px;padding-right:10px;')

		ss.addRule( '.round-border', 'border-radius:5px 5px 5px 5px;' );
		ss.addRule( '.mTop-s', 'margin-top:5px;' );
		ss.addRule( '.mTop-m', 'margin-top:10px;' );
		ss.addRule( '.mTop-l', 'margin-top:20px;' );
		ss.addRule( '.mTop-h', 'margin-top:30px;' );
		ss.addRule( '.padTop-h', 'padding-top:40px;')
		ss.addRule( '.checkout-register', 'text-align: right; width: 90px;  margin-top:20px;font-size:12px; cursor: pointer; color:rgb(66, 139, 202); margin-left:60%;' );

		//Checkout success loading
		ss.addRule( '.checkout-spinner', 'margin: 200px auto;width: 60px;height: 60px;position: relative;opacity: 1;');
		ss.addRule( '.checkout-container1 > div, .checkout-container2 > div, .checkout-container3 > div', 'width: 16px;height: 16px;background-color: rgb(66, 139, 202);border-radius: 100%;position: absolute;animation: checkout-bouncedelay 1.2s infinite ease-in-out;-webkit-animation: checkout-bouncedelay 1.2s infinite ease-in-out;-moz-animation:checkout-bouncedelay 1.2s infinite ease-in-out;-o-animation:checkout-bouncedelay 1.2s infinite ease-in-out;animation-fill-mode: both;animation-fill-mode: both;-webkit-animation-fill-mode: both;animation-fill-mode: both;-moz-animation-fill-mode: both;animation-fill-mode: both;-o-animation-fill-mode: both;animation-fill-mode: both;' );
		ss.addRule( '.checkout-spinner .checkout-spinner-container', 'position: absolute;width: 100%;height: 100%;' );
		ss.addRule( '.checkout-container2', 'transform: rotateZ(45deg);-webkit-transform: rotateZ(45deg);-moz-transform: rotateZ(45deg);' );
		ss.addRule( '.checkout-container3', 'transform: rotateZ(90deg);-webkit-transform: rotateZ(90deg);-moz-transform: rotateZ(90deg);' );
		ss.addRule( '.checkout-circle1', 'top: 0; left: 0;' );
		ss.addRule( '.checkout-circle2', 'top: 0; right: 0;' );
		ss.addRule( '.checkout-circle3', 'right: 0; bottom: 0;' );
		ss.addRule( '.checkout-circle4', 'left: 0; bottom: 0;' );
		ss.addRule( '.checkout-container2 .checkout-circle1', 'animation-delay: -1.1s;-moz-animation-delay: -1.1s;-webkit-animation-delay: -1.1s;' );
		ss.addRule( '.checkout-container3 .checkout-circle1', 'animation-delay: -1.0s;-moz-animation-delay: -1.0s;-webkit-animation-delay: -1.0s;' );
		ss.addRule( '.checkout-container1 .checkout-circle2', 'animation-delay: -0.9s;-moz-animation-delay: -0.9s;-webkit-animation-delay: -0.9s;' );
		ss.addRule( '.checkout-container2 .checkout-circle2', 'animation-delay: -0.8s;-moz-animation-delay: -0.8s;-webkit-animation-delay: -0.8s;' );
		ss.addRule( '.checkout-container3 .checkout-circle2', 'animation-delay: -0.7s;-moz-animation-delay: -0.7s;-webkit-animation-delay: -0.7s;' );
		ss.addRule( '.checkout-container1 .checkout-circle3', 'animation-delay: -0.6s;-moz-animation-delay: -0.6s;-webkit-animation-delay: -0.6s;' );
		ss.addRule( '.checkout-container2 .checkout-circle3', 'animation-delay: -0.5s;-moz-animation-delay: -0.5s;-webkit-animation-delay: -0.5s;' );
		ss.addRule( '.checkout-container3 .checkout-circle3', 'animation-delay: -0.4s;-moz-animation-delay: -0.4s;-webkit-animation-delay: -0.4s;' );
		ss.addRule( '.checkout-container1 .checkout-circle4', 'animation-delay: -0.3s;-moz-animation-delay: -0.3s;-webkit-animation-delay: -0.3s;' );
		ss.addRule( '.checkout-container2 .checkout-circle4', 'animation-delay: -0.2s;-moz-animation-delay: -0.2s;-webkit-animation-delay: -0.2s;' );
		ss.addRule( '.checkout-container3 .checkout-circle4', 'animation-delay: -0.1s;-moz-animation-delay: -0.1s;-webkit-animation-delay: -0.1s;' );
		if( isFirefox=navigator.userAgent.indexOf("Firefox") != -1 ){ 
			ss.addRule( '@-moz-keyframes checkout-bouncedelay', '0%, 80%, 100% { transform: scale(0.0);-webkit-transform: scale(0.0);} 40% {transform: scale(1.0);-webkit-transform: scale(1.0);}' );
	    }
	    if(  ( isChrome = navigator.userAgent.indexOf("Chrome") != -1 ) || (isSafari=navigator.userAgent.indexOf("Safari") != -1 ) ){ 
		    ss.addRule( '@-webkit-keyframes checkout-bouncedelay', '0%, 80%, 100% { -webkit-transform: scale(0.0) }40% { -webkit-transform: scale(1.0) }' );
        }
        if( isIE = navigator.userAgent.indexOf("MSIE") != -1 ) { 
        	var index = ss.cssRules.length; 
        	ss.insertRule( '@keyframes checkout-bouncedelay{0%, 80%, 100% { transform: scale(0.0);-webkit-transform: scale(0.0);} 40% {transform: scale(1.0);-webkit-transform: scale(1.0);}', index );
        }
     
		ss.addRule( '.checkout-loading-page', 'width:302px;height:340px;top:-339px;z-index:999;background:rgb(229, 229, 208);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;position: relative; opacity: 0.7;display:none;' );

		//payment success
		ss.addRule( '.success-description', 'width:400px;margin: 0 auto;margin-top: 10px;height:180px');
		ss.addRule( '.success-description img', 'margin-top:20px;');
		ss.addRule( '.success-description p', 'width: 100%;text-align: center;font-size: 14px;' );
		ss.addRule( '.success-description h2', 'width: 100%;text-align: center;font-size: 32px; font-weight:bold;' );
		ss.addRule( '.success-back-shopping', 'margin-top: 0px;margin-left:40px; text-align:left; font-size:16px;' );
		ss.addRule( '.success-sdk', 'display:none;width: 600px;background:#ffffff;height:300px;margin:230px auto;z-index:999;color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;');
        ss.addRule( '.success-done', 'margin-top:20px;width:120px;height:40px; background:#787878;font-size:16px;color:#ffffff;margin-left:400px;border:1px solid #ccc;outline:none;' );
        ss.addRule( '.success-done:hover', 'opacity:0.7' );
        ss.addRule( '.success-done:active', 'opacity:1;background#585858;' );

  //Pier Checkout
		// Pier button attach point
		var parentElem = me.parentElement;

		// Pier button
		var	btnElem = document.createElement( 'button' );

		// shadow mask
		var	overlay = document.createElement( 'div' );

		// Pier checkout dialog
		var	checkout = document.createElement( 'div');

		//pier checkout container
		var pier_body = document.createElement( 'div' );

		// Pier checkout header
		var	checkoutHead = document.createElement( 'div' );
		// Pier checkout close button
		var	close = document.createElement( 'div');
		
		var	checkoutTitle = document.createElement( 'p' );
				checkoutTitle.innerHTML = name;
		var	checkoutDescription = document.createElement( 'div' );
				checkoutDescription.innerHTML = description;

		var divider = document.createElement( 'div' );
		

		// Pier checkout body
		var	checkoutBody = document.createElement( 'div' );
		var checkoutError = document.createElement( 'p' );
		var	phoneNumberInput = document.createElement( 'input' );
		phoneNumberInput.setAttribute( 'placeholder', PHONE_NUMBER );
		phoneNumberInput.setAttribute( 'type', 'tel' );
		var	dynamicCodeInput = document.createElement( 'input' );
		dynamicCodeInput.setAttribute( 'placeholder', PASS_CODE_INPUT );
		dynamicCodeInput.setAttribute( 'type', 'text' );
		var dynamicCodeBtn = document.createElement( 'button' );
		dynamicCodeBtn.setAttribute( 'type', 'button' );
		dynamicCodeBtn.innerHTML = PASS_CODE;
		var passwordInput = document.createElement( 'input' );
		passwordInput.setAttribute( 'type', 'password' );
		passwordInput.setAttribute( 'placeholder', 'Password' );
		var checkoutNextBtn = document.createElement( 'button' );
		checkoutNextBtn.innerHTML = CHECK_LOGIN_NEXT;
		var checkoutPasscodeInput = document.createElement( 'input' );
		checkoutPasscodeInput.setAttribute( 'placeholder', PASSCODE_PAYMENT_INPUT );
		var checkoutWrapLogin = document.createElement( 'div' );
		var checkoutWrapDynamicCode = document.createElement( 'div' );
		var checkoutWrapPassCode = document.createElement( 'div' );

		var	payButton = document.createElement( 'button' );
		payButton.setAttribute( 'type', 'button' );
		var	payButton2 = document.createElement( 'button' );
		payButton2.setAttribute( 'type', 'button' );
		var check_code_loading = document.createElement( 'img' );
		check_code_loading.setAttribute( 'src', URL_PREFIX+CHECK_CODE_LOADING );
		
		var registerText = document.createElement( 'p' );
		registerText.innerHTML = REGISTER_TEXT;
		var pBlank = document.createElement( 'p' );
		payButton.innerHTML = 'Pay $ ' + amount;
		payButton2.innerHTML = 'Pay $ ' + amount;
		//register text click for register process
		registerText.onclick = function(){
			window.open( OFFICIAL_WEBSITE );
		}

		var checkout_loading_page = document.createElement( 'div' );
		var checkout_spinner = document.createElement( 'div' );
		var checkout_container1 = document.createElement( 'div' );
		var checkout_container2 = document.createElement( 'div' );
		var checkout_container3 = document.createElement( 'div' );
		var checkout_container1_cir1 = document.createElement( 'div' );
		var checkout_container1_cir2 = document.createElement( 'div' );
		var checkout_container1_cir3 = document.createElement( 'div' );
		var checkout_container1_cir4 = document.createElement( 'div' );
		var checkout_container2_cir1 = document.createElement( 'div' );
		var checkout_container2_cir2 = document.createElement( 'div' );
		var checkout_container2_cir3 = document.createElement( 'div' );
		var checkout_container2_cir4 = document.createElement( 'div' );
		var checkout_container3_cir1 = document.createElement( 'div' );
		var checkout_container3_cir2 = document.createElement( 'div' );
		var checkout_container3_cir3 = document.createElement( 'div' );
		var checkout_container3_cir4 = document.createElement( 'div' );
		var checkout_merchant_logo = document.createElement( 'img' );
		checkout_merchant_logo.setAttribute( 'src', merchantLogo );
		var checkout_country_select = document.createElement( 'select' );

     //Payment success
        var success_sdk = document.createElement( 'div' );
        var success_description = document.createElement( 'div' );
        var success_des_content = document.createElement( 'p' );
        var success_back_shopping = document.createElement( 'div' );
        var success_payment_done = document.createElement( 'button' );
        success_payment_done.innerHTML = PAYMENT_DONE;
        var success_image = document.createElement( 'img' );
        success_image.setAttribute( 'src', SUCCESS_PAYMENT_IMAGE );
        var success_back_link = document.createElement( 'a' );
        success_des_content.innerHTML = PAYMENT_SUCCESS;
        success_back_link.innerHTML = SUCCESS_BACK_PAGE;
        success_back_link.setAttribute( 'href', successBackUrl );
        success_back_link.onclick = function(){
        	close.onclick();
        }
        var success_desc_amount = document.createElement( 'h2' );
        
       //switch country code to currency symbol
        var gerCurrencyCode = function( code ){
        	var currencyFlag = '';
        	switch( code ){
        		case "USD": currencyFlag = '$';break;
        		case "RMB": currencyFlag = '￥';break;
        		default: currencyFlag = '$';break;
        	}
        	return currencyFlag;
        }
   //Checkout
      
		//user get dynamic code by sending 
		dynamicCodeBtn.onclick = function(){
			if( checkoutHasSendCode ) return;
            //get country obj from selected option{name:,code:,phone_prefix}
            var countryObj = JSON.parse( checkout_country_select.options[checkout_country_select.selectedIndex].value ),
			phoneValue = phoneNumberInput.value,
			passwordValue = passwordInput.value,
			merchantId = me.getAttribute( 'data-merchant-id' ),
			amount = me.getAttribute( 'data-amount' );

			if( phoneValue == undefined || phoneValue == '' || passwordValue == undefined || passwordValue == '' ) return;
			check_code_loading.style.display = "inline";
			var patrn=/^[0-9]{1,20}$/; 
		    var flag = patrn.test( phoneValue );
		    checkoutErrorMsg( '' );
		    if( !flag || phoneValue.length != countryObj.phone_size ){
			    checkoutErrorMsg( PHONE_NUMBER_ERROR );
			    return;
		    }
		    var checkoutDynamicCodeUrl = URL.getTransactionSMS;
		    var message = {
		    	phone: phoneValue,
		    	country_code: countryObj.code,
		    	merchant_id: merchantId,
		    	amount: amount,
		    	currency_code: CURRENCY_CODE,
		    	session_token: session_token
		    };
		    var pDynamicCode = templateApiCall( checkoutDynamicCodeUrl, message, function( httpObj ){
		    	var msg = JSON.parse( httpObj.responseText );
			    if( httpObj.status == 200 ){
			    	console.log( 'get dynamic code on pay by pier', msg );
			    	session_token = msg.result.session_token;
			    	globalPaymentAmount = msg.result.amount;
			    	user_id = msg.result.user_id;
			    	status_bit = msg.result.status_bit;
			    	console.log( 'Get Code', msg.result.code );
			    	checkoutHasSendCode = true;
			    	checkoutTimer();
			    	check_code_loading.style.display = "none";
			    }else{
			    	checkoutErrorMsg( msg.message );
			    	check_code_loading.style.display = "none";
			    }
		    } );
		};

		//120s timer clock 
        var checkoutTimer = function(){
			// var validationSend = register_code_send;
			dynamicCodeBtn.innerHTML = checkTimetemp;
			checkTimetemp -= 1;
			if( checkTimetemp == 0 ){
				checkTimetemp = CHECK_TIME_TEMP;
				dynamicCodeBtn.innerHTML = RESEND;
				checkoutHasSendCode = false;
				return;
			}
			checkoutT = setTimeout( checkoutTimer, 1000 )
			return checkoutT;
  
	    }

	    //login switch layout for payment
	    var checkoutSwitchPayment = function( passType ){
		    checkoutWrapLogin.style.display = 'none';
		    checkoutWrapDynamicCode.style.display = 'none'
		    checkoutWrapPassCode.style.display = 'none'
		    switch( passType ){
		  	    case 1: checkoutWrapDynamicCode.style.display = 'block';break;
		  	    case 2: checkoutWrapPassCode.style.display = 'block';break;
		  	    default: checkoutWrapLogin.style.display = 'block';break;
		    }
	    }

	    //User login
	    checkoutNextBtn.onclick = function(){
	    	var phoneValue = phoneNumberInput.value;
			var passwordValue = passwordInput.value;

	    	if( phoneValue == null || phoneValue == '' || passwordValue == null || passwordValue == '' ) return;
	    	checkoutErrorMsg( '' );
	    	var countryObj = JSON.parse( checkout_country_select.options[checkout_country_select.selectedIndex].value );
			var message = {
				phone: phoneValue,
				country_code: countryObj.code,
				password: passwordValue
			}
			var loginUrl = URL.loginApiUrl;
			var loginPromise = templateApiCall( loginUrl, message, function( httpObj ){
				var msg = JSON.parse( httpObj.responseText );
				if( httpObj.status == 200 ){
					if( msg.code == 200 ){
						console.log( 'Login success', msg );
						session_token = msg.result.session_token;
						status_bit = msg.result.status_bit;
						if( status_bit == 0 ){
							checkoutErrorMsg( invalidAccount );
							return;
						}

						if( status_bit < APPLY_CREDIT_FINISHED ){ 
							checkoutErrorMsg( error.hasNoCredit );
							return;
						 }
						if( status_bit >= APPLY_CREDIT_FINISHED ){
						   checkoutSwitchPayment(1);
						}
					}else{
						checkoutErrorMsg( msg.message );
					}
				}else{
					checkoutErrorMsg( msg.message );
				}
			} );
			
	    }
		//payment button
		payButton.onclick = function() {
			var countryObj = JSON.parse( checkout_country_select.options[checkout_country_select.selectedIndex].value );
			var phoneValue = phoneNumberInput.value;
			var dynamicCodeInputValue = dynamicCodeInput.value;
			var merchantId = me.getAttribute( 'data-merchant-id' );
			// var	amount = me.getAttribute( 'data-amount' );

			if( dynamicCodeInputValue === undefined || dynamicCodeInputValue === '' || dynamicCodeInputValue  === undefined || dynamicCodeInputValue === '' ) return;
            checkoutErrorMsg( '' );
			var authTokenUrl = URL.getAuthToken;
			var message = {
				phone: phoneValue,
				country_code: countryObj.code,
				pass_code: dynamicCodeInputValue,
				pass_type: PASS_TYPE,
				merchant_id: merchantId,
				amount: globalPaymentAmount,
				currency_code: CURRENCY_CODE,
				session_token: session_token
			};
			
			var pPayment = templateApiCall( authTokenUrl, message, function( httpObj ){
				var msg = JSON.parse( httpObj.responseText );
				if( httpObj.status == 200 ){
					if( msg.code == 200 ){
						console.log( 'Get auth token success', msg );
						authToken = msg.result.auth_token;
						checkout_loading_page.style.display = 'block';
						setTimeout( makePayment, 3000 );
					}else{
						checkoutErrorMsg( msg.message );
					}
				}else{
					checkoutErrorMsg( msg.message );
				}
			} );
		};
		//payment button2
		payButton2.onclick = function() {
			var countryObj = JSON.parse( checkout_country_select.options[checkout_country_select.selectedIndex].value );
			var phoneValue = phoneNumberInput.value;
			var passCode = checkoutPasscodeInput.value;
			var merchantId = me.getAttribute( 'data-merchant-id' );
			var	amount = me.getAttribute( 'data-amount' );

			if( passCode === undefined || passCode === '' || passCode  === undefined || passCode === '' ) return;

			var payUrl = URL.getAuthToken;
			var message = {
				phone: phoneValue,
				country_code: countryObj.code,
				pass_code: passCode,
				pass_type: PASS_TYPE2,
				merchant_id: merchantId,
				amount: amount,
				currency_code: CURRENCY_CODE,
				session_token: session_token
			};
			
			var pPayment = templateApiCall( payUrl, message, function( httpObj ){
				var msg = JSON.parse( httpObj.responseText );
				if( httpObj.status == 200 ){
					if( msg.code == 200 ){
						console.log( 'Pay by pier success', msg );
						authToken = msg.result.auth_token;
						checkout_loading_page.style.display = 'block';
						setTimeout( makePayment, 20000 );
					}else{
						checkoutErrorMsg( msg.message );
					}
				}else{
					checkoutErrorMsg( msg.message );
				}
			} );
			
	
		};

		//payment
		var makePayment = function(){
			var merchantAction = me.getAttribute( 'data-action' );
			var paymentUrl = merchantAction;
			paymentUrl += '/' + globalPaymentAmount + '/' + authToken + '/' + CURRENCY_CODE + '/' + merchantOrderId;

			var xhr = null;
		  	if ( window.XMLHttpRequest ) {
				xhr = new XMLHttpRequest();
			} else if ( window.ActiveXObject ) {
				xhr = new ActiveXObject( 'Microsoft.XMLHTTP' );
			} else {
				alert( BROWSER_NOT_SUPPORT );
				return;
			}

			xhr.open( 'GET', paymentUrl, false );

			xhr.setRequestHeader( 'Content-type', 'text/html' );
				
			xhr.send( null );

			console.log( '=======', JSON.parse( xhr.responseText ) );
			var msg = JSON.parse( xhr.responseText );

			if( xhr.readyState == 4 && xhr.status == 200 ){
				if( msg.code == 200 ){
					checkout_loading_page.style.display = 'none';
					success_desc_amount.innerHTML = '-'+ gerCurrencyCode( CURRENCY_CODE ) + globalPaymentAmount;
					showScreen( success_sdk );

				}else{
					checkout_loading_page.style.display = 'none';
					checkoutErrorMsg( msg.message );
				}
                
            }

		}

		// Pier button setting
		btnElem.setAttribute( 'type', 'button' );
		btnElem.style.width = buttonWidth;
		btnElem.style.height = buttonHeight;
		btnElem.innerHTML = buttonText;
		btnElem.classList.add( 'pier-btn' );
		btnElem.onclick = function() {
			overlay.style.visibility = 'visible';
			pier_body.style.visibility = 'visible';
			if( COUNTRY_TYPE === undefined ){
				getCountries();
			}
			
		};
		// attach Pier button
		parentElem.appendChild( btnElem );

		// overlay mask setting
		overlay.classList.add( 'overlay' );

		// Pier checkout setting
		checkout.classList.add( 'checkout' );
		pier_body.classList.add( 'pier-body' );

		checkoutHead.classList.add( 'checkout-head' );
		close.classList.add( 'close' );
		close.classList.add( 'checkout-close' );
		close.onclick = function() {
			clearAllData();
			showScreen( checkout );
			overlay.style.visibility = 'hidden';
			pier_body.style.visibility = 'hidden';
		}

		checkoutTitle.classList.add( 'checkout-title' );
		checkoutDescription.classList.add( 'checkout-description' );
		divider.classList.add( 'divider' );

		checkoutBody.classList.add( 'checkout-body' );
		checkoutError.classList.add( 'checkout-error-msg' );
		phoneNumberInput.classList.add( 'checkout-input-phone' );
		phoneNumberInput.classList.add( 'round-border' );
		phoneNumberInput.classList.add( 'mTop-l' );

		dynamicCodeInput.classList.add( 'checkout-input-code' );
		dynamicCodeInput.classList.add( 'round-border' );
		dynamicCodeInput.classList.add( 'mTop-m' );
		// dynamicCodeInput.classList.add( 'none' );

		dynamicCodeBtn.classList.add( 'checkout-dynamic-code-btn' );
		dynamicCodeBtn.classList.add( 'round-border' );
		dynamicCodeBtn.classList.add( 'mTop-m' );
		// dynamicCodeBtn.classList.add( 'none' );

		passwordInput.classList.add( 'checkout-input' );
		passwordInput.classList.add( 'round-border' );
		passwordInput.classList.add( 'mTop-m' );

		payButton.classList.add( 'pay-btn' );
		payButton.classList.add( 'round-border' );
		payButton.classList.add( 'mTop-l' );
		payButton2.classList.add( 'pay-btn' );
		payButton2.classList.add( 'round-border' );
		payButton2.classList.add( 'mTop-l' );
        // payButton.classList.add( 'none' );

        // checkoutWrapLogin.classList.add( 'none' );
		checkoutWrapDynamicCode.classList.add( 'none' );
		checkoutWrapDynamicCode.classList.add( 'padTop-h' );
		checkoutWrapPassCode .classList.add( 'none' );
		checkoutWrapPassCode.classList.add( 'padTop-h' );

		registerText.classList.add( 'checkout-register' );
		checkout_country_select.classList.add( 'checkout-country-select' );
		checkout_country_select.classList.add( 'round-border' );
		checkoutNextBtn.classList.add( 'pay-btn' );
		checkoutNextBtn.classList.add( 'round-border' );
		checkoutNextBtn.classList.add( 'mTop-l' );
		checkoutPasscodeInput.classList.add( 'checkout-input' );
		checkoutPasscodeInput.classList.add( 'round-border' );
		checkoutPasscodeInput.classList.add( 'mTop-m' );
		// checkoutPasscodeInput.classList.add( 'none' );

		checkout_loading_page.classList.add( 'checkout-loading-page' );
		checkout_spinner.classList.add( 'checkout-spinner' );
		checkout_container1.classList.add( 'checkout-spinner-container' );
		checkout_container1.classList.add( 'checkout-container1' );
		checkout_container2.classList.add( 'checkout-spinner-container' );
		checkout_container2.classList.add( 'checkout-container2' );
		checkout_container3.classList.add( 'checkout-spinner-container' );
		checkout_container3.classList.add( 'checkout-container3' );

		checkout_container1_cir1.classList.add( 'checkout-circle1' );
		checkout_container1_cir2.classList.add( 'checkout-circle2' );
		checkout_container1_cir3.classList.add( 'checkout-circle3' );
		checkout_container1_cir4.classList.add( 'checkout-circle4' );

		checkout_container2_cir1.classList.add( 'checkout-circle1' );
		checkout_container2_cir2.classList.add( 'checkout-circle2' );
		checkout_container2_cir3.classList.add( 'checkout-circle3' );
		checkout_container2_cir4.classList.add( 'checkout-circle4' );

		checkout_container3_cir1.classList.add( 'checkout-circle1' );
		checkout_container3_cir2.classList.add( 'checkout-circle2' );
		checkout_container3_cir3.classList.add( 'checkout-circle3' );
		checkout_container3_cir4.classList.add( 'checkout-circle4' );
		checkout_merchant_logo.classList.add( 'checkout-logo' );
		check_code_loading.classList.add( 'checkout-code-loading' );
	  
	   //payment success
	   success_sdk.classList.add( 'success-sdk' );
	   success_description.classList.add( 'success-description' );
	   success_back_shopping.classList.add( 'success-back-shopping' );
	   success_payment_done.classList.add( 'success-done' );
	   success_payment_done.classList.add( 'round-border');

        //checkout append components
        dynamicCodeBtn.appendChild( check_code_loading );
        checkoutHead.appendChild( checkout_merchant_logo );  
		checkoutHead.appendChild( close );
		checkoutHead.appendChild( checkoutTitle );
		checkoutHead.appendChild( checkoutDescription );

		
		checkoutWrapLogin.appendChild( checkout_country_select );
		checkoutWrapLogin.appendChild( phoneNumberInput );
		checkoutWrapLogin.appendChild( passwordInput ); 
		checkoutWrapLogin.appendChild( checkoutNextBtn );

		checkoutWrapDynamicCode.appendChild( dynamicCodeInput );
		checkoutWrapDynamicCode.appendChild( dynamicCodeBtn );
		checkoutWrapDynamicCode.appendChild( payButton );

		checkoutWrapPassCode.appendChild( checkoutPasscodeInput );
		checkoutWrapPassCode.appendChild( payButton2 );

		checkoutBody.appendChild( checkoutError );
		checkoutBody.appendChild( checkoutWrapLogin );
		checkoutBody.appendChild( checkoutWrapDynamicCode );
		checkoutBody.appendChild( checkoutWrapPassCode );

		checkoutBody.appendChild( registerText );

		checkout_container1.appendChild( checkout_container1_cir1 );
		checkout_container1.appendChild( checkout_container1_cir2 );
		checkout_container1.appendChild( checkout_container1_cir3 );
		checkout_container1.appendChild( checkout_container1_cir4 );

		checkout_container2.appendChild( checkout_container2_cir1 );
		checkout_container2.appendChild( checkout_container2_cir2 );
		checkout_container2.appendChild( checkout_container2_cir3 );
		checkout_container2.appendChild( checkout_container2_cir4 );

		checkout_container3.appendChild( checkout_container3_cir1 );
		checkout_container3.appendChild( checkout_container3_cir2 );
		checkout_container3.appendChild( checkout_container3_cir3 );
		checkout_container3.appendChild( checkout_container3_cir4 );

		checkout_spinner.appendChild( checkout_container1 );
		checkout_spinner.appendChild( checkout_container2 );
		checkout_spinner.appendChild( checkout_container3 );

		checkout_loading_page.appendChild( checkout_spinner );

		//Payment success
		success_sdk.appendChild( success_payment_done );
		success_description.appendChild( success_image );
		success_description.appendChild( success_des_content );
		success_description.appendChild( success_desc_amount );
		success_back_shopping.appendChild( success_back_link );
		success_sdk.appendChild( success_payment_done );
		success_sdk.appendChild( success_description );
		success_sdk.appendChild( success_back_shopping );
		
		// attach checkout components in order
		checkout.appendChild( checkoutHead );
		checkout.appendChild( divider );
		checkout.appendChild( checkoutBody );
		checkout.appendChild( checkout_loading_page );

		pier_body.appendChild( checkout );
		pier_body.appendChild( success_sdk );

		overlay.appendChild( pier_body ); 
		parentElem.appendChild( overlay );

	//show screen controller
	var showScreen = function( obj ){
		checkout.style.display = 'none';
		success_sdk.style.display = 'none';
		obj.style.display = 'block';
	};

	var switchScreenByBit = function( bit ){
		switch( bit ){
			default: showScreen( checkout );
		}
	};
   //show error message when something was wrong on register
	  var checkoutErrorMsg = function( msg ){
	  	if( checkoutError.innerHTML == '' || msg == '' )
	  	checkoutError.innerHTML = msg;
	  };
	  //when close this sdk, it will clear all data
	  var clearAllData = function(){
	  	 phoneNumberInput.value = '';
	  	 passwordInput.value = '';
	  	 dynamicCodeInput.value = '';
	  	 checkoutError.innerHTML = '';
	  	 checkoutHasSendCode = false;
	  	 clearTimeout( checkoutT );
		 checkTimetemp = CHECK_TIME_TEMP;
	  	 dynamicCodeBtn.innerHTML = PASS_CODE;
	  	 checkoutSwitchPayment();
	  };
	  //template api call, access api
	  var templateApiCall = function(){
	  	var xhr = null;
	  	var templateUrl = arguments[0];
	  	var message = arguments[1];
	  	var callback = arguments[2];
	  	if ( window.XMLHttpRequest ) {
			xhr = new XMLHttpRequest();
		} else if ( window.ActiveXObject ) {
			xhr = new ActiveXObject( 'Microsoft.XMLHTTP' );
		} else {
			alert( BROWSER_NOT_SUPPORT );
			return;
		}

		xhr.open( 'POST', templateUrl, true );

		xhr.setRequestHeader( 'Content-type', 'application/json' );
		xhr.onreadystatechange = function(){
			if (xhr.readyState == 4 ) {
				callback.call( this, xhr );
			}
		}
		console.log( templateUrl );
		xhr.send( JSON.stringify( message ) );
	  };
	  var templateApiCallGet = function(){
	  	var xhr = null;
	  	var templateUrl = arguments[0];
	  	var callback = arguments[1];
	    // return xhr;
	  	if ( window.XMLHttpRequest ) {
			xhr = new XMLHttpRequest();
		} else if ( window.ActiveXObject ) {
			xhr = new ActiveXObject( 'Microsoft.XMLHTTP' );
		} else {
			alert( BROWSER_NOT_SUPPORT );
			return;
		}
		 if ("withCredentials" in xhr){
	        xhr.open( 'GET', templateUrl, true );
	    } else if (typeof XDomainRequest != "undefined"){
	        xhr = new XDomainRequest();
	        xhr.open( 'GET', templateUrl, true );
	    } else {
	        xhr = null;
	    }

		// xhr.open( 'GET', templateUrl, true );

		xhr.setRequestHeader( 'Content-type', 'application/json' );

		xhr.onreadystatechange = function(){
			if (xhr.readyState == 4 ) {
				callback.call( this, xhr );
			}
		}
			
		console.log( templateUrl );
		xhr.send( null );
	  };

     //close all payment screen when payment done;
     success_payment_done.onclick = function(){
     	close.onclick();
     }

	}.call( this );
}() );