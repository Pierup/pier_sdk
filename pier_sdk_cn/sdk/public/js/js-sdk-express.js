/**
 * 品而中国版支付SDK
 * @param  @version express
 * @return PIER    PIER对象，用于支付的实例对象
 * @author Flower
 * @date
 */
(function( win, doc ){
    //for stylesheet and container
    var styleSheet, styleElem, _OPTIONS, _callback;
    var _pierPayBtn, _pierOverlay, _flipWrap, _flipContainer, 
    _EPLoginContainer,
    _cfmContainer,
    _payRstContainer,
    _EPRegContainer,
    _applyContainer,
    _applyRstContainer;

    var apiConfig = {
        hostName: 'http://pierup.asuscomm.com:8686', //'http://pierup.asuscomm.com:8686',
        regCode: '/sdk_register_cn/v1/register/activation_code',
        regUser: '/sdk_register_cn/v1/register/register_user',
        setPin: '/sdk_register_cn/v1/register/forget_payment_password_reset',
        signIn: '/sdk_register_cn/v1/register/signin',
        bindCard: '/payment_api/bind_card?platform=1',
        verifyCard: '/payment_api/verify_card?platform=1',
        EP:{
            prepay: '/payment_api/prepay_by_card?platform=1',
            payByCard: '/payment_api/pay_by_card?platform=1',
        },
        savePaymentOrder: '/payment_api/save_payment_order',
        applyCredit: '/sdk_register_cn/v1/user/apply_promotion_credit',
        saveInstalmentAndCard: '/payment_api/save_installment_card?platform=1',
        getPaySMS: '/payment_api/get_sms_code',
        updateBasic: '/sdk_register_cn/v1/user/update_user_basic'
    };
    var userAuth = {
        user_id: '',
        session_token: '',
        statusBit: '',
        name: ''
    };
    var basicInfo = {};
    var payType = {
        credit: '1',
        bankCard: '2',
        mixed: '3'
    };
    var switchType = {
        rightInLeftOut: 'rightInLeftOut',
        filp: 'filp',
        normal: 'normal'
    };

    var defaultSettings = {
        env: 'dev', //default 'dev' for testing, if 'pro',it will be production mode.
        totalAmount: 0, //the total amount to be paid, default 0
        currency: 'CNY', //default 'cny',
        payButtonId: '',
        merchantLogo: '',
        sdk_type: 'EP',
        api_key: '',
        order_id: '',
        user_id: '',
        order_desc: '品而金融',
        merchant_id:'',
        available_time: '10080'
    },  pierConst = (function(){
        return {
            paramError: "配置参数格式错误！",
            cssPrefix: 'PIER-',
            phoneInputTip: "请输入您的手机号",
            exitTip: "再次点击退出支付！",
            pwdInputTip: "请输入您的密码",
            pierLogo: "http://pierup.cn/images/sdk-logo.png",
            title: {
                login:'品而金融',
                payment: '支付',
            },
            next: '下一步',
            notYetPierUser: '还不是品而用户？',
            regRightNow: '马上注册',
            pierCreditAmount: '品而金融支付金额',
            agreeAndRead: '我已同意并阅读',
            baomixieyi: '《保密授权协议》',
            emptyPayBtn: '未指定支付按钮的ID',
            sendCode: '获取验证码',
            reSend: '重新发送',
            btnLoading: '<img src="http://pierup.cn:4000/images/sdk_loading.gif" style="width:22px;height:22px;display:inline;"/>',
            btnLoading2: '<img src="/images/btn-loading.gif" style="width:20px;height:20px;display:inline;"/>'
        }
    }()),  defaultUtils = {
        init: function(){
            styleElem = doc.createElement( 'style' );//init style sheet for pier layout
            doc.head.appendChild( styleElem );//add pier stylesheet to head
            styleSheet = styleElem.sheet;
            if( !styleSheet.addRule ){//for firefox not support function 'addRule', instead of insertRule.
                styleSheet.addRule = function( selector, style ){
                    var index = styleSheet.cssRules.length; 
                    styleSheet.insertRule( selector+'{'+style+'}', index );
                }
            };
            var ss = styleSheet, _bind = function(fn, me) {
                return function() {
                    return fn.apply(me, arguments);
                }
            };
            var $ = _bind( ss.addRule, ss );
            
            $( '.pier-payment-btn', 'width:120px;height:32px;border:1px solid #ccc; cursor:pointer; overflow: hidden;' );
            $( '.pier-payment-btn:hover', 'width:120px;height:32px;border:1px solid #7b37a6; cursor:pointer;' );
            /***payment layout***/
            $( '.PIER-flip-container, .PIER-overlay, .PIER-flip-container *', '-moz-box-sizing:border-box;-webkit-box-sizing:border-box;-ms-box-sizing:border-box;-o-box-sizing:border-box;box-sizing:border-box;')
            $( '.PIER-overlay', "overflow:scroll;position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:#000;/*visibility:hidden;*/opacity:0.4;font-family: 'Microsoft YaHei', Arial, SimHei;")
            $( '.PIER-panel-head, .PIER-overlay img, .PIER-overlay table, .PIER-overlay table td, .PIER-EPlogin-body, .PIER-comm-input, .PIER-payment-body', 'margin:0px;height: 0px;');
            $( '.PIER-flip-wrap', 'overflow:scroll;position:fixed;left:0;top:0;width:100%;height:100%;z-index:888;');
            $( '.PIER-flip-container', '-webkit-perspective:1000;-moz-perspective:1000;-ms-perspective:1000;perspective:1000;-webkit-transform:perspective(1000px);-ms-transform:perspective(1000px);-moz-transform:perspective(1000px);transform:perspective(1000px);-webkit-transform-style:preserve-3d;-moz-transform-style:preserve-3d;-ms-transform-style:preserve-3d;transform-style:preserve-3d;margin:0 auto;margin-top:10%;width:460px;height:auto;');
            $( '.PIER-reg-container-back', '-webkit-transform:rotateY(0)!important;-moz-transform:rotateY(0)!important;-o-transform:rotateY(0)!important;-ms-transform:rotateY(0)!important;transform:rotateY(0)!important;opacity:1!important;z-index:10;');
            $( '.PIER-login-container-back', '-webkit-transform:rotateY(180deg)!important;-moz-transform:rotateY(180deg)!important;-o-transform:rotateY(180deg)!important;-ms-transform:rotateY(180deg)!important;transform:rotateY(180deg)!important;opacity:0;');
            $( '.PIER-login-container, .PIER-reg-container', '-webkit-backface-visibility:hidden;-moz-backface-visibility:hidden;-ms-backface-visibility:hidden;-o-backface-visibility:hidden;backface-visibility:hidden;-webkit-transition:.6s;-webkit-transform-style:preserve-3d;-moz-transition:.6s;-moz-transform-style:preserve-3d;-o-transition:.6s;-o-transform-style:preserve-3d;-ms-transition:.6s;-ms-transform-style:preserve-3d;transition:.6s;transform-style:preserve-3d;position:absolute;top:0;left:0');
            $( '.PIER-login-container', '-webkit-transform:rotateY(0);-moz-transform:rotateY(0);-ms-transform:rotateY(0);-o-transform:rotateY(0);transform:rotateY(0);z-index:2;width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;');
            

            $( '.PIER-payment-container, .PIER-apply-container', '-webkit-transform:rotateY(0);-ms-transform:rotateY(0);width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;z-index:222;display:none;');
            $( '.PIER-payresult-container, .PIER-applyresult-container', '-webkit-transform:rotateY(0);-ms-transform:rotateY(0);width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;z-index:4;display:none;');
            $( '.PIER-reg-container', '-webkit-transform:rotateY(-180deg);-moz-transform:rotateY(-180deg);-o-transform:rotateY(-180deg);-ms-transform:rotateY(-180deg);transform:rotateY(-180deg);width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;opacity:0;');
            $( '.PIER-EPreg-container', 'width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;');

            $( '.PIER-payresult-body', 'padding-bottom: 40px;');
            $( '.PIER-payresult-body img', 'width: 90px;height: 90px;');
            
            $( '.PIER-panel-head', 'text-align:center;width:100%;height:80px;border-top-right-radius:6px;border-top-left-radius:6px;filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(235,235,237)");-ms-filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(235,235,237)");background-image:-moz-linear-gradient(top,#f5f5f5,#ebebed);background-image:-ms-linear-gradient(top,#f5f5f5,#ebebed);background-image:-o-linear-gradient(top,#f5f5f5,#ebebed);background-image:-webkit-gradient(linear,center top,center bottom,from(#f5f5f5),to(#ebebed));background-image:-webkit-linear-gradient(top,#f5f5f5,#ebebed);background-image:linear-gradient(top,#f5f5f5,#ebebed);-moz-background-clip:padding;-webkit-background-clip:padding-box;background-clip:padding-box;border-bottom:0;border-bottom:1px solid silver;background:url(/images/top-bg.png) repeat-x;');
            $( '.PIER-panel-head table', 'width: 100%;height: 75px;');
            $( '.PIER-panel-head table tr td:first-child', 'width:20%;');
            $( '.PIER-panel-head table tr td:nth-child(2) img', 'height: 56px;width: 56px;border:2px solid #fff;border-radius: 28px;');
            $( '.PIER-panel-head table tr td:nth-child(2) div', 'height:58px;width:58px;border:1px solid #c8c8c8;margin-top:-32px;border-radius:30px;display:inline-block;' );
            $( '.PIER-panel-head table tr td:nth-child(2) h4', 'font-size: 16px;margin-top: -2px;letter-spacing: 2px;font-weight: lighter;');
            $( '.PIER-panel-head table tr td:nth-child(3)', 'width: 20%;');
            $( '.PIER-panel-head table tr td:nth-child(3) img', 'width:20px;height:20px;border-radius: 10px;border: 1px solid rgb(200,200,200);margin: 2px;');
            $( '.PIER-close', "height:22px;width:22px;float:right;margin-top:-24px;margin-right:4px;cursor:pointer;background-size:100% 100%;background-image: url('data:image/png;base64,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');");
            $( '.PIER-EPlogin-body', 'height: 288px;width: 100%;border-top:1px solid #f5f5f5;');
            $( '.PIER-reg-body', 'height: 376px;width: 100%;border-top:1px solid #f5f5f5;');
            $( '.PIER-cardPay-body', 'height: auto;width: 100%;border-top:1px solid #f5f5f5;');
            $( '.PIER-apply-body','height: auto;width: 100%;padding-bottom: 20px;border-top:1px solid #f5f5f5;');
            $( '.PIER-loading-body', 'height:290px;width:100%; text-align:center;padding-top:40px;background:#fff;')
            $( '.PIER-loading-body src', 'height:290px;width:100%; height:100px;width:100px;')
            $( '.PIER-payment-body', 'height: auto;width: 100%;padding-bottom: 20px;border-top:1px solid #f5f5f5;');
            
            $( '.PIER-payment-body label', 'font-size: 14px;');
            $( '.PIER-right', 'float: right;');
            $( '.PIER-row', 'width: 262px;margin: 0 auto;');
            $( '.PIER-comm-input', 'width:260px;height:30px;outline:0;border-radius:4px;border:1px solid #dcdcdc;padding-left:6px;');
            $( '.PIER-code-input', 'width:173px;height:30px;padding-left:6px;outline:0;border:1px solid #dcdcdc;border-top-left-radius:4px;border-bottom-left-radius:4px;float:left;display:block!important');
            $( '.PIER-code-label', 'border:1px solid #b4b4b4;font-size:12px!important;background:#b4b4b4;color:#fff;height:30px;border-top-right-radius:4px;border-bottom-right-radius:4px;padding-left:8px;padding-right:8px;margin-left:-4px;float:left;cursor:pointer;width:89px;outline:none;');
            $( '.PIER-clear', 'clear: both;');
            $( '.PIER-switch-btn', 'background:#fff;color:#7b37a6;border:1px solid #ccc;outline:0;width:90px;height:28px;display:inline-block;cursor:pointer;font-size:14px;');
            $( '.PIER-switch-btn.active', 'background: #7b37a6;color: #fff;');
            $( '.PIER-switch-btn.left-btn', 'border-top-left-radius: 4px;border-bottom-left-radius: 4px;border-right: 0px;');
            $( '.PIER-switch-btn.right-btn', 'border-top-right-radius: 4px;border-bottom-right-radius: 4px;border-left: 0px;');
            $( '.PIER-bank-body', 'height:auto;width:100%;background:#fff;border-bottom-left-radius:6px;border-bottom-right-radius:6px;');
            $( '.PIER-bank-body table', 'margin: 0 auto;height: 80px;');
            $( '.PIER-bank-body table img', 'width: 40px;height: 40px;line-height: 80px;');
            $( '.PIER-link-bank-panel', 'width:100%;transition:height .5s;-moz-transition:height .5s;-webkit-transition:height .5s;-o-transition:height .5s;height:auto;overflow:hidden;');

            $( '.PIER-instalment-select', 'width: 168px;border-radius: 4px;height: 28px;outline: none;border: 1px solid rgb(220,220,220);');
            $( '.PIER-bankcard-select', 'width: 172px;border-radius: 4px;height: 28px;outline: none;border: 1px solid rgb(220,220,220);');
            $( '.PIER-bankcard-select span', 'font-size:10px;');
            $( '.PIER-mT-lg', 'margin-top: 52px;');
            $( '.PIER-mT-md', 'margin-top: 32px;');
            $( '.PIER-mT-sm', 'margin-top: 16px;');
            $( '.PIER-mT-xs', 'margin-top: 12px;');
            $( '.PIER-mB-sm', 'margin-bottom: 18px;');
            $( '.PIER-mB-md', 'margin-bottom: 36px;');
            $( '.PIER-h-auto', 'height: auto !important;');
            $( '.PIER-color', 'color: #7b37a6;');
            $( '.PIER-color-gray', 'color: rgb(180,180,180);');
            $( '.PIER-color-black', 'color:#000;');
            $( '.PIER-money', 'color: #f34949;');
            $( '.PIER-font-lg', 'font-size: 30px;');
            $( '.PIER-font-md', 'font-size: 16px;');
            $( '.PIER-font-sm', 'font-size: 12px;');
            $( '.PIER-font-xs', 'font-size: 10px;');
            $( '.PIER-text-center', 'text-align: center;');
            $( '.PIER-text-left', 'text-align: left !important;');

            $( '.PIER-submit-btn', 'width:132px;height:28px;border-radius:4px;border:1px solid #dcdcdc;filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(255,255,255)", endColorstr = "rgb(225,225,225)");-ms-filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(255,255,255)", endColorstr = "rgb(225,225,225)");background-image:-moz-linear-gradient(top,#fff,#e1e1e1);background-image:-ms-linear-gradient(top,#fff,#e1e1e1);background-image:-o-linear-gradient(top,#fff,#e1e1e1);background-image:-webkit-gradient(linear,center top,center bottom,from(#fff),to(#e1e1e1));background-image:-webkit-linear-gradient(top,#fff,#e1e1e1);background-image:linear-gradient(top,#fff,#e1e1e1);-moz-background-clip:padding;-webkit-background-clip:padding-box;background-clip:padding-box;outline:0;cursor:pointer;display:block;margin:0 auto;');
            $( '.PIER-submit-btn:active', 'filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(215,215,215)");-ms-filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(215,215,215)");background-image:-moz-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:-ms-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:-o-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:-webkit-gradient(linear,center top,center bottom,from(#fff),to(#d7d7d7));background-image:gradient(linear,center top,center bottom,from(#fff),to(#d7d7d7));background-image:-webkit-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:linear-gradient(top,#f5f5f5,#d7d7d7);');
            
            $( '.PIER-bottom-text', 'font-size: 12px !important;');
            $( '.PIER-forward-reg:hover, .PIER-forward-login:hover', 'cursor: pointer;text-decoration: underline;');
            $( '.PIER-dot-line', 'padding-bottom: 15px;border-bottom: 1px dotted #ccc;');
            $( '.PIER-display-block', 'display: block !important;');
            $( '.PIER-animated', '-webkit-animation-duration:1s;-moz-animation-duration:1s;-o-animation-duration:1s;animation-duration:1s;-webkit-animation-fill-mode:both;-moz-animation-fill-mode:both; -o-animation-fill-mode:both;animation-fill-mode:both;');
            $( '.PIERbounceOutLeft', '-webkit-animation-name:PIERbounceOutLeft;-moz-animation-name:PIERbounceOutLeft;-o-animation-name:PIERbounceOutLeft;animation-name:PIERbounceOutLeft');
            $( '.PIERbounceInTop', '-webkit-animation-name:PIERbounceInTop;-moz-animation-name:PIERbounceInTop;-o-animation-name:PIERbounceInTop;-ms-animation-name:PIERbounceInTop;animation-name:PIERbounceInTop')
            $( '.PIERbounceInRight', '-webkit-animation-name:PIERbounceInRight;-moz-animation-name:PIERbounceInRight;-o-animation-name:PIERbounceInRight;animation-name:PIERbounceInRight' );
            $( '.PIER-buzz-class', '-webkit-animation-name:PIER-buzz-out;-moz-animation-name:PIER-buzz-out;-o-animation-name:PIER-buzz-out;-ms-animation-name:PIER-buzz-out;animation-name:PIER-buzz-out;-webkit-animation-duration:.5s;-moz-animation-duration:.5s;-o-animation-duration:.5s;-ms-animation-duration:.5s;animation-duration:.5s;-webkit-animation-timing-function:linear;-moz-animation-timing-function:linear;-o-animation-timing-function:linear;-ms-animation-timing-function:linear;animation-timing-function:linear;-webkit-animation-iteration-count:1;-moz-animation-iteration-count:1;-o-animation-iteration-count:1;-ms-animation-iteration-count:1;animation-iteration-count:1' );
            $( '.PIER-error', 'font-size: 12px;color: #f34949;height: 36px;padding-top: 2px;overflow: hidden;margin-bottom: 4px;' );
            $( '.PIER-error2', 'font-size: 12px;color: #f34949;' );
            /**apply credit**/
            $( '.PIER-set-pin', 'width: 100%;height: auto;');
            $( '.PIER-apply-container  label', 'font-size: 14px !important; color: rgb(149,149,149);');
            $( '.PIER-apply-body .PIER-row>span', 'font-size: 14px ; color: #000;');
            $( '.PIER-split-line', 'border-bottom: 1px dotted #ccc;margin-top: 30px;margin-bottom: 30px;');
            /**apply result**/
            $( '.PIER-applyresult-body', 'padding-bottom: 10px;border-top:1px solid #f5f5f5;' );
            $( '.PIER-applyresult-body img', 'width: 70px;height: 70px;' );

            if( isFirefox=navigator.userAgent.indexOf("Firefox") != -1 ){ 
                $( '@-moz-keyframes PIERbounceOutLeft', '0% {-moz-transform:translateX(0) }20% {opacity:1;-moz-transform:translateX(20px)}100% { opacity:0;-moz-transform:translateX(-2000px)}');
                $( '@-moz-keyframes PIERbounceInRight', '0% {opacity:0;-moz-transform:translateX(2000px) }60% {opacity:1;-moz-transform:translateX(-30px)} 80% {-moz-transform:translateX(10px)}100% {-moz-transform:translateX(0)}' );
                $( '@-moz-keyframes PIER-buzz-out', '10% {-moz-transform: translate(4.5px, 4px) rotate(-1deg); }20% {-moz-transform: translate(-2px, 3.5px) rotate(2deg); }30% {-moz-transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {-moz-transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {-moz-transform: translate(-4.5px, -4px) rotate(-1deg); }60% {-moz-transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {-moz-transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {-moz-transform: translate(-2px, 3.5px) rotate(2deg); }90% {-moz-transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {-moz-transform: translate(0, 0) rotate(0);  }' );
                $( '@-moz-keyframes PIERbounceInTop','0%{opacity:0;-moz-transform:translateY(-2000px)}60%{opacity:1;-moz-transform:translateY(30px)}80%{-moz-transform:translateY(-30px)}100%{-moz-transform:translateY(0)}');
            }
            if(  ( isChrome = navigator.userAgent.indexOf("Chrome") != -1 ) || (isSafari=navigator.userAgent.indexOf("Safari") != -1 ) ){
                $( '@-webkit-keyframes PIERbounceOutLeft', '0% {-webkit-transform:translateX(0)} 20% {opacity:1; -webkit-transform:translateX(20px)}100% {opacity:0;-webkit-transform:translateX(-2000px)}');
                $( '@-webkit-keyframes PIERbounceInRight', '0% {opacity:0;-webkit-transform:translateX(2000px)}60% {opacity:1;-webkit-transform:translateX(-30px) }80% {-webkit-transform:translateX(10px)}100% { -webkit-transform:translateX(0) }' );
                $( '@-webkit-keyframes PIER-buzz-out', '10% {-webkit-transform: translate(4.5px, 4px) rotate(-1deg); }20% {-webkit-transform: translate(-2px, 3.5px) rotate(2deg); }30% {-webkit-transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {-webkit-transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {-webkit-transform: translate(-4.5px, -4px) rotate(-1deg); }60% {-webkit-transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {-webkit-transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {-webkit-transform: translate(-2px, 3.5px) rotate(2deg); }90% {-webkit-transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {-webkit-transform: translate(0, 0) rotate(0);  }' );
                $( '@-webkit-keyframes PIERbounceInTop', '0%{opacity:0;-webkit-transform:translateY(-2000px)}60%{opacity:1;-webkit-transform:translateY(30px)}80%{-webkit-transform:translateY(-30px)}100%{-webkit-transform:translateY(0)}');
            }
            if( navigator.userAgent.indexOf("MSIE") != -1 || navigator.userAgent.indexOf("Trident") !=- 1 ) {
                $( 'PIERbounceOutLeft', '0% {transform:translateX(0) } 20% {opacity:1;  transform:translateX(20px) } 100% {opacity:0;transform:translateX(-2000px) }');
                $( 'PIERbounceInRight', '0% {opacity:0;transform:translateX(2000px)}60% { opacity:1; transform:translateX(-30px) }80% { transform:translateX(10px) }100% {transform:translateX(0)}' );
                $( 'PIER-buzz-out', '10% {transform: translate(4.5px, 4px) rotate(-1deg); }20% {transform: translate(-2px, 3.5px) rotate(2deg); }30% {transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {transform: translate(-4.5px, -4px) rotate(-1deg); }60% {transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {transform: translate(-2px, 3.5px) rotate(2deg); }90% {transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {transform: translate(0, 0) rotate(0);  }' );
                $( 'PIERbounceInTop', '0%{opacity:0;-ms-transform:translateY(-2000px)}60%{opacity:1;-ms-transform:translateY(30px)}80%{-ms-transform:translateY(-30px)}100%{-ms-transform:translateY(0)}');
            }
            if( Opera = navigator.userAgent.indexOf("Opera") != -1 ){
                $( '@-o-keyframes PIERbounceOutLeft', '0% { -o-transform:translateX(0)}20% {opacity:1;-o-transform:translateX(20px)}100% { opacity:0; -o-transform:translateX(-2000px)}');
                $( '@-o-keyframes PIERbounceInRight', '0% {opacity:0;-o-transform:translateX(2000px)}60% {opacity:1;-o-transform:translateX(-30px)}80% {-o-transform:translateX(10px)}100% {-o-transform:translateX(0)}' );
                $( '@-o-keyframes PIER-buzz-out', '10% {-o-transform: translate(4.5px, 4px) rotate(-1deg); }20% {-o-transform: translate(-2px, 3.5px) rotate(2deg); }30% {-o-transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {-o-transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {-o-transform: translate(-4.5px, -4px) rotate(-1deg); }60% {-o-transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {-o-transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {-o-transform: translate(-2px, 3.5px) rotate(2deg); }90% {-o-transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {-o-transform: translate(0, 0) rotate(0);  }' );
                $( '@-o-keyframes PIERbounceInTop', '0%{opacity:0;-o-transform:translateY(-2000px)}60%{opacity:1;-o-transform:translateY(30px)}80%{-o-transform:translateY(-30px)}100%{-o-transform:translateY(0)}');
            }
        },
        setUser:function( user ){
            if( typeof user !== 'object' ) return;
            for( var key in user ){
                if( userAuth.hasOwnProperty(key) ){
                    userAuth[key] = user[key];
                }
            }
        },
        getUser: function(){
            return userAuth;
        },
        setBasic:function( info ){
            basicInfo = info;
        },
        getBasic: function(){
            return basicInfo;
        },
        setConfig: function( target, original ){
            if( typeof target === 'object' && typeof original === 'object' ){
                for(key in original){
                    if( !target.hasOwnProperty(key) ){
                        target[key] = original[key];
                    }
                }
                return target;
            }else{
                throw new Error( pierConst.paramError );
            }
        },
        notEmpty: function( array ){
            var _array = array;
            var _error = '';
            if ( typeof _array != 'object' ){
                throw new Error( "参数错误！" );
                return;
            }else{
                for( var i in _array ){
                    if( _array[i] == '' || _array[i] == undefined || _array[i] == null ){
                        _error =  i+'不能为空';
                        return _error;
                    }
                }
                return _error;
            }
        },
        isUndefined: function( input ){
            return input === undefined || input === ''? true:false;
        },
        isArray: function( input ){
            return Array.isArray(input);
        },
        filter: function( filterName, value, key ){
            if( filterName === 'currency' ){
                var returnVal = '';
                switch( key ){
                    default: returnVal= '<span class="PIER-font-sm">￥</span>'+ value;break;
                }
                return returnVal;
            }
        },
        trim: function( string ){
            if( typeof string !== 'string' ){
                throw new Error('trim 方法参数错误'); 
                return;
            } 
            return string.replace(/(^\s*)|(\s*$)/g, "");
        },
        digitalInputListener: function( event ){
            var obj = event.srcElement ? event.srcElement : event.target;
            console.log('input',obj.value );
            var input = obj.value;
            if( typeof input === 'undefined' ) return;

            if( input.length > 0 ){
                var output = input.replace( /[^0-9]/g, '' );
                event.srcElement.value = output;
            }
        },
        idCardListener: function( event ){
            var obj = event.srcElement ? event.srcElement : event.target;
            console.log('input',obj.value );
            var input = obj.value;
            if( typeof input === 'undefined' ) return;

            if( input.length > 0 ){
                var numberInput = input;
                if( numberInput.length == 18 && ( numberInput.substr(17,1)=='X'||numberInput.substr(17,1)=='x' ) ){
                    var tempInput = numberInput.substr(0,17);
                    numberInput = tempInput.replace( /[^0-9]/g, '' ) + 'X';
                }else{
                    numberInput = input.replace( /[^0-9]/g, '' );
                }
                if ( numberInput != input ) {
                    event.srcElement.value = numberInput;
                }
            }
        },
        timer: function( btn ){
            if( typeof btn !== 'object' ) return;
            var countDown;
            var btnText = btn.html();
            console.log( 'btnText', btnText );
            var tempCount = 60;
            if( parseFloat(btnText) === NaN ){
                btnText = tempCount;
                btn.html(btnText);
            }
            var _timer = function(){
                tempCount -= 1;
                if( tempCount == 0 ){
                    btn.html(pierConst.reSend);
                    clearInterval(countDown);
                }else{
                   btn.html(tempCount);
                }
            }
            _timer();
            countDown = setInterval(_timer, 1000);
        },
        extend: function(fn, me) {
            return function() {
                return fn.apply(me, arguments);
            }
        },
        switchPanel: function( opts  ){
            var $$ = defaultUtils,
            _type = opts.type,
            _origin = opts.origin,
            _target = opts.target;

            if( _type === switchType.rightInLeftOut ){
                _origin.addClass( ['PIER-animated', 'PIER-display-block', 'PIERbounceOutLeft'] );
                _target.addClass( ['PIER-animated','PIER-display-block', 'PIERbounceInRight' ]);
                _origin.destory(10);
                _flipContainer.appendChild(_target);
            }

            if( _type === switchType.filp ){
                var _direction = opts.direction;
                if( _direction === 'fromFront' ){
                    setTimeout(function(){
                        _origin.addClass('PIER-login-container-back');
                        _target.addClass('PIER-reg-container-back');
                    }, 10); 
                    _flipContainer.appendChild(_target);
                }
                if( _direction === 'fromBack' ){
                    _origin.removeClass('PIER-reg-container-back');
                    _target.removeClass('PIER-login-container-back');
                    _origin.destory();
                }
            }
        },
        createElem: function( elem, classArray ){
            var _this = doc.createElement( elem );
            _this.addClass = function( array ){
                if( typeof array == 'object' ){
                    for( var i in array ){
                        if( this.classList ){
                            this.classList.add( array[i] );
                        }else{
                            var tempArray = _this.className.split(' ');
                            _this.className += ' '+array[i];
                        }
                    }
                }
                if( typeof array == 'string' ){
                    if( this.classList ){
                        this.classList.add( array );
                    }else{
                        var tempArray = _this.className.split(' ');
                        _this.className += ' '+array;
                    }
                }
            };
            _this.removeClass = function( array ){
                if( typeof array == 'object' ){
                    if( this.classList ){
                        for( var i in array ){
                            this.classList.remove( array[i] );
                        }
                    }else{
                        var newArray = '';
                        var tempArray = _this.className.split(' ');
                        for( var i in array ){
                            
                        }
                    }
                }
                if( typeof array == 'string' ){
                    if( this.classList ){
                        this.classList.remove( array );
                    }else{
                        var tempArray = _this.className.split(' ');
                        var newArray = '';
                        for( var i in tempArray ){
                            if( tempArray[i] !== array ){
                                newArray += ' '+tempArray[i];
                            }
                        }
                        _this.className = newArray;
                    }
                }
            };
            _this.setAttrs = function( obj ){
                if( typeof obj !== 'object' ) return;
                for( var i in obj ){
                    this.setAttribute( i, obj[i] )
                }
            };
            _this.getAttr = function( attr ){
                if( attr == '' || attr == undefined ) return;
                return _elemTemp.getAttribute( attr );
            };
            _this.appendChildren = function(array){
                if( typeof array !== 'object' ) return;
                for( var i in array ){
                    this.appendChild(array[i]);
                }
                return this;
            };
            _this.contains = function( className ){
                if( typeof className !== 'string' ) return;
                if( _this.classList ){
                    if( _this.classList.contains(className) ){
                        return true;
                    }else{
                        return false;
                    }
                }else{
                    var classArray = _this.className.split(' ');
                    var hasClass = false;
                    for( var i in classArray ){
                        if( classArray[i] == className ) hasClass = true;
                    }
                    return hasClass;
                }
            };
            _this.css = function( _styles ){
                if( typeof _styles !== 'object' ) return;
                for( var i in _styles ){
                    _this.style[i] = _styles[i];
                }
                console.log( ' _this.style',  _this.style);
            };
            _this.destory = function( timeSec ){
                setTimeout(function(){
                    console.log( 'this.parentNode', _this.parentNode );
                    _this.parentNode.removeChild(_this);
                }, timeSec ||　500);
            };
            _this.val = function( input ){
                if( input === undefined || input === '' || input === null ) return this.value;
                else this.value = input;
            };
            _this.html = function( text ){
                if( text === undefined || text === null ) return this.innerHTML;
                else this.innerHTML = text;
            };
            _this.bind = function( type, Fun, useCapture ){
                var action = [ 'click', 'change', 'blur', 'focus' ];
                if ( typeof doc.addEventListener != "undefined" ){
                    this.addEventListener( type, Fun, useCapture||false );
                }else{
                    this.attachEvent( type, Fun );
                }
            };
            _this.unbind = function( type, Fun ){
                var action = [ 'click', 'change', 'blur', 'focus' ];
                if ( typeof doc.addEventListener != "undefined" ){
                    this.removeEventListener( type, Fun );
                }else{
                    this.detachEvent( type, Fun );
                }
            };

            if( classArray != '' && classArray != undefined ){
                _this.addClass(classArray);
            }
            return _this;
        },
        destorySDK:function(){
            doc.body.removeChild(_pierOverlay);
            doc.body.removeChild(_flipWrap);
        },
        initPierBtn: function( parentNode ){
            _pierPayBtn = defaultUtils.createElem( 'div', ['pier-payment-btn']);
            _pierPayBtn.html( '<img  src="http://pierup.cn/images/pierlogo38.png" style="width:24px;margin-top:4px;margin-left:10px;margin-right:6px;float:left;">'+
       '<div style="font-size:14px;margin-top:10px;margin-left:50px;">品而付V2</div>');
            if( parentNode ){
                parentNode.parentNode.appendChild(_pierPayBtn);
            }else{
                doc.body.appendChild(_pierPayBtn);
            }
            
            return _pierPayBtn;
        },
        initBtnLoading: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var _image = C( 'img' );
            _image.setAttrs({ 'src':pierConst.btnLoading, 'style':'width:20px;height:20px;display:inline;' });
            return _image;
        },
        initHeader:function( headerOpt ){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var payResult = false;
            if( headerOpt ){
                payResult = headerOpt.payResult || false;
            }
            var _tempHead = C( 'div', 'PIER-panel-head' ),
            _tempHeadTable = C( 'table' ),
            _tempHeadTableTr = C( 'tr' ),
            _tempHeadTableTrTd = C( 'td' ),
            _tempHeadClose = C( 'div', 'PIER-close' );
            _tempHeadTableTr.html( '<td ></td><td><div><img src="'+headerOpt.logo+'"></div><h4>'+headerOpt.wording+'</h4></td>' );
            _tempHead.appendChild(_tempHeadTable);
            _tempHeadTable.appendChild( _tempHeadTableTr );
            _tempHeadTableTr.appendChild(_tempHeadTableTrTd);
            _tempHeadTableTrTd.appendChild(_tempHeadClose);
            _tempHeadClose.bind( 'click', function(){
                if( headerOpt.errorObj ){
                    if( headerOpt.errorObj.parentNode.contains( 'PIER-h-auto' ) ){
                        headerOpt.errorObj.parentNode.removeClass('PIER-h-auto')
                    }
                }
                if( payResult ){
                    $$.destorySDK();
                }else{
                    _flipContainer.classList.remove( 'PIER-buzz-class' );
                    setTimeout(function( ){
                        if( headerOpt.errorObj.html() == pierConst.exitTip ){
                            $$.destorySDK();
                        }else{
                            _flipContainer.addClass( 'PIER-buzz-class' );
                            headerOpt.errorObj.html( pierConst.exitTip );
                            setTimeout(function(){
                                headerOpt.errorObj.html('');
                            }, 5000);                   
                        }
                    }, 10); 
                }                
            })
            return _tempHead;
        },
        initPinSettingPanel:function( clickFun ){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var pinSettingPanel = C( 'div', 'PIER-set-pin'),
            splitLine = C( 'div', 'PIER-split-line');
            var pinTip = C( 'div', ['PIER-row', 'PIER-font-sm', 'PIER-color-black']);
            pinTip.html( '<p>设置品而金融支付密码以保障支付安全</p>' );

            var pinRow = C( 'div', 'PIER-row'),
            pinInput = C( 'input', 'PIER-comm-input');
            pinInput.setAttrs({'placeholder':'设置支付密码', 'type': 'password', 'maxlength': '6'});
            pinInput.bind( 'keyup', $$.digitalInputListener );
            pinRow.appendChild(pinInput);

            var pinCfmRow = C( 'div', ['PIER-row','PIER-mT-sm']),
            pinCfmInput = C( 'input', 'PIER-comm-input');
            pinCfmInput.setAttrs({'placeholder':'确认支付密码', 'type': 'password', 'maxlength': '6'});
            pinCfmRow.appendChild(pinCfmInput);

            var pinErrorRow = C( 'div', ['PIER-row', 'PIER-error2',  'PIER-text-center']),
            pinErrorMsg = C( 'p' );
            pinErrorMsg.html('');
            pinErrorRow.appendChild(pinErrorMsg);

            var pinBtnRow = C( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']),
            pinBtn = C( 'button', ['PIER-submit-btn', 'PIER-color'] );
            pinBtn.html('申请品而信用');
            pinBtnRow.appendChild(pinBtn);
            var validPwd = function(){
                var _pwdVal = $$.trim( pinInput.val() );
                if( _pwdVal === '' || _pwdVal === undefined ){
                    pinErrorMsg.html( '支付密码不能为空！' );
                }else if( _pwdVal.length < 6 ){
                    pinErrorMsg.html('支付密码应该由6位数字组成！');
                }else{
                    var tempStr = _pwdVal.replace( /[^0-9]/g, '' );
                    if( tempStr != _pwdVal ) pinErrorMsg.html('支付密码只能由数字组成！');
                }
            }
            var validPwdMatch = function(){
                var _pwdVal = $$.trim( pinInput.val() );
                var _pwdConfirmVal = $$.trim( pinCfmInput.val() );
                if( _pwdVal !== _pwdConfirmVal ){
                    pinErrorMsg.html('两次输入的支付密码不匹配！');
                }
            }
            pinInput.addEventListener( 'change', validPwd );
            pinBtn.bind( 'click', function(){
                pinErrorMsg.html('');
                validPwd();
                if( pinErrorMsg.html() !== '' ) return;
                validPwdMatch();
                if( pinErrorMsg.html() !== '' ) return;
                clickFun.call( this, pinInput.val() );                
            })
            pinSettingPanel.appendChildren([splitLine,pinTip,pinRow, pinCfmRow, pinErrorRow, pinBtnRow]);
            return pinSettingPanel;
        },
        initLoadingBody: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var body = C( 'div', 'PIER-loading-body');
            var loadingImg = C( 'img');
            loadingImg.setAttrs({ 'src': '/images/loading_page.gif'});
            body.appendChild(loadingImg);
            return body;
        },
        initEPLogin: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            _EPLoginContainer = C( 'div', 'PIER-login-container');

            var body = C('div', 'PIER-EPlogin-body');

            var eroRow = C('div', ['PIER-row', 'PIER-error', 'PIER-text-center']),
            eroRowSpan = C('span', 'errorMsg' );
            eroRow.appendChild(eroRowSpan);

            var loginHead = $$.initHeader({
                errorObj: eroRowSpan,
                logo: _OPTIONS.merchantLogo,
                wording: _OPTIONS.order_desc
            });

            var switchRow = C('div', ['PIER-row', 'PIER-text-center']),
            creditBtn = C('button', ['PIER-switch-btn', 'active', 'left-btn']);
            creditBtn.html('使用信用');
            cardPayBtn = C('button', ['PIER-switch-btn', 'right-btn']);
            cardPayBtn.html('银联卡支付');
            switchRow.appendChildren([creditBtn, cardPayBtn]);

            var phoneRow = C( 'div', ['PIER-row', 'PIER-mT-md']),
            phoneInput = C( 'input', 'PIER-comm-input' );
            phoneInput.setAttrs({'placeholder':pierConst.phoneInputTip, 'maxlength':'11'});
            phoneInput.bind( 'keyup', $$.digitalInputListener );
            phoneRow.appendChild(phoneInput);

            var pwdRow = C( 'div', ['PIER-row', 'PIER-mT-sm']),
            pwdInput = C( 'input', 'PIER-comm-input' );
            pwdInput.setAttrs({'placeholder':pierConst.pwdInputTip, 'type':'password'});
            pwdRow.appendChild(pwdInput);

            var submitRow = C( 'div', ['PIER-row', 'PIER-mT-sm']);
            submitBtn = C( 'button', 'PIER-submit-btn' );
            submitBtn.setAttrs({'id':'pierLogin'});
            submitBtn.html( pierConst.next );
            submitRow.appendChild(submitBtn);

            var goRegRow = C( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-text-center']),
            bottomText = C( 'p', 'PIER-bottom-text');
            bottomText.html('只需轻松两步，');
            var regLink = C( 'a', ['PIER-color']);
            regLink.html('申请品而信用');
            regLink.setAttrs({'style':'cursor:pointer;'})
            bottomText.appendChild(regLink);
            goRegRow.appendChild(bottomText);

            _flipWrap.appendChild(_flipContainer); 
            _flipContainer.appendChild(_EPLoginContainer);

            _EPLoginContainer.appendChildren([loginHead, body]);
            //set body
            body.appendChildren([eroRow, switchRow, phoneRow, pwdRow, submitRow, goRegRow] );
            
            regLink.bind( 'click', function(){
                $$.initEPReg();
                _EPLoginContainer.destory(10);
                _flipContainer.appendChild(_EPRegContainer);
            })

            submitBtn.bind( 'click', function(){
                var ph = phoneInput.val(),
                pwd = pwdInput.val();
                eroRowSpan.html( $$.notEmpty({'手机号':ph, '密码': pwd }) );
                if( eroRow.contains('PIER-h-auto') ){
                    eroRow.removeClass('PIER-h-auto');
                }
                if( eroRowSpan.html() != '' ){
                    return;
                }
                var _url = apiConfig.hostName+apiConfig.signIn,
                _message = {
                    phone: ph,
                    password: pwd
                }, _this = submitBtn;
                var tempBtnCont = _this.html();
                _this.html(pierConst.btnLoading);

                $$.http( { url:_url, body:_message}, function( data ){
                    
                    console.log('user login success', data);
                    $$.setUser({session_token:data.session_token, user_id:data.user_id, status_bit: data.status_bit });
                    $$.initConfirm();
                    $$.switchPanel({
                        origin: _EPLoginContainer,
                        target: _cfmContainer,
                        type: switchType.rightInLeftOut
                    });
                }, function( error ){
                    console.log('user login failed', error);
                    eroRowSpan.html( error.message );
                    if( error.code === '1008' || error.code === '2009' ){
                        eroRow.addClass('PIER-h-auto');
                    }
                    _this.html(tempBtnCont);
                } );                
            })

            cardPayBtn.bind( 'click', function(){
                $$.initCardPay();
                $$.switchPanel({
                    origin: _EPLoginContainer,
                    target: _pierCardPayContainer,
                    type: switchType.filp,
                    direction: 'fromFront'
                });
            })
        },
        initCardPay: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            _pierCardPayContainer = C( 'div', 'PIER-reg-container');
            //pay result container header

            var body = C( 'div', 'PIER-cardPay-body' );
            var eroRow = C('div', ['PIER-row', 'PIER-error', 'PIER-text-center']);
            eroSpan = C('span', 'errorMsg' );
            eroRow.appendChild(eroSpan);
            var regHead = $$.initHeader({
                errorObj: eroSpan,
                logo: _OPTIONS.merchantLogo,
                wording: _OPTIONS.order_desc
            });

            var row1 = C('div', ['PIER-row', 'PIER-text-center']),
            creditBtn = C('button', ['PIER-switch-btn', 'left-btn']);
            creditBtn.html('使用信用');
            var applyBtn = C('button', ['PIER-switch-btn', 'active', 'right-btn']);
            applyBtn.html( '银联卡支付' );
            row1.appendChildren([creditBtn, applyBtn]);

            var priceRow = C('div', ['PIER-row', 'PIER-mT-md']);
            priceRow.html( '<label class="PIER-font-sm">商品总价：</label>' );
            var priceSpan = C('span', ['PIER-right', 'PIER-money']);
            priceSpan.html( $$.filter( 'currency', parseFloat(_OPTIONS.amount).toFixed(2), 'CNY' ) );
            priceRow.appendChild(priceSpan);

            var orderInfoRow = C('div', ['PIER-row']); 
            orderInfoRow.setAttrs({ 'style': 'height:60px;margin-top:4px;'});
            var orderSpan1 = C('div', ['PIER-right', 'PIER-font-sm']); 
            // orderSpan1.html( '美元共计：￥812.33' );
            var orderSpan2 = C('div', ['PIER-right','PIER-font-xs','PIER-color-gray','PIER-mT-xs']); 
            orderSpan2.html( '中国银行上海分行：2015-12-18 10:15' );
            var orderSpan3 = C('div', ['PIER-right','PIER-font-xs','PIER-color-gray']); 
            var orderBr = C('br'); 
            orderSpan3.html( '汇率：1USD = 6.47RMB' );
            orderInfoRow.appendChildren([orderSpan1, orderSpan2, orderBr, orderSpan3]);

            var _pierLinkBankPanel = C( 'div', ['PIER-link-bank-panel', 'PIER-mT-sm', 'PIER-mB-sm'] );

            var _pierBankNameRow = C( 'div', 'PIER-row' ),
            _pierBankNameInput = C( 'input', 'PIER-comm-input' );
            _pierBankNameInput.setAttrs({'placeholder':'姓名'});
            _pierBankNameRow.appendChild(_pierBankNameInput);

            var _pierBankIDRow = C( 'div', ['PIER-row','PIER-mT-sm'] ),
            _pierBankIDInput = C( 'input', 'PIER-comm-input' );
            _pierBankIDInput.setAttrs({'placeholder':'身份证', 'maxlength':18});
            _pierBankIDInput.bind( 'keyup', $$.idCardListener );
            _pierBankIDRow.appendChild(_pierBankIDInput);

            var _pierBankCardRow = C( 'div', ['PIER-row','PIER-mT-sm'] ),
            _pierBankCardInput = C( 'input', 'PIER-comm-input' );
            _pierBankCardInput.setAttrs({'placeholder':'借记卡号'});
            _pierBankCardRow.appendChild(_pierBankCardInput);

            var _pierBankPhoneRow = C( 'div', ['PIER-row','PIER-mT-sm'] ),
            _pierBankPhoneInput = C( 'input', 'PIER-comm-input' );
            _pierBankPhoneInput.setAttrs({'placeholder':'银行卡预留手机号'});
            _pierBankPhoneRow.appendChild(_pierBankPhoneInput);
            _pierBankPhoneInput.bind( 'keyup', $$.digitalInputListener );

            var _pierCheckboxRow = C('div', ['PIER-row', 'PIER-mT-xs']);
            var _pierCheckbox = C('input');
            _pierCheckbox.setAttrs( {'type':'checkbox'});
            var _pierCheckboxText = C('span', 'PIER-bottom-text');
            _pierCheckboxText.html( '同意<a class="PIER-color">《品而银行卡服务协议》</a>');
            
            _pierCheckboxRow.appendChild(_pierCheckbox);
            _pierCheckboxRow.appendChild(_pierCheckboxText);

            var _pierBankCodeRow = C( 'div', ['PIER-row','PIER-mT-sm', 'PIER-font-xs']),
            _pierBankCodeInput = C( 'input', 'PIER-code-input' );
            _pierBankCodeInput.setAttrs({'placeholder':'借记卡验证码'});
            _pierBankCodeBtn = C( 'button', ['PIER-font-xs', 'PIER-code-label'] );
            _pierBankCodeBtn.html( pierConst.sendCode );
            _pierBankCodeRow.css({'height':'32px'});
            _pierBankCodeRow.appendChildren([_pierBankCodeInput, _pierBankCodeBtn]);

            var _pierBankErrorRow = C( 'div', ['PIER-row', 'PIER-error2',  'PIER-text-center']),
            _pierBankErrorMsg = C( 'p' );
            _pierBankErrorMsg.html('');
            _pierBankErrorRow.appendChild(_pierBankErrorMsg);

            var _pierBankPayRow = C( 'div', ['PIER-row', 'PIER-mT-sm' ,'PIER-mB-sm']),
            _pierBankPayBtn = C( 'button', 'PIER-submit-btn' );
            _pierBankPayBtn.html('支付');
            _pierBankPayRow.appendChild(_pierBankPayBtn);

            _pierLinkBankPanel.appendChildren([_pierBankNameRow, _pierBankIDRow, _pierBankCardRow, _pierBankPhoneRow, _pierCheckboxRow, _pierBankCodeRow, _pierBankErrorRow, _pierBankPayRow]);

            
            body.appendChildren([eroRow, row1, priceRow, orderInfoRow,  _pierLinkBankPanel ]);
            
            _pierCardPayContainer.appendChildren([regHead, body]);

            creditBtn.bind( 'click', function(){
                $$.switchPanel({
                    origin: _pierCardPayContainer,
                    target: _EPLoginContainer,
                    type: switchType.filp,
                    direction: 'fromBack'
                });
            })
            var cardPayAuth = {
                token: '',
                orderNo: ''
            }

            _pierBankCodeBtn.bind( 'click', function(){
                var name = _pierBankNameInput.val();
                var idNo = _pierBankIDInput.val();
                var cardNo = _pierBankCardInput.val();
                var phone = _pierBankPhoneInput.val();
                _pierBankErrorMsg.html('');
                var errorMsg = $$.notEmpty({ '姓名':name,'身份证号码': idNo, '借记卡号':cardNo, '预留手机号': phone });
                
                if( errorMsg !== '' ){
                    _pierBankErrorMsg.html( errorMsg );
                    return;
                }
                if( !_pierCheckbox.checked ){
                    _pierCheckbox.focus();
                    return;
                }
                if( _pierBankCodeBtn.html() === pierConst.sendCode || _pierBankCodeBtn.html() === pierConst.reSend ){
                    var _url = apiConfig.hostName + apiConfig.EP.prepay,
                    _message = {
                        user_id: _OPTIONS.user_id,
                        merchant_id: _OPTIONS.merchant_id,
                        no_order: _OPTIONS.order_id,
                        money_order: _OPTIONS.amount,
                        name_goods: _OPTIONS.order_desc,
                        dt_order: '20160108113511',
                        acct_name: name,
                        id_no: idNo,
                        card_no: cardNo,
                        bind_mob: phone,
                        notify_url: 'http://pierup.cn/notify_url',
                        sign_type: 'RSA',
                        api_key: _OPTIONS.api_key,
                    },
                    _this = _pierBankCodeBtn;

                    var tempBtnCont = _this.html();
                    _this.html(pierConst.btnLoading2);
                    $$.http( { url:_url, body:_message, noAuth: true}, function( data ){
                        _this.html(tempBtnCont);
                        console.log('get card pay code success', data);
                        cardPayAuth.token = data.token;
                        cardPayAuth.orderNo = data.no_order;
                        $$.timer(_this);
                    }, function( error ){
                        _pierBankErrorMsg.html( error.message );
                        console.log('get card pay code failed', error);
                    } ); 
                }
            });

            _pierBankPayBtn.bind( 'click', function(){
                var code = _pierBankCodeInput.val();
                _pierBankErrorMsg.html( $$.notEmpty({'短信验证码': code}) );
                if( _pierBankErrorMsg.html() !== '' ) return;
                if( cardPayAuth.orderNo === '' || cardPayAuth.token === '' ) return;

                var _url = apiConfig.hostName + apiConfig.EP.payByCard,
                _message = {
                    user_id: _OPTIONS.user_id,
                    no_order: cardPayAuth.orderNo,
                    money_order: _OPTIONS.amount,
                    token: cardPayAuth.token,
                    api_key: _OPTIONS.api_key,
                    verify_code: code,
                    merchant_id: _OPTIONS.merchant_id,
                },
                _this = _pierBankPayBtn;
                var tempBtnCont = _this.html();
                _this.html(pierConst.btnLoading);

                $$.http( { url:_url, body:_message, noAuth: true}, function( data ){
                    console.log('card make payment success', data);
                    $$.initPayRst();
                    $$.switchPanel({
                        origin: _pierCardPayContainer,
                        target: _payRstContainer,
                        type: switchType.rightInLeftOut
                    });
                    _EPLoginContainer.destory(10);
                }, function( error ){
                    _pierBankErrorMsg.html( error.message );
                    console.log('card make payment failed', error);
                    _this.html(tempBtnCont);
                } );                
            })
        },
        /**
         * @param callback send payment result to handler
         */
        initPay:function( options, callback ){
            var payMode = options.payMode;
            var bankInfo = options.bankInfo;
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var paymentWrap = C( 'div', 'PIER-set-pin'),
            splitLine = C( 'div', 'PIER-split-line'),
            bkInfoRow = C('div', ['PIER-row', 'PIER-mT-sm', 'PIER-font-xs']),
            bkInfoP = C('p');
            bkInfoP.html( '借记卡（'+bankInfo.name+'）绑定的手机号为：'+bankInfo.phone );
            bkInfoRow.appendChild(bkInfoP);

            var bkCodeRow = C('div', ['PIER-row', 'PIER-font-xs']);  
            bkCodeRow.setAttrs({'style':'height:38px;'});
            var bkCodeInput = C('input', 'PIER-code-input'); 
            bkCodeInput.setAttrs( {'placeholder':'借记卡验证码'} );
            var bkCodeBtn = C('button', ['PIER-font-xs', 'PIER-code-label']);
            bkCodeBtn.html( pierConst.sendCode );
            bkCodeRow.appendChildren([bkCodeInput, bkCodeBtn]);

            var payPinRow = C( 'div', ['PIER-row','PIER-font-xs','PIER-mT-xs']),
            payPinInput = C( 'input', ['PIER-comm-input','PIER-clear']);
            payPinInput.setAttrs( {'placeholder':'品而金融6位支付密码','type':'password', 'maxlength': '6'});
            payPinRow.appendChild(payPinInput);

            var paySubmitRow = C( 'div', ['PIER-row', 'PIER-mT-md']),
            payBtn = C( 'button', ['PIER-submit-btn']);
            payBtn.html( '确认并付款' );
            paySubmitRow.appendChild(payBtn);

            bkCodeBtn.bind( 'click', function(){
                var _url = apiConfig.hostName + apiConfig.getPaySMS;
                var _message = {
                    trans_id: bankInfo.trans_id
                };

                var _this = bkCodeBtn;
                var tempBtnCont = _this.html();
                _this.html(pierConst.btnLoading2);

                $$.http( { url:_url, body:_message }, function( data ){
                    _this.html(tempBtnCont);
                    $$.timer(_this);
                    console.log( 'get bank code success', data );

                }, function( error ){
                    console.log( 'get bank code failed', error );
                }) 
            });
            payBtn.bind( 'click', function(){
                var pin = $$.trim( payPinInput.val() );
                var code = $$.trim( bkCodeInput.val() );
                var url = '';
                var message = {};
                if( payMode === payType.credit ){
                    if( pin !== undefined && pin !== '' ){}
                }
                if( payMode === payType.bankCard ){
                    if( code !== undefined && code !== '' ){}
                }
                if( payMode === payType.mixed ){
                    if( pin !== undefined && pin !== '' && code !== undefined && code !== '' ){

                    }
                }
                callback.call(this, payresult = true);                
            })
            if( payMode === payType.credit ){
                paymentWrap.appendChildren( [splitLine, payPinRow, paySubmitRow] );
            }
            if( payMode === payType.bankCard ){
                paymentWrap.appendChildren( [splitLine, bkInfoRow, bkCodeRow, paySubmitRow] );
            }
            if( payMode === payType.mixed ){
                paymentWrap.appendChildren( [splitLine, bkInfoRow, bkCodeRow, payPinRow, paySubmitRow] );
            }
            return paymentWrap;
        },
        /**
         * @param payMode 0: credit only; 1:bank card only; 2 mixed;
         */
        initConfirm: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            _cfmContainer = C( 'div', 'PIER-payment-container');

            var cfmBody = C( 'div', ['PIER-payment-body', 'PIER-text-left']);

            var eroRow = C('div', ['PIER-row', 'PIER-error', 'PIER-text-center']);
            eroSpan = C('span', 'errorMsg' );
            eroRow.appendChild(eroSpan);
            var confirmHead = $$.initHeader({
                errorObj:eroSpan,
                logo: _OPTIONS.merchantLogo,
                wording: _OPTIONS.order_desc
            });
            
            var row1 = C('div', ['PIER-row', 'PIER-mT-xs']);
            row1.html( '<label>'+pierConst.pierCreditAmount+'</label>' );
            var row1Amount = C('span', ['PIER-right', 'PIER-money'] );
            
            row1.appendChild(row1Amount);

            var row2 = C('div', ['PIER-row', 'PIER-mT-xs']);
            row2.html( '<label>分期选项</label>' );
            var row2Select = C('select', ['PIER-right', 'PIER-instalment-select'] );
            var row2SelectOp0 = C('option');
            row2SelectOp0.html('不分期');
            row2SelectOp0.setAttrs({'value':'0'});
            row2Select.appendChild(row2SelectOp0);
            
            row2.appendChild(row2Select);

            var row3 = C('div', ['PIER-row', 'PIER-mT-xs', 'PIER-dot-line']);
            var row3Checkbox = C('input');
            row3Checkbox.setAttrs( {'type':'checkbox'});
            var row3Span1 = C('span', 'PIER-bottom-text');
            row3Span1.html( pierConst.agreeAndRead );
            var row3Span2 = C('span', 'PIER-color');
            row3Span2.html( pierConst.baomixieyi );
            row3Span1.appendChild(row3Span2);
            row3.appendChild(row3Checkbox);
            row3.appendChild(row3Span1);

            var row4 = C('div', ['PIER-row', 'PIER-mT-sm', 'PIER-dot-line']);
            var row4Select = C('select', 'PIER-bankcard-select');
            
            row4.appendChild(row4Select);
            var row4Amount = C('span', ['PIER-right', 'PIER-money']);
            row4.appendChild(row4Amount);

            var row5 = C('div', ['PIER-row', 'PIER-mT-sm']);
            row5.html( '<label>商品总价</label>' );
            var row5Span = C('span', ['PIER-right', 'PIER-money']);
            
            row5.appendChild(row5Span);

            var row6 = C('div', ['PIER-row']); 
            row6.setAttrs({ 'style': 'height:60px;'});
            var row6Span1 = C('div', ['PIER-right', 'PIER-font-sm']); 
            row6Span1.html( '美元共计：￥812.33' );
            var row6Span2 = C('div', ['PIER-right','PIER-font-xs','PIER-color-gray','PIER-mT-xs']); 
            row6Span2.html( '中国银行上海分行：2015-12-18 10:15' );
            var row6Span3 = C('div', ['PIER-right','PIER-font-xs','PIER-color-gray']); 
            var row6Br = C('br'); 
            row6Span3.html( '汇率：1USD = 6.47RMB' );
            row6.appendChildren([ row6Span2, row6Br, row6Span3]);

            var submitRow = C( 'div', ['PIER-row', 'PIER-mT-md']);
            var submitBtn = C( 'button', ['PIER-submit-btn']);
            submitBtn.html( '下一步' );
            submitRow.appendChild(submitBtn);

            var timerRow = C( 'div', ['PIER-row', 'PIER-mT-md']);
            var timerP = C( 'p', ['PIER-bottom-text', 'PIER-text-center']);
            timerP.html( '您可以在4分12秒内使用额度支付' );
            timerRow.appendChild(timerP);

            var loadingBody = $$.initLoadingBody();
            _cfmContainer.appendChildren([confirmHead, loadingBody]);

            var transactionId = '', tempPayMode = 1, totalAmount = 0, cards, split = '|';

            
            var saveOrder = function(){
                var _url = apiConfig.hostName + apiConfig.savePaymentOrder;
                var _message = {
                    merchant_id: _OPTIONS.merchant_id,
                    no_order: _OPTIONS.order_id,
                    money_order: _OPTIONS.amount,
                    name_goods: _OPTIONS.order_desc,
                    sign_type: _OPTIONS.sign_type,
                    api_key: _OPTIONS.api_key,
                    user_id: _OPTIONS.user_id,
                    dt_order: '20160108113511',
                    valid_order: _OPTIONS.available_time
                };
                $$.http( { url:_url, body:_message }, function( data ){
                    
                    console.log('user save order success', data);
                    if( !$$.isUndefined( data.payment_type ) ){
                        tempPayMode = data.payment_type;
                    }
                    setCfmBody(tempPayMode);
                    if( !$$.isUndefined( data.credit_amount ) ){
                        row1Amount.html( $$.filter( 'currency', parseFloat(data.credit_amount).toFixed(2), 'CNY' ) );
                        totalAmount += parseFloat(data.credit_amount);
                    }
                    if( !$$.isUndefined( data.card_amount ) ){
                        row4Amount.html( $$.filter( 'currency', parseFloat(data.card_amount).toFixed(2), 'CNY' ) );
                        totalAmount += parseFloat(data.card_amount);
                    }
                    transactionId = data.trans_id;
                    row5Span.html( $$.filter( 'currency', totalAmount.toFixed(2), 'CNY' ) );
                    var instal;
                    if( $$.isArray( data.iterms ) ){
                        instal = data.iterms;
                        for( var i = 0; i<instal.length; i++ ){
                            var tempOp = C('option');
                            tempOp.html( instal[i].term+'期(每期利率为'+instal[i].rate+'%)' );
                            tempOp.setAttrs({'value':instal[i].id});
                            row2Select.appendChild(tempOp);
                        }
                    }
                    
                    if( $$.isArray( data.cards ) ){
                        cards = data.cards;
                        for( var i = 0; i<cards.length; i++ ){
                            var tailNo = cards[i].card_no.split('*')[cards[i].card_no.split('*').length-1];
                            var tempOp = C('option');
                            tempOp.html('借记卡支付金额');
                            tempOp.setAttrs( { 'value': cards[i].card_id+ split + cards[i].bank_name+' 尾号'+tailNo +split+cards[i].bind_mob });
                            var tempOpSpan = C('span');
                            tempOpSpan.html( '（'+cards[i].bank_name+' 尾号'+tailNo+'）' );
                            tempOp.appendChild(tempOpSpan);
                            row4Select.appendChild(tempOp);
                        }
                    }
                    _cfmContainer.removeChild( loadingBody );
                    _cfmContainer.appendChild( cfmBody );
                    
                }, function( error ){
                    
                } );
            }();
            //append head and body
            //append body elem
            var setCfmBody = function( payMode ){
                if( payMode === payType.credit ){
                    cfmBody.appendChildren([eroRow, row1, row2, row3, row5, row6, submitRow, timerRow ]);
                }
                if( payMode === payType.bankCard ){
                    cfmBody.appendChildren([eroRow,  row4, row5, row6, submitRow, timerRow ]);
                }
                if( payMode === payType.mixed ){
                    cfmBody.appendChildren([eroRow, row1, row2, row3, row4, row5, row6, submitRow, timerRow ]);
                }
            };
            submitBtn.bind( 'click', function(){
                if( !row3Checkbox.checked ){
                    row3Checkbox.focus();
                    return;
                };
                var _cardId =  row4Select.val().split( split )[0];
                var _url = apiConfig.hostName + apiConfig.saveInstalmentAndCard;
                var _message = {
                    term_id: row2Select.val(),
                    card_id: _cardId,
                    trans_id: transactionId
                };
                eroSpan.html('');
                $$.http( { url:_url, body:_message }, function( data ){
                    console.log( 'save order installment and card success', data );
                    row2Select.setAttrs( {'disabled':'disabled'} );
                    row3Checkbox.setAttrs( {'disabled':'disabled'} );
                    row4Select.setAttrs( {'disabled':'disabled'} );
                    var payOpts = {
                        payMode: tempPayMode
                    };
                    if( tempPayMode === payType.bankCard || tempPayMode === payType.mixed ){
                        payOpts.bankInfo = {
                            name: row4Select.val().split( split )[1],
                            phone: row4Select.val().split( split )[2],
                            trans_id: transactionId
                        }
                    };
                    var payWrap = $$.initPay( payOpts, function(){
                        $$.initPayRst();
                        $$.switchPanel({
                            origin: _cfmContainer,
                            target: _payRstContainer,
                            type: switchType.rightInLeftOut
                        });
                    });
                    cfmBody.removeChild(submitRow );
                    cfmBody.removeChild(timerRow);
                    cfmBody.appendChildren([payWrap, timerRow]);
                }, function( error ){
                    console.log( 'save order installment and card success', error );
                    eroSpan.html(error.message);
                });
            } )
        },
        initPayRst:function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            _payRstContainer = C( 'div', 'PIER-payresult-container');
            //pay result container header
            var payResultHead = $$.initHeader({
                payResult: true,
                logo: _OPTIONS.merchantLogo,
                wording: _OPTIONS.order_desc
            });
            //pay result container body
            var body = C( 'div', ['PIER-payresult-body', 'PIER-text-center']);
            var QRRow = C( 'div', ['PIER-row', 'PIER-mT-md']);
            var QRImage = C( 'img');
            QRImage.setAttrs({ 'src':'http://pierup.cn/images/getqrcode.jpg'});
            QRRow.appendChild(QRImage);

            var msgRow = C( 'div', ['PIER-row','PIER-mT-md']);
            msgRow.html( '<p class="PIER-color">支付成功!</p>' );

            var downloadRow = C( 'div', ['PIER-row','PIER-mT-md']);
            downloadRow.html( '<p>马上在各大市场下载品而金融APP，轻松提高和管理您的额度!</p>' );

            var returnRow = C( 'div', ['PIER-row','PIER-mT-md']);
            returnRow.html( '<p class="PIER-color-gray PIER-font-sm">正在返回商家……</p>' );

            body.appendChildren([QRRow, msgRow, downloadRow, returnRow] );
            _payRstContainer.appendChildren([payResultHead, body]);
            
        },
        initEPReg: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            _EPRegContainer = C( 'div', 'PIER-EPreg-container');
            //pay result container header
            var body = C( 'div', 'PIER-reg-body' );

            var eroRow = C('div', ['PIER-row', 'PIER-error', 'PIER-text-center']);
            eroSpan = C('span', 'errorMsg' );
            eroRow.appendChild(eroSpan);
            var regHead = $$.initHeader({
                errorObj: eroSpan,
                logo: pierConst.pierLogo,
                wording: '品而额度申请<span class="PIER-color">1/2</span>'
            });

            var row1 = C('div', ['PIER-row', 'PIER-text-center']);

            var row2 = C('div', ['PIER-row', 'PIER-mT-md']);
            phoneInput = C('input', 'PIER-comm-input' );
            phoneInput.setAttrs({'placeholder':'手机号','maxlength':'11'});
            phoneInput.bind( 'keyup', $$.digitalInputListener );
            row2.appendChild(phoneInput);

            var row3 = C( 'div', ['PIER-row','PIER-mT-sm']),
            codeInput = C( 'input', 'PIER-code-input' );
            codeInput.setAttrs({'placeholder':'短信验证码'});
            codeBtn = C( 'button', ['PIER-font-xs', 'PIER-code-label'] );
            codeBtn.html( pierConst.sendCode );
            row3.css({'height':'32px'});
            row3.appendChildren([codeInput, codeBtn]);

            var row4 = C('div', ['PIER-row', 'PIER-mT-sm']);
            nameInput = C('input', 'PIER-comm-input' );
            nameInput.setAttrs({'placeholder':'真实姓名'});
            row4.appendChild(nameInput);

            var row5 = C('div', ['PIER-row', 'PIER-mT-sm']);
            idInput = C('input', 'PIER-comm-input' );
            idInput.setAttrs({'placeholder':'身份证', 'maxlength':18});
            idInput.bind( 'keyup', $$.idCardListener );
            row5.appendChild(idInput);

            var row6 = C('div', ['PIER-row', 'PIER-mT-xs']);
            var row6Checkbox = C('input');
            row6Checkbox.setAttrs({'type':'checkbox'});
            var row6Span = C('span', ['PIER-bottom-text']);
            row6Span.html( '同意<span class="PIER-color">《品而服务协议》</span>和<span class="PIER-color">《保密授权协议》</span>' );
            row6.appendChildren([row6Checkbox,row6Span]);

            var submitRow = C( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']);
            submitBtn = C( 'button', 'PIER-submit-btn' );
            submitBtn.html( pierConst.next );
            submitRow.appendChild(submitBtn);

            var goLoginRow = C( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-text-center']),
            bottomText = C( 'p', 'PIER-bottom-text');
            bottomText.html( '已经是品而用户了？' );
            var loginLink = C( 'a', ['PIER-color']);
            loginLink.html( '马上登录' );
            loginLink.setAttrs({'style':'cursor:pointer;'})
            bottomText.appendChild(loginLink);
            goLoginRow.appendChild(bottomText);
            
            body.appendChildren([eroRow, row1, row2, row3, row4, row5, row6, submitRow, goLoginRow ]);
            
            _EPRegContainer.appendChildren([regHead, body]);

            loginLink.bind( 'click', function(){
                $$.initEPLogin();
                _EPRegContainer.destory(10);
                _flipContainer.appendChild(_EPRegContainer);                
            })

            submitBtn.bind( 'click', function(){
                var phone = phoneInput.val();
                var username = nameInput.val();
                var idNumber = idInput.val();
                var code = codeInput.val();
                eroSpan.html( $$.notEmpty({'手机号':phone, '验证码': code, '姓名': username, '银行卡号': idNumber}) );

                if( eroSpan.html() !== '' ){
                    return;
                }
                if( !row6Checkbox.checked ){
                    row6Checkbox.focus();
                    return;
                }
                var _url = apiConfig.hostName + apiConfig.regUser,
                _message = { phone: phone, name: username, id_number: idNumber, activation_code: code },
                _this = submitBtn;
                
                var tempBtnCont = _this.html();
                _this.html(pierConst.btnLoading);
                $$.http( { url:_url, body:_message}, function( data ){
                    console.log('reg user success', data);
                    $$.setBasic({username:username, idCard: idNumber });
                    $$.setUser({user_id:data.user_id, session_token:data.session_token, status_bit:data.status_bit, name: username});
                    $$.initApply();
                    $$.switchPanel({
                        origin: _EPRegContainer,
                        target: _applyContainer,
                        type: switchType.rightInLeftOut
                    });
                }, function( error ){
                    _this.html(tempBtnCont);
                    eroSpan.html( error.message );
                } );                
            });

            codeBtn.bind( 'click', function(){
                var _ph = phoneInput.val();
                if( _ph.match(/\d{11,11}/) ){
                    if( codeBtn.html() === pierConst.sendCode || codeBtn.html() === pierConst.reSend ){
                        var _url = apiConfig.hostName + apiConfig.regCode,
                        _message = { phone: _ph },
                        _this = codeBtn;
                        eroSpan.html('');
                        var tempBtnCont = _this.html();
                        _this.html(pierConst.btnLoading2);
                        $$.http( { url:_url, body:_message}, function( data ){
                            _this.html(tempBtnCont);
                            console.log('get reg code success', data);
                            $$.timer(codeBtn);
                        }, function( error ){
                            _this.html(tempBtnCont);
                            eroSpan.html( error.message );
                            console.log('get reg code failed', error);
                        } );
                    }
                }                
            })
        },
        initUpdateInfo: function(){
            var callback = arguments[0];
            var errorMsg = arguments[1];
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var infoPanel = C( 'div', 'PIER-set-pin' );
            var basicInfo = $$.getBasic();

            var eroRow = C('div', ['PIER-row', 'PIER-error', 'PIER-text-center']),
            eroRowSpan = C('p');
            if( !errorMsg ){
                eroRowSpan.html('您的身份信息有误，请重新修改。');
            }else{
                eroRowSpan.html(errorMsg);
            }
            
            eroRow.appendChild(eroRowSpan);

            var nameLabelRow = C( 'div', ['PIER-row', 'PIER-mT-sm'] );
            var nameLabel = C( 'label' );
            nameLabel.html( '姓名：' );
            nameLabelRow.appendChild(nameLabel);

            var nameRow = C( 'div', ['PIER-row', 'PIER-mT-xs'] );
            var nameInput = C( 'input', 'PIER-comm-input' );
            nameInput.setAttrs({'placeholder': '请填写您的真实姓名'});
            nameInput.val(basicInfo.username);
            nameRow.appendChild(nameInput);

            var idLabelRow = C( 'div', ['PIER-row', 'PIER-mT-sm'] );
            var idLabel = C( 'label' );
            idLabel.html( '身份证：' );
            idLabelRow.appendChild(idLabel);

            var idRow = C( 'div', ['PIER-row', 'PIER-mT-xs'] );
            var idInput = C( 'input', 'PIER-comm-input' );
            idInput.setAttrs({'placeholder': '请填写您的真实身份证', 'maxlength': '18'});
            idInput.val(basicInfo.idCard);
            idInput.bind( 'keyup', $$.idCardListener );
            idRow.appendChild(idInput);

            var submitRow = C( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']);
            var submitBtn = C( 'button', ['PIER-submit-btn', 'PIER-color'] );
            submitBtn.html( '确认' );
            submitRow.appendChild(submitBtn);

            infoPanel.appendChildren([eroRow, nameLabelRow, nameRow, idLabelRow, idRow, submitRow]);

            submitRow.bind( 'click', function(){
                var _name = nameInput.val(), _id = idInput.val();
                eroRowSpan.html( $$.notEmpty({ '姓名': _name, '身份证号':_id }) );
                if( eroRowSpan.html() !== '' ){
                    return;
                }
                var _url = apiConfig.hostName + apiConfig.updateBasic;
                var _message = {
                    name: _name, 
                    id_number: _id
                }
                $$.http( { url:_url, body:_message}, function( data ){
                    console.log( 'update user basic info success', data );
                    $$.setUser({username: _name});
                    $$.setBasic({username:_name, idCard: _id });
                    callback.call( this, {
                        name: _name
                    })
                }, function( error ){
                    console.log( 'update user basic info failed', error );
                    if( error.code == '1169' ){
                        eroRow.addClass('PIER-h-auto');
                    }
                    eroRowSpan.html( error.message );
                });
            })
            return infoPanel;
        },
        initApply: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );

            var _userAuth = $$.getUser();
            _applyContainer = C( 'div', 'PIER-apply-container');
            //pay result container header
            var body = C( 'div', 'PIER-apply-body' );
            var bodyWrap = C( 'div' );

            var eroRow = C('div', ['PIER-row', 'PIER-error', 'PIER-text-center']),
            eroRowSpan = C('p');
            eroRow.appendChild(eroRowSpan);

            var applyHeader = $$.initHeader({
                errorObj: eroRowSpan,
                logo: pierConst.pierLogo,
                wording: '品而额度申请<span class="PIER-color">2/2</span>'
            });

            var cardOwnerRow = C( 'div', ['PIER-row', 'PIER-mT-sm'] );
            var cardOwnerLabel = C( 'label' );
            cardOwnerLabel.html( '持卡人：' );
            var cardOwnerName = C( 'span', 'PIER-right' );
            cardOwnerName.html( _userAuth.name || '' );
            cardOwnerRow.appendChildren([cardOwnerLabel,cardOwnerName]);

            var cardRow = C( 'div', ['PIER-row', 'PIER-mT-xs'] );
            var cardInput = C( 'input', 'PIER-comm-input' );
            cardInput.setAttrs({'placeholder': '借记卡卡号'});
            cardRow.appendChild(cardInput);

            var cardTypeRow = C( 'div', ['PIER-row', 'PIER-mT-sm'] );
            var cardTypeLabel = C( 'label' );
            cardTypeLabel.html( '卡类型：' );
            var cardTypeName = C( 'span', 'PIER-right' );
            cardTypeName.html( '中国银行' );
            cardTypeRow.appendChildren([cardTypeLabel,cardTypeName]);

            var cardPhoneRow = C( 'div', ['PIER-row', 'PIER-mT-xs'] );
            var cardPhoneInput = C( 'input', 'PIER-comm-input' );
            cardPhoneInput.setAttrs({'placeholder': '银行预留手机号'});
            cardPhoneInput.bind( 'keyup', $$.digitalInputListener );
            cardPhoneRow.appendChild(cardPhoneInput);

            var agreetRow = C( 'div', ['PIER-row', 'PIER-mT-xs'] );
            var agreetCheck = C( 'input' );
            agreetCheck.setAttrs({'type':'checkbox'});
            var agreetSpan = C( 'span', 'PIER-bottom-text' );
            agreetSpan.html( '同意<span class="PIER-color">《品而服务协议》</span>和<span class="PIER-color">《保密授权协议》</span>');
            agreetRow.appendChildren([agreetCheck,agreetSpan]);

            var codeRow = C( 'div', ['PIER-row', 'PIER-mT-sm'] );
            codeRow.css({'height':'32px'});
            var codeInput = C( 'input', 'PIER-code-input' );
            codeInput.setAttrs({'placeholder': '短信验证码'});
            var codeBtn = C( 'button', ['PIER-font-xs', 'PIER-code-label'] );
            codeBtn.html( pierConst.sendCode );
            codeRow.appendChildren([codeInput, codeBtn]);

            var submitRow = C( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']);
            var submitBtn = C( 'button', ['PIER-submit-btn', 'PIER-color'] );
            submitBtn.html( '确认' );
            submitRow.appendChild(submitBtn);

            var cardToken = '';
            var cardId = ''
            
            codeBtn.bind( 'click', function(){
                var cardNum = cardInput.val();
                var cardPhone = cardPhoneInput.val();
                eroRowSpan.html( $$.notEmpty({'银行卡号': cardNum, '预留手机号': cardPhone }) );
                if( eroRowSpan.html() !== '' ){
                    return;
                }
                if( !agreetCheck.checked ){
                    agreetCheck.focus();
                    return;
                }
                var _url = apiConfig.hostName + apiConfig.bindCard,
                _message = { 
                    card_no: cardNum, 
                    bind_mob: cardPhone
                },
                _this = codeBtn;
                var tempBtnCont = _this.html();
                _this.html(pierConst.btnLoading2);
                $$.http( { url:_url, body:_message}, function( data ){
                    console.log('bind card success', data);
                    _this.html(tempBtnCont);
                    cardToken = data.token;
                    cardId = data.card_id;
                    $$.timer(codeBtn);
                }, function( error ){
                    console.log('bind card failed', error);
                    _this.html(tempBtnCont);
                    if( error.code === '1004' || error.code === '1113' ){
                        var erorTemp;
                        if( error.code === '1113' ){
                            erorTemp = error.message;
                        }
                        var updatePanel = $$.initUpdateInfo(function(data){
                            console.log('data',data);
                            cardOwnerName.html( data.name );
                            body.removeChild(updatePanel);
                            body.appendChild(bodyWrap);
                        }, erorTemp);
                        body.removeChild(bodyWrap);
                        body.appendChild(updatePanel);
                    }else{
                        eroRowSpan.html( error.message );
                    }
                } );                
            });
            submitBtn.bind( 'click', function(){
                var code = codeInput.val();
                var pinToken = '';
                var errorMsg = '';
                eroRowSpan.html( $$.notEmpty({'短信验证码': code}) );
                if( eroRowSpan.html() !== '' ){
                    return;
                }
                if( cardToken === '' || cardId === ''){
                    eroRowSpan.html( '请先填写正确的验证码' );
                    return;
                }
                var _url = apiConfig.hostName + apiConfig.verifyCard,
                _message = { 
                    token: cardToken, 
                    verify_code: code, 
                    bind_purpose: 2, 
                    card_id:cardId 
                },
                _this = submitBtn;

                var tempBtnCont = _this.html();
                _this.html(pierConst.btnLoading);
                $$.http( { url:_url, body:_message}, function( data ){
                    console.log('verify card success', data);
                    pinToken = data.token;
        
                    var pinPanel = $$.initPinSettingPanel(function( pwd ){
                        console.log( 'pin code ', pwd );
                        var pinUrl = apiConfig.hostName + apiConfig.setPin;
                        var message = {
                            new_payment_password: pwd,
                            payment_password_token: pinToken,
                        };
                        $$.http( { url: pinUrl, body: message }, function(data){
                            console.log( 'set pin success', data );
                            $$.initApplyRst();
                            $$.switchPanel({
                                origin: _applyContainer,
                                target: _applyRstContainer,
                                type: switchType.rightInLeftOut
                            });
                        }, function( error ){
                            console.log('set pin failed', error);
                            eroRowSpan.html( error.message );
                        } )
                    });
                    submitBtn.parentNode.removeChild(submitBtn);
                    body.appendChild(  pinPanel );
                }, function( error ){
                    _this.html(tempBtnCont);
                    console.log('verify card failed', error);
                    eroRowSpan.html( error.message );
                } );                
            });
            //set apply body 
            bodyWrap.appendChildren([eroRow, cardOwnerRow,cardRow, cardTypeRow, cardPhoneRow, agreetRow, codeRow, submitRow ]);
            body.appendChild(bodyWrap);
            _applyContainer.appendChildren( [applyHeader, body ]);
        },
        initApplyRst:function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            // _applyContainer, 
            _applyRstContainer = C( 'div', 'PIER-applyresult-container');
            var header = $$.initHeader({
                payResult:true,
                logo: pierConst.pierLogo,
                wording: '品而付额度申请'
            });
            var body = C( 'div', ['PIER-applyresult-body', 'PIER-text-center']);
            var loadingBody = $$.initLoadingBody();
            _applyRstContainer.appendChildren([header, loadingBody]);

            var applyCredit = function(){
                var _url = apiConfig.hostName + apiConfig.applyCredit;
                var _message = { 
                    merchant_id: _OPTIONS.merchant_id
                };
                $$.http( { url:_url, body:_message }, function( data ){
                    var creditLimit = data.credit_limit;
                    var iconRow = C( 'div', ['PIER-row', 'PIER-mT-sm']);
                    iconRow.html('<img src="/images/approval.png">');
                    var textRow = C( 'div', ['PIER-row', 'PIER-font-sm']); 
                    textRow.html('<p>申请成功!</p><p style="margin-top:-10px;">您的初步信用额度为：</p>');
                    var creditRow = C( 'div', ['PIER-row', 'PIER-mT-sm']),
                    credit = C( 'span', ['PIER-money', 'PIER-font-lg']);
                    credit.html( $$.filter( 'currency', creditLimit, 'CNY' ) );
                    creditRow.appendChild(credit);
                    var text2Row = C( 'div', 'PIER-row'); 
                    text2Row.html( '<p class="PIER-font-xs PIER-color-gray">新用户注册专用金额，仅限于此次消费</p>' );
                    var resultRow = C( 'div', ['PIER-row','PIER-mT-sm']),
                    resultBtn = C( 'button', ['PIER-submit-btn', 'PIER-color']),
                    bottomText = C( 'p', 'PIER-font-xs');
                    resultBtn.html( '使用额度付款' );
                    bottomText.html( '*若订单金额超出信用额度，不足部分可以用借记卡支付' );
                    resultRow.appendChildren([resultBtn, bottomText]);
                    body.appendChildren([iconRow, textRow, creditRow, text2Row, resultRow ]);
                    _applyRstContainer.removeChild( loadingBody ); 
                    _applyRstContainer.appendChild( body ); 
                    resultBtn.bind( 'click', function(){
                        $$.initConfirm();
                        $$.switchPanel({
                            origin: _applyRstContainer,
                            target: _cfmContainer,
                            type: switchType.rightInLeftOut
                        });                        
                    })
                
                }, function( error ){
                    var errorMsg = error.message;
                    var iconRow = C( 'div', ['PIER-row', 'PIER-mT-sm']);
                    iconRow.html( '<img src="/images/approval.png">' );
                    var textRow = C( 'div', ['PIER-row', 'PIER-font-sm']); 
                    textRow.html( '<p>'+errorMsg+'</p>' );
                    var resultTable = C( 'table', 'PIER-font-sm');
                    resultTable.css({'margin':'0 auto'});
                    resultTable.html( '<tr><td>您仍可以使用</td><td><img src="/images/tab-union.png" style="width:40px;height:40px;" /></td><td>借记卡完成支付</td></tr>' );
                    var resultRow = C( 'div', ['PIER-row','PIER-mT-md', 'PIER-mB-md']),
                    resultBtn = C( 'button', ['PIER-submit-btn', 'PIER-color']);
                    resultBtn.html( '去支付' );
                    resultRow.appendChild(resultBtn);
                    body.appendChildren([ iconRow, textRow, resultTable, resultRow ]);
                    _applyRstContainer.removeChild( loadingBody ); 
                    _applyRstContainer.appendChild( body );

                    resultBtn.bind( 'click', function(){
                        $$.initConfirm();
                        $$.switchPanel({
                            origin: _applyRstContainer,
                            target: _cfmContainer,
                            type: switchType.rightInLeftOut
                        });                        
                    })
                } );
            }();
        },
        http: function(){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var _userAuth = $$.getUser();
            var _xhr = null;
            var _apiOpts = arguments[0];
            var _successCallback = arguments[1];
            var _failedCallback = arguments[2];
            if( !_apiOpts.noAuth ){
                _apiOpts.body.session_token = _userAuth.session_token;
                _apiOpts.body.user_id = _userAuth.user_id;
            }
            if ( win.XMLHttpRequest ) {
                _xhr = new XMLHttpRequest();
            } else if ( win.ActiveXObject ) {
                _xhr = new ActiveXObject( 'Microsoft.XMLHTTP' );
            } else {
                throw new Error( BROWSER_NOT_SUPPORT );
                return;
            }
            _xhr.open( 'POST', _apiOpts.url, true );

            _xhr.setRequestHeader( 'Content-type', 'application/json' );
            _xhr.onreadystatechange = function(){
                if (_xhr.readyState == 4 ) {
                    var _data = JSON.parse( _xhr.response );
                    if( _data.code == '200' ){
                        _successCallback.call( this, _data.result );
                        if( _data.result.session_token !== '' || _data.result.session_token !== undefined ){
                            $$.setUser({session_token: _data.result.session_token });
                        }
                        if( _data.result.status_bit !== '' || _data.result.status_bit !== undefined ){
                            $$.setUser({status_bit: _data.result.status_bit });
                        }
                    }else{
                        console.error( 'error', _data );
                        _failedCallback.call( this, _data ); 
                    }
                }
            }
            _xhr.send( JSON.stringify( _apiOpts.body ) );           
        },
        loadingSDK: function( pierBtn ){
            var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
            var __pierPayBtn = $$.initPierBtn(pierBtn);
            __pierPayBtn.bind( 'click', function(){
                _pierOverlay = C( 'div','PIER-overlay' );
                _flipWrap = C( 'div','PIER-flip-wrap' );
                _flipContainer = C('div', ['PIER-flip-container', 'PIER-animated', 'PIERbounceInTop']);
                $$.initEPLogin();
                doc.body.appendChild(_pierOverlay );
                doc.body.appendChild( _flipWrap );                
            })
        }
    },  PIER = this.PIER = {
        version: '0.1.0',
    };
    PIER.initSDK = function(){
        var $$ = defaultUtils, C = $$.extend( $$.createElem, $$ );
        $$.init();
        _OPTIONS = $$.setConfig( arguments[0], defaultSettings );
        _callback = arguments[1];
        var _pierScriptBtn = doc.querySelector("script[class='pier-button']");
        $$.loadingSDK(_pierScriptBtn);
    };
})( window, document );
