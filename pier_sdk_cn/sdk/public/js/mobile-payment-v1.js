angular.module( 'PaymentApp', [])
.controller( 'PaymentController', function( $scope, SdkUrl, HttpService, $timeout, $log){
   $scope.payFlag = false;
   $scope.sendCodeFlag = false;
   $scope.timeStemp = 60;
   $scope.hasSendCode = false;
   $scope.sessionMsg = '对不起，您登录超时,请重新登录';
   $scope.checkCode = {
		resend: "重新发送",
		getCode: "获取验证码"
	}
	$scope.timeHandler = $scope.checkCode.getCode;
    $scope.getValidCode = function(){
    	$scope.smsError = false;
    	$scope.sendCodeFlag = true;
    	var merchantId = $('#merchant_id').val();
    	var orderId = $('#order_id').val();
    	var url = SdkUrl.checkoutSMS;
    	var pGetCode = HttpService.templateAccessAPI( url, { merchant_id: merchantId, order_id: orderId } );
    	pGetCode.then( function( result ){
    		$log.debug('get valid code success', result );
    		$scope.hasSendCode = true;
    		timer();
    		$scope.smsCode = '';
    	}, function( reason ){
            $scope.smsErrorMsg = reason.message;
            $scope.smsError = true;   
    	}).then(function(){
    		$scope.sendCodeFlag = false;
    	})
    };
    var timer = function(){
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

   $scope.payment = function(){
	   	$scope.errorPay = false;
	    if( $scope.payPassword == '' || $scope.payPassword == undefined || $scope.smsCode == '' || $scope.smsCode == undefined ) return;
	    if( $scope.payPassword.length < 6 ){
	    	$scope.errorPay = true;
			$scope.errorMsg = '支付密码必须是6位的数字';
			return;
	    }
	    $scope.payFlag = true;
	    $('#paymentForm').submit();
   };
} )
.factory('SdkUrl', function(){
	var hostName = '';
	return{
		checkoutSMS: hostName+ '/mobile/checkout/getSMS',
		checkoutPay: hostName+ '/mobile/checkout/pay',
	}
})
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
	               $('#myModal').modal({backdrop:'static',keyboard: false})
	               break;
	            case "500" :
	               window.location.href="/mobile/checkout/unknownError";
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
} );