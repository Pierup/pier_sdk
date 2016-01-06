(function() {
	var namespace = "PierCheckout.require".split("."),
		name = namespace[namespace.length - 1],
		base = this,
		i;
	for (i = 0; i < namespace.length - 1; i++) {
		base = base[namespace[i]] = base[namespace[i]] || {}
	}
	if (base[name] === undefined) {
		base[name] = function() {
			var modules = {},
				cache = {};
			var requireRelative = function(name, root) {
					var path = expand(root, name),
						indexPath = expand(path, "./index"),
						module, fn;
						console.log( 'path', path);
					module = cache[path] || cache[indexPath];
					if (module) {
						return module
					} else if (fn = modules[path] || modules[path = indexPath]) {
						module = {
							id: path,
							exports: {}
						};
						cache[path] = module.exports;
						fn(module.exports, function(name) {
							return require(name, dirname(path))
						}, module);
						return cache[path] = module.exports
					} else {
						throw "module " + name + " not found"
					}
				};
			var expand = function(root, name) {
					var results = [],
						parts, part;
					if (/^\.\.?(\/|$)/.test(name)) {
						parts = [root, name].join("/").split("/")
					} else {
						parts = name.split("/")
					}
					for (var i = 0, length = parts.length; i < length; i++) {
						part = parts[i];
						if (part == "..") {
							results.pop()
						} else if (part != "." && part != "") {
							results.push(part)
						}
					}
					return results.join("/")
				};
			var dirname = function(path) {
					return path.split("/").slice(0, -1).join("/")
				};
			var require = function(name) {
					return requireRelative(name, "")
				};
			require.define = function(bundle) {
				for (var key in bundle) {
					modules[key] = bundle[key]
				}
			};
			require.modules = modules;
			require.cache = cache;
			return require
		}.call(this)
	}
})();
PierCheckout.require.define({
	"pier/lib/utils": function(exports, require, module) {
		(function() {
			var $, __indexOf = [].indexOf ||
			function(item) {
				for (var i = 0, l = this.length; i < l; i++) {
					if (i in this && this[i] === item) return i
				}
				return -1
			};
			$ = function(sel, attrType) {
				var _this;
				if( document.querySelector ){
					_this = document.querySelector(sel);
				}else{
					_this = document.getElementById(sel.split('#')[1]);
				}
				_this.hasAttr = function(attr){
					var node;
					if (typeof this.hasAttribute === "function") {
						return this.hasAttribute(attr)
					} else {
						node = this.getAttributeNode(attr);
						return !!(node && (node.specified || node.nodeValue))
					}
				};
				_this.addClass = function(name) {
					if( typeof name === 'object' ){
						for( i in name ){
							this.className += " " + name[i];
						}
					}else{
						this.className += " " + name;
					}
					return this.className;
				};
				_this.hasClass = function(){
					return __indexOf.call(this.className.split(" "), name) >= 0
				};
				_this.text = function(value){
					if ("innerText" in this) {
						this.innerText = value;
					} else {
						this.textContent = value;
					}
					return this.innerText;
				};
				_this.css = function(css){
					this.style.cssText += ";" + css
				};
				_this.append = function(child){
					this.appendChild(child);
				};
				_this.remove = function(){
					var _ref;
				    ( _ref = this.parentNode ) != null ? _ref.removeChild(this) : void 0;
				};
				_this.insertBefore = function(child){
	                this.parentNode.insertBefore(child, this);
				};
				_this.insertAfter = function(child){
	                this.parentNode.insertBefore(child, this.nextSibling);
				}
				return _this;
			};
			// $.createButton = function(){
			// 	var button = document.createElement( 'button' );
			// 	button.style = 'width:120px;height:32px;border:1px solid #ccc; cursor:pointer; overflow: hidden;';
			// 	button.innerHTML = '<img  src="http://pierup.cn/images/pierlogo38.png" style="width:24px;margin-top:4px;margin-left:10px;margin-right:6px;float:left;">'+
   //      '<div style="font-size:14px;margin-top:10px;margin-left:50px;">品而付</div>';
			// }
			module.exports = {
				$: $
			}
		}).call(this)
	}
});
PierCheckout.require.define({
	"pier/controllers/button": function(exports, require, module) {
		(function() {
			var $, Button, _ref, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};
			_ref = require("pier/lib/utils");
			$ = _ref.$;

			Button = function() {
				Button.init = function(){
					var button = new Button();
                    // console.log( 'init', button.render() );
				}
				function Button(){
					this.render = __bind(this.render, this);
					
					this.render()
				}
				Button.prototype.render = function() {
					var element = $(".pier-button");
					console.log( 'element', element.parentNode );
					element.parentNode.appendChild(this);
					// element.insertBefore(this);
					// return element.insertBefore(this);
				};

				// Button.load = function() {
				// 	var button, el, element;
				// 	button = new Button();
				// };
				// function Button(){
				// 	var element = $(".pier-button");
				// 	if (!element) {
				// 		throw "Pier class in script not found";
				// 		return;
				// 	}
				// 	var _pierBtn = $.createButton();
				// 	this.render();
				// };
				// Button.prototype.render = function() {
				// 	var element = $(".pier-button");
				// 	console.log( 'element', element );
				// 	element.insertBefore(this);
				// 	// return element.insertBefore(this);
				// };
				return Button
			}();
			
			module.exports = Button
		}).call(this)
	}
});
(function() {
	var App, Button, app, require, _ref, _ref1, _ref2, util, $;

	require = require || this.PierCheckout.require;
	Button = require("pier/controllers/button");
	Button.init();
}).call(this);