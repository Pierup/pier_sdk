( function() {
	this.Pier = function() {
		// private variables
		var pubicKey = '',
			reCardType = {
				// regExps for validation of different types of cards
				'Visa' : '',
				'American Express': '',
				'Master': '',
				'Union Pay': ''
			};
			// reExp for validation of CVC
			reCVC = '',
			// URLs of backend APIs
			endPoints = {
				getCardInfo: '',
				getAccoundInfo: ''
			};

		// public variables
		var version = 0.00;
		
		// private methods
		var getInfo = function( url, msg ) {
				/*
				 * XMLHttpRequest to call backend
				 * need to coordinate with server side
				 * security issues would be extremely import  
				 */
			},
			makeUrlQuery = function( objArgs ) {
				/* format of message to be sent decided by
				 * backend APIs
				 */
			};

		// public methods
		var cardType = function( strCardType ) {
				for ( var cardType in reCardType ) {
					if ( reCardType[cardType].match() ) {
						return cardType;
					}
				}
				return 'mistake';
			},
			validateCVC = function( strCVC ) {
				if ( reCVC.match() ) {
					return true;
				}
				return false;
			},
			validateExpiry = function( strMonth, strYear ) {
				/* all validate tool methods implement by reExp */
			},
			validateCardNumber = function( strCardNum ) {
				/* all validate tool methods implement by reExp */
			},
			validateAccountNumber = function( strAcountNum, strCountry ) {
				/* all validate tool methods implement by reExp */
			},
			validateRoutingNumber = function( strAcountNum, strCountry ) {
				/* all validate tool methods implement by reExp */
			}
			setPublishableKey = function( strKey ) {
				publicKey = strKey;
			},
			createTokenCard = function( objToken, 
										/* PierupResponseHandler is used for checkout widget*/
										PierupResponseHandler ) {
				// validate inputs
				if ( !validateCardNumber( objToken.number ) ) return false;
				if ( !validateCVC( objToken.cvc ) ) return false;
				if ( !validateExpiry( objToken.exp_month, objToken.exp_year ) ) return false;

				var strQuery = makeUrlQuery( objToken ),
					res = JSON.parse( getInfo( endPoints.getCardInfo, 
											   strQuery ) );

				/* validate response from backend API */

				return res;
			},
			createTokenAccount = function( objToken, PierupResponseHandler ) {
				/* use private ajax method to call backend API */
			};

		// expose APIs
		return {
			version: version,
			setPublishableKey: setPublishableKey,
			card: {
				createToken: createTokenCard,
				cardType: cardType,
				validateCVC: validateCVC,
				validateExpiry: validateExpiry,
				validateCardNumber: validateCardNumber
			},
			bankAcount: {
				createToken: createTokenAccount,
				validateAccountNumber: validateAccountNumber,
				validateRoutingNumber: validateRoutingNumber
			}
		};
	}.call( this );
}() );