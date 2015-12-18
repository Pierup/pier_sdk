/**
 * 品而中国版支付SDK
 * @param  {[type]} global  [description]
 * @param  {[type]} factory [description]
 * @return PIER    PIER对象，用于支付的实例对象
 * @author Flower
 * @date
 */
// (function( global, factory ) {
//     if ( typeof module === "object" && typeof module.exports === "object" ) {
//         module.exports = global.document ?
//             factory( global, true ) :
//             function( w ) {
//                 if ( !w.document ) {
//                     throw new Error( "PIER requires a window with a document" );
//                 }
//                 return factory( w );
//             };
//     }else if (typeof define === 'function' && define.amd) {
//         define( factory(global) );
//     }else {
//         factory( global );
//     }
// // Pass this if window is not defined yet
// }(typeof window !== "undefined" ? window : this, function( window, noGlobal ) {

// }))
// var PIER = (function( m ){
//   console.log( 'aaaaa', this);
// })()

(function( window ){
    var styleSheet, styleElem;
    var defaultSettings = {
        env: 'dev', //default 'dev' for testing, if 'pro',it will be production mode.
        totalAmount: 0, //the total amount to be paid, default 0
        currency: 'CNY', //default 'cny',
    },  pierConst = (function(){
        return {
            paramError: "配置参数格式错误！",
            cssPrefix: 'PIER-'
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
            styleSheet.addRule( '.PIER-panel-head', "width:400px;height:300px;-moz-border-radius: 6px;-webkit-border-radius: 6px;border-radius: 6px;-moz-box-shadow: 0px 0px 2px rgb(160,160,160);-webkit-box-shadow: 0px 0px 2px rgb(160,160,160);box-shadow: 0px 0px 2px rgb(160,160,160);filter: progid: DXImageTransform.Microsoft.gradient(startColorstr = 'rgb(245,245,245)', endColorstr = 'rgb(235,235,235)');-ms-filter: 'progid: DXImageTransform.Microsoft.gradient(startColorstr = 'rgb(245,245,245)', endColorstr = 'rgb(235,235,235)')';background-image: -moz-linear-gradient(top, rgb(245,245,245), rgb(235,235,235));background-image: -ms-linear-gradient(top, rgb(245,245,245), rgb(235,235,235));background-image: -o-linear-gradient(top, rgb(245,245,245), rgb(235,235,235));background-image: -webkit-gradient(linear, center top, center bottom, from(rgb(245,245,245)), to(rgb(235,235,235)));background-image: -webkit-linear-gradient(top, rgb(245,245,245), rgb(235,235,235));background-image: linear-gradient(top, rgb(245,245,245), rgb(235,235,235));-moz-background-clip: padding;-webkit-background-clip: padding-box;background-clip: padding-box;");
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
        notEmpty: function(){

        },
        createElem: function( elem ){
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
            }
            return _this;
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
        var _options = defaultUtils.setConfig( arguments[0], defaultSettings );
        var _callback = arguments[1];
        console.log( '_options', _options );
        console.log( 'pierConst', pierConst );
        var _input = defaultUtils.createElem( 'input' );
        var _header = defaultUtils.createElem( 'div' );
        // _input.addClass(['testClass','class2', 'class3']);
        // _input.setAttrs({ 'data-A':'123', 'data-B': '234'})
        // _input.removeClass('class2')
        _header.addClass('PIER-panel-head');
        document.body.appendChild(_header);
        console.log( '_header', _header );
    };
})(window);
