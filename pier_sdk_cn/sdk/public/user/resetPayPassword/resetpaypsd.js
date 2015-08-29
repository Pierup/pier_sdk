angular.module( 'ResetApp',[] )
.factory('SdkUrl', function(){
	var hostName = '';
	return{
		regLinkBankCard: hostName+'/user/resetPayPsd/linkBankCard',
		verifyBank: hostName+ '/user/resetPayPsd/verifyBank',
		reSetPayPsd: hostName+'/user/resetPayPsd/reset',
		bankCardInfo: hostName+'/api/v1/users/bankCardInfo'
	}
})
.controller( 'ForgetController', function( $rootScope, $scope, HttpService, SdkUrl, $log, $timeout ){
	$scope.phoneLength = 11;
	$scope.linkStatus = false;
	$scope.hasSendCode = false;
	$scope.timeHandler = "获取验证码";
	$scope.timeStemp = 60;
	$scope.sendCodeFlag = false;
	$scope.bankNum = '';
	$scope.bankObj = {};
	$scope.serviceRule = false;
	$scope.addBankFlag = false;
	$scope.validBankFlag = false;
	$scope.checkCode = {
		right: "验证码正确",
		resend: "重新发送",
		getCode: "获取验证码"
	}
	$scope.validCode = '';

	var timer = function(){
		if (!$scope.hasSendCode ) {
			return;
		}
		$scope.timeHandler = $scope.timeStemp;
		$scope.timeStemp -= 1;
		if( $scope.timeStemp == 0 ){
			$scope.timeStemp = 60;
			$scope.timeHandler = $scope.checkCode.resend;
			$scope.hasSendCode = false;
			$scope.sendCodeFlag = false;
			return;
		}
        return $timeout( timer, 1000);
	}
	$scope.addBankInfo = function(){
		$scope.addBankError = false;
	    if( $scope.bankObj == {} || $scope.bankObj['card_type'] == '无效卡' || !$scope.serviceRule ) return;
	    $scope.addBankFlag = true;
	    var url = SdkUrl.regLinkBankCard;
	    var message = {
	    	bank_id: $scope.bankObj.bank_id,
	    	card_num: $scope.bankNum,
	    	linked_phone: $scope.phone,
	    	id_number: $scope.idNum
	    };
	    var pAddBank = HttpService.templateAccessAPI( url, message );
	    pAddBank.then( function( result ){
	    	$log.debug( 'add bank info success', result );
	    	$scope.linkStatus = true;
	    	$scope.bank_card_id = result.bank_card_id;
	    	$scope.hasSendCode = true;
    		timer();
    		$scope.smsCode = '';
	    }, function( reason ){
	    	$scope.addBankError = true;
	    	$scope.addBankErrorMsg = reason.message;
	    } ).then( function(){
	    	$scope.addBankFlag = false;
	    })
	}
	$scope.getValidCode = function(){
		$scope.hasSendCode = true;
		timer();
		$scope.smsCode = '';
    };

    $scope.getBankInfo = function(){
    	if( $scope.bankNum == '' ) return;
    	var url =SdkUrl.bankCardInfo;
    	var message = {
    		query:{
    			card_number: $scope.bankNum
    		}
    	};
    	var pBankInfo = HttpService.templateAccessAPI( url, message );
    	pBankInfo.then( function( result ){
    		$log.debug( 'get bank info success', result );
    		$scope.bankObj = result;
    	}, function( reason ){
    		$scope.bankObj['bank_name'] = reason.message;
    		$scope.bankObj['card_type'] = '无效卡';
    	})
    }

	$scope.next = function(){
		$scope.validBankError = false;
		if( $scope.validCode == '' ) return;
		$scope.validBankFlag = true;
		var url = SdkUrl.verifyBank,
		message = {
			bank_card_id: $scope.bank_card_id,
			code: $scope.validCode,
			linked_phone: $scope.phone
		};
		var pValidBank = HttpService.templateAccessAPI( url, message );
		pValidBank.then( function( result ){
			$log.debug( 'user valid bank account success', result );
			window.location.href="/user/resetPayPassword2?token="+result.token
		}, function( reason ){
			$scope.validBankError = true;
			$scope.validBankErrorMsg = reason.message;
		} ).then( function(){
			$scope.validBankFlag = false;
		} )
	}

} )
.controller( 'ResetController', function( $scope, $log, HttpService, SdkUrl, $location ){
	$scope.payPsd = '';
	$scope.payPsdConfirm = '';
	$scope.psdNotMatch = false;
	$scope.psdNotRight = false;
	$scope.setPsdFlag = false;

	$scope.validatePsdMatch = function(){
		$scope.psdNotMatch = false;
		if( $scope.payPsdConfirm == '' ) return;
		if( $scope.payPsd != $scope.payPsdConfirm ) $scope.psdNotMatch = true;
	}
	$scope.validatePsd = function(){
		$scope.psdNotRight = false;
		if( $scope.payPsd == '' ) return; 
		if( $scope.payPsd.length != 6 ) $scope.psdNotRight = true;
		else $scope.validatePsdMatch();
	}
	$scope.next = function(){
		$scope.validatePsd();
		$scope.validatePsdMatch();
		$scope.setPayError = false;
		if( $scope.payPsd == '' || $scope.payPsdConfirm == '' || $scope.psdNotMatch || $scope.psdNotRight ) return;
        var url = SdkUrl.reSetPayPsd;
        var message = {
        	new_payment_password: $scope.payPsd,
        	payment_password_token: $('#tokenGet').val()
        };
        $scope.setPsdFlag = true;
        var pSetPay = HttpService.templateAccessAPI( url, message );
        pSetPay.then( function( result ){
        	$log.debug( 'set pay password success ', result );
        	window.location.href="/user/resetPinSuccess";
        }, function( reason ){
        	$scope.setPayError = true;
			$scope.setPayErrorMsg = reason.message;
        } ).then(function(){
            $scope.setPsdFlag = false;
        })
	}
} )
.factory('HttpService', function( $log, $http, $q ){
	return {
	    //url call template
	    templateAccessAPI: function( apiUrl, msg ){
	      var d = $q.defer(),
	          url = apiUrl;
	      $http.post( url, msg )
	        .success( function( data, status, headers, config ) {
	          switch( data.code ){
	            case "200" :
	              d.resolve( data.result );
	              break;
	            case "1001" :
	               window.location.href="/checkout/unknownError";
	               break;
	              break;
	            case "500" :
	               window.location.href="/checkout/unknownError";
	               break;
	            default :
	              d.reject( data );
	          }
	        } )
	        .error( function( data, status, headers, config ) {
	            d.reject( data );
	        } );

	      return d.promise;

	    }
	}
})
.directive( 'numberOnlyInput', function() {
	return {
		restrict: 'A',
		scope: false,
		require: 'ngModel',
		link: function( scope, elem, attrs, controller ) {
			controller.$parsers.push( function( input ) {
				if ( input == undefined ) return '';
				// delete non-number string
				var numberInput = input.replace( /[^0-9]/g, '' );
				if ( numberInput != input ) {
					controller.$setViewValue( numberInput );
					controller.$render();
				}
				return numberInput;
			} );
		}
	};
} )
.directive( 'idCardInput', function() {
	return {
		restrict: 'A',
		scope: false,
		require: 'ngModel',
		link: function( scope, elem, attrs, controller ) {
			controller.$parsers.push( function( input ) {
				if ( input == undefined ) return '';
				// delete non-number string
				var numberInput = input;
				if( numberInput.length == 18 && ( numberInput.substr(17,1)=='X'||numberInput.substr(17,1)=='x' ) ){
					var tempInput = numberInput.substr(0,17);
					numberInput = tempInput.replace( /[^0-9]/g, '' ) + 'X';
				}else{
					numberInput = input.replace( /[^0-9]/g, '' );
				}
				if ( numberInput != input ) {
					controller.$setViewValue( numberInput );
					controller.$render();
				}
				return numberInput;
			} );

		}
	};
} )