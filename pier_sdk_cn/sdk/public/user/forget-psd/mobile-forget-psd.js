angular.module( 'ForgetPassword',[])
.factory('SdkUrl', function(){
	var hostName = '';
	return{
		getValidCode: hostName+ '/api/v1/users/sdkSMSPsdForget',
		activation: hostName+ '/api/v1/users/sdkSMSPsdCheck',
		resetPsd: hostName+ '/api/v1/users/sdkResetPsd'
	}
})
.controller( 'ForgetController',function($scope,$log, HttpService, SdkUrl, $timeout){

	$scope.phoneLength = 11;
	$scope.idLength = 18;
	$scope.hasSendCode = false;
	$scope.timeHandler = "获取验证码";
	$scope.timeStemp = 60;
	$scope.sendCodeFlag = false;
	$scope.nextFlag = false;
	$scope.phone = '';
	$scope.idNum = ''

	$scope.getValidCode = function(){
    	$scope.phoneError = false;
    	if( $scope.phone == '' || $scope.phoneLength != $scope.phone.length ){
    		$scope.phoneError = true;
    		$('#phoneErrorMsg').html( '你的手机号必须是'+$scope.phoneLength+'位' );
    		return;
    	}
    	$scope.sendCodeFlag = true;
    	var url = SdkUrl.getValidCode,
    	message = {
    		phone: $scope.phone,
    	};
    	var pGetCode = HttpService.templateAccessAPI( url, message );
    	pGetCode.then( function( result ){
    		$log.debug('get valid code success', result );
    		$scope.hasSendCode = true;
    		timer();
    		$scope.smsCode = '';
    	}, function( reason ){
            $('#phoneErrorMsg').html( reason.message );
            $scope.phoneError = true;
    	}).then(function(){
    		$scope.sendCodeFlag = false;
    	})
    };

    $scope.verifyId = function(){
    	$scope.idError = false;
    	$scope.verifyError = false;
    	if( $scope.idNum == '' || $scope.idLength != $scope.idNum.length){
    		$scope.idError = true;
    		$('#idErrorMsg').html( '你的身份证号码必须是'+$scope.idLength+'位' );
    		return;
    	}
    	if( $scope.smsCode == undefined || $scope.smsCode == '' ) return;
    	$scope.nextFlag = true;
    	var url = SdkUrl.activation,
    	message = {
    		id_number:$scope.idNum,
		    phone: $scope.phone,
		    code:$scope.smsCode
    	}
    	var pNext = HttpService.templateAccessAPI( url, message );
    	pNext.then( function(result){
    		$log.debug('activate valid code success', result );
    		window.location.href="/mobile/user/resetPassword/"+result.token+"?action=10012";
           
    	}, function( reason ){
    		$scope.idError = true;
    		$('#idErrorMsg').html( reason.message );
    	}).then(function(){
    		$scope.nextFlag = false;
    	})
    }
	var timer = function(){
		if (!$scope.hasSendCode ) {
			return;
		}
		$scope.timeHandler = $scope.timeStemp;
		$scope.timeStemp -= 1;
		if( $scope.timeStemp == 0 ){
			$scope.timeStemp = 60;
			$scope.timeHandler = "重新发送";
			$scope.hasSendCode = false;
			$scope.sendCodeFlag = false;
			return;
		}
        return $timeout( timer, 1000);
	}

	$scope.phoneChange = function() {
		$scope.timeHandler = "获取验证码"
	    $scope.hasSendCode = false;
	    $scope.timeStemp = 60;
	    $scope.smsCode = "";
	    if( $scope.phone != '' && $scope.phone.length == $scope.phoneLength ){
            clearError();
	    }
	};

	var clearError = function(){
    	$scope.msgError = false; 
    	$scope.phoneError = false; 
    	$scope.smsCodeError = false; 
    };
	
})
.controller( 'ResetController', function( $scope, $log, HttpService, SdkUrl){
	$scope.resetFlag = false;
	$scope.password = '';
	$scope.passwordConfirm = '';
	$scope.passwordNotRight = false;
	$scope.passwordNotMatch = false;
	$scope.resetError = false;

	$scope.resetPsd = function(){
		if( $scope.password == '' || $scope.passwordNotRight || $scope.passwordNotMatch) return;
        var token = $('#token').val();
        $scope.resetFlag = true;
		var url = SdkUrl.resetPsd;
		var message = {
			token: token,
			password: $scope.password
		};
		var pReset = HttpService.templateAccessAPI( url, message );
		pReset.then(function(result){
			$log.debug( 'reset success',result );
			window.location.href="/mobile/user/resetSuccess?action=10013";
			
		}, function(reason){
			$log.debug( 'reset failed',reason );
			$scope.resetError = true;
			$scope.errorMsg = reason.message;
		}).then(function(){
			$scope.resetFlag = false;
		})

	};

	$scope.validPassword = function(){
		if( $scope.password == '' ) return; 
		var reg = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,}$/;
		$scope.passwordNotRight = false;
		if( !reg.test($scope.password ) ){
			$scope.passwordNotRight = true;
		}
		if( $scope.passwordConfirm != ''){
			$scope.validateMatch();
		}
	}
	//confirm password on blur
	$scope.validateMatch = function(evt) {
		if( $scope.password == '' || $scope.passwordNotRight || $scope.passwordConfirm == '') return;
		$scope.passwordNotMatch = false;
		if( $scope.password == $scope.passwordConfirm ) return;
		$scope.passwordNotMatch = true;
	};

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
.factory('HttpService', function( $log, $http, $q, SDKService ){
	return {
	    //url call template
	    templateAccessAPI: function( apiUrl, msg ){
	      var d = $q.defer(),
	          url = apiUrl;
	      $http.post( url, msg )
	        .success( function( data, status, headers, config ) {
	          switch( data.code ){
	            case "200" :
	              if( angular.isDefined( data.result.session_token ) ){
	                 var session_token = data.result.session_token;
	                 SDKService.refreshToken( session_token );
	              }
	              d.resolve( data.result );
	              break;
	            case "1001" :
	              sessionStorage.setItem( "session_error", "For your security, please relogin!" );
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
.factory('SDKService', function($rootScope){
	var user = sessionStorage.getItem( 'userCredit' ) || { user_id: '', session_token: ''};
	function getUser() {
		return angular.fromJson( sessionStorage.getItem( 'userCredit' ) );
	}
	return {
		refreshToken: function( token ) {
			var user = getUser();
			if ( user === undefined || user === null ) return;
			user.session_token = token;
			sessionStorage.setItem( 'userCredit', angular.toJson( user ) );
		},
		setUser: function( obj ){
			if ( obj === null ) {
				user = { user_id: '', session_token: '', phone: ''};
			} else {
				user = { 
					user_id: obj.user_id, 
					session_token: obj.session_token, 
					phone: obj.phone
				};
			}
			sessionStorage.setItem( 'userCredit', angular.toJson( user ) );
		},
		getBinBit: function (num, pos){
		    if( isNaN(num) ) return;
		    if( isNaN(pos) ) return parseInt(num,10).toString(2);
		    else {
		    	var length = (parseInt(num,10).toString(2)).length;
		    	if( length < pos ) return 'error';
		    	return parseInt(num,10).toString(2).substr((length - pos),1);
		    }
		}
	}
});