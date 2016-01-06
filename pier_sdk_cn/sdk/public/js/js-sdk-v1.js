/**
 * 品而中国版支付SDK
 * @param  {[type]} global  [description]
 * @param  {[type]} factory [description]
 * @return PIER    PIER对象，用于支付的实例对象
 * @author Flower
 * @date
 */
(function( window ){
    //for stylesheet 
    var styleSheet, styleElem, _OPTIONS, _callback;
    var _pierPayBtn, _pierOverlay, _pierFlipWrap, _pierFlipContainer, _pierLoginContainer, _pierLoginHead, _pierLoginHeadTable, _pierLoginHeadTableTr, _pierLoginHeadTableTrTd, _pierLoginClose, _pierLoginHeadTableTr;
    var _pierPayContainer, 
    _pierPayHead, 
    _pierPayHeadTable, 
    _pierPayHeadTableTr, 
    _pierPayHeadTableTrTd, 
    _pierPayClose, 
    _pierPayBody, 
    _pierPayErrorRow, 
    _pierPayErrorSpan, 
    _pierPayCreditRow, 
    _pierPayCreditRowAmount, 
    _pierPayInstalmentRow, 
    _pierPayInstalmentRowSelect, 
    _pierPayInstalmentRowOp0, 
    _pierPayInstalmentRowOp1, 
    _pierPayInstalmentRowOp2, 
    _pierPayBankRowAmount, 
    _pierPayAgreementRow,
    _pierPayAgreementRowInput,
    _pierPayAgreementRowSpan,
    _pierPayAgreementRowSpan2,
    _pierPayTotalRow,
    _pierPayTotalRowSpan,
    _pierPayExchangeRow,
    _pierPayExchangeRowSpan1,
    _pierPayExchangeRowSpan2,
    _pierPayExchangeRowSpan3,
    _pierPayExchangeRowBr,
    _pierPayBankInfoRow,
    _pierPayBankInfoRowP,
    _pierPayValidCodeRow,
    _pierPayValidCodeInput,
    _pierPayValidBtn,
    _pierPayPinRow,
    _pierPayPinInput,
    _pierPaySubmitRow,
    _pierPaySubmitBtn,
    _pierPayTimerRow,
    _pierPayTimerP;
    var _pierLoginSwitchRow, _pierLoginUseCreditBtn, _pierLoginApplyCreditBtn;

    var _pierPayResultContainer,
    _pierPayResultHead,
    _pierPayResultHeadTable,
    _pierPayResultHeadTableTr,
    _pierPayResultHeadTableTrTd,
    _pierPayResultClose,
    _pierPayResultBody,
    _pierPayResultQRRow,
    _pierPayResultQRImage,
    _pierPayResultMsgRow,
    _pierPayResultDownRow,
    _pierPayResultReturnRow;

    var _pierRegContainer,
    _pierRegHead,
    _pierRegHeadTable,
    _pierRegHeadTableTr,
    _pierRegHeadTableTrTd,
    _pierRegClose,
    _pierRegBody,
    _pierRegErrorRow,
    _pierRegErrorSpan,
    _pierRegSwitchRow,
    _pierRegUseCreditBtn,
    _pierRegApplyCreditBtn,
    _pierRegPhoneRow,
    _pierRegPhoneInput,
    _pierRegCodeRow,
    _pierRegCodeInput,
    _pierRegCodeBtn,
    _pierRegNameInput,
    _pierRegNameRow,
    _pierRegIDInput,
    _pierRegIDRow,
    _pierRegAgreetmentRow,
    _pierRegAgreetmentInput,
    _pierRegAgreetmentSpan,
    _pierRegBtnRow,
    _pierRegBtnNext;

    var _pierApplyContainer;

    var defaultSettings = {
        env: 'dev', //default 'dev' for testing, if 'pro',it will be production mode.
        totalAmount: 0, //the total amount to be paid, default 0
        currency: 'CNY', //default 'cny',
        payButtonId: '',
        merchantLogo: '',
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
            emptyPayBtn: '未指定支付按钮的ID'
        }
    }()),  defaultUtils = {
        init: function(){
            styleElem = document.createElement( 'style' );//init style sheet for pier layout
            document.head.appendChild( styleElem );//add pier stylesheet to head
            styleSheet = styleElem.sheet;
            if( !styleSheet.addRule ){//for firefox not support function 'addRule', instead of insertRule.
                styleSheet.addRule = function( selector, style ){
                    var index = styleSheet.cssRules.length; 
                    styleSheet.insertRule( selector+'{'+style+'}', index );
                }
            }; 
            
            styleSheet.addRule( '.pier-payment-btn', 'width:120px;height:32px;border:1px solid #ccc; cursor:pointer; overflow: hidden;' );
            styleSheet.addRule( '.pier-payment-btn:hover', 'width:120px;height:32px;border:1px solid #7b37a6; cursor:pointer;' );
            /***payment layout***/
            styleSheet.addRule( '.PIER-flip-container, .PIER-overlay, .PIER-flip-container *', '-moz-box-sizing:border-box;-webkit-box-sizing:border-box;-ms-box-sizing:border-box;-o-box-sizing:border-box;box-sizing:border-box;')
            styleSheet.addRule( '.PIER-overlay', "overflow:scroll;position:fixed;left:0;top:0;width:100%;height:100%;z-index:100;background:#000;/*visibility:hidden;*/opacity:0.4;font-family: 'Microsoft YaHei', Arial, SimHei;")
            styleSheet.addRule( '.PIER-panel-head, .PIER-overlay img, .PIER-overlay table, .PIER-overlay table td, .PIER-login-body, .PIER-comm-input, .PIER-payment-body', 'margin:0px;height: 0px;');
            styleSheet.addRule( '.PIER-flip-wrap', 'overflow:scroll;position:fixed;left:0;top:0;width:100%;height:100%;z-index:888;');
            styleSheet.addRule( '.PIER-flip-container', '-webkit-perspective:1000;-moz-perspective:1000;-ms-perspective:1000;perspective:1000;-webkit-transform:perspective(1000px);-ms-transform:perspective(1000px);-moz-transform:perspective(1000px);transform:perspective(1000px);-webkit-transform-style:preserve-3d;-moz-transform-style:preserve-3d;-ms-transform-style:preserve-3d;transform-style:preserve-3d;margin:0 auto;margin-top:10%;width:460px;height:auto;');
            styleSheet.addRule( '.PIER-reg-container-back', '-webkit-transform:rotateY(0)!important;-moz-transform:rotateY(0)!important;-o-transform:rotateY(0)!important;-ms-transform:rotateY(0)!important;transform:rotateY(0)!important;opacity:1!important;z-index:10;');
            styleSheet.addRule( '.PIER-login-container-back', '-webkit-transform:rotateY(180deg)!important;-moz-transform:rotateY(180deg)!important;-o-transform:rotateY(180deg)!important;-ms-transform:rotateY(180deg)!important;transform:rotateY(180deg)!important;opacity:0;');
            styleSheet.addRule( '.PIER-login-container, .PIER-reg-container', '-webkit-backface-visibility:hidden;-moz-backface-visibility:hidden;-ms-backface-visibility:hidden;-o-backface-visibility:hidden;backface-visibility:hidden;-webkit-transition:.6s;-webkit-transform-style:preserve-3d;-moz-transition:.6s;-moz-transform-style:preserve-3d;-o-transition:.6s;-o-transform-style:preserve-3d;-ms-transition:.6s;-ms-transform-style:preserve-3d;transition:.6s;transform-style:preserve-3d;position:absolute;top:0;left:0');
            styleSheet.addRule( '.PIER-login-container', '-webkit-transform:rotateY(0);-moz-transform:rotateY(0);-ms-transform:rotateY(0);-o-transform:rotateY(0);transform:rotateY(0);z-index:2;width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;');
            

            styleSheet.addRule( '.PIER-payment-container, .PIER-apply-container', '-webkit-transform:rotateY(0);-ms-transform:rotateY(0);width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;z-index:2;display:none;');
            styleSheet.addRule( '.PIER-payresult-container', '-webkit-transform:rotateY(0);-ms-transform:rotateY(0);width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#fff;z-index:4;display:none;');
            styleSheet.addRule( '.PIER-reg-container', '-webkit-transform:rotateY(-180deg);-moz-transform:rotateY(-180deg);-o-transform:rotateY(-180deg);-ms-transform:rotateY(-180deg);transform:rotateY(-180deg);width:460px;height:auto;-moz-border-radius:6px;-webkit-border-radius:6px;-ms-border-radius:6px;-o-border-radius:6px;border-radius:6px;-moz-box-shadow:0 0 2px #a0a0a0;-webkit-box-shadow:0 0 2px #a0a0a0;-ms-box-shadow:0 0 2px #a0a0a0;-o-box-shadow:0 0 2px #a0a0a0;box-shadow:0 0 2px #a0a0a0;background:#f5f5f5;opacity:0;');
            
            styleSheet.addRule( '.PIER-payresult-body', 'padding-bottom: 40px;');
            styleSheet.addRule( '.PIER-payresult-body img', 'width: 90px;height: 90px;');
            
            styleSheet.addRule( '.PIER-panel-head', 'text-align:center;width:100%;height:80px;border-top-right-radius:6px;border-top-left-radius:6px;filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(235,235,237)");-ms-filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(235,235,237)");background-image:-moz-linear-gradient(top,#f5f5f5,#ebebed);background-image:-ms-linear-gradient(top,#f5f5f5,#ebebed);background-image:-o-linear-gradient(top,#f5f5f5,#ebebed);background-image:-webkit-gradient(linear,center top,center bottom,from(#f5f5f5),to(#ebebed));background-image:-webkit-linear-gradient(top,#f5f5f5,#ebebed);background-image:linear-gradient(top,#f5f5f5,#ebebed);-moz-background-clip:padding;-webkit-background-clip:padding-box;background-clip:padding-box;border-bottom:0;border-bottom:1px solid silver;background:url(/images/top-bg.png) repeat-x;');
            styleSheet.addRule( '.PIER-panel-head table', 'width: 100%;height: 75px;');
            styleSheet.addRule( '.PIER-panel-head table tr td:first-child', 'width:20%;');
            styleSheet.addRule( '.PIER-panel-head table tr td:nth-child(2) img', 'height: 56px;width: 56px;border:2px solid #fff;border-radius: 28px;');
            styleSheet.addRule( '.PIER-panel-head table tr td:nth-child(2) div', 'height:58px;width:58px;border:1px solid #c8c8c8;margin-top:-32px;border-radius:30px;display:inline-block;' );
            styleSheet.addRule( '.PIER-panel-head table tr td:nth-child(2) h4', 'font-size: 16px;margin-top: -2px;letter-spacing: 2px;font-weight: lighter;');
            styleSheet.addRule( '.PIER-panel-head table tr td:nth-child(3)', 'width: 20%;');
            styleSheet.addRule( '.PIER-panel-head table tr td:nth-child(3) img', 'width:20px;height:20px;border-radius: 10px;border: 1px solid rgb(200,200,200);margin: 2px;');
            styleSheet.addRule( '.PIER-close', "height:22px;width:22px;float:right;margin-top:-24px;margin-right:4px;cursor:pointer;background-size:100% 100%;background-image: url('data:image/png;base64,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');");
            styleSheet.addRule( '.PIER-login-body', 'height: 230px;width: 100%;border-top:1px solid #f5f5f5;');
            styleSheet.addRule( '.PIER-reg-body', 'height: 346px;width: 100%;border-top:1px solid #f5f5f5;');
            styleSheet.addRule( '.PIER-apply-body','height: auto;width: 100%;padding-bottom: 20px;');

            styleSheet.addRule( '.PIER-payment-body', 'height: auto;width: 100%;padding-bottom: 40px;');
            
            styleSheet.addRule( '.PIER-payment-body label', 'font-size: 14px;');
            styleSheet.addRule( '.PIER-right', 'float: right;');
            styleSheet.addRule( '.PIER-row', 'width: 262px;margin: 0 auto;');
            styleSheet.addRule( '.PIER-comm-input', 'width:260px;height:30px;outline:0;border-radius:4px;border:1px solid #dcdcdc;padding-left:6px;');
            styleSheet.addRule( '.PIER-code-input', 'width:173px;height:30px;padding-left:6px;outline:0;border:1px solid #dcdcdc;border-top-left-radius:4px;border-bottom-left-radius:4px;float:left;display:block!important');
            styleSheet.addRule( '.PIER-code-label', 'font-size:12px!important;background:#b4b4b4;color:#fff;height:30px;border-top-right-radius:4px;border-bottom-right-radius:4px;padding-left:8px;padding-right:8px;padding-top:6px;padding-bottom:2px;margin-left:-4px;float:left;cursor:pointer;width:89px;');
            styleSheet.addRule( '.PIER-clear', 'clear: both;');
            styleSheet.addRule( '.PIER-switch-btn', 'background:#fff;color:#7b37a6;border:1px solid #ccc;outline:0;width:90px;height:28px;display:inline-block;cursor:pointer;font-size:14px;');
            styleSheet.addRule( '.PIER-switch-btn.active', 'background: #7b37a6;color: #fff;');
            styleSheet.addRule( '.PIER-switch-btn.left-btn', 'border-top-left-radius: 4px;border-bottom-left-radius: 4px;border-right: 0px;');
            styleSheet.addRule( '.PIER-switch-btn.right-btn', 'border-top-right-radius: 4px;border-bottom-right-radius: 4px;border-left: 0px;');
            styleSheet.addRule( '.PIER-bank-body', 'height:auto;width:100%;background:#fff;border-bottom-left-radius:6px;border-bottom-right-radius:6px;');
            styleSheet.addRule( '.PIER-bank-body table', 'margin: 0 auto;height: 80px;');
            styleSheet.addRule( '.PIER-bank-body table img', 'width: 40px;height: 40px;line-height: 80px;');
            styleSheet.addRule( '.PIER-link-bank-panel', 'width:100%;transition:height .5s;-moz-transition:height .5s;-webkit-transition:height .5s;-o-transition:height .5s;height:0;overflow:hidden;');


            styleSheet.addRule( '.PIER-instalment-select', 'width: 158px;border-radius: 4px;height: 26px;outline: none;border: 1px solid rgb(220,220,220);');
            styleSheet.addRule( '.PIER-bankcard-select', 'width: 178px;border-radius: 4px;height: 26px;outline: none;border: 1px solid rgb(220,220,220);');
            styleSheet.addRule( '.PIER-bankcard-select span', 'font-size:10px;');
            styleSheet.addRule( '.PIER-mT-lg', 'margin-top: 55px;');
            styleSheet.addRule( '.PIER-mT-md', 'margin-top: 40px;');
            styleSheet.addRule( '.PIER-mT-sm', 'margin-top: 18px;');
            styleSheet.addRule( '.PIER-mT-xs', 'margin-top: 10px;');
            styleSheet.addRule( '.PIER-mB-sm', 'margin-bottom: 18px;');
            styleSheet.addRule( '.PIER-color', 'color: #7b37a6;');
            styleSheet.addRule( '.PIER-color-gray', 'color: rgb(200,200,200);');
            styleSheet.addRule( '.PIER-color-black', 'color:#000;');
            styleSheet.addRule( '.PIER-money', 'color: #f34949;');
            styleSheet.addRule( '.PIER-font-sm', 'font-size: 12px;');
            styleSheet.addRule( '.PIER-font-xs', 'font-size: 10px;');
            styleSheet.addRule( '.PIER-text-center', 'text-align: center;');
            styleSheet.addRule( '.PIER-text-left', 'text-align: left !important;');

            styleSheet.addRule( '.PIER-submit-btn', 'width:132px;height:28px;border-radius:4px;border:1px solid #dcdcdc;filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(255,255,255)", endColorstr = "rgb(225,225,225)");-ms-filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(255,255,255)", endColorstr = "rgb(225,225,225)");background-image:-moz-linear-gradient(top,#fff,#e1e1e1);background-image:-ms-linear-gradient(top,#fff,#e1e1e1);background-image:-o-linear-gradient(top,#fff,#e1e1e1);background-image:-webkit-gradient(linear,center top,center bottom,from(#fff),to(#e1e1e1));background-image:-webkit-linear-gradient(top,#fff,#e1e1e1);background-image:linear-gradient(top,#fff,#e1e1e1);-moz-background-clip:padding;-webkit-background-clip:padding-box;background-clip:padding-box;outline:0;cursor:pointer;display:block;margin:0 auto;');
            styleSheet.addRule( '.PIER-submit-btn:active', 'filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(215,215,215)");-ms-filter:progid: DXImageTransform.Microsoft.gradient(startColorstr = "rgb(245,245,245)", endColorstr = "rgb(215,215,215)");background-image:-moz-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:-ms-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:-o-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:-webkit-gradient(linear,center top,center bottom,from(#fff),to(#d7d7d7));background-image:gradient(linear,center top,center bottom,from(#fff),to(#d7d7d7));background-image:-webkit-linear-gradient(top,#f5f5f5,#d7d7d7);background-image:linear-gradient(top,#f5f5f5,#d7d7d7);');
            
            styleSheet.addRule( '.PIER-bottom-text', 'font-size: 12px !important;');
            styleSheet.addRule( '.PIER-forward-reg:hover, .PIER-forward-login:hover', 'cursor: pointer;text-decoration: underline;');
            styleSheet.addRule( '.PIER-dot-line', 'padding-bottom: 15px;border-bottom: 1px dotted #ccc;');
            styleSheet.addRule( '.PIER-display-block', 'display: block !important;');
            styleSheet.addRule( '.PIER-animated', '-webkit-animation-duration:1s;-moz-animation-duration:1s;-o-animation-duration:1s;animation-duration:1s;-webkit-animation-fill-mode:both;-moz-animation-fill-mode:both; -o-animation-fill-mode:both;animation-fill-mode:both;');
            styleSheet.addRule( '.PIERbounceOutLeft', '-webkit-animation-name:PIERbounceOutLeft;-moz-animation-name:PIERbounceOutLeft;-o-animation-name:PIERbounceOutLeft;animation-name:PIERbounceOutLeft');
            styleSheet.addRule( '.PIERbounceInTop', '-webkit-animation-name:PIERbounceInTop;-moz-animation-name:PIERbounceInTop;-o-animation-name:PIERbounceInTop;animation-name:PIERbounceInTop')
            styleSheet.addRule( '.PIERbounceInRight', '-webkit-animation-name:PIERbounceInRight;-moz-animation-name:PIERbounceInRight;-o-animation-name:PIERbounceInRight;animation-name:PIERbounceInRight' );
            styleSheet.addRule( '.PIER-buzz-class', '-webkit-animation-name:PIER-buzz-out;-moz-animation-name:PIER-buzz-out;-o-animation-name:PIER-buzz-out;-ms-animation-name:PIER-buzz-out;animation-name:PIER-buzz-out;-webkit-animation-duration:.5s;-moz-animation-duration:.5s;-o-animation-duration:.5s;-ms-animation-duration:.5s;animation-duration:.5s;-webkit-animation-timing-function:linear;-moz-animation-timing-function:linear;-o-animation-timing-function:linear;-ms-animation-timing-function:linear;animation-timing-function:linear;-webkit-animation-iteration-count:1;-moz-animation-iteration-count:1;-o-animation-iteration-count:1;-ms-animation-iteration-count:1;animation-iteration-count:1' );
            styleSheet.addRule( '.PIER-error', 'font-size: 14px;color: #f34949;' );
            /**apply credit**/
            styleSheet.addRule( '.PIER-set-pin', 'width: 100%;height: auto;');
            styleSheet.addRule( '.PIER-apply-container  label', 'font-size: 14px !important; color: rgb(149,149,149);');
            styleSheet.addRule( '.PIER-apply-body .PIER-row>span', 'font-size: 14px ; color: #000;');
            styleSheet.addRule( '.PIER-split-line', 'border-bottom: 1px dotted #ccc;margin-top: 30px;margin-bottom: 30px;');

            if( isFirefox=navigator.userAgent.indexOf("Firefox") != -1 ){ 
                styleSheet.addRule( '@-moz-keyframes PIERbounceOutLeft', '0% {-moz-transform:translateX(0) }20% {opacity:1;-moz-transform:translateX(20px)}100% { opacity:0;-moz-transform:translateX(-2000px)}');
                styleSheet.addRule( '@-moz-keyframes PIERbounceInRight', '0% {opacity:0;-moz-transform:translateX(2000px) }60% {opacity:1;-moz-transform:translateX(-30px)} 80% {-moz-transform:translateX(10px)}100% {-moz-transform:translateX(0)}' );
                styleSheet.addRule( '@-moz-keyframes PIER-buzz-out', '10% {-moz-transform: translate(4.5px, 4px) rotate(-1deg); }20% {-moz-transform: translate(-2px, 3.5px) rotate(2deg); }30% {-moz-transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {-moz-transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {-moz-transform: translate(-4.5px, -4px) rotate(-1deg); }60% {-moz-transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {-moz-transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {-moz-transform: translate(-2px, 3.5px) rotate(2deg); }90% {-moz-transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {-moz-transform: translate(0, 0) rotate(0);  }' );
                styleSheet.addRule( '@-moz-keyframes PIERbounceInTop','0%{opacity:0;-moz-transform:translateY(-2000px)}60%{opacity:1;-moz-transform:translateY(30px)}80%{-moz-transform:translateY(-30px)}100%{-moz-transform:translateY(0)}');
            }
            if(  ( isChrome = navigator.userAgent.indexOf("Chrome") != -1 ) || (isSafari=navigator.userAgent.indexOf("Safari") != -1 ) ){
                styleSheet.addRule( '@-webkit-keyframes PIERbounceOutLeft', '0% {-webkit-transform:translateX(0)} 20% {opacity:1; -webkit-transform:translateX(20px)}100% {opacity:0;-webkit-transform:translateX(-2000px)}');
                styleSheet.addRule( '@-webkit-keyframes PIERbounceInRight', '0% {opacity:0;-webkit-transform:translateX(2000px)}60% {opacity:1;-webkit-transform:translateX(-30px) }80% {-webkit-transform:translateX(10px)}100% { -webkit-transform:translateX(0) }' );
                styleSheet.addRule( '@-webkit-keyframes PIER-buzz-out', '10% {-webkit-transform: translate(4.5px, 4px) rotate(-1deg); }20% {-webkit-transform: translate(-2px, 3.5px) rotate(2deg); }30% {-webkit-transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {-webkit-transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {-webkit-transform: translate(-4.5px, -4px) rotate(-1deg); }60% {-webkit-transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {-webkit-transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {-webkit-transform: translate(-2px, 3.5px) rotate(2deg); }90% {-webkit-transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {-webkit-transform: translate(0, 0) rotate(0);  }' );
                styleSheet.addRule( '@-webkit-keyframes PIERbounceInTop', '0%{opacity:0;-webkit-transform:translateY(-2000px)}60%{opacity:1;-webkit-transform:translateY(30px)}80%{-webkit-transform:translateY(-30px)}100%{-webkit-transform:translateY(0)}');
            }
            if( isIE = navigator.userAgent.indexOf("MSIE") != -1 ) {
                // styleSheet.addRule( '@keyframes PIERbounceOutLeft', '0% {transform:translateX(0) } 20% {opacity:1;  transform:translateX(20px) } 100% {opacity:0;transform:translateX(-2000px) }');
                // styleSheet.addRule( '@keyframes PIERbounceInRight', '0% {opacity:0;transform:translateX(2000px)}60% { opacity:1; transform:translateX(-30px) }80% { transform:translateX(10px) }100% {transform:translateX(0)}' );
                // styleSheet.addRule( 'PIER-buzz-out', '10% {transform: translate(4.5px, 4px) rotate(-1deg); }20% {transform: translate(-2px, 3.5px) rotate(2deg); }30% {transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {transform: translate(-4.5px, -4px) rotate(-1deg); }60% {transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {transform: translate(-2px, 3.5px) rotate(2deg); }90% {transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {transform: translate(0, 0) rotate(0);  }' );
                // styleSheet.addRule(  '@keyframes PIERbounceInTop', '0%{opacity:0;transform:translateY(-2000px)}60%{opacity:1;transform:translateY(30px)}80%{transform:translateY(-30px)}100%{transform:translateY(0)}');
            }
            if( isIE = navigator.userAgent.indexOf("Opera") != -1 ){
                styleSheet.addRule( '@-o-keyframes PIERbounceOutLeft', '0% { -o-transform:translateX(0)}20% {opacity:1;-o-transform:translateX(20px)}100% { opacity:0; -o-transform:translateX(-2000px)}');
                styleSheet.addRule( '@-o-keyframes PIERbounceInRight', '0% {opacity:0;-o-transform:translateX(2000px)}60% {opacity:1;-o-transform:translateX(-30px)}80% {-o-transform:translateX(10px)}100% {-o-transform:translateX(0)}' );
                styleSheet.addRule( '@-o-keyframes PIER-buzz-out', '10% {-o-transform: translate(4.5px, 4px) rotate(-1deg); }20% {-o-transform: translate(-2px, 3.5px) rotate(2deg); }30% {-o-transform: translate(-1.5px, -2.5px) rotate(1deg); }40% {-o-transform: translate(3.5px, -3.5px) rotate(-2deg); }50% {-o-transform: translate(-4.5px, -4px) rotate(-1deg); }60% {-o-transform: translate(3.5px, -3.5px) rotate(-2deg); }70% {-o-transform: translate(-1.5px, -2.5px) rotate(1deg); }80% {-o-transform: translate(-2px, 3.5px) rotate(2deg); }90% {-o-transform: translate(4.5px, 4px) rotate(-1deg); }0%, 100% {-o-transform: translate(0, 0) rotate(0);  }' );
                styleSheet.addRule( '@-o-keyframes PIERbounceInTop', '0%{opacity:0;-o-transform:translateY(-2000px)}60%{opacity:1;-o-transform:translateY(30px)}80%{-o-transform:translateY(-30px)}100%{-o-transform:translateY(0)}');

            }
            
        },
        setConfig: function( target, original ){
            if( typeof target === 'object' && typeof original === 'object' ){
                for(key in original){
                    if( !target.hasOwnProperty(key) ){
                        target[key] = original[key];
                    }
                }
                // target = Object.create(original)
                return target;
            }else{
                throw new Error( pierConst.paramError );
            }
        },
        notEmpty: function( input ){
            if( input === undefined || input === '' || input === null ) return false;
            else return true;
        },
        digitalInputListener: function( event ){
            
            var obj = event.srcElement ? event.srcElement : event.target;
            console.log('input',obj.value );
            var input = obj.value;
            if( typeof input === 'undefined' ) return;
            if( input.length > 0 ){
                // if( input.substr(input.length-1,1))
                console.log('input.substr(input.length-1,1)', input.substr(input.length-1,1));
            }
            

        },
        createElem: function( elem, classArray ){
            var _this = document.createElement( elem );
            _this.addClass = function( array ){
                if( typeof array == 'object' ){
                    for( var i in array ){
                        this.classList.add( array[i] );
                    }
                }
                if( typeof array == 'string' ){
                    this.classList.add( array );
                }
            };
            _this.removeClass = function( array ){
                if( typeof array == 'object' ){
                    for( var i in array ){
                        this.classList.remove( array[i] );
                    }
                }
                if( typeof array == 'string' ){
                    this.classList.remove( array );
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
            _this.css = function( _styles ){
                if( typeof _styles !== 'object' ) return;
                for( var i in _styles ){
                    _this.style[i] = _styles[i];
                }
                console.log( ' _this.style',  _this.style);
            }
            if( classArray != '' && classArray != undefined ){
                _this.addClass(classArray);
            }
            return _this;
        },
        destorySDK:function(){
            document.body.removeChild(_pierOverlay);
            document.body.removeChild(_pierFlipWrap);
        },
        initPierBtn: function( parentNode ){
            _pierPayBtn = defaultUtils.createElem( 'div', ['pier-payment-btn']);
            _pierPayBtn.innerHTML = '<img  src="http://pierup.cn/images/pierlogo38.png" style="width:24px;margin-top:4px;margin-left:10px;margin-right:6px;float:left;">'+
       '<div style="font-size:14px;margin-top:10px;margin-left:50px;">品而付</div>';
            if( parentNode ){
                parentNode.parentNode.appendChild(_pierPayBtn);
            }else{
                document.body.appendChild(_pierPayBtn);
            }
            
            return _pierPayBtn;
        },
        initBankCardContainer: function(){
            var _pierBankContainer = defaultUtils.createElem( 'div', 'PIER-bank-body');
            var _pierBankTable = defaultUtils.createElem( 'table' );
            var _pierBankTableTr = defaultUtils.createElem( 'tr' );
            var _pierBankTableTrTd = defaultUtils.createElem( 'td' );
            var _pierBankCheckbox = defaultUtils.createElem( 'input' );
            _pierBankCheckbox.setAttrs({'type':'checkbox','id':'useBankForPay'});
            var _pierBankCheckboxText = defaultUtils.createElem( 'span' );
            _pierBankCheckboxText.innerHTML = '或使用';
            _pierBankTableTrTd.appendChild(_pierBankCheckbox);
            _pierBankTableTrTd.appendChild(_pierBankCheckboxText);
            _pierBankTableTr.appendChild(_pierBankTableTrTd);

            var _pierBankTableTrTd2 = defaultUtils.createElem( 'td' );
            _pierBankTableTrTd2.innerHTML = '<img src="/images/tab-union.png"/>';
            var _pierBankTableTrTd3 = defaultUtils.createElem( 'td' );
            _pierBankTableTrTd3.innerHTML = '借记卡支付';

            _pierBankTableTr.appendChild(_pierBankTableTrTd2);
            _pierBankTableTr.appendChild(_pierBankTableTrTd3);

            _pierBankTable.appendChild(_pierBankTableTr);
            _pierBankContainer.appendChild(_pierBankTable);

            var _pierLinkBankPanel = defaultUtils.createElem( 'div', 'PIER-link-bank-panel' );

            var _pierBankNameRow = defaultUtils.createElem( 'div', 'PIER-row' ),
            _pierBankNameInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierBankNameInput.setAttrs({'placeholder':'姓名'});
            _pierBankNameRow.appendChild(_pierBankNameInput);

            var _pierBankIDRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-sm'] ),
            _pierBankIDInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierBankIDInput.setAttrs({'placeholder':'身份证'});
            _pierBankIDRow.appendChild(_pierBankIDInput);

            var _pierBankCardRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-sm'] ),
            _pierBankCardInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierBankCardInput.setAttrs({'placeholder':'借记卡号'});
            _pierBankCardRow.appendChild(_pierBankCardInput);

            var _pierBankPhoneRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-sm'] ),
            _pierBankPhoneInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierBankPhoneInput.setAttrs({'placeholder':'银行卡预留手机号'});
            _pierBankPhoneRow.appendChild(_pierBankPhoneInput);

            var _pierBankCodeRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-sm', 'PIER-font-xs']),
            _pierBankCodeInput = defaultUtils.createElem( 'input', 'PIER-code-input' );
            _pierBankCodeInput.setAttrs({'placeholder':'借记卡验证码'});
            _pierBankCodeBtn = defaultUtils.createElem( 'div', ['PIER-font-xs', 'PIER-code-label'] );
            _pierBankCodeBtn.innerHTML = '获取验证码';
            _pierBankCodeRow.css({'height':'32px'});
            _pierBankCodeRow.appendChild(_pierBankCodeInput);
            _pierBankCodeRow.appendChild(_pierBankCodeBtn);

            var _pierBankErrorRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-error',  'PIER-text-center']),
            _pierBankErrorMsg = defaultUtils.createElem( 'p' );
            _pierBankErrorMsg.innerHTML = '';
            _pierBankErrorRow.appendChild(_pierBankErrorMsg);

            var _pierBankPayRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm' ,'PIER-mB-sm']),
            _pierBankPayBtn = defaultUtils.createElem( 'button', 'PIER-submit-btn' );
            _pierBankPayBtn.innerHTML = '支付';
            _pierBankPayRow.appendChild(_pierBankPayBtn);

            _pierLinkBankPanel.appendChildren([_pierBankNameRow, _pierBankIDRow, _pierBankCardRow, _pierBankPhoneRow, _pierBankCodeRow, _pierBankErrorRow, _pierBankPayRow]);
            _pierBankContainer.appendChild(_pierLinkBankPanel);
            
            _pierBankCheckbox.onchange = function(){
                if( _pierBankCheckbox.checked ){
                    _pierLinkBankPanel.css({'height':'300px'});
                }else{
                    _pierLinkBankPanel.css({'height':'0px'});
                }
            }
            return _pierBankContainer;
        },
        initHeader:function( headerOpt ){
            var isRegStatus = false, payResult = false;
            if( headerOpt ){
                isRegStatus = headerOpt.regStatus || false;
                payResult = headerOpt.payResult || false;
            }
            var _tempHead = defaultUtils.createElem( 'div', 'PIER-panel-head' ),
            _tempHeadTable = defaultUtils.createElem( 'table' ),
            _tempHeadTableTr = defaultUtils.createElem( 'tr' ),
            _tempHeadTableTrTd = defaultUtils.createElem( 'td' ),
            _tempHeadClose = defaultUtils.createElem( 'div', 'PIER-close' );
            if( isRegStatus ){
                _tempHeadTableTr.innerHTML = '<td ></td><td ><div><img src="http://pierup.cn/images/sdk-logo.png"></div><h4>品而额度申请<span class="PIER-color">'+headerOpt.regStep+'/2</span></h4></td>';
            }else{
                _tempHeadTableTr.innerHTML = '<td ></td><td ><div><img src="'+ (_OPTIONS.merchantLogo !==""?_OPTIONS.merchantLogo:pierConst.pierLogo)+'"></div><h4>'+pierConst.title.login+'</h4></td>';
            }
            _tempHead.appendChild(_tempHeadTable);
            _tempHeadTable.appendChild( _tempHeadTableTr );
            _tempHeadTableTr.appendChild(_tempHeadTableTrTd);
            _tempHeadTableTrTd.appendChild(_tempHeadClose);

            _tempHeadClose.onclick = function(){
                if( payResult ){
                    defaultUtils.destorySDK();
                }else{
                    _pierFlipContainer.classList.remove( 'PIER-buzz-class' );
                    setTimeout(function( ){
                        if( _pierLoginErrorRow.innerHTML == pierConst.exitTip ){
                            defaultUtils.destorySDK();
                        }else{
                            _pierFlipContainer.addClass( 'PIER-buzz-class' );
                            _pierLoginErrorRow.innerHTML = pierConst.exitTip;
                            setTimeout(function(){
                                _pierLoginErrorRow.innerHTML = '';
                            }, 5000);                   
                        }
                    }, 10); 
                }
            };
            return _tempHead;
        },
        initPinSettingPanel:function( clickFun ){
            var pinSettingPanel = defaultUtils.createElem( 'div', 'PIER-set-pin'),
            splitLine = defaultUtils.createElem( 'div', 'PIER-split-line');
            var pinTip = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-font-sm', 'PIER-color-black']);
            pinTip.innerHTML = '<p>设置品而金融支付密码以保障支付安全</p>';

            var pinPwdRow = defaultUtils.createElem( 'div', 'PIER-row'),
            pinPwdInput = defaultUtils.createElem( 'input', 'PIER-comm-input');
            pinPwdInput.setAttrs({'placeholder':'设置支付密码', 'type': 'password'});
            pinPwdRow.appendChild(pinPwdInput);

            var pinPwdConfirmRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-sm']),
            pinPwdConfirmInput = defaultUtils.createElem( 'input', 'PIER-comm-input');
            pinPwdConfirmInput.setAttrs({'placeholder':'确认支付密码', 'type': 'password'});
            pinPwdConfirmRow.appendChild(pinPwdConfirmInput);

            var pinBtnRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']);
            _pierRegBtnNext = defaultUtils.createElem( 'button', ['PIER-submit-btn', 'PIER-color'] );
            _pierRegBtnNext.innerHTML = '申请品而信用';
            pinBtnRow.appendChild(_pierRegBtnNext);//defaultUtils.digitalInputListener
            pinPwdInput.addEventListener( 'change', defaultUtils.digitalInputListener );
            pinBtnRow.onclick = function(){
               clickFun.apply( this );
            };

            pinSettingPanel.appendChildren([splitLine,pinTip,pinPwdRow, pinPwdConfirmRow, pinBtnRow]);
            return pinSettingPanel;
        },
        initLoginContainer: function(){
            _pierLoginContainer = defaultUtils.createElem( 'div', 'PIER-login-container');
            _pierLoginHead = defaultUtils.initHeader();
            _pierLoginBody = defaultUtils.createElem('div', 'PIER-login-body');

            _pierLoginErrorRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-error', 'PIER-text-center']);
            _pierLoginErrorSpan = defaultUtils.createElem('span', 'errorMsg' );
            _pierLoginErrorRow.appendChild(_pierLoginErrorSpan);

            _pierLoginSwitchRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm', 'PIER-text-center']);
            _pierLoginUseCreditBtn = defaultUtils.createElem('button', ['PIER-switch-btn', 'active', 'left-btn']);
            _pierLoginUseCreditBtn.innerHTML = '使用信用';
            _pierLoginApplyCreditBtn = defaultUtils.createElem('button', ['PIER-switch-btn', 'right-btn']);
            _pierLoginApplyCreditBtn.innerHTML = '申请信用';
            _pierLoginSwitchRow.appendChild(_pierLoginUseCreditBtn);
            _pierLoginSwitchRow.appendChild(_pierLoginApplyCreditBtn);

            _pierLoginPhoneRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm']);
            _pierLoginPhoneInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierLoginPhoneInput.setAttrs({'placeholder':pierConst.phoneInputTip});
            _pierLoginPhoneRow.appendChild(_pierLoginPhoneInput);

            _pierLoginPsdRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm']);
            _pierLoginPsdInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierLoginPsdInput.setAttrs({'placeholder':pierConst.pwdInputTip, 'type':'password'});
            _pierLoginPsdRow.appendChild(_pierLoginPsdInput);

            _pierLoginBtnRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm']);
            _pierLoginBtnNext = defaultUtils.createElem( 'button', 'PIER-submit-btn' );
            _pierLoginBtnNext.setAttrs({'id':'pierLogin'});
            _pierLoginBtnNext.innerHTML = pierConst.next;
            _pierLoginBtnRow.appendChild(_pierLoginBtnNext);

            _pierFlipWrap.appendChild(_pierFlipContainer); 
            _pierFlipContainer.appendChild(_pierLoginContainer);

            _pierLoginContainer.appendChild(_pierLoginHead);
            _pierLoginContainer.appendChild(_pierLoginBody);

            
            //set body
            
            _pierLoginBody.appendChild(_pierLoginErrorRow);
            _pierLoginBody.appendChild(_pierLoginSwitchRow);
            _pierLoginBody.appendChild(_pierLoginPhoneRow);
            _pierLoginBody.appendChild(_pierLoginPsdRow);
            _pierLoginBody.appendChild(_pierLoginBtnRow);
            var _pierLoginBankContainer = defaultUtils.initBankCardContainer();
            _pierLoginContainer.appendChild(_pierLoginBankContainer);

            _pierLoginBtnNext.onclick = function(){
                defaultUtils.initPaymentContainer();
                _pierLoginContainer.addClass( 'PIER-animated' );
                _pierLoginContainer.addClass( 'PIER-display-block' );
                _pierLoginContainer.addClass( 'PIERbounceOutLeft' );
                _pierPayContainer.addClass( 'PIER-animated' );
                _pierPayContainer.addClass( 'PIER-display-block' );
                _pierPayContainer.addClass( 'PIERbounceInRight' );
                _pierFlipContainer.appendChild(_pierPayContainer);
            };
            _pierLoginApplyCreditBtn.onclick = function(){
                defaultUtils.initRegContainer();
                _pierFlipContainer.appendChild(_pierRegContainer);//add reg container for animate only
                setTimeout(function(){
                    if( _pierLoginContainer.classList.contains('PIER-login-container-back') ){
                        _pierLoginContainer.classList.remove('PIER-login-container-back');
                    }else{
                        _pierLoginContainer.classList.add('PIER-login-container-back');
                    }
                    if( _pierRegContainer.classList.contains('PIER-reg-container-back') ){
                        _pierRegContainer.classList.remove('PIER-reg-container-back');
                    }else{
                        _pierRegContainer.classList.add('PIER-reg-container-back');
                    } 
                }, 10);
            }
        },
        initPaymentContainer: function(){
            _pierPayContainer = defaultUtils.createElem( 'div', 'PIER-payment-container');
            _pierPayHead = defaultUtils.initHeader();
            
            _pierPayBody = defaultUtils.createElem( 'div', ['PIER-payment-body', 'PIER-text-left']);

            _pierPayErrorRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-error', 'PIER-text-center']);
            _pierPayErrorSpan = defaultUtils.createElem('span', 'errorMsg' );
            _pierPayErrorRow.appendChild(_pierPayErrorSpan);
            
            _pierPayCreditRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-md']);
            _pierPayCreditRow.innerHTML = '<label>'+pierConst.pierCreditAmount+'</label>';
            _pierPayCreditRowAmount = defaultUtils.createElem('span', ['PIER-right', 'PIER-money'] );
            _pierPayCreditRowAmount.innerHTML = '￥2000'
            _pierPayCreditRow.appendChild(_pierPayCreditRowAmount);
            _pierPayInstalmentRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-xs']);
            _pierPayInstalmentRow.innerHTML = '<label>分期选项</label>';
            _pierPayInstalmentRowSelect = defaultUtils.createElem('select', ['PIER-right', 'PIER-instalment-select'] );
            _pierPayInstalmentRowOp0 = defaultUtils.createElem('option');
            _pierPayInstalmentRowOp0.innerHTML = '不分期';
            _pierPayInstalmentRowOp1 = defaultUtils.createElem('option');
            _pierPayInstalmentRowOp1.innerHTML = '三期';
            _pierPayInstalmentRowOp2 = defaultUtils.createElem('option');
            _pierPayInstalmentRowOp2.innerHTML = '六期';
            _pierPayInstalmentRowSelect.appendChild(_pierPayInstalmentRowOp0);
            _pierPayInstalmentRowSelect.appendChild(_pierPayInstalmentRowOp1);
            _pierPayInstalmentRowSelect.appendChild(_pierPayInstalmentRowOp2);
            _pierPayInstalmentRow.appendChild(_pierPayInstalmentRowSelect);

            _pierPayAgreementRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-xs', 'PIER-dot-line']);
            _pierPayAgreementRowInput = defaultUtils.createElem('input');
            _pierPayAgreementRowInput.setAttrs( {'type':'checkbox'});
            _pierPayAgreementRowSpan = defaultUtils.createElem('span', 'PIER-bottom-text');
            _pierPayAgreementRowSpan.innerHTML = pierConst.agreeAndRead;
            _pierPayAgreementRowSpan2 = defaultUtils.createElem('span', 'PIER-color');
            _pierPayAgreementRowSpan2.innerHTML = pierConst.baomixieyi;
            _pierPayAgreementRowSpan.appendChild(_pierPayAgreementRowSpan2);
            _pierPayAgreementRow.appendChild(_pierPayAgreementRowInput);
            _pierPayAgreementRow.appendChild(_pierPayAgreementRowSpan);

            _pierPayBankRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm', 'PIER-dot-line']);
            _pierPayBankRowSelect = defaultUtils.createElem('select', 'PIER-bankcard-select');
            _pierPayBankRowOp0 = defaultUtils.createElem('option');
            _pierPayBankRowOp0.innerHTML = '借记卡支付金额';
            _pierPayBankRowOp0Span = defaultUtils.createElem('span');
            _pierPayBankRowOp0Span.innerHTML = '（中国银行 尾号0003）';
            _pierPayBankRowOp0.appendChild(_pierPayBankRowOp0Span);
            _pierPayBankRowSelect.appendChild(_pierPayBankRowOp0);
            _pierPayBankRow.appendChild(_pierPayBankRowSelect);
            _pierPayBankRowAmount = defaultUtils.createElem('label', ['PIER-right', 'PIER-money']);
            _pierPayBankRowAmount.innerHTML = '￥3000';
            _pierPayBankRow.appendChild(_pierPayBankRowAmount);

            _pierPayTotalRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm']);
            _pierPayTotalRow.innerHTML = '<label>商品总价</label>';
            _pierPayTotalRowSpan = defaultUtils.createElem('span', ['PIER-right', 'PIER-money']);
            _pierPayTotalRowSpan.innerHTML = '￥5000';
            _pierPayTotalRow.appendChild(_pierPayTotalRowSpan);

            _pierPayExchangeRow = defaultUtils.createElem('div', ['PIER-row']); 
            _pierPayExchangeRow.setAttrs({ 'style': 'height:60px;'});
            _pierPayExchangeRowSpan1 = defaultUtils.createElem('div', ['PIER-right', 'PIER-font-sm']); 
            _pierPayExchangeRowSpan1.innerHTML = '美元共计：$812.33';
            _pierPayExchangeRowSpan2 = defaultUtils.createElem('div', ['PIER-right','PIER-font-xs','PIER-color-gray','PIER-mT-xs']); 
            _pierPayExchangeRowSpan2.innerHTML = '中国银行上海分行：2015-12-18 10:15';
            _pierPayExchangeRowSpan3 = defaultUtils.createElem('div', ['PIER-right','PIER-font-xs','PIER-color-gray']); 
            _pierPayExchangeRowBr = defaultUtils.createElem('br'); 
            _pierPayExchangeRowSpan3.innerHTML = '汇率：1USD = 6.47RMB';
            _pierPayExchangeRow.appendChild(_pierPayExchangeRowSpan1);
            _pierPayExchangeRow.appendChild(_pierPayExchangeRowSpan2);
            _pierPayExchangeRow.appendChild(_pierPayExchangeRowBr);
            _pierPayExchangeRow.appendChild(_pierPayExchangeRowSpan3);

            _pierPayBankInfoRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm', 'PIER-font-xs']); 
            _pierPayBankInfoRowP = defaultUtils.createElem('p'); 
            _pierPayBankInfoRowP.innerHTML = '借记卡（中国银行 尾号为0003）绑定的手机号为：186****123';
            _pierPayBankInfoRow.appendChild(_pierPayBankInfoRowP);

            _pierPayValidCodeRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-font-xs']); 
            _pierPayValidCodeRow.setAttrs({'style':'height:38px;'});
            _pierPayValidCodeInput = defaultUtils.createElem('input', 'PIER-code-input'); 
            _pierPayValidCodeInput.setAttrs( {'placeholder':'借记卡验证码'} );
            _pierPayValidBtn = defaultUtils.createElem('div', ['PIER-font-xs', 'PIER-code-label']);
            _pierPayValidBtn.innerHTML = '获取验证码';
            _pierPayValidCodeRow.appendChild(_pierPayValidCodeInput);
            _pierPayValidCodeRow.appendChild(_pierPayValidBtn);

            _pierPayPinRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-font-xs','PIER-mT-xs']);
            _pierPayPinInput = defaultUtils.createElem( 'input', ['PIER-comm-input','PIER-clear']);
            _pierPayPinInput.setAttrs( {'placeholder':'品而金融6位支付密码'});
            _pierPayPinRow.appendChild(_pierPayPinInput);

            _pierPaySubmitRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-md']);
            _pierPaySubmitBtn = defaultUtils.createElem( 'button', ['PIER-submit-btn']);
            _pierPaySubmitBtn.innerHTML = '下一步';
            _pierPaySubmitRow.appendChild(_pierPaySubmitBtn);

            _pierPayTimerRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-md']);
            _pierPayTimerP = defaultUtils.createElem( 'p', ['PIER-bottom-text', 'PIER-text-center']);
            _pierPayTimerP.innerHTML = '您可以在4分12秒内使用额度支付';
            _pierPayTimerRow.appendChild(_pierPayTimerP);


            //append head and body
            _pierPayContainer.appendChild(_pierPayHead);
            _pierPayContainer.appendChild(_pierPayBody);
            //append body elem
            _pierPayBody.appendChild(_pierPayErrorRow);
            _pierPayBody.appendChild(_pierPayCreditRow);
            _pierPayBody.appendChild(_pierPayInstalmentRow);
            _pierPayBody.appendChild(_pierPayAgreementRow);
            _pierPayBody.appendChild(_pierPayBankRow);
            _pierPayBody.appendChild(_pierPayTotalRow);
            _pierPayBody.appendChild(_pierPayExchangeRow);
            _pierPayBody.appendChild(_pierPayBankInfoRow);
            _pierPayBody.appendChild(_pierPayValidCodeRow);
            _pierPayBody.appendChild(_pierPayPinRow);
            _pierPayBody.appendChild(_pierPaySubmitRow);
            _pierPayBody.appendChild(_pierPayTimerRow);

            _pierPaySubmitBtn.onclick = function(){
                defaultUtils.initPayResultContainer();
                _pierPayContainer.removeClass( 'PIERbounceInRight' );
                _pierPayContainer.addClass( 'PIERbounceOutLeft' );
                _pierPayContainer.removeClass( 'PIER-display-block' );

                _pierPayResultContainer.addClass( 'PIER-animated' );
                _pierPayResultContainer.addClass( 'PIER-display-block' );
                _pierPayResultContainer.addClass( 'PIERbounceInRight' );
                _pierFlipContainer.appendChild(_pierPayResultContainer);
            };
            
        },
        initPayResultContainer:function(){
            _pierPayResultContainer = defaultUtils.createElem( 'div', 'PIER-payresult-container');
            //pay result container header
            _pierPayResultHead = defaultUtils.initHeader({
                payResult: true
            });
            //pay result container body
            _pierPayResultBody = defaultUtils.createElem( 'div', ['PIER-payresult-body', 'PIER-text-text']);
            _pierPayResultQRRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-md']);
            _pierPayResultQRImage = defaultUtils.createElem( 'img');
            _pierPayResultQRImage.setAttrs({ 'src':'http://pierup.cn/images/getqrcode.jpg'});
            _pierPayResultQRRow.appendChild(_pierPayResultQRImage);

            _pierPayResultMsgRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-md']);
            _pierPayResultMsgRow.innerHTML = '<p class="PIER-color">支付成功!</p>';

            _pierPayResultDownRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-md']);
            _pierPayResultDownRow.innerHTML = '<p>马上在各大市场下载品而金融APP，轻松提高和管理您的额度!</p>';

            _pierPayResultReturnRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-md']);
            _pierPayResultReturnRow.innerHTML = '<p class="PIER-color-gray PIER-font-sm">正在返回商家……</p>';


            _pierPayResultContainer.appendChild(_pierPayResultHead);
            _pierPayResultContainer.appendChild(_pierPayResultBody);
            _pierPayResultBody.appendChild(_pierPayResultQRRow);
            _pierPayResultBody.appendChild(_pierPayResultMsgRow);
            _pierPayResultBody.appendChild(_pierPayResultDownRow);
            _pierPayResultBody.appendChild(_pierPayResultReturnRow);

        },
        initRegContainer: function(){
            _pierRegContainer = defaultUtils.createElem( 'div', 'PIER-reg-container');
            //pay result container header
            _pierRegHead = defaultUtils.initHeader({
                regStatus: true,
                regStep: 1
            });
            _pierRegBody = defaultUtils.createElem( 'div', 'PIER-reg-body' );

            _pierRegErrorRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-error', 'PIER-text-center']);
            _pierRegErrorSpan = defaultUtils.createElem('span', 'errorMsg' );
            _pierRegErrorRow.appendChild(_pierRegErrorSpan);

            _pierRegSwitchRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm', 'PIER-text-center']);
            _pierRegUseCreditBtn = defaultUtils.createElem('button', ['PIER-switch-btn', 'left-btn']);
            _pierRegUseCreditBtn.innerHTML = '使用信用';
            _pierRegApplyCreditBtn = defaultUtils.createElem('button', ['PIER-switch-btn', 'active', 'right-btn']);
            _pierRegApplyCreditBtn.innerHTML = '申请信用';
            _pierRegSwitchRow.appendChildren([_pierRegUseCreditBtn, _pierRegApplyCreditBtn]);

            _pierRegPhoneRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm']);
            _pierRegPhoneInput = defaultUtils.createElem('input', 'PIER-comm-input' );
            _pierRegPhoneInput.setAttrs({'placeholder':'手机号'});
            _pierRegPhoneRow.appendChild(_pierRegPhoneInput);

            _pierRegCodeRow = defaultUtils.createElem( 'div', ['PIER-row','PIER-mT-sm']),
            _pierRegCodeInput = defaultUtils.createElem( 'input', 'PIER-code-input' );
            _pierRegCodeInput.setAttrs({'placeholder':'短信验证码'});
            _pierRegCodeBtn = defaultUtils.createElem( 'div', ['PIER-font-xs', 'PIER-code-label'] );
            _pierRegCodeBtn.innerHTML = '获取验证码';
            _pierRegCodeRow.css({'height':'32px'});
            _pierRegCodeRow.appendChildren([_pierRegCodeInput, _pierRegCodeBtn]);

            _pierRegNameRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm']);
            _pierRegNameInput = defaultUtils.createElem('input', 'PIER-comm-input' );
            _pierRegNameInput.setAttrs({'placeholder':'真实姓名'});
            _pierRegNameRow.appendChild(_pierRegNameInput);

            _pierRegIDRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-sm']);
            _pierRegIDInput = defaultUtils.createElem('input', 'PIER-comm-input' );
            _pierRegIDInput.setAttrs({'placeholder':'身份证'});
            _pierRegIDRow.appendChild(_pierRegIDInput);

            _pierRegAgreetmentRow = defaultUtils.createElem('div', ['PIER-row', 'PIER-mT-xs']);
            _pierRegAgreetmentInput = defaultUtils.createElem('input');
            _pierRegAgreetmentInput.setAttrs({'type':'checkbox'});
            _pierRegAgreetmentSpan = defaultUtils.createElem('span', ['PIER-bottom-text']);
            _pierRegAgreetmentSpan.innerHTML = '同意<span class="PIER-color">《品而服务协议》</span>和<span class="PIER-color">《保密授权协议》</span>';
            _pierRegAgreetmentRow.appendChildren([_pierRegAgreetmentInput,_pierRegAgreetmentSpan]);

            _pierRegBtnRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']);
            _pierRegBtnNext = defaultUtils.createElem( 'button', 'PIER-submit-btn' );
            _pierRegBtnNext.innerHTML = pierConst.next;
            _pierRegBtnRow.appendChild(_pierRegBtnNext);
            
            _pierRegBody.appendChildren([_pierRegErrorRow, _pierRegSwitchRow, _pierRegPhoneRow, _pierRegCodeRow, _pierRegNameRow, _pierRegIDRow, _pierRegAgreetmentRow, _pierRegBtnRow ]);
            
            var _pierRegBankContainer = defaultUtils.initBankCardContainer();
            _pierRegContainer.appendChildren([_pierRegHead, _pierRegBody, _pierRegBankContainer]);

            _pierRegUseCreditBtn.onclick = function(){
                if( _pierLoginContainer.classList.contains('PIER-login-container-back') ){
                    _pierLoginContainer.classList.remove('PIER-login-container-back');
                }else{
                    _pierLoginContainer.classList.add('PIER-login-container-back');
                }
                if( _pierRegContainer.classList.contains('PIER-reg-container-back') ){
                    _pierRegContainer.classList.remove('PIER-reg-container-back');
                }else{
                    _pierRegContainer.classList.add('PIER-reg-container-back');
                }
            }
            _pierRegBtnNext.onclick = function(){
                defaultUtils.initApplyContainer();
                _pierRegContainer.addClass( 'PIER-animated' );
                _pierRegContainer.addClass( 'PIER-display-block' );
                _pierRegContainer.addClass( 'PIERbounceOutLeft' );

                _pierApplyContainer.addClass( 'PIER-animated' );
                _pierApplyContainer.addClass( 'PIER-display-block' );
                _pierApplyContainer.addClass( 'PIERbounceInRight' );
                _pierFlipContainer.appendChild(_pierApplyContainer);
                setTimeout(function(){
                    // _pierFlipContainer.removeChild(_pierRegContainer);
                }, 100);
                
            }
        },
        initApplyContainer: function(){
            //_pierApplyHeader, _pierApplyBody, _pierApplyCardOwnerRow, _pierApplyCardOwnerLabel, 
            //_pierApplyCardOwnerName, _pierApplyCardRow, _pierApplyCardInput,
            //_pierApplyCardTypeRow, _pierApplyCardTypeLabel, _pierApplyCardTypeName, _pierApplyCardPhoneRow, _pierApplyCardPhoneInput
            _pierApplyContainer = defaultUtils.createElem( 'div', 'PIER-apply-container');
            //pay result container header
            _pierApplyHeader = defaultUtils.initHeader({
                regStatus: true,
                regStep: 2
            });

            _pierApplyBody = defaultUtils.createElem( 'div', 'PIER-apply-body' );

            _pierApplyCardOwnerRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm'] );
            _pierApplyCardOwnerLabel = defaultUtils.createElem( 'label' );
            _pierApplyCardOwnerLabel.innerHTML = '持卡人：';
            _pierApplyCardOwnerName = defaultUtils.createElem( 'span', 'PIER-right' );
            _pierApplyCardOwnerName.innerHTML = '张三';
            _pierApplyCardOwnerRow.appendChildren([_pierApplyCardOwnerLabel,_pierApplyCardOwnerName]);

            _pierApplyCardRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-xs'] );
            _pierApplyCardInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierApplyCardInput.setAttrs({'placeholder': '借记卡卡号'});
            _pierApplyCardRow.appendChild(_pierApplyCardInput);

            _pierApplyCardTypeRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm'] );
            _pierApplyCardTypeLabel = defaultUtils.createElem( 'label' );
            _pierApplyCardTypeLabel.innerHTML = '卡类型：';
            _pierApplyCardTypeName = defaultUtils.createElem( 'span', 'PIER-right' );
            _pierApplyCardTypeName.innerHTML = '中国银行';
            _pierApplyCardTypeRow.appendChildren([_pierApplyCardTypeLabel,_pierApplyCardTypeName]);

            _pierApplyCardPhoneRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-xs'] );
            _pierApplyCardPhoneInput = defaultUtils.createElem( 'input', 'PIER-comm-input' );
            _pierApplyCardPhoneInput.setAttrs({'placeholder': '银行预留手机号'});
            _pierApplyCardPhoneRow.appendChild(_pierApplyCardPhoneInput);

            _pierApplyAgreetmentRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-xs'] );
            _pierApplyAgreetmentCheck = defaultUtils.createElem( 'input' );
            _pierApplyAgreetmentCheck.setAttrs({'type':'checkbox'});
            _pierApplyAgreetmentSpan = defaultUtils.createElem( 'span', 'PIER-bottom-text' );
            _pierApplyAgreetmentSpan.innerHTML = '同意<span class="PIER-color">《品而服务协议》</span>和<span class="PIER-color">《保密授权协议》</span>';
            _pierApplyAgreetmentRow.appendChildren([_pierApplyAgreetmentCheck,_pierApplyAgreetmentSpan]);

            _pierApplyCodeRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm'] );
            _pierApplyCodeRow.css({'height':'32px'});
            _pierApplyCodeInput = defaultUtils.createElem( 'input', 'PIER-code-input' );
            _pierApplyCodeInput.setAttrs({'placeholder': '短信验证码'});
            _pierApplyCodeBtn = defaultUtils.createElem( 'div', ['PIER-font-xs', 'PIER-code-label'] );
            _pierApplyCodeBtn.innerHTML = '获取验证码';
            _pierApplyCodeRow.appendChildren([_pierApplyCodeInput, _pierApplyCodeBtn]);

            _pierApplyBtnRow = defaultUtils.createElem( 'div', ['PIER-row', 'PIER-mT-sm', 'PIER-mB-sm']);
            _pierApplyBtnNext = defaultUtils.createElem( 'button', ['PIER-submit-btn', 'PIER-color'] );
            _pierApplyBtnNext.innerHTML = '申请品而信用';
            _pierApplyBtnRow.appendChild(_pierApplyBtnNext);

            var pierSettingPin = defaultUtils.initPinSettingPanel(function(){
                alert(124)
            });

            
            //set apply body 
            _pierApplyBody.appendChildren([_pierApplyCardOwnerRow,_pierApplyCardRow, _pierApplyCardTypeRow, _pierApplyCardPhoneRow, _pierApplyAgreetmentRow, _pierApplyCodeRow, _pierApplyBtnRow, pierSettingPin ]);
            _pierApplyContainer.appendChild(_pierApplyHeader);
            _pierApplyContainer.appendChild(_pierApplyBody);
            
        },
        apiTemplateCall: function(){
            var _xhr = null;
            var _apiOpts = arguments[0];
            // var _templateUrl = arguments[0];
            // var _message = arguments[1];
            var _apiCallback = arguments[2];
            if ( window.XMLHttpRequest ) {
                _xhr = new XMLHttpRequest();
            } else if ( window.ActiveXObject ) {
                _xhr = new ActiveXObject( 'Microsoft.XMLHTTP' );
            } else {
                throw new Error( BROWSER_NOT_SUPPORT );
                return;
            }
            _xhr.open( 'POST', _apiOpts.url, true );

            xhr.setRequestHeader( 'Content-type', 'application/json' );
            xhr.onreadystatechange = function(){
                if (xhr.readyState == 4 ) {
                    _apiCallback.call( this, xhr );
                }
            }
            xhr.send( JSON.stringify( _apiOpts.body ) );           
        }
    },  PIER = this.PIER = {
        version: '0.1.0',
    };
    PIER.initSDK = function(){
        defaultUtils.init();
        _OPTIONS = defaultUtils.setConfig( arguments[0], defaultSettings );
        _callback = arguments[1];

        var _pierScriptBtn = document.querySelector("script[class='pier-button']");
        console.log('_pierScriptBtn', _pierScriptBtn);
        var __pierPayBtn = defaultUtils.initPierBtn(_pierScriptBtn);

        __pierPayBtn.onclick = function(){
            _pierOverlay = defaultUtils.createElem( 'div','PIER-overlay' );
            _pierFlipWrap = defaultUtils.createElem( 'div','PIER-flip-wrap' );
            _pierFlipContainer = defaultUtils.createElem('div', ['PIER-flip-container', 'PIER-animated', 'PIERbounceInTop']);
            // setTimeout(function(){
            //     _pierFlipContainer.removeClass('PIER-animated');
            // }, 1000);
            
            defaultUtils.initLoginContainer();
            document.body.appendChild(_pierOverlay);
            document.body.appendChild(_pierFlipWrap);
        }
    };
})(window);
