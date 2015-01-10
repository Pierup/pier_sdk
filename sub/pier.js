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
			getAuthToken: 'http://pierup.ddns.net:8686/user_api/v1/sdk/get_auth_token'
		};

		// create  CSS styles
		var styleElem = document.createElement( 'style' );
		// for WebKit
		styleElem.appendChild( document.createTextNode( '' ) );
		document.head.appendChild( styleElem );

		var ss = styleElem.sheet;
		ss.addRule( '.pier-btn', 'background-color:#428bca;border-color:#357ebd;color:#fff;text-align:center;white-space:nowrap;vertical-align:middle;cursor:pointer;padding:10px 16px;font-size:14px;border-radius:6px;border:1px solid transparent;' );
		ss.addRule( '.overlay', 'position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:rgba(0,0,0,0.6);visibility:hidden;opacity:1;');
		ss.addRule( '.checkout', 'width:302px;height:365px;margin:250px auto;z-index:999;background:rgba(248,248,255,1);color:#000;box-shadow:0px 3px 10px #000100;border-radius:5px 5px 5px 5px;border:1px solid #000011;visibility:hidden;' );
		ss.addRule( '.checkout-head', 'width:100%;height:120px;border-radius:5px 5px 0 0;background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(250,250,255,0.8)), to(rgba(230,230,255,0.6)));background: -moz-linear-gradient(top, rgba(250,250,255,0.6),rgba(230,230,255,0.4));');
		ss.addRule( '.checkout-body', 'width:100%;height:237px;margin-top:1px;background:rgba(255,255,250,0.8);border-radius:0 0 5px 5px;');
		ss.addRule( '.divider', 'width:100%;height:1px;background:#fff;box-shadow:1px 1px 0.5px #888888;');
		ss.addRule( '.close', "margin-top:7px;margin-left:272px;width:22px;height:23px;cursor:pointer;background-size:100% 100%;background-image: url('data:image/png;base64,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');")
		ss.addRule( '.checkout-title', 'text-align:center;margin-bottom:5px;font-size:18px;font-weight:bold;' );
		ss.addRule( '.checkout-description', 'text-align:center;margin-top:0;font-size:13px;color:#5b5b65;font-family:"HelveticaNeueMedium","HelveticaNeue-Medium","Helvetica Neue Medium","HelveticaNeue","Helvetica Neue",Helvetica,Arial;' );
		ss.addRule( '.checkout-input', 'width:76%;height:32px;border:1px solid #CCC;font-size:16px;margin-left:10%;padding-left:10px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.checkout-input:focus', 'box-shadow:0px 0px 10px rgba(0,204,209,1);border-radius: 6px 6px 6px 6px;transition: box-shadow 1s;-moz-transition: box-shadow 1s;-webkit-transition: box-shadow 1s;-o-transition: box-shadow 1s;' );
		ss.addRule( '.pay-btn', 'width:80%;height:40px;margin-left:10%;font-size:16px;background:#428bca;color:#FFFFFF;border:1px solid #CCC;cursor:pointer;');

		ss.addRule( '.round-border', 'border-radius:6px 6px 6px 6px;' );
		ss.addRule( '.mTop-s', 'margin-top:10px;' );
		ss.addRule( '.mTop-m', 'margin-top:20px;' );
		ss.addRule( '.mTop-l', 'margin-top:30px;' );
		ss.addRule( '.mTop-h', 'margin-top:40px;' );

		// Pier button attach point
		var parentElem = me.parentElement;

		// Pier button
		var	btnElem = document.createElement( 'button' );

		// shadow mask
		var	overlay = document.createElement( 'div' );

		// Pier checkout dialog
		var	checkout = document.createElement( 'div');

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
		var	phoneNumberInput = document.createElement( 'input' );
		phoneNumberInput.setAttribute( 'placeholder', 'Phone Number' );
		var	passwordInput = document.createElement( 'input' );
		passwordInput.setAttribute( 'placeholder', 'Password' );
		passwordInput.setAttribute( 'type', 'password' );
		var	payButton = document.createElement( 'button' );
		payButton.setAttribute( 'type', 'button' );
		payButton.innerHTML = 'Pay $ ' + amount;
		payButton.onclick = function() {
			var phone = phoneNumberInput.value;
			var pwd = passwordInput.value;

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

			var message = {
				phone: phone,
				// hard code
				country_code: 'CN',
				password: pwd,
				merchant_id: merchantId,
				amount: amount,
				// hard code
				currency_code: 'USD'
			};

			console.log( message );
			xhrGetToken.send( JSON.stringify( message ) );
		};

		// Pier button setting
		btnElem.setAttribute( 'type', 'button' );
		btnElem.style.width = buttonWidth;
		btnElem.style.height = buttonHeight;
		btnElem.innerHTML = buttonText;
		btnElem.classList.add( 'pier-btn' );
		btnElem.onclick = function() {
			overlay.style.visibility = 'visible';
			checkout.style.visibility = 'visible';
		};
		// attach Pier button
		parentElem.appendChild( btnElem );

		// overlay mask setting
		overlay.classList.add( 'overlay' );

		// Pier checkout setting
		checkout.classList.add( 'checkout' );

		checkoutHead.classList.add( 'checkout-head' );
		close.classList.add( 'close' );
		close.onclick = function() {
			overlay.style.visibility = 'hidden';
			checkout.style.visibility = 'hidden';
		};
		checkoutTitle.classList.add( 'checkout-title' );
		checkoutDescription.classList.add( 'checkout-description' );

		divider.classList.add( 'divider' );

		checkoutBody.classList.add( 'checkout-body' );
		phoneNumberInput.classList.add( 'checkout-input' );
		phoneNumberInput.classList.add( 'round-border' );
		phoneNumberInput.classList.add( 'mTop-l' );
		passwordInput.classList.add( 'checkout-input' );
		passwordInput.classList.add( 'round-border' );
		passwordInput.classList.add( 'mTop-m' );
		payButton.classList.add( 'pay-btn' );
		payButton.classList.add( 'round-border' );
		payButton.classList.add( 'mTop-h' );


		checkoutHead.appendChild( close );
		checkoutHead.appendChild( checkoutTitle );
		checkoutHead.appendChild( checkoutDescription );

		checkoutBody.appendChild( phoneNumberInput );
		checkoutBody.appendChild( passwordInput );
		checkoutBody.appendChild( payButton );

		// attach checkout components in order
		checkout.appendChild( checkoutHead );
		checkout.appendChild( divider );
		checkout.appendChild( checkoutBody );
		overlay.appendChild( checkout );
		parentElem.appendChild( overlay );
	}.call( this );
}() );