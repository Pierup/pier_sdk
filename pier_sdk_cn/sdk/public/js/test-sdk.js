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
	"pier/controllers/button": function(exports, require, module) {
		(function() {
			var $, Button, _ref, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};

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
					
				};

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