'use strict';
angular.module( 'RegisterApp', ['ui.router','ui.bootstrap'])
.factory('SdkUrl', function(){
	var hostName = '';
	return{
		regActivationCode: hostName+ '/api/v1/users/regActivationCode',
		regActivate: hostName+ '/api/v1/users/regActivate',
		regUser: hostName+'/api/v1/users/regUser',
		regSaveUserBasic: hostName+'/api/v1/users/regSaveUserBasic',
		regUserInfo: hostName+'/api/v1/users/regUserInfo',
		regUpdateUser: hostName+'/api/v1/users/regUpdateUser',
		regLinkBankCard: hostName+'/api/v1/users/regLinkBankCard',
		regVerifyBank: hostName+ '/api/v1/users/regVerifyBank',
		regSetPayPsd: hostName+'/api/v1/users/regSetPayPsd',
		bankCardInfo: hostName+'/api/v1/users/bankCardInfo',
		regGetBankCards: hostName+ '/api/v1/users/regGetBankCards',
		regApplyCredit: hostName + '/api/v1/users/regApplyCredit',
		login: hostName + '/api/v1/users/checkoutLogin'
	}
})
.config( function( $urlRouterProvider, $stateProvider, $logProvider ){
	$urlRouterProvider.otherwise( '/' );
	$stateProvider
		.state( 'register', {
			url: '/',
			templateUrl: 'home.ejs',
			controller: 'HomeController'
		} )
		.state( 'information', {
			url: '/information',
			templateUrl: 'information.ejs',
			controller: 'InfoController'
		} )
		.state( 'pay-password', {
			url: '/pay-password',
			templateUrl: 'pay-password.ejs',
			controller: 'PayPsdController'
		} )
		.state( 'link-bank', {
			url: '/link-bank',
			templateUrl: 'link-bank-v2.ejs',
			controller: 'LinkBankController'
		} )
		.state( 'confirm', {
			url: '/confirm',
			templateUrl: 'confirm.ejs',
			controller: 'ConfirmController'
		} )
		.state( 'success', {
			url: '/success',
			templateUrl: 'success.ejs'
			// controller: 'SuccessController'
		} )
		.state( 'failure', {
			url: '/failure',
			templateUrl: 'failure.ejs'
		} )
		.state( 'login', {
			url: '/login',
			templateUrl: 'login.ejs',
			controller: 'LoginController'
		} )

})
.run(function($rootScope, $state, $window, $location, $log, $stateParams, SDKService){
	$rootScope.$on( '$stateChangeStart', function( event, toState, toParams, fromState, fromParams ) {
		var userObj = $('#userObj').val();
		$log.debug( 'user get obj', typeof userObj );
		if( typeof userObj == 'object' ){
			SDKService.setStatusBit( userObj.statusBit );
			SDKService.setUser( userObj );
			$('#userObj').val(""); 
		}
        var statusBit = SDKService.getStatusBit();
         $log.debug( 'statusBit', fromState.name +'aaaa'+toState.name );

        if( toState.name == 'login' ){
        	return;
        }
        if( !statusBit && toState.name != 'register' ){
        	event.preventDefault();
			$state.go( 'register' );
			return;
        }
       
        if( toState.name == 'success' ){
        	if( SDKService.getBinBit(statusBit, 8 ) == '1' ){
				return;
        	}else if( SDKService.getBinBit(statusBit, 3 ) == '1' ){
        		event.preventDefault();
				$state.go( 'confirm' );
				return;
        	}else if( SDKService.getBinBit(statusBit, 5 ) == '1' ){
        		event.preventDefault();
				$state.go( 'link-bank' );
				return;
        	}else if( SDKService.getBinBit(statusBit, 2 ) == '1' ){
        		event.preventDefault();
				$state.go( 'pay-password' );
				return;
        	}else if( SDKService.getBinBit(statusBit, 1 ) == '1' ){
        		event.preventDefault();
				$state.go( 'information' );
				return;
        	}
        } 
        // document.onkeydown=alert(); 
        if( SDKService.getBinBit(statusBit, 8 ) == '1' ){
        	if( toState.name != 'success' ){
        		javascript:window.history.forward(1);
				document.onkeydown = banBackSpace; 
        	}  
        	return;
        }

        if( SDKService.getBinBit(statusBit, 3 ) == '1' ){
        	if( toState.name != 'confirm' ){
        		javascript:window.history.forward(1);
				document.onkeydown = banBackSpace; 
        	};
        	return;
        }

        if( SDKService.getBinBit(statusBit, 5 ) == '1' ){
        	if( toState.name != 'link-bank' ){
        		javascript:window.history.forward(1);
				document.onkeydown = banBackSpace; 
        	};
        	return;
        }

        if( SDKService.getBinBit(statusBit, 2 ) == '1' ){
        	if( toState.name != 'pay-password' ){
        		javascript:window.history.forward(1);
				document.onkeydown = banBackSpace; 
        	}; 
        	return;
        }
        if( SDKService.getBinBit(statusBit, 1 ) == '1' ){
        	if( toState.name != 'information' ){
        		javascript:window.history.forward(1);
				document.onkeydown = banBackSpace; 
        	}; 
        	return;
        }

        if( toState.name == 'failure' ){

        }

        //处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外 
		// function banBackSpace(e){ 
		// 	var ev = e || window.event;//获取event对象 
		// 	var obj = ev.target || ev.srcElement;//获取事件源 

		// 	var t = obj.type || obj.getAttribute('type');//获取事件源类型 

		// 	//获取作为判断条件的事件类型 
		// 	var vReadOnly = obj.getAttribute('readonly'); 
		// 	var vEnabled = obj.getAttribute('enabled'); 
		// 	//处理null值情况 
		// 	vReadOnly = (vReadOnly == null) ? false : vReadOnly; 
		// 	vEnabled = (vEnabled == null) ? true : vEnabled; 

		// 	//当敲Backspace键时，事件源类型为密码或单行、多行文本的， 
		// 	//并且readonly属性为true或enabled属性为false的，则退格键失效 
		// 	var flag1=(ev.keyCode == 8 && (t=="password" || t=="text" || t=="textarea") 
		// 	&& (vReadOnly==true || vEnabled!=true))?true:false; 

		// 	//当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效 
		// 	var flag2=(ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea") ?true:false; 
		// 	//判断 
		// 	if(flag2){ 
		// 	return false; 
		// 	} 
		// 	if(flag1){ 
		// 	return false; 
		// 	} 
		// } 

	})
})
.controller( 'LoginController', function( $scope, $state, $log, $location, SdkUrl, HttpService, SDKService ){
    $scope.phone = $location.search().phone || '';
    if( $scope.phone == undefined || $scope.phone == '' ) $state.go('register');
    $scope.signInFlag = false;

    $scope.login = function(){
    	if( $scope.password == undefined || $scope.password == '' ) return;
    	$scope.signInFlag = true;
    	var url = SdkUrl.login;
    	var message = {
    		phone: $scope.phone,
    		password: $scope.password
    	};
    	var pLogin = HttpService.templateAccessAPI( url, message );
    	pLogin.then( function( result ){
    		$log.debug( 'user login' );
    		SDKService.setUser({
            	user_id: result.user_id,
            	session_token: result.session_token,
            	phone: $scope.phone,
            	username: result.name
        	});
        	SDKService.setStatusBit( result.status_bit );
        	$state.go( 'success' );
    	}, function( reason ){
    		$scope.signInError = true;
            $scope.signInErrorMsg = reason.message;
    	}).then(function(){
    		$scope.signInFlag = false;
    	})
    }
})
.controller('IndexController', function( $scope, $state, $log ){
	$scope.$state = $state;
})
.controller('HomeController', function( $log, $state, $scope, SdkUrl, HttpService, $timeout, SDKService ){
	$scope.password = '';
	$scope.passwordConfirm = '';
	$scope.phoneLength = 11;
	$scope.phone = '';
	$scope.smsCode = ''
	$scope.hasSendCode = false;
	$scope.timeStemp = 60;
	$scope.sendCodeFlag = false;
	$scope.nextFlag = false;
	$scope.phoneError = false;
	$scope.smsError = false;
	$scope.smsErrorMsg = '';
	$scope.serviceRule = false;
	$scope.signUpFlag = false;
	$scope.checkCode = {
		right: "验证码正确",
		resend: "重新发送",
		getCode: "获取验证码"

	}
	$scope.timeHandler = $scope.checkCode.getCode;

    $scope.getValidCode = function(){
    	$scope.phoneError = false;
    	$scope.smsError = false;
    	if( $scope.phone == '' || $scope.phoneLength != $scope.phone.length ){
    		$scope.phoneError = true;
    		return;
    	}
    	$scope.sendCodeFlag = true;
    	var url = SdkUrl.regActivationCode,
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
            $scope.smsErrorMsg = reason.message;
            $scope.smsError = true;   
    	}).then(function(){
    		$scope.sendCodeFlag = false;
    	})
    };
    var timer = function(){
		if (!$scope.hasSendCode || $scope.timeHandler == $scope.checkCode.right ) {
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

	$scope.phoneChange = function() {
		$scope.timeHandler = $scope.checkCode.getCode;
	    $scope.hasSendCode = false;
	    $scope.timeStemp = 60;
	    $scope.smsCode = "";
	    if( $scope.phone == undefined ){
	    	$scope.phone = "";
	    	 return;
	    }
	    if( $scope.phoneLength == $scope.phone.length ){
            clearError();
	    }
	};

	var clearError = function(){
    	$scope.msgError = false; 
    	$scope.phoneError = false; 
    	$scope.smsError = false; 
    };
	$scope.verifyActivateCode = function(){
		if( $scope.phone == '' || $scope.smsCode == undefined || $scope.smsCode == "" ) return;
		if( $scope.smsCode.length == 4 ){
			$scope.smsError = false;
			var message = {
				phone: $scope.phone,
				activation_code: $scope.smsCode
			};
			var url = SdkUrl.regActivate;
			var activationPromise = HttpService.templateAccessAPI( url, message );
			activationPromise.then( function( result ){
				$log.debug( "user verifyInvitation successfully", result );
				$scope.token = result.token;
				$scope.timeHandler = $scope.checkCode.right;
				$scope.hasSendCode = true;
				if( $scope.password !== '' ){
					$scope.validPassword();
				}
			}, function( reason ){
				$scope.smsErrorMsg = reason.message;
	            $scope.smsError = true;
				$scope.token = '';
			})
		}
	}

	$scope.signUp = function(){
		$scope.signUpError = false;
		if( !$scope.serviceRule || $scope.timeHandler != $scope.checkCode.right || $scope.passwordNotMatch || $scope.passwordNotRight) return;
		$scope.signUpFlag = true;
        var url = SdkUrl.regUser,
        message = {
        	phone: $scope.phone,
        	password: $scope.password,
        	token: $scope.token,
        	version: '1.0',
        	invitation_code: $scope.inviteCode
        };
        var pSavaUser = HttpService.templateAccessAPI( url, message );
        pSavaUser.then(function(result){
            SDKService.setUser({
            	user_id: result.user_id,
            	session_token: result.session_token,
            	phone: $scope.phone,
        	});
        	SDKService.setStatusBit( result.status_bit );
        	$state.go( 'success' );
        }, function(reason){
        	$scope.signUpErrorMsg = reason.message;
        	$scope.signUpError = true;

        }).then(function(){
			$scope.signUpFlag = false;
        })

	}
	
	//confirm password on blur
	$scope.validateMatch = function(evt) {
		if( $scope.password == '' || $scope.password == undefined || $scope.passwordNotRight || $scope.passwordConfirm == '') return;
		$scope.passwordNotMatch = false;
		if( $scope.password == $scope.passwordConfirm ) return;
		$scope.passwordNotMatch = true;
	};
	$scope.validPassword = function(){
		if( $scope.password == '' ) return; 
		var reg = /^(?=.*\d)(?=\S*[^\d])[\S]{6,}$/;
		$scope.passwordNotRight = false;
		if( !reg.test($scope.password ) ){
			$scope.passwordNotRight = true;
		}
		if( $scope.passwordConfirm != '' || $scope.passwordConfirm != undefined ){
			$scope.validateMatch();
		}
	}
})
.controller( 'InfoController', function( $scope, $state, HttpService, SdkUrl, $log, SDKService ){
	$scope.username = '';
	$scope.idNum = '';
	$scope.email = '';
	$scope.idNumNotRight = false;
	$scope.validateIdNum = function(){
		$scope.idNumNotRight = false;
		if( $scope.idNum == '' ) return;
		if( $scope.idNum.length < 18 ) $scope.idNumNotRight = true;
	}
	$scope.validateEmail = function(){
		$scope.emailNotRight = false;
    	if( $scope.email == '' ) return;
	   	var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
	   	if( !reg.test($scope.email) ){
            $scope.emailNotRight = true;
	   	}
	}

	$scope.next = function(){
		$scope.validateIdNum();
		$scope.validateEmail();
		$scope.saveError = false;
		if( $scope.emailNotRight || $scope.idNumNotRight || $scope.username == '' || $scope.idNum == '' || $scope.email == '' ) return;
		$scope.saveFlag = true;
		var url = SdkUrl.regSaveUserBasic;
		var user = SDKService.getUser();
		var message = {
            user_id: user.user_id,
            session_token: user.session_token,
            email: $scope.email,
            id_number: $scope.idNum,
            name: $scope.username
		}
		var pSaveInfo = HttpService.templateAccessAPI( url, message );
		pSaveInfo.then( function( result ){
            $log.debug( 'user save basic infomation success', result );
            user.username = $scope.username;
            SDKService.setUser( user );
            SDKService.setStatusBit( result.status_bit );
            $state.go('success');
		}, function( reason ){
			$scope.saveError = true;
			$scope.errorMsg = reason.message;
		} ).then( function(){
			$scope.saveFlag = false;
		})
	}

})
.controller('PayPsdController', function($scope, $state, HttpService, SdkUrl, $log, SDKService){
	var user = SDKService.getUser();
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
	}
	$scope.next = function(){
		$scope.validatePsd();
		$scope.validatePsdMatch();
		$scope.setPayError = false;
		if( $scope.payPsd == '' || $scope.payPsdConfirm == '' || $scope.psdNotMatch || $scope.psdNotRight ) return;
        var url = SdkUrl.regSetPayPsd;
        var message = {
        	password: $scope.payPsd,
        	user_id: user.user_id,
        	session_token: user.session_token
        };
        $scope.setPsdFlag = true;
        var pSetPay = HttpService.templateAccessAPI( url, message );
        pSetPay.then( function( result ){
        	$log.debug( 'set pay password success ', result );
        	SDKService.setStatusBit( result.status_bit );
        	$state.go( 'success' );
        }, function( reason ){
        	$scope.setPayError = true;
			$scope.setPayErrorMsg = reason.message;
        } ).then(function(){
            $scope.setPsdFlag = false;
        })
	}
})
.factory( 'PopupService', function( $modal ) {
	return {
		popupModal: function() {
			$modal.open( {
				size: 'sm',
				controller: 'PopupModalController',
				templateUrl: 'popup.html'
			} );
		}
	};
} )
.controller('PopupModalController', function( $scope, HttpService, SDKService, $log, SdkUrl, $modalInstance ){
	$scope.loginFlag = false;
	$scope.phone = SDKService.getUser().phone;
	$scope.loginError = false;
	$scope.login = function(){
		if( $scope.phone == '' || $scope.phone == undefined || $scope.password == '' || $scope.password == undefined ) return;
		if( $scope.phone.length < 11 ) return;
		var url = SdkUrl.login;
		$scope.loginFlag = true;;
		var message ={
			phone: $scope.phone,
			password: $scope.password
		};
        var pLogin = HttpService.templateAccessAPI( url, message );
        pLogin.then( function( result ){
        	$log.debug( 'user relogin success', result );
        	SDKService.setUser({ session_token: result.session_token,user_id: result.user_id,username: result.name, phone: $scope.phone});
			$modalInstance.close();
        }, function( reason ){
        	$scope.loginError = true;
        	$scope.errorMsg = reason.message;
        }).then(function(){
        	$scope.loginFlag = false;
        })
	}

})
.controller('LinkBankController', function( $scope, $state, HttpService, SdkUrl, $log, SDKService, $timeout, $modal ){
	$scope.phoneLength = 11;
	$scope.linkStatus = false;
	$scope.hasSendCode = false;
	$scope.timeHandler = "获取验证码";
	$scope.timeStemp = 60;
	$scope.sendCodeFlag = false;
	$scope.bankNum = '';
	$scope.bankObj = undefined;
	$scope.serviceRule = false;
	$scope.addBankFlag = false;
	$scope.checkCode = {
		right: "验证码正确",
		resend: "重新发送",
		getCode: "获取验证码"

	};
	$scope.validCode = '';
	var user = SDKService.getUser();
	$scope.user = user;
	$scope.username = user.username;

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
		user = SDKService.getUser();
		$scope.addBankError = false;
	    if( $scope.bankObj == undefined || $scope.bankObj['card_type'] == '' || !$scope.serviceRule ) return;
	    $scope.addBankFlag = true;
	    var url = SdkUrl.regLinkBankCard;
	    var message = {
	    	user_id: user.user_id,
	    	session_token: user.session_token,
	    	bank_id: $scope.bankObj.bank_id,
	    	card_num: $scope.bankNum,
	    	linked_phone: $scope.phone
	    }
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
    	// $scope.smsError = false;
    	// $scope.sendCodeFlag = true;
    	// var url = SdkUrl.getValidCode,
    	// message = {
    	// 	phone: $scope.phone,
    	// };
    	// var pGetCode = HttpService.templateAccessAPI( url, message );
    	// pGetCode.then( function( result ){
    	// 	$log.debug('get valid code success', result );
    	// 	$scope.hasSendCode = true;
    	// 	timer();
    	// 	$scope.smsCode = '';
    	// }, function( reason ){
     //        $scope.smsErrorMsg = reason.message;
     //        $scope.smsError = true;   
    	// }).then(function(){
    	// 	$scope.sendCodeFlag = false;
    	// })
    };

    $scope.getBankInfo = function(){
    	if( $scope.bankNum == '' || $scope.bankNum == undefined ) return;
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
    		$scope.bankObj = {};
    		$scope.bankObj['bank_name'] = reason.message;
    		$scope.bankObj['card_type'] = '';
    	})
    }

    $scope.verifySubmit = function(){
    	if( $scope.bankNum == '' || $scope.bankNum == undefined ) return;
   		$("#registerForm").submit();
    }

	$scope.next = function(){
        $scope.validBankError = false;
		if( $scope.validCode == '' ) return;
		$scope.validBankFlag = true;
		user = SDKService.getUser();
		var url = SdkUrl.regVerifyBank,
		message = {
			user_id: user.user_id,
			session_token: user.session_token,
			bank_card_id: $scope.bank_card_id,
			code: $scope.validCode
		};
		var pValidBank = HttpService.templateAccessAPI( url, message );
		pValidBank.then( function( result ){
			$log.debug( 'user valid bank account success', result );
			SDKService.setStatusBit( result.status_bit );
			$state.go( 'success' );
		}, function( reason ){
			$scope.validBankError = true;
			$scope.validBankErrorMsg = reason.message;
		} ).then( function(){
			$scope.validBankFlag = false;
		} )
	};

	$scope.updateUser = function(){
		var modalInstance = $modal.open({
			size: 'md',
			controller: 'InfoController',
			templateUrl: 'update-user.html'

		});

	}
	// $scope.updateUser();
})
.controller( 'UpdateUserController', function( $scope, $log, SdkUrl, HttpService, SDKService ){

} )
.controller( 'ConfirmController', function( $scope, $state, HttpService, SdkUrl, $log, SDKService ){
    var user = SDKService.getUser();
    $scope.user = user;
    $scope.editStatus = false;
    $scope.saveEmailFlag = false;

    $scope.getUserInfo = function(){
    	$scope.dataLoading = true;
    	user = SDKService.getUser();
    	var url = SdkUrl.regUserInfo,
    	message = {
    		user_id: user.user_id,
    		session_token: user.session_token
    	};
    	var pGetUserInfo = HttpService.templateAccessAPI( url, message );
    	pGetUserInfo.then( function( result ){
    		$log.debug( 'get user information success', result );
    		$scope.userObj = result;
    		$scope.getUserBankInfo();
    	}, function( reason ){

    	} ).then(function(){
    		$scope.dataLoading = false;
    	})
    }
    $scope.getUserBankInfo = function(){
    	$scope.dataLoading = true;
    	var url = SdkUrl.regGetBankCards,
    	message = {
    		user_id: user.user_id,
    		session_token: user.session_token
    	};
    	var pBankCards = HttpService.templateAccessAPI( url, message );
    	pBankCards.then( function(result){
    		$log.debug( 'user get bank info success' );
    		$scope.bankCards = result.items;
    	}, function(reason){

    	} ).then( function(){
    		$scope.dataLoading = false;
    	})
    };

    $scope.applyCredit = function(){
    	var url = SdkUrl.regApplyCredit;
    	user = SDKService.getUser();
    	var message = {
    		user_id: user.user_id,
    		session_token: user.session_token
    	};
    	var pApply = HttpService.templateAccessAPI( url, message );
    	pApply.then( function( result ){
    		$log.debug( 'user apply credit success', result );
    		// $state.go( 'success' );
    		window.location.href="/user/applySuccess";
    	}, function( reason ){
    		$log.debug( 'user apply credit faild', reason );
    		// $state.go( 'failure' );
    		window.location.href="/user/applyFailure";
    	} )
    	// window.location.href="/user/apply";
    };
    $scope.changeEditStatus = function(){
    	$scope.editStatus = !$scope.editStatus;
    	$scope.email = $scope.userObj.email;
    }
    $scope.validateEmail = function(){
		$scope.emailNotRight = false;
    	if( $scope.email == '' ) return;
	   	var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
	   	if( !reg.test($scope.email) ){
            $scope.emailNotRight = true;
            $scope.saveErrorMsg = "请填写正确的邮箱";
	   	}
	}
    $scope.saveEmail = function(){
    	if( $scope.email == '' ) return;
    	$scope.validateEmail();
    	if( $scope.emailNotRight ) return;
		$scope.saveEmailFlag = true;
    	var message = {
    		user_id: user.user_id,
    		session_token: user.session_token,
    		type: '1',
    		email: $scope.email
    	},
    	url = SdkUrl.regUpdateUser;
    	var pUpdata = HttpService.templateAccessAPI( url, message );
    	pUpdata.then( function( result ){
    		$log.debug( 'user update email success', result );
    		$scope.userObj.email = $scope.email;
    		$scope.editStatus = !$scope.editStatus;
    	}, function( reason ){
    		$scope.emailNotRight = true;
    		$scope.saveErrorMsg = reason.message;
    	}).then(function(){
    		$scope.saveEmailFlag = false;
    	});
    }
    $scope.cancelEdit = function(){
    	$scope.emailNotRight = false;
    	$scope.editStatus = !$scope.editStatus;
    }

    $scope.getUserInfo();
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
.factory('HttpService', function( $log, $http, $q, SDKService, $state, PopupService ){
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
		            PopupService.popupModal();
		            d.reject({message:''});
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
	var user = sessionStorage.getItem( 'user' ) || { user_id: '', session_token: '', phone: '', username: ''};
	function getUser() {
		return angular.fromJson( sessionStorage.getItem( 'user' ) );
	}
    var browser = { 
        versions: function() { 
            var u = navigator.userAgent, app = navigator.appVersion; 
            return {//移动终端浏览器版本信息                                  
	            trident : u.indexOf('Trident') > -1, //IE内核                                  
	            presto : u.indexOf('Presto') > -1, //opera内核                                  
	            webKit : u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核                                  
	            gecko : u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核                                 
	            mobile : !!u.match(/AppleWebKit.*Mobile.*/) 
	                    || !!u.match(/AppleWebKit/), //是否为移动终端                                  
	            ios : !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端                  
	            android : u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器                                  
	            iPhone : u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器                     
	            iPad: u.indexOf('iPad') > -1, //是否iPad        
	            webApp : u.indexOf('Safari') == -1,//是否web应该程序，没有头部与底部 
	            google:u.indexOf('Chrome')>-1 
	        }; 
	    }(), 
	    language : (navigator.browserLanguage || navigator.language).toLowerCase() 
    }
	return {
		refreshToken: function( token ) {
			var user = getUser();
			if ( user === undefined || user === null ) return;
			user.session_token = token;
			sessionStorage.setItem( 'user', angular.toJson( user ) );
		},
		setUser: function( obj ){
			if ( obj === null ) {
				user = { user_id: '', session_token: '', phone: '', username: '' };
			} else {
				user = { 
					user_id: obj.user_id, 
					session_token: obj.session_token, 
					phone: obj.phone,
					username: obj.username
				};
			}
			sessionStorage.setItem( 'user', angular.toJson( user ) );
		},
		getUser: function(){
			return angular.fromJson( sessionStorage.getItem( 'user' ) );
		},
		getBinBit: function (num, pos){
		    if( isNaN(num) ) return;
		    if( isNaN(pos) ) return parseInt(num,10).toString(2);
		    else {
		    	var length = (parseInt(num,10).toString(2)).length;
		    	if( length < pos ) return 'error';
		    	return parseInt(num,10).toString(2).substr((length - pos),1);
		    }
		},
		setStatusBit: function( bit ){
			if( isNaN(bit) ) return;
			sessionStorage.setItem( 'statusBit', bit );
		},
		getStatusBit: function(){
			return sessionStorage.getItem( 'statusBit' );
		},
		isMobileClient: function(){
           return browser.versions.mobile || browser.versions.ios || browser.versions.android || browser.versions.iPhone || browser.versions.iPad;
		}
	}
	
})