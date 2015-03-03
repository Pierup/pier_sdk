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
				merchantAction = me.getAttribute( 'data-action' );

		if ( merchantId === null ) {
			console.error( 'Missing data-merchant-id attribute' );
			return;
		} else if ( merchantAction === null ) {
			console.error( 'Missing data-action attribute' );
			return;
		}

		// API call
		var url = {
			getAuthToken: 'http://pierup.ddns.net:8686/user_api/v1/sdk/get_auth_token',
			getDynamicCode: '',
			getRegisterValidationCode: 'http://pierup.ddns.net:8686/user_api/v1/sdk/get_auth_token',
			validateCode: '',
			register:''
		};

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
		ss.addRule( '.checkout', 'width:302px;height:365px;margin:250px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;' );
		ss.addRule( '.checkout-head', 'width:100%;height:120px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.checkout-body', 'width:100%;height:237px;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
		ss.addRule( '.divider', 'width:100%;height:1px;background:#fff;box-shadow:1px 1px 0.5px #888888;');
		ss.addRule( '.close', "margin-top:7px;margin-left:90%;width:22px;height:23px;cursor:pointer;background-size:100% 100%;background-image: url('data:image/png;base64,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');")
		ss.addRule( '.checkout-title', 'text-align:center;margin-bottom:5px;font-size:18px;font-weight:bold;' );
		ss.addRule( '.checkout-description', 'text-align:center;margin-top:0;font-size:13px;color:#5b5b65;font-family:"HelveticaNeueMedium","HelveticaNeue-Medium","Helvetica Neue Medium","HelveticaNeue","Helvetica Neue",Helvetica,Arial;' );
		ss.addRule( '.checkout-input', 'width:76%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:10%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.checkout-input-code', 'width:44%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:10%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.checkout-dynamic-code-btn', 'cursor:pointer;width:32%;height:32px;border:1px solid #CCC;font-size:10px;margin-left:2%;padding:4px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;')
		ss.addRule( '.checkout-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.pay-btn', 'width:80%;height:40px;margin-left:10%;font-size:16px;background:#428bca;color:#FFFFFF;border:1px solid #CCC;cursor:pointer;');

		ss.addRule( '.round-border', 'border-radius:6px 6px 6px 6px;' );
		ss.addRule( '.mTop-s', 'margin-top:10px;' );
		ss.addRule( '.mTop-m', 'margin-top:20px;' );
		ss.addRule( '.mTop-l', 'margin-top:30px;' );
		ss.addRule( '.mTop-h', 'margin-top:40px;' );

		ss.addRule( '.checkout-register', 'text-align: right; width: 30%; height:40px; font-size:14px; cursor: pointer; color:rgb(66, 139, 202); margin-left:60%;' );


		//register & apply credit layout
		ss.addRule( '.register-sdk', 'width: 400px;height:auto;background: #CCC;margin:140px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;height:auto;');
		ss.addRule( '.register-head', 'width:100%;height:110px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.register-head-title', 'width: 100%;text-align: center;font-size: 20px;font-weight: bold;');
		ss.addRule( '.register-head-description', 'width: 100%;text-align: center;font-size: 14px;');
		ss.addRule( '.register-body', 'width:100%;height: auto;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
		ss.addRule( '.register-input', 'width:70%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:15%;padding-left:10px;margin-top: 10px;border-radius: 5px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;');
		ss.addRule( '.register-validate-code', 'width: 50%;margin-left:15%;');
		ss.addRule( '.register-phone-btn', 'width: 18%;font-size:14px;padding: 8px;border:1px solid #CCC;border-radius: 2px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;margin-left:2%;');
		ss.addRule( '.register-phone-btn:hover', 'cursor: pointer;');
		ss.addRule( '.register-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;');
		ss.addRule( '.register-input-first-name', 'width: 32%;');
		ss.addRule( '.register-input-last-name', 'width:32%;margin-left: 1%;');
		ss.addRule( '.register-btn-submit', 'width:73%;height:42px;border:1px solid #CCC;font-size:16px;margin-left:15%;text-align: center;padding: 8px;margin-top: 10px;background: #52A552;border-radius: 5px;');
		ss.addRule( '.register-back', 'width: 100%;font-size: 16px;font-weight: bold;text-align: left;margin-left: 20px;cursor: pointer;' );
		ss.addRule( '.register-back:hover', 'color: #22B8CB;' );
		ss.addRule( '.register-error-msg', 'width:100%; text-align:center; color:#FF0000;font-size:14px;' );
        
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
		var	close1 = document.createElement( 'div');
		var	checkoutTitle = document.createElement( 'p' );
				checkoutTitle.innerHTML = name;
		var	checkoutDescription = document.createElement( 'div' );
				checkoutDescription.innerHTML = description;

		var divider = document.createElement( 'div' );
		var register_divider = document.createElement( 'div' );

		// Pier checkout body
		var	checkoutBody = document.createElement( 'div' );
		var	phoneNumberInput = document.createElement( 'input' );
		phoneNumberInput.setAttribute( 'placeholder', 'Phone Number' );
		var	passwordInput = document.createElement( 'input' );
		passwordInput.setAttribute( 'placeholder', 'Dynamic Code' );
		passwordInput.setAttribute( 'type', 'text' );
		var	payButton = document.createElement( 'button' );
		payButton.setAttribute( 'type', 'button' );
		var dynamicCode = document.createElement( 'button' );
		dynamicCode.setAttribute( 'type', 'button' );
		dynamicCode.innerHTML = 'Dynamic Code';
		var registerText = document.createElement( 'p' );
		registerText.innerHTML = 'New Account';
		var pBlank = document.createElement( 'p' );
		payButton.innerHTML = 'Pay $ ' + amount;
		//register text click for register process
		registerText.onclick = function(){
			// window.location.href = "http://localhost:8686/#/userRegister";
			checkout.style.display = 'none';
			register_sdk.style.display = 'block';

		}

		//Register Create Element
	   var register_error = document.createElement( 'p' );
       var register_sdk = document.createElement( 'div' );
       var register_head = document.createElement( 'div' );
       var register_head_title = document.createElement( 'p' );
       register_head_title.innerText = 'Register & Apply Credit';

       var register_head_description = document.createElement( 'p' );
       register_head_description.innerText = 'Simple credit for living a better live'; 
       var register_body = document.createElement( 'form' );
       register_body.setAttribute( 'name', 'registerForm');
       var register_phone = document.createElement( 'input' );
       register_phone.setAttribute( 'placeholder', 'Phone Number' );
       register_phone.setAttribute( 'type', 'tel' );
       register_phone.setAttribute( 'required', 'required' );
       register_phone.setAttribute( 'maxLength', '10' );
       var register_validate_code = document.createElement( 'input' );
       register_validate_code.setAttribute( 'type', 'text' );
       register_validate_code.setAttribute( 'placeholder', 'Validation Code' );
       register_validate_code.setAttribute( 'required', 'required' );
       var register_code_send = document.createElement( 'button' );
       register_code_send.setAttribute( 'type', 'button' );
       register_code_send.innerText = 'Send';
       var register_password = document.createElement( 'input');
       register_password.setAttribute( 'type', 'password' );
       register_password.setAttribute( 'placeholder', 'Password' );
       register_password.setAttribute( 'required', 'required' );
       var register_password_confirm = document.createElement( 'input' );
       register_password_confirm.setAttribute( 'type', 'password' );
       register_password_confirm.setAttribute( 'placeholder', 'Password Confirm' );
       register_password_confirm.setAttribute( 'required', 'required' );
       var register_first_name = document.createElement( 'input' );
       register_first_name.setAttribute( 'type', 'text' );
       register_first_name.setAttribute( 'placeholder', 'First Name' );
       register_first_name.setAttribute( 'required', 'required' );
       var register_last_name = document.createElement( 'input' );
       register_last_name.setAttribute( 'type', 'text' );
       register_last_name.setAttribute( 'placeholder', 'Last Name' );
       register_last_name.setAttribute( 'required', 'required' );
       var register_email = document.createElement( 'input' );
       register_email.setAttribute( 'type', 'email' );
       register_email.setAttribute( 'placeholder', 'Email' );
       register_email.setAttribute( 'required', 'required' );
       var register_address = document.createElement( 'input' );
       register_address.setAttribute( 'type', 'text' );
       register_address.setAttribute( 'placeholder', 'Residential Address' );
       register_address.setAttribute( 'required', 'required' );
       var register_dob = document.createElement( 'input' );
       register_dob.setAttribute( 'type', 'text' );
       register_dob.setAttribute( 'placeholder', 'Date of Birth' );
       register_dob.setAttribute( 'required', 'required' );
       var register_ssn = document.createElement( 'input' );
       register_ssn.setAttribute( 'type', 'text' );
       register_ssn.setAttribute( 'placeholder', 'SSN' );
       register_ssn.setAttribute( 'required', 'required' );
       var register_btn_submit = document.createElement( 'button' );
       register_btn_submit.setAttribute( 'type', 'submit' );
       register_btn_submit.innerText = 'Submit';
       var register_back = document.createElement( 'a' );
       register_back.innerText = 'BACK';

		//user get dynamic code by sending 
		dynamicCode.onclick = function(){
			var xhrGetDynamicCode = null;

			if ( window.XMLHttpRequest ) {
				xhrGetDynamicCode = new XMLHttpRequest();
			} else if ( window.ActiveXObject ) {
				xhrGetDynamicCode = new ActiveXObject( 'Microsoft.XMLHTTP' );
			} else {
				alert( 'Your browser is too old to support send ...' );
				return;
			}
			xhrGetDynamicCode.open( 'POST', url.getDynamicCode, false );
			xhrGetDynamicCode.onreadystatechange = function() {
				if ( xhrGetDynamicCode.readyState == 4 ) {
					console.log( xhrGetDynamicCode.responseText );
					if ( xhrGetDynamicCode.status == 200 ) {

					}
				}
			};
			var phone = phoneNumberInput.value;

			xhrGetDynamicCode.setRequestHeader( 'Content-type', 'application/json' );

			var message = {
	            phone: phone
			}

			xhrGetDynamicCode.send( JSON.stringify( message ) );

		};
		//payment button
		payButton.onclick = function() {
			var phone = phoneNumberInput.value;
			var pwd = passwordInput.value;

			if( phone === undefined || phone === '' || pwd  === undefined || pwd === '' ) return;

			var xhrGetToken = null;

			if ( window.XMLHttpRequest ) {
				xhrGetToken = new XMLHttpRequest();
			} else if ( window.ActiveXObject ) {
				xhrGetToken = new ActiveXObject( 'Microsoft.XMLHTTP' );
			} else {
				alert( 'Your browser is too old to support pay by Pier...' );
				return;
			}

			xhrGetToken.open( 'POST', url.getAuthToken, false );

			xhrGetToken.onreadystatechange = function() {
				if ( xhrGetToken.readyState == 4 ) {
					console.log( xhrGetToken.responseText );
					if ( xhrGetToken.status == 200 ) {
						var token = JSON.parse( xhrGetToken.responseText ).result.auth_token;
						console.log( 'Get token: ' + token );
					}
				}
			};

			xhrGetToken.setRequestHeader( 'Content-type', 'application/json' );

			// var message = {
			// 	phone: phone,
			// 	// hard code
			// 	country_code: 'CN',
			// 	password: pwd,
			// 	merchant_id: merchantId,
			// 	amount: amount,
			// 	// hard code
			// 	currency_code: 'USD'
			// };
			var message = {
				phone1: "13621643896",
			    country_code: "CN",
			    pass_code: "247338",
			    pass_type: 1,
			    merchant_id: "MC0000000017",
			    amount: "199.00",
			    currency_code: "USD",
			    session_token: "353b22a4-bf2f-11e4-8564-77a7e16f885e"
			}

			console.log( message );
			xhrGetToken.send( message );
		};

		// Pier button setting
		btnElem.setAttribute( 'type', 'button' );
		btnElem.style.width = buttonWidth;
		btnElem.style.height = buttonHeight;
		btnElem.innerHTML = buttonText;
		btnElem.classList.add( 'pier-btn' );
		btnElem.onclick = function() {
			register_sdk.style.display = 'none';
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
			checkout.style.display = 'block';
			register_sdk.style.display = 'none';
			overlay.style.visibility = 'hidden';
			pier_body.style.visibility = 'hidden';
		}

		checkoutTitle.classList.add( 'checkout-title' );
		checkoutDescription.classList.add( 'checkout-description' );

		divider.classList.add( 'divider' );


		checkoutBody.classList.add( 'checkout-body' );
		phoneNumberInput.classList.add( 'checkout-input' );
		phoneNumberInput.classList.add( 'round-border' );
		phoneNumberInput.classList.add( 'mTop-l' );
		passwordInput.classList.add( 'checkout-input-code' );
		passwordInput.classList.add( 'round-border' );
		passwordInput.classList.add( 'mTop-m' );
		dynamicCode.classList.add( 'checkout-dynamic-code-btn' );
		dynamicCode.classList.add( 'round-border' );
		dynamicCode.classList.add( 'mTop-m' );
		payButton.classList.add( 'pay-btn' );
		payButton.classList.add( 'round-border' );
		payButton.classList.add( 'mTop-h' );
		registerText.classList.add( 'checkout-register' );

		//Register Element add class
		close1.classList.add( 'close' );
		close1.onclick = function() {
			clearAllData();
			checkout.style.display = 'block';
			register_sdk.style.display = 'none';
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
	   register_first_name.classList.add( 'register-input' );
	   register_first_name.classList.add( 'register-input-first-name' );
	   register_last_name.classList.add( 'register-input' );
	   register_last_name.classList.add( 'register-input-last-name' );
	   register_email.classList.add( 'register-input' );
	   register_address.classList.add( 'register-input' );
	   register_dob.classList.add( 'register-input' );
	   register_ssn.classList.add( 'register-input' );
	   register_btn_submit.classList.add( 'register-btn-submit' );
	   register_back.classList.add( 'register-back' );


        //checkout append components 
		checkoutHead.appendChild( close );
		checkoutHead.appendChild( checkoutTitle );
		checkoutHead.appendChild( checkoutDescription );

		checkoutBody.appendChild( phoneNumberInput );
		checkoutBody.appendChild( passwordInput );
		checkoutBody.appendChild( dynamicCode );
		checkoutBody.appendChild( payButton );
		checkoutBody.appendChild( registerText );

		//register append components
		register_head.appendChild( close1 );
		register_head.appendChild( register_head_title );
		register_head.appendChild( register_head_description );
        register_body.appendChild( register_error );
		register_body.appendChild( register_phone );
		register_body.appendChild( register_validate_code );
		register_body.appendChild( register_code_send );
		register_body.appendChild( register_password );
		register_body.appendChild( register_password_confirm );
		register_body.appendChild( register_first_name );
		register_body.appendChild( register_last_name );
		register_body.appendChild( register_email );
		register_body.appendChild( register_address );
		register_body.appendChild( register_dob );
		register_body.appendChild( register_ssn );
		register_body.appendChild( register_btn_submit ); 
		register_body.appendChild( register_back );  

		
		// attach checkout components in order
		checkout.appendChild( checkoutHead );
		checkout.appendChild( divider );
		checkout.appendChild( checkoutBody );
		register_sdk.appendChild( register_head );
		register_sdk.appendChild( register_divider );
		register_sdk.appendChild( register_body );
		pier_body.appendChild( register_sdk );
		pier_body.appendChild( checkout );
		overlay.appendChild( pier_body ); 
		parentElem.appendChild( overlay );

// Pier Register
       //Constant
       var timeTemp = 60;
	   var hasSendCode = false;
       
       //send validation code by phone
       register_code_send.onclick = function(){
	       if( hasSendCode ) return;
	       showErrorMsg( '' );
		   var phoneValue = register_phone.value;
		   var patrn=/^[0-9]{1,20}$/; 
		   var flag = patrn.test( phoneValue );
		   if( !flag || phoneValue.length != 10 ){
			   showErrorMsg( 'You must enter a validate phone number!' );
			   return;
		   }
		   var sendCodeUrl = url.getRegisterValidationCode;
		   var message = {
				phone: "13621643896",
			    country_code: "CN",
			    password: "abc123",
			    merchant_id: "MC0000000017",
			    amount: "199.00",
			    currency_code: "USD"
		   };
		   var pSendCode = templateApiCall( sendCodeUrl, message );
		   pSendCode.onreadystatechange = null;
		 //   pSendCode.onreadystatechange = function() {
		   	
			// 	if ( pSendCode.readyState == 4 ) {
			// 		console.log( pSendCode.responseText );
			// 		if ( pSendCode.status == 200 ) {

			// 			// var msg = JSON.parse( xhrValidateCode.responseText ).result.auth_token;
			// 			// console.log( 'Get token: ' + token );
			// 		}
			// 	}
			// }; 

		   hasSendCode = true;
		   timer();
       };
       //when phone number is on focus, the error disappear
       register_phone.onfocus = function(){
       	    showErrorMsg( '' );
       } 

       //60s timer clock 
        var timer = function(){
			// var validationSend = register_code_send;

			register_code_send.innerText = timeTemp;
			timeTemp -= 1;
			if( timeTemp == 0 ){
				timeTemp = 60;
				register_code_send.innerText = 'Resend';
				hasSendCode = false;
				return;
			}
			return setTimeout( timer, 1000 );
  
	   }
	  //register back to checkout
	  register_back.onclick = function(){
	  	checkout.style.display = 'block';
		register_sdk.style.display = 'none';
	  }
	  //validate code after receiving a validation code on blur
	  register_validate_code.onblur = function(){
          if( !hasSendCode ) return;
          var xhrValidateCode = null;

			if ( window.XMLHttpRequest ) {
				xhrValidateCode = new XMLHttpRequest();
			} else if ( window.ActiveXObject ) {
				xhrValidateCode = new ActiveXObject( 'Microsoft.XMLHTTP' );
			} else {
				alert( 'Your browser is too old to support pay by Pier...' );
				return;
			}

			xhrValidateCode.open( 'POST', url.getRegisterValidationCode, false );

			xhrValidateCode.onreadystatechange = function() {
				if ( xhrValidateCode.readyState == 4 ) {
					console.log( xhrValidateCode.responseText );
					if ( xhrValidateCode.status == 200 ) {
						// var msg = JSON.parse( xhrValidateCode.responseText ).result.auth_token;
						// console.log( 'Get token: ' + token );
					}
				}
			};

			xhrValidateCode.setRequestHeader( 'Content-type', 'application/json' );
			var message = {
				
			};
			console.log( message );
			xhrValidateCode.send( JSON.stringify( message ) );
	  }

	  //show error message when something was wrong
	  var showErrorMsg = function( msg ){
	  		register_error.innerText = msg;
	  }
	  //when close this sdk, it will clear all data
	  var clearAllData = function(){
	  	 showErrorMsg( '' );
	  	 register_phone.value = '';
	  	 register_password.value = '';
	  	 register_validate_code.value = '';
	  	 register_password_confirm.value = '';
	  	 register_first_name.value = '';
	  	 register_last_name.value = '';
	  	 register_email.value = '';
	  	 register_address.value = '';
	  	 register_dob.value = '';
	  	 register_ssn.value = '';
	  }
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
			alert( 'Your browser is too old to support pay by Pier...' );
			return;
		}

		xhr.open( 'POST', templateUrl, false );

		xhr.setRequestHeader( 'Content-type', 'application/json' );
			
		console.log( templateUrl );
		xhr.send( JSON.stringify( message ) );
		return xhr;

	  }

	//validate password format
	  register_password.onblur = function(){
	  	var passwordValue = register_password.value;
	  	var passwordConfirmValue = register_password_confirm.value;
	  	showErrorMsg( '' ); 
	  	if( passwordValue == undefined || passwordValue == '' ) return;
	  	var pattern = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,}$/;
	  	if( !pattern.test( passwordValue ) ){
            showErrorMsg( 'Password should contain at least 1 number, 1 character and at least 6-digit' );
	  	}
	  	if( passwordConfirmValue != '' && passwordConfirmValue != undefined ) register_password_confirm.onblur();
	  }
	  
	//validate password confirm match
	  register_password_confirm.onblur = function(){
	  	if( register_error.innerText != '' ) return; 
	  	var passwordValue = register_password.value;
	  	var passwordConfirmValue = register_password_confirm.value;
	  	showErrorMsg( '' );
	  	if( passwordConfirmValue == undefined || passwordConfirmValue == '' ) return;
	  	if( passwordValue != passwordConfirmValue )
	  		showErrorMsg( 'Password is not match' );
	  }
	// register submit
	 register_btn_submit.onclick = function( event ){
        console.log( event );
	 }
	  

	}.call( this );
}() );