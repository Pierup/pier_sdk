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
				buttonText = me.getAttribute( 'data-button-text' ) || 'Pay by Pier',
				buttonWidth = '120px',
				buttonHeight = '40px',
				name = me.getAttribute( 'data-name' ),
				description = me.getAttribute( 'data-description' ),
				amount = me.getAttribute( 'data-amount' ),
				// endpoint URL at merchant server
				merchantAction = me.getAttribute( 'data-action' ),
				successBackUrl = me.getAttribute( 'data-success-back' );

		if ( merchantId === null ) {
			console.error( 'Missing data-merchant-id attribute' );
			return;
		} else if ( merchantAction === null ) {
			console.error( 'Missing data-action attribute' );
			return;
		}
  //CONSTANCE
		// API call
		var URL = {
			getTransactionSMS: 'http://pierup.ddns.net:8686/user_api/v2/sdk/transaction_sms',
			getAuthToken: 'http://pierup.ddns.net:8686/user_api/v2/sdk/get_auth_token',
			getDynamicCode: '',
			getRegisterValidationCode: 'http://pierup.ddns.net:8686/user_api/v2/user/activation_code',
			validateCode: 'http://pierup.ddns.net:8686/user_api/v2/user/activation',
			register:'http://pierup.ddns.net:8686/user_api/v2/user/register_user?platform=3',
			updateUser: 'http://pierup.ddns.net:8686/user_api/v2/user/update_user?platform=3',
			applyCredit: 'http://pierup.ddns.net:8686/user_api/v2/sdk/apply_credit?platform=3'
		};

		var GLOBAL_CONTRY_CODE = 'US';
		var CURRENCY_CODE = 'USD';
		var PASS_TYPE = 1;
		var HEAD_DESCRIPTION = 'Simple credit for living a better live';
		var PASS_CODE = 'Dynamic Code';
		var PHONE_NUMBER = 'Phone Number';
		var PHONE_NUMBER_LENGTH = '10';
		var REGISTER_TEXT = 'New Account';
		var VALIDATE_CODE = 'Validation Code';
		var CREDIT_BACK_BTN = 'Back to make a payment';
		var PHONE_NUMBER_ERROR = 'You must enter a validate phone number!';
		var RESEND = 'Resend';
		var BROWSER_NOT_SUPPORT = 'Your browser is too old to support pay by Pier...';
		var PASSWORD_FORMAT_ERROR = 'Password should contain at least 1 number, 1 character and at least 6-digit';
		var PASSWORD_MATCH_ERROR = 'Password is not match';
		var INFOMATION_NOT_COMPLETED = 'Please complete all infomation in correct way!';
		var SEND = 'Send';
		var REGISTER_FINISHED = '13';
		var UPDATE_INFO_FINIESHED = '141';
		var APPLY_CREDIT_FINISHED = '6285';
		var SIGN_UP = 'Sign Up';


		//Variable
		var status_bit = 0;
		var user_id = null, device_id = null, session_token = null;
		var checkTimetemp = 120;
        var checkoutHasSendCode = false;
        var checkoutT = null;
        var passCode = undefined;
        var authToken = undefined;
        var registerTimeTemp = 300;
	    var registerHasSendCode = false;
	    var registerT = null;
	    var token = '';
	    var creditLimit = 0;
	    var creditNote = null;

		// create  CSS styles
		var styleElem = document.createElement( 'style' );
		// for WebKit
		styleElem.appendChild( document.createTextNode( '' ) );
		document.head.appendChild( styleElem );

		var ss = styleElem.sheet;

		//checkout layout
		ss.addRule( '.pier-btn', 'background-color:#428bca;border-color:#357ebd;color:#fff;text-align:center;white-space:nowrap;vertical-align:middle;cursor:pointer;padding:10px 16px;font-size:14px;border-radius:6px;border:1px solid transparent;' );
		ss.addRule( '.overlay', 'position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:rgba(0,0,0,0.6);visibility:hidden;opacity:1;');
		ss.addRule( '.pier-body', 'visibility:hidden;' );
		ss.addRule( '.checkout', 'width:302px;height:410px;margin:250px auto;z-index:998;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;' );
		ss.addRule( '.checkout-head', 'width:100%;height:120px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.checkout-body', 'width:100%;height:auto;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
		ss.addRule( '.divider', 'width:100%;height:1px;background:#fff;box-shadow:1px 1px 0.5px #888888;');
		ss.addRule( '.close', "margin-top:7px;margin-left:90%;width:22px;height:23px;cursor:pointer;background-size:100% 100%;background-image: url('data:image/png;base64,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');")
		ss.addRule( '.checkout-title', 'text-align:center;margin-bottom:5px;font-size:18px;font-weight:bold;' );
		ss.addRule( '.checkout-description', 'text-align:center;margin-top:0;font-size:13px;color:#5b5b65;font-family:"HelveticaNeueMedium","HelveticaNeue-Medium","Helvetica Neue Medium","HelveticaNeue","Helvetica Neue",Helvetica,Arial;' );
		ss.addRule( '.checkout-input', 'width:76%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:10%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.checkout-input-code', 'width:42%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:10%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.checkout-dynamic-code-btn', 'cursor:pointer;width:32%;height:32px;border:1px solid #CCC;font-size:10px;margin-left:2%;padding:4px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;')
		ss.addRule( '.checkout-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.pay-btn', 'width:80%;height:40px;margin-left:10%;font-size:16px;background:#428bca;color:#FFFFFF;border:1px solid #CCC;cursor:pointer;');

		ss.addRule( '.round-border', 'border-radius:5px 5px 5px 5px;' );
		ss.addRule( '.mTop-s', 'margin-top:5px;' );
		ss.addRule( '.mTop-m', 'margin-top:10px;' );
		ss.addRule( '.mTop-l', 'margin-top:20px;' );
		ss.addRule( '.mTop-h', 'margin-top:30px;' );

		ss.addRule( '.checkout-register', 'text-align: right; width: 30%;  font-size:14px; cursor: pointer; color:rgb(66, 139, 202); margin-left:60%;' );


		//register  
		ss.addRule( '.register-sdk', 'width: 400px;height:auto;background: #CCC;margin:140px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;height:auto;display:none;');
		ss.addRule( '.register-head', 'width:100%;height:110px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.register-head-title', 'width: 100%;text-align: center;font-size: 20px;font-weight: bold;');
		ss.addRule( '.register-head-description', 'width: 100%;text-align: center;font-size: 14px;');
		ss.addRule( '.register-body', 'width:100%;height: auto;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
		ss.addRule( '.register-input', 'width:70%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:15%;padding-left:10px;margin-top: 10px;border-radius: 5px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;');
		ss.addRule( '.register-validate-code', 'width: 50%;margin-left:15%;');
		ss.addRule( '.register-phone-btn', 'width: 18%;font-size:14px;padding: 8px;border:1px solid #CCC;border-radius: 2px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;margin-left:2%;');
		ss.addRule( '.register-phone-btn:hover', 'cursor: pointer;');
		ss.addRule( '.register-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;');
		ss.addRule( '.register-btn-submit', 'width:73%;height:42px;margin-top:20px;border:1px solid #CCC;font-size:16px;margin-left:15%;text-align: center;padding: 8px;background: #52A552;border-radius: 5px;cursor:pointer;');
		ss.addRule( '.register-back', 'width: 100%;font-size: 16px;font-weight: bold;text-align: left;margin-left: 20px;cursor: pointer;' );
		ss.addRule( '.register-back:hover', 'color: #22B8CB;' );
		ss.addRule( '.register-error-msg', 'width:100%; text-align:center; color:#FF0000;font-size:14px;' );

		//apply credit layout
		ss.addRule( '.apply-sdk', 'width: 400px;height:auto;background: #CCC;margin:140px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;height:auto;display:none;');
		ss.addRule( '.apply-head', 'width:100%;height:110px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.apply-head-title', 'width: 100%;text-align: center;font-size: 20px;font-weight: bold;');
		ss.addRule( '.apply-head-description', 'width: 100%;text-align: center;font-size: 14px;');
		ss.addRule( '.apply-body', 'width:100%;height: auto;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
		ss.addRule( '.apply-input', 'width:70%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:15%;padding-left:10px;margin-top: 10px;border-radius: 5px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;');
        ss.addRule( '.apply-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;');
		ss.addRule( '.apply-input-first-name', 'width: 32%;');
		ss.addRule( '.apply-input-last-name', 'width:32%;margin-left: 3%;');
		ss.addRule( '.apply-btn-submit', 'width:73%;height:42px;border:1px solid #CCC;font-size:16px;margin-left:15%;text-align: center;padding: 8px;margin-top: 10px;background: #52A552;border-radius: 5px;');
        ss.addRule( '.apply-back', 'width: 100%;font-size: 16px;font-weight: bold;text-align: left;margin-left: 20px;cursor: pointer;' );
		ss.addRule( '.apply-back:hover', 'color: #22B8CB;' );
		ss.addRule( '.apply-error-msg', 'width:100%; text-align:center; color:#FF0000;font-size:14px;' );

		//credit check layout
		ss.addRule( '.credit-sdk', 'width: 400px;height:auto;background: #CCC;margin:140px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;height:auto;display:none;');
		ss.addRule( '.credit-head', 'width:100%;height:110px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.credit-head-title', 'width: 100%;text-align: center;font-size: 20px;font-weight: bold;');
		ss.addRule( '.credit-head-description', 'width: 100%;text-align: center;font-size: 14px;');
		ss.addRule( '.credit-body', 'width:100%;height: auto;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
	    ss.addRule( '.credit-body-desc', 'width: 100%;text-align: center;');
	    ss.addRule( '.credit-body-amount', 'width: 100%;text-align: center;color: #52A552;');
		ss.addRule( '.credit-btn-submit', 'width:73%;height:42px;border:1px solid #CCC;font-size:16px;margin-left:15%;text-align: center;padding: 8px;margin-top: 10px;background: #52A552;border-radius: 5px;');

		//Checkout success loading
		ss.addRule( '.checkout-spinner', 'margin: 200px auto;width: 60px;height: 60px;position: relative;opacity: 1;');
		ss.addRule( '.checkout-container1 > div, .checkout-container2 > div, .checkout-container3 > div', 'width: 16px;height: 16px;background-color: rgb(66, 139, 202);border-radius: 100%;position: absolute;-webkit-animation: checkout-bouncedelay 1.2s infinite ease-in-out;animation: checkout-bouncedelay 1.2s infinite ease-in-out;-webkit-animation-fill-mode: both;animation-fill-mode: both;' );
		ss.addRule( '.checkout-spinner .checkout-spinner-container', 'position: absolute;width: 100%;height: 100%;' );
		ss.addRule( '.checkout-container2', '-webkit-transform: rotateZ(45deg);transform: rotateZ(45deg);' );
		ss.addRule( '.checkout-container3', '-webkit-transform: rotateZ(90deg);transform: rotateZ(90deg);' );
		ss.addRule( '.checkout-circle1', 'top: 0; left: 0;' );
		ss.addRule( '.checkout-circle2', 'top: 0; right: 0;' );
		ss.addRule( '.checkout-circle3', 'right: 0; bottom: 0;' );
		ss.addRule( '.checkout-circle4', 'left: 0; bottom: 0;' );
		ss.addRule( '.checkout-container2 .checkout-circle1', '-webkit-animation-delay: -1.1s;animation-delay: -1.1s;' );
		ss.addRule( '.checkout-container3 .checkout-circle1', '-webkit-animation-delay: -1.0s;animation-delay: -1.0s;' );
		ss.addRule( '.checkout-container1 .checkout-circle2', '-webkit-animation-delay: -0.9s;animation-delay: -0.9s;' );
		ss.addRule( '.checkout-container2 .checkout-circle2', '-webkit-animation-delay: -0.8s;animation-delay: -0.8s;' );
		ss.addRule( '.checkout-container3 .checkout-circle2', '-webkit-animation-delay: -0.7s;animation-delay: -0.7s;' );
		ss.addRule( '.checkout-container1 .checkout-circle3', '-webkit-animation-delay: -0.6s;animation-delay: -0.6s;' );
		ss.addRule( '.checkout-container2 .checkout-circle3', '-webkit-animation-delay: -0.5s;animation-delay: -0.5s;' );
		ss.addRule( '.checkout-container3 .checkout-circle3', '-webkit-animation-delay: -0.4s;animation-delay: -0.4s;' );
		ss.addRule( '.checkout-container1 .checkout-circle4', '-webkit-animation-delay: -0.3s;animation-delay: -0.3s;' );
		ss.addRule( '.checkout-container2 .checkout-circle4', '-webkit-animation-delay: -0.2s;animation-delay: -0.2s;' );
		ss.addRule( '.checkout-container3 .checkout-circle4', '-webkit-animation-delay: -0.1s;animation-delay: -0.1s;' );
		ss.addRule( '@-webkit-keyframes checkout-bouncedelay', '0%, 80%, 100% { -webkit-transform: scale(0.0) }40% { -webkit-transform: scale(1.0) }' );
		ss.addRule( '@-webkit-keyframes checkout-bouncedelay', '0%, 80%, 100% { transform: scale(0.0);-webkit-transform: scale(0.0);} 40% {transform: scale(1.0);-webkit-transform: scale(1.0);}' );
		ss.addRule( '.checkout-loading-page', 'width:302px;height:410px;z-index:999;background:rgb(229, 229, 208);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;position: relative;top:-395px; opacity: 0.7;display:none;' );

		//payment success
		ss.addRule( '.success-description', 'width:400px;margin: 0 auto;margin-top: 60px;' );
		ss.addRule( '.success-description p', 'width: 100%;text-align: center;font-size: 24px;font-weight: bold;' );
		ss.addRule( '.success-back-shopping', 'margin-top: 120px;margin-left:340px;' );
		ss.addRule( '.success-sdk', 'display:none;width: 600px;height:300px;background: #CCC;margin:230px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;');
       

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
		phoneNumberInput.setAttribute( 'maxLength', PHONE_NUMBER_LENGTH );
		var	dynamicCodeInput = document.createElement( 'input' );
		dynamicCodeInput.setAttribute( 'placeholder', PASS_CODE );
		dynamicCodeInput.setAttribute( 'type', 'text' );
		var dynamicCodeBtn = document.createElement( 'button' );
		dynamicCodeBtn.setAttribute( 'type', 'button' );
		dynamicCodeBtn.innerHTML = PASS_CODE;
		var passwordInput = document.createElement( 'input' );
		passwordInput.setAttribute( 'type', 'password' );
		passwordInput.setAttribute( 'placeholder', 'Password' );

		var	payButton = document.createElement( 'button' );
		payButton.setAttribute( 'type', 'button' );
		
		var registerText = document.createElement( 'p' );
		registerText.innerHTML = REGISTER_TEXT;
		var pBlank = document.createElement( 'p' );
		payButton.innerHTML = 'Pay $ ' + amount;
		//register text click for register process
		registerText.onclick = function(){
			showScreen( register_sdk );
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


		//Register Create Element
		var	register_close = document.createElement( 'div');
		var register_divider = document.createElement( 'div' );
	    var register_error = document.createElement( 'p' );
        var register_sdk = document.createElement( 'div' );
        var register_head = document.createElement( 'div' );
        var register_head_title = document.createElement( 'p' );
        register_head_title.innerHTML = 'Register';
        var register_head_description = document.createElement( 'p' );
        register_head_description.innerHTML = HEAD_DESCRIPTION; 
        var register_body = document.createElement( 'form' );
        register_body.setAttribute( 'name', 'registerForm');
        var register_phone = document.createElement( 'input' );
        register_phone.setAttribute( 'placeholder', PHONE_NUMBER );
        register_phone.setAttribute( 'type', 'tel' );
        register_phone.setAttribute( 'required', 'required' );
        register_phone.setAttribute( 'maxLength', PHONE_NUMBER_LENGTH );
        var register_validate_code = document.createElement( 'input' );
        register_validate_code.setAttribute( 'type', 'text' );
        register_validate_code.setAttribute( 'placeholder', VALIDATE_CODE );
        register_validate_code.setAttribute( 'required', 'required' );
        register_validate_code.setAttribute( 'maxLength', '6' );
        var register_code_send = document.createElement( 'button' );
        register_code_send.setAttribute( 'type', 'button' );
        register_code_send.innerHTML = SEND;
        var register_password = document.createElement( 'input');
        register_password.setAttribute( 'type', 'password' );
        register_password.setAttribute( 'placeholder', 'Password' );
        register_password.setAttribute( 'required', 'required' );
        var register_password_confirm = document.createElement( 'input' );
        register_password_confirm.setAttribute( 'type', 'password' );
        register_password_confirm.setAttribute( 'placeholder', 'Password Confirm' );
        register_password_confirm.setAttribute( 'required', 'required' );
        var register_btn_submit = document.createElement( 'button' );
        register_btn_submit.setAttribute( 'type', 'button' );
        register_btn_submit.innerHTML = SIGN_UP;
        // register_btn_submit.disabled = true;
        var register_back = document.createElement( 'a' );
        register_back.innerHTML = 'BACK';
        var register_p_blank = document.createElement( 'p' );


    //Apply Credit
	    var	apply_close = document.createElement( 'div');
	    var apply_divider = document.createElement( 'div' );
	    var apply_error = document.createElement( 'p' );
        var apply_sdk = document.createElement( 'div' );
        var apply_head = document.createElement( 'div' );
        var apply_head_title = document.createElement( 'p' );
        apply_head_title.innerHTML = 'Apply Credit';
        var apply_head_description = document.createElement( 'p' );
        apply_head_description.innerHTML = HEAD_DESCRIPTION; 
        var apply_body = document.createElement( 'form' );
        apply_body.setAttribute( 'name', 'applyForm');
        var apply_first_name = document.createElement( 'input' );
        apply_first_name.setAttribute( 'type', 'text' );
        apply_first_name.setAttribute( 'placeholder', 'First Name' );
        apply_first_name.setAttribute( 'required', 'required' );
        var apply_last_name = document.createElement( 'input' );
        apply_last_name.setAttribute( 'type', 'text' );
        apply_last_name.setAttribute( 'placeholder', 'Last Name' );
        apply_last_name.setAttribute( 'required', 'required' );
        var apply_email = document.createElement( 'input' );
        apply_email.setAttribute( 'type', 'email' );
        apply_email.setAttribute( 'placeholder', 'Email' );
        apply_email.setAttribute( 'required', 'required' );
        var apply_address = document.createElement( 'input' );
        apply_address.setAttribute( 'type', 'text' );
        apply_address.setAttribute( 'placeholder', 'Residential Address' );
        apply_address.setAttribute( 'required', 'required' );
        var apply_dob = document.createElement( 'input' );
        apply_dob.setAttribute( 'type', 'text' );
        apply_dob.setAttribute( 'placeholder', 'Date of Birth' );
        apply_dob.setAttribute( 'required', 'required' );
        var apply_ssn = document.createElement( 'input' );
        apply_ssn.setAttribute( 'type', 'text' );
        apply_ssn.setAttribute( 'placeholder', 'SSN' );
        apply_ssn.setAttribute( 'required', 'required' );
        apply_ssn.setAttribute( 'maxLength', '9' );
        var apply_btn_submit = document.createElement( 'button' );
        apply_btn_submit.setAttribute( 'type', 'button' );
        apply_btn_submit.innerHTML = 'Submit';
        var apply_back = document.createElement( 'a' );
        apply_back.innerHTML = '';
        var apply_p_blank = document.createElement( 'p' );

     //Credit Check
        var	credit_close = document.createElement( 'div');
	    var credit_divider = document.createElement( 'div' );
	    var credit_sdk = document.createElement( 'div' );
        var credit_head = document.createElement( 'div' );
        var credit_head_title = document.createElement( 'p' );
        credit_head_title.innerHTML = 'Congraduation!';
        var credit_head_description = document.createElement( 'p' );
        credit_head_description.innerHTML = HEAD_DESCRIPTION; 
        var credit_body = document.createElement( 'div' );
        var credit_body_desc = document.createElement( 'h2' );
        credit_body_desc.innerHTML = 'Your credit limit is:';
        var credit_body_amount = document.createElement( 'h1' );
        // credit_body_amount.innerHTML = '$1000';
        var credit_body_note = document.createElement( 'h2' );
        var credit_body_ok = document.createElement( 'button' );
        credit_body_ok.innerHTML = CREDIT_BACK_BTN;
        credit_body_ok.setAttribute( 'type', 'button' ); 
        var credit_p_blank = document.createElement( 'p' );

     //Payment success
        var success_sdk = document.createElement( 'div' );
        var success_description = document.createElement( 'div' );
        var success_des_content = document.createElement( 'p' );
        var success_back_shopping = document.createElement( 'div' );
        var success_back_link = document.createElement( 'a' );
        success_des_content.innerHTML = 'Payment Successful!';
        success_back_link.innerHTML = '<<<< Go on shopping!';
        success_back_link.setAttribute( 'href', successBackUrl );


   //Checkout
      
		//user get dynamic code by sending 
		dynamicCodeBtn.onclick = function(){
			if( checkoutHasSendCode ) return;

			var phoneValue = phoneNumberInput.value;
			var passwordValue = passwordInput.value;
			if( phoneValue == undefined || phoneValue == '' || passwordValue == undefined || passwordValue == '' ) return;
			var patrn=/^[0-9]{1,20}$/; 
		    var flag = patrn.test( phoneValue );
		    checkoutErrorMsg( '' );
		    if( !flag || phoneValue.length != 10 ){
			    checkoutErrorMsg( PHONE_NUMBER_ERROR );
			    return;
		    }
		    var checkoutDynamicCodeUrl = URL.getTransactionSMS;
		    var message = {
		    	phone: phoneValue,
		    	country_code: GLOBAL_CONTRY_CODE,
		    	password: passwordValue
		    };
		    var pDynamicCode = templateApiCall( checkoutDynamicCodeUrl, message );
		    var msg = JSON.parse( pDynamicCode.responseText );
		    if( pDynamicCode.status == 200 ){
		    	console.log( 'get dynamic code on pay by pier', msg );
		    	session_token = msg.result.session_token;
		    	passCode = msg.result.code;
		    	user_id = msg.result.user_id;
		    	status_bit = msg.result.status_bit;
		    	if( status_bit != APPLY_CREDIT_FINISHED ){ switchScreenByBit( status_bit ); }
		    	
		    	checkoutHasSendCode = true;
		    	checkoutTimer();
		    }else{
		    	checkoutErrorMsg( msg.message );
		    }


		};

		//120s timer clock 
        var checkoutTimer = function(){
			// var validationSend = register_code_send;

			dynamicCodeBtn.innerHTML = checkTimetemp;
			checkTimetemp -= 1;
			if( checkTimetemp == 0 ){
				checkTimetemp = 120;
				dynamicCodeBtn.innerHTML = RESEND;
				checkoutHasSendCode = false;
				return;
			}
			checkoutT = setTimeout( checkoutTimer, 1000 )
			return checkoutT;
  
	    }
		//payment button
		payButton.onclick = function() {
			var phoneValue = phoneNumberInput.value;
			var dynamicCodeInputValue = dynamicCodeInput.value;
			var passwordValue = passwordInput.value;

			if( dynamicCodeInputValue === undefined || dynamicCodeInputValue === '' || dynamicCodeInputValue  === undefined || dynamicCodeInputValue === '' ) return;

			var payUrl = URL.getAuthToken;
			var message = {
				phone: phoneValue,
				country_code: GLOBAL_CONTRY_CODE,
				pass_code: passCode,
				pass_type: PASS_TYPE,
				password: passwordValue,
				merchant_id: merchantId,
				amount: amount,
				currency_code: CURRENCY_CODE,
				session_token: session_token
			};
			checkout_loading_page.style.display = 'block';
			var pPayment = templateApiCall( payUrl, message );
			var msg = JSON.parse( pPayment.responseText );
			if( pPayment.status == 200 ){
				if( msg.code == 200 ){
					console.log( 'Pay by pier success', msg );
					authToken = msg.result.auth_token;
					setTimeout( makePayment, 3000 );
				}else{
					checkoutErrorMsg( msg.message );
				}
			}else{
				checkoutErrorMsg( msg.message );
			}
		};

		//payment
		var makePayment = function(){
			var paymentUrl = merchantAction;
			paymentUrl += '/' + amount + '/' + authToken + '/' + CURRENCY_CODE;

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

			if( xhr.readyState == 4 && xhr.status == 200 ){
                checkout_loading_page.style.display = 'none';
				showScreen( success_sdk );
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
		checkoutError.classList.add( 'register-error-msg' );
		phoneNumberInput.classList.add( 'checkout-input' );
		phoneNumberInput.classList.add( 'round-border' );
		phoneNumberInput.classList.add( 'mTop-l' );
		dynamicCodeInput.classList.add( 'checkout-input-code' );
		dynamicCodeInput.classList.add( 'round-border' );
		dynamicCodeInput.classList.add( 'mTop-m' );
		dynamicCodeBtn.classList.add( 'checkout-dynamic-code-btn' );
		dynamicCodeBtn.classList.add( 'round-border' );
		dynamicCodeBtn.classList.add( 'mTop-m' );
		passwordInput.classList.add( 'checkout-input' );
		passwordInput.classList.add( 'round-border' );
		passwordInput.classList.add( 'mTop-m' );
		payButton.classList.add( 'pay-btn' );
		payButton.classList.add( 'round-border' );
		payButton.classList.add( 'mTop-l' );
		registerText.classList.add( 'checkout-register' );

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

		
		//Register Element add class
		register_close.classList.add( 'close' );
		register_close.onclick = function() {
			clearAllData();
			showScreen( checkout );
			overlay.style.visibility = 'hidden';
			pier_body.style.visibility = 'hidden';
		}
	   register_error.classList.add( 'register-error-msg' );
	   register_divider.classList.add( 'divider' );
	   register_sdk.classList.add( 'register-sdk' );
	   register_head.classList.add( 'register-head' );
	   register_head_title.classList.add( 'register-head-title' );
	   register_head_description.classList.add( 'register-head-description' );
	   register_body.classList.add( 'register-body' );
	   register_phone.classList.add( 'register-input' );
	   register_validate_code.classList.add( 'register-input' );
	   register_validate_code.classList.add( 'register-validate-code' );
	   register_code_send.classList.add( 'register-phone-btn' );
	   register_password.classList.add( 'register-input' );
	   register_password_confirm.classList.add( 'register-input' );
	   register_btn_submit.classList.add( 'register-btn-submit' );
	   register_back.classList.add( 'register-back' );

	   //Apply Credit
	   apply_close.classList.add( 'close' );
	   apply_close.onclick = function() {
			clearAllData();
			showScreen( checkout );
			overlay.style.visibility = 'hidden';
			pier_body.style.visibility = 'hidden';
	   };
	   apply_error.classList.add( 'apply-error-msg' );
	   apply_divider.classList.add( 'divider' );
	   apply_sdk.classList.add( 'apply-sdk' );
	   apply_head.classList.add( 'apply-head' );
	   apply_head_title.classList.add( 'apply-head-title' );
	   apply_head_description.classList.add( 'apply-head-description' );
	   apply_body.classList.add( 'apply-body' );
	   apply_first_name.classList.add( 'apply-input' );
	   apply_first_name.classList.add( 'apply-input-first-name' );
	   apply_last_name.classList.add( 'apply-input' );
	   apply_last_name.classList.add( 'apply-input-last-name' );
	   apply_email.classList.add( 'apply-input' );
	   apply_address.classList.add( 'apply-input' );
	   apply_dob.classList.add( 'apply-input' );
	   apply_ssn.classList.add( 'apply-input' );
	   apply_btn_submit.classList.add( 'apply-btn-submit' );
	   apply_back.classList.add( 'apply-back' );

	   //Credit Check 
	   credit_close.classList.add( 'close' );
	   credit_close.onclick = function() {
			clearAllData();
			showScreen( checkout );
			overlay.style.visibility = 'hidden';
			pier_body.style.visibility = 'hidden';
	   };
	   credit_divider.classList.add( 'divider' );
	   credit_sdk.classList.add( 'credit-sdk' );
	   credit_head.classList.add( 'credit-head' );
	   credit_head_title.classList.add( 'credit-head-title' );
	   credit_head_description.classList.add( 'credit-head-description' );
	   credit_body.classList.add( 'credit-body' );
	   credit_body_desc.classList.add( 'credit-body-desc' );
	   credit_body_amount.classList.add( 'credit-body-amount' );
	   credit_body_note.classList.add( 'credit-body-desc' );
	   credit_body_ok.classList.add( 'credit-btn-submit' );

	   //payment success
	   success_sdk.classList.add( 'success-sdk' );
	   success_description.classList.add( 'success-description' );
	   success_back_shopping.classList.add( 'success-back-shopping' );






        //checkout append components 
		checkoutHead.appendChild( close );
		checkoutHead.appendChild( checkoutTitle );
		checkoutHead.appendChild( checkoutDescription );

		checkoutBody.appendChild( checkoutError );
		checkoutBody.appendChild( phoneNumberInput );
		checkoutBody.appendChild( passwordInput ); 
		checkoutBody.appendChild( dynamicCodeInput );
		checkoutBody.appendChild( dynamicCodeBtn );
		checkoutBody.appendChild( payButton );
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



		//register append components
		register_head.appendChild( register_close );
		register_head.appendChild( register_head_title );
		register_head.appendChild( register_head_description );
        register_body.appendChild( register_error );
		register_body.appendChild( register_phone );
		register_body.appendChild( register_validate_code );
		register_body.appendChild( register_code_send );
		register_body.appendChild( register_password );
		register_body.appendChild( register_password_confirm );
		register_body.appendChild( register_btn_submit ); 
		register_body.appendChild( register_back );
		register_body.appendChild( register_p_blank );

		//Apply Credit append components
		apply_head.appendChild( apply_close );
		apply_head.appendChild( apply_head_title );
		apply_head.appendChild( apply_head_description );
        apply_body.appendChild( apply_error );
		apply_body.appendChild( apply_first_name );
		apply_body.appendChild( apply_last_name );
		apply_body.appendChild( apply_email );
		apply_body.appendChild( apply_address );
		apply_body.appendChild( apply_dob );
		apply_body.appendChild( apply_ssn );
		apply_body.appendChild( apply_btn_submit ); 
		apply_body.appendChild( apply_back );
		apply_body.appendChild( apply_p_blank );  

		//Credit Check append conponents
		credit_head.appendChild( credit_close );
		credit_head.appendChild( credit_head_title );    
		credit_head.appendChild( credit_head_description );
		credit_body.appendChild( credit_body_desc );
		credit_body.appendChild( credit_body_amount );  
		credit_body.appendChild( credit_body_note );
		credit_body.appendChild( credit_body_ok );
		credit_body.appendChild( credit_p_blank );

		//Payment success
		success_description.appendChild( success_des_content );
		success_back_shopping.appendChild( success_back_link );
		success_sdk.appendChild( success_description );
		success_sdk.appendChild( success_back_shopping );

		
		// attach checkout components in order
		checkout.appendChild( checkoutHead );
		checkout.appendChild( divider );
		checkout.appendChild( checkoutBody );
		checkout.appendChild( checkout_loading_page );

		register_sdk.appendChild( register_head );
		register_sdk.appendChild( register_divider );
		register_sdk.appendChild( register_body );

		apply_sdk.appendChild( apply_head );
		apply_sdk.appendChild( apply_divider );
		apply_sdk.appendChild( apply_body );

		credit_sdk.appendChild( credit_head );
		credit_sdk.appendChild( credit_divider );
		credit_sdk.appendChild( credit_body );

		pier_body.appendChild( register_sdk );
		pier_body.appendChild( checkout );
		pier_body.appendChild( apply_sdk);
		pier_body.appendChild( credit_sdk );
		pier_body.appendChild( success_sdk );

		overlay.appendChild( pier_body ); 
		parentElem.appendChild( overlay );

// Pier Register
       //Constant
       
       
       //send validation code by phone
       register_code_send.onclick = function(){
	       if( registerHasSendCode ) return;
	       registerErrorMsg( '' );
		   var phoneValue = register_phone.value;
		   var patrn=/^[0-9]{1,20}$/; 
		   var flag = patrn.test( phoneValue );
		   if( !flag || phoneValue.length != 10 ){
			   registerErrorMsg( PHONE_NUMBER_ERROR );
			   return;
		   }
		   var sendCodeUrl = URL.getRegisterValidationCode;
		   var message = {
				phone: phoneValue,
			    country_code: GLOBAL_CONTRY_CODE
		   };

		   var pSendCode = templateApiCall( sendCodeUrl, message );
		   var msg = JSON.parse( pSendCode.responseText );
		   
		   if( pSendCode.status == 200 ){
		   	    
		   	    console.log( 'Register send validate code', msg );
		   	    if( msg.code == 200 ){
		   	    	registerHasSendCode = true;
				    registerTimer();
		   	    }else{
		   	    	registerErrorMsg( msg.message );
		   	    }
		   }else{
		   	    registerErrorMsg( msg.message );
		   };

		   
       };
       //when phone number is on focus, the error disappear
       // register_phone.onfocus = function(){
       // 	    registerErrorMsg( '' );
       // } 

       //300s timer clock 
        var registerTimer = function(){
			// var validationSend = register_code_send;

			register_code_send.innerHTML = registerTimeTemp;
			registerTimeTemp -= 1;
			if( registerTimeTemp == 0 ){
				registerTimeTemp = 300;
				register_code_send.innerHTML = RESEND;
				registerHasSendCode = false;
				return;
			}
			registerT = setTimeout( registerTimer, 1000 )
			return registerT;
  
	    }
	   
	  //register back to checkout
	  register_back.onclick = function(){
	  	showScreen( checkout );
	  }
	  //validate code after receiving a validation code on blur
	  register_validate_code.onblur = function(){
	  	  var validateUrl = URL.validateCode;
          var phoneValue = register_phone.value;
          var activationCodeValue = register_validate_code.value;
          if( !registerHasSendCode || activationCodeValue.length != 6 ) return;
          
          var message = {
          	phone: phoneValue,
          	country_code: GLOBAL_CONTRY_CODE,
          	activation_code: activationCodeValue
          };
          var pActivation = templateApiCall( validateUrl, message );
          var msg = JSON.parse( pActivation.responseText );
          if( pActivation.status == 200 ){
		   	   console.log( 'Validate code', msg );
		   	   if( msg.code == 200 ){
                   token = msg.result.token;
                   registerErrorMsg( '' );
		   	   }else{
			   	   console.log( 'Validate code error', msg );
	          	   registerErrorMsg( msg.message );
		   	   }
          }else{
          	console.log( 'Validate code error', msg );
          	registerErrorMsg( msg.message );
          }
	  };

	  

	//validate password format
	  register_password.onblur = function(){
	  	var passwordValue = register_password.value;
	  	var passwordConfirmValue = register_password_confirm.value;
	  	// registerErrorMsg( '' ); 
	  	if( passwordValue == undefined || passwordValue == '' ) return;
	  	var pattern = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,}$/;
	  	if( !pattern.test( passwordValue ) ){
            registerErrorMsg( PASSWORD_FORMAT_ERROR );
	  	}else{
	  		registerErrorMsg( '' );
	  	}
	  	if( passwordConfirmValue != '' && passwordConfirmValue != undefined ) register_password_confirm.onblur();
	  }
	  
	//validate password confirm match
	  register_password_confirm.onblur = function(){
	  	if( register_error.innerHTML != '' && register_error.innerHTML != PASSWORD_MATCH_ERROR ) return;
      
	  	var passwordValue = register_password.value;
	  	var passwordConfirmValue = register_password_confirm.value;
	  	registerErrorMsg( '' );
	  	if( passwordConfirmValue == undefined || passwordConfirmValue == '' ) return;
	  	if( passwordValue != passwordConfirmValue )
	  		registerErrorMsg( PASSWORD_MATCH_ERROR );
	  }
	// register submit
	 register_btn_submit.onclick = function( event ){
        if( !registerCheckSignUp() ) {
        	alert( INFOMATION_NOT_COMPLETED );
        	return;
        }
        var phoneValue = register_phone.value;
        var passwordValue = register_password.value;
        var message = {
            phone: phoneValue,
            country_code: GLOBAL_CONTRY_CODE,
            password: passwordValue,
            token: token
        }
        var registerUrl = URL.register;
        var pRegister = templateApiCall( registerUrl, message );
        var msg = JSON.parse( pRegister.responseText );
        if( pRegister.status == 200 ){
        	console.log( 'register infomation', msg );
        	if( msg.code == 200 ){
        		status_bit = msg.result.status_bit;
        		user_id = msg.result.user_id;
        		device_id = msg.result.device_id;
        		session_token = msg.result.session_token;
        		switchScreenByBit( status_bit );
        	}
        }else{
        	registerErrorMsg( msg.message );
        }
        
	 }

	//Apply Credit submit
	 apply_btn_submit.onclick = function( event ){
	 	if( !applyCheckAllInfo() ) {
	 		alert( INFOMATION_NOT_COMPLETED );
	 		return;
	 	};

	 	var firstNameValue = apply_first_name.value;
	  	var lastNameValue = apply_last_name.value;
	  	var emailValue = apply_email.value;
	  	var addressValue = apply_address.value;
	  	var dobValue = apply_dob.value;
	  	var ssnValue = apply_ssn.value;

	 	var message = {
	 		user_id: user_id,
	 		session_token: session_token,
	 		first_name: firstNameValue,
	 		last_name: lastNameValue,
	 		email: emailValue,
	 		dob: dobValue,
	 		ssn: ssnValue,
	 		address: addressValue
	 	};
	 	var updateUserUrl = URL.updateUser;
	 	var pUpdate = templateApiCall( updateUserUrl, message );
	 	var msg = JSON.parse( pUpdate.responseText );
	 	if( pUpdate.status == 200 ){
	 		console.log( 'Update User success', msg );
	 		if( msg.code == 200 ){
	 			status_bit = msg.result.status_bit;
	 			session_token = msg.result.session_token;
	 			switchScreenByBit( status_bit );
	 		}
	 	}else{
	 		applyErrorMsg( msg.message );
	 	}


	 }

	//show screen controller
	var showScreen = function( obj ){
		checkout.style.display = 'none';
		register_sdk.style.display = 'none';
		apply_sdk.style.display = 'none';
		credit_sdk.style.display = 'none';
		success_sdk.style.display = 'none';
		obj.style.display = 'block';
	};

	var switchScreenByBit = function( bit ){
		switch( bit ){
			case REGISTER_FINISHED: showScreen( apply_sdk );break;
			case UPDATE_INFO_FINIESHED: applyCreditAccess(); break;
			case APPLY_CREDIT_FINISHED: showScreen( credit_sdk ); break;
			default: showScreen( checkout );
		}

	};

   //show error message when something was wrong on register
	  var registerErrorMsg = function( msg ){
	  	if( register_error.innerHTML == '' || msg == '' )
	  	register_error.innerHTML = msg;
	  };
	  var checkoutErrorMsg = function( msg ){
	  	if( checkoutError.innerHTML == '' || msg == '' )
	  	checkoutError.innerHTML = msg;
	  };
	  var applyErrorMsg = function( msg ){
	  	if( apply_error.innerHTML == '' || msg == '' )
	  	apply_error.innerHTML = msg;
	  };

	  //
	  var registerCheckSignUp = function(){
	  	var phoneValue = register_phone.value;
	  	var validationCodeValue = register_validate_code.value;
	  	var passwordValue = register_password.value;
	  	var passwordConfirmValue = register_password_confirm.value;
	  	var errorMsg = register_error.innerHTML;
	  	return phoneValue != undefined && phoneValue != '' && validationCodeValue != '' && validationCodeValue != undefined && passwordValue != ''
	  	   && passwordValue != undefined && passwordConfirmValue != '' && passwordConfirmValue != undefined && errorMsg == '';
	  }
	  var applyCheckAllInfo = function(){
	  	var firstNameValue = apply_first_name.value;
	  	var lastNameValue = apply_last_name.value;
	  	var emailValue = apply_email.value;
	  	var addressValue = apply_address.value;
	  	var dobValue = apply_dob.value;
	  	var ssnValue = apply_ssn.value;
	  	return firstNameValue != undefined && firstNameValue != '' && lastNameValue != undefined && lastNameValue != '' && emailValue != undefined 
		  	&& emailValue != '' &&  addressValue != undefined && addressValue != '' && dobValue != undefined && dobValue != '' && ssnValue != undefined
		  	&& ssnValue != '';
	  }

	  //when close this sdk, it will clear all data
	  var clearAllData = function(){
	  	 phoneNumberInput.value = '';
	  	 passwordInput.value = '';
	  	 dynamicCodeInput.value = '';

	  	 registerErrorMsg( '' );
	  	 register_phone.value = '';
	  	 register_password.value = '';
	  	 register_validate_code.value = '';
	  	 register_password_confirm.value = '';
	  	 apply_first_name.value = '';
	  	 apply_last_name.value = '';
	  	 apply_email.value = '';
	  	 apply_address.value = '';
	  	 apply_dob.value = '';
	  	 apply_ssn.value = '';
	  	 registerHasSendCode = false;
	  	 clearTimeout( registerT );
	  	 clearTimeout( checkoutT );
	  	 register_code_send.innerHTML = SEND;
	  	 dynamicCodeBtn.innerHTML = PASS_CODE;

	  };
	  //template api call, access api
	  var templateApiCall = function(){
	  	var xhr = null;
	  	var templateUrl = arguments[0];
	  	var message = arguments[1];
	  	if ( window.XMLHttpRequest ) {
			xhr = new XMLHttpRequest();
		} else if ( window.ActiveXObject ) {
			xhr = new ActiveXObject( 'Microsoft.XMLHTTP' );
		} else {
			alert( BROWSER_NOT_SUPPORT );
			return;
		}

		xhr.open( 'POST', templateUrl, false );

		xhr.setRequestHeader( 'Content-type', 'application/json' );
			
		console.log( templateUrl );
		xhr.send( JSON.stringify( message ) );
		return xhr;

	  };
	 //apply credit access
	   var applyCreditAccess = function(){
	   	  var message = {
	   	  	user_id: user_id,
	   	  	session_token: session_token,
	   	  	currency_code: CURRENCY_CODE
	   	  };
	   	  var applyUrl = URL.applyCredit;
	   	  var pApply = templateApiCall( applyUrl, message );
	   	  var msg = JSON.parse( pApply.responseText );
	   	  if( pApply.status == 200 ){
	   	  	console.log( 'apply credit:', msg );
	   	  	if( msg.code == 200 ){
	   	  		creditLimit = msg.result.credit_limit;
	   	  		status_bit = msg.result.status_bit;
	   	  		session_token = msg.result.session_token;
	   	  		creditNote = msg.result.note;
	   	  		credit_body_amount.innerHTML = creditLimit;
	   	  		switchScreenByBit( status_bit );
	   	  	}else{
                alert( msg.message );
	   	  	}
	   	  	
	   	  }else{
			 alert( msg.message ); 
	   	  }
	   }
	 //apply credit ok button event
	   credit_body_ok.onclick = function(){
	   	 clearAllData();
	   	 showScreen( checkout );
	   }
	  

	}.call( this );
}() );