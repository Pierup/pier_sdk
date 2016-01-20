/**@name  Pier banner script
 * @author Cheng Cong
 * @util.isDate( 2015-12-30 );
 */
(function(){
    var me = document.querySelector( 'script[class="pier-banner-script"]' );
    if ( me === null ) {
		console.error( 'Class attribute in script must be "pier-banner-script"' );
		return;
	}
	var _merchantId = me.getAttribute( 'pier-data-merchant' ),
	_currency = me.getAttribute( 'pier-data-currency' ),
	_amount = me.getAttribute( 'pier-data-amount' );

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
	ss.addRule( '.pier-banner-wrap', 'width:620px;' );
	ss.addRule( '.pier-banner-wrap table', 'width:100%;');
	ss.addRule( '.pier-banner-wrap table tr td:first-child', 'width:42px;');
	ss.addRule( '.pier-banner-wrap table tr td:nth-child(2)', 'width:88px;');
	var initBanner = function( message ){
		if( typeof message !== 'object') return;
		var	_pierBannerWrap = document.createElement( 'div' );
		_pierBannerWrap.classList.add('pier-banner-wrap');
		var _pierTable = document.createElement( 'table' );
		var _pierTableTr = document.createElement( 'tr' );
		var _pierTableTd1 = document.createElement( 'td' );
		_pierTableTd1.innerHTML = message.col1;
		var _pierTableTd2 = document.createElement( 'td' );
		_pierTableTd2.innerHTML = message.col2;
		var _pierTableTd3 = document.createElement( 'td' );
		_pierTableTd3.innerHTML = message.col3;
		_pierTableTr.appendChild(_pierTableTd1);
		_pierTableTr.appendChild(_pierTableTd2);
		_pierTableTr.appendChild(_pierTableTd3);
		_pierTable.appendChild(_pierTableTr);
		_pierBannerWrap.appendChild(_pierTable);
		// Pier button attach point
		var parentElem = me.parentElement;
		// attach Pier button
		parentElem.appendChild( _pierBannerWrap );
	}

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
		xhr.send( JSON.stringify( message ) );
    };
	var getRemoteData = function(){
		var url = 'http://pierup.cn:4000/sdk/crd/getBannerData';
		var message = {
			merchant_id: _merchantId,
			currency: _currency,
			amount: _amount
		};
		
		var pPost = templateApiCall( url, message, function(httpObj){
	    	var msg = JSON.parse( httpObj.responseText );
		    if( httpObj.status == 200 ){
		    	initBanner(msg);
		    }
		})
	}
	getRemoteData();
})()