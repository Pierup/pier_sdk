if (typeof JSON !== "object") {
	JSON = {}
}(function() {
	"use strict";

	function f(n) {
		return n < 10 ? "0" + n : n
	}
	if (typeof Date.prototype.toJSON !== "function") {
		Date.prototype.toJSON = function() {
			return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null
		};
		String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function() {
			return this.valueOf()
		}
	}
	var cx, escapable, gap, indent, meta, rep;

	function quote(string) {
		escapable.lastIndex = 0;
		return escapable.test(string) ? '"' + string.replace(escapable, function(a) {
			var c = meta[a];
			return typeof c === "string" ? c : "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)
		}) + '"' : '"' + string + '"'
	}

	function str(key, holder) {
		var i, k, v, length, mind = gap,
			partial, value = holder[key];
		if (value && typeof value === "object" && typeof value.toJSON === "function") {
			value = value.toJSON(key)
		}
		if (typeof rep === "function") {
			value = rep.call(holder, key, value)
		}
		switch (typeof value) {
		case "string":
			return quote(value);
		case "number":
			return isFinite(value) ? String(value) : "null";
		case "boolean":
		case "null":
			return String(value);
		case "object":
			if (!value) {
				return "null"
			}
			gap += indent;
			partial = [];
			if (Object.prototype.toString.apply(value) === "[object Array]") {
				length = value.length;
				for (i = 0; i < length; i += 1) {
					partial[i] = str(i, value) || "null"
				}
				v = partial.length === 0 ? "[]" : gap ? "[\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "]" : "[" + partial.join(",") + "]";
				gap = mind;
				return v
			}
			if (rep && typeof rep === "object") {
				length = rep.length;
				for (i = 0; i < length; i += 1) {
					if (typeof rep[i] === "string") {
						k = rep[i];
						v = str(k, value);
						if (v) {
							partial.push(quote(k) + (gap ? ": " : ":") + v)
						}
					}
				}
			} else {
				for (k in value) {
					if (Object.prototype.hasOwnProperty.call(value, k)) {
						v = str(k, value);
						if (v) {
							partial.push(quote(k) + (gap ? ": " : ":") + v)
						}
					}
				}
			}
			v = partial.length === 0 ? "{}" : gap ? "{\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "}" : "{" + partial.join(",") + "}";
			gap = mind;
			return v
		}
	}
	if (typeof JSON.stringify !== "function") {
		escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
		meta = {
			"\b": "\\b",
			"	": "\\t",
			"\n": "\\n",
			"\f": "\\f",
			"\r": "\\r",
			'"': '\\"',
			"\\": "\\\\"
		};
		JSON.stringify = function(value, replacer, space) {
			var i;
			gap = "";
			indent = "";
			if (typeof space === "number") {
				for (i = 0; i < space; i += 1) {
					indent += " "
				}
			} else if (typeof space === "string") {
				indent = space
			}
			rep = replacer;
			if (replacer && typeof replacer !== "function" && (typeof replacer !== "object" || typeof replacer.length !== "number")) {
				throw new Error("JSON.stringify")
			}
			return str("", {
				"": value
			})
		}
	}
	if (typeof JSON.parse !== "function") {
		cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g
		JSON.parse = function(text, reviver) {
			var j;

			function walk(holder, key) {
				var k, v, value = holder[key];
				if (value && typeof value === "object") {
					for (k in value) {
						if (Object.prototype.hasOwnProperty.call(value, k)) {
							v = walk(value, k);
							if (v !== undefined) {
								value[k] = v
							} else {
								delete value[k]
							}
						}
					}
				}
				return reviver.call(holder, key, value)
			}
			text = String(text);
			cx.lastIndex = 0;
			if (cx.test(text)) {
				text = text.replace(cx, function(a) {
					return "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)
				})
			}
			if (/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) {
				j = eval("(" + text + ")");
				return typeof reviver === "function" ? walk({
					"": j
				}, "") : j
			}
			throw new SyntaxError("JSON.parse")
		}
	}
})();
(function() {
	var namespace = "StripeCheckout.require".split("."),
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
		}.call()
	}
})();
StripeCheckout.require.define({
	"vendor/cookie": function(exports, require, module) {
		var cookie = {};
		var pluses = /\+/g;

		function extend(target, other) {
			target = target || {};
			for (var prop in other) {
				if (typeof source[prop] === "object") {
					target[prop] = extend(target[prop], source[prop])
				} else {
					target[prop] = source[prop]
				}
			}
			return target
		}

		function raw(s) {
			return s
		}

		function decoded(s) {
			return decodeURIComponent(s.replace(pluses, " "))
		}

		function converted(s) {
			if (s.indexOf('"') === 0) {
				s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, "\\")
			}
			try {
				return config.json ? JSON.parse(s) : s
			} catch (er) {}
		}
		var config = cookie.set = cookie.get = function(key, value, options) {
				if (value !== undefined) {
					options = extend(options, config.defaults);
					if (typeof options.expires === "number") {
						var days = options.expires,
							t = options.expires = new Date;
						t.setDate(t.getDate() + days)
					}
					value = config.json ? JSON.stringify(value) : String(value);
					return document.cookie = [config.raw ? key : encodeURIComponent(key), "=", config.raw ? value : encodeURIComponent(value), options.expires ? "; expires=" + options.expires.toUTCString() : "", options.path ? "; path=" + options.path : "", options.domain ? "; domain=" + options.domain : "", options.secure ? "; secure" : ""].join("")
				}
				var decode = config.raw ? raw : decoded;
				var cookies = document.cookie.split("; ");
				var result = key ? undefined : {};
				for (var i = 0, l = cookies.length; i < l; i++) {
					var parts = cookies[i].split("=");
					var name = decode(parts.shift());
					var cookie = decode(parts.join("="));
					if (key && key === name) {
						result = converted(cookie);
						break
					}
					if (!key) {
						result[name] = converted(cookie)
					}
				}
				return result
			};
		config.defaults = {};
		cookie.remove = function(key, options) {
			if (cookie.get(key) !== undefined) {
				cookie.set(key, "", extend(options, {
					expires: -1
				}));
				return true
			}
			return false
		};
		module.exports = cookie
	}
});
StripeCheckout.require.define({
	"vendor/ready": function(exports, require, module) {
		!
		function(name, definition) {
			if (typeof module != "undefined") module.exports = definition();
			else if (typeof define == "function" && typeof define.amd == "object") define(definition);
			else this[name] = definition()
		}("domready", function(ready) {
			var fns = [],
				fn, f = false,
				doc = document,
				testEl = doc.documentElement,
				hack = testEl.doScroll,
				domContentLoaded = "DOMContentLoaded",
				addEventListener = "addEventListener",
				onreadystatechange = "onreadystatechange",
				readyState = "readyState",
				loadedRgx = hack ? /^loaded|^c/ : /^loaded|c/,
				loaded = loadedRgx.test(doc[readyState]);

			function flush(f) {
				loaded = 1;
				while (f = fns.shift()) f()
			}
			doc[addEventListener] && doc[addEventListener](domContentLoaded, fn = function() {
				doc.removeEventListener(domContentLoaded, fn, f);
				flush()
			}, f);
			hack && doc.attachEvent(onreadystatechange, fn = function() {
				if (/^c/.test(doc[readyState])) {
					doc.detachEvent(onreadystatechange, fn);
					flush()
				}
			});
			return ready = hack ?
			function(fn) {
				self != top ? loaded ? fn() : fns.push(fn) : function() {
					try {
						testEl.doScroll("left")
					} catch (e) {
						return setTimeout(function() {
							ready(fn)
						}, 50)
					}
					fn()
				}()
			} : function(fn) {
				loaded ? fn() : fns.push(fn)
			}
		})
	}
});
(function() {
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(obj, start) {
			var f, i, j, _i;
			j = this.length;
			f = start ? start : 0;
			for (i = _i = f; f <= j ? _i < j : _i > j; i = f <= j ? ++_i : --_i) {
				if (this[i] === obj) {
					return i
				}
			}
			return -1
		}
	}
}).call(this);
StripeCheckout.require.define({
	"lib/helpers": function(exports, require, module) {
		(function() {
			var delurkWinPhone, helpers, uaVersionFn;
			uaVersionFn = function(re) {
				return function() {
					var uaMatch;
					uaMatch = helpers.userAgent.match(re);
					return uaMatch && parseInt(uaMatch[1])
				}
			};
			delurkWinPhone = function(fn) {
				return function() {
					return fn() && !helpers.isWindowsPhone()
				}
			};
			helpers = {
				userAgent: window.navigator.userAgent,
				escape: function(value) {
					return value && ("" + value).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\"/g, "&quot;")
				},
				trim: function(value) {
					return value.replace(/^[\s﻿ ]+|[\s﻿ ]+$/g, "")
				},
				sanitizeURL: function(value) {
					var SCHEME_WHITELIST, allowed, scheme, _i, _len;
					if (!value) {
						return
					}
					value = helpers.trim(value);
					SCHEME_WHITELIST = ["data:", "http:", "https:"];
					allowed = false;
					for (_i = 0, _len = SCHEME_WHITELIST.length; _i < _len; _i++) {
						scheme = SCHEME_WHITELIST[_i];
						if (value.indexOf(scheme) === 0) {
							allowed = true;
							break
						}
					}
					if (!allowed) {
						return null
					}
					return encodeURI(value)
				},
				iOSVersion: uaVersionFn(/(?:iPhone OS |iPad; CPU OS )(\d+)_\d+/),
				iOSMinorVersion: uaVersionFn(/(?:iPhone OS |iPad; CPU OS )\d+_(\d+)/),
				iOSBuildVersion: uaVersionFn(/(?:iPhone OS |iPad; CPU OS )\d+_\d+_(\d+)/),
				androidWebkitVersion: uaVersionFn(/Mozilla\/5\.0.*Android.*AppleWebKit\/([\d]+)/),
				androidVersion: uaVersionFn(/Android (\d+)\.\d+/),
				firefoxVersion: uaVersionFn(/Firefox\/(\d+)\.\d+/),
				chromeVersion: uaVersionFn(/Chrome\/(\d+)\.\d+/),
				safariVersion: uaVersionFn(/Version\/(\d+)\.\d+ Safari/),
				iOSChromeVersion: uaVersionFn(/CriOS\/(\d+)\.\d+/),
				iOSNativeVersion: uaVersionFn(/Stripe\/(\d+)\.\d+/),
				ieVersion: uaVersionFn(/(?:MSIE |Trident\/.*rv:)(\d{1,2})\./),
				isiOSChrome: function() {
					return /CriOS/.test(helpers.userAgent)
				},
				isiOSWebView: function() {
					return /(iPhone|iPod|iPad).*AppleWebKit((?!.*Safari)|(.*\([^)]*like[^)]*Safari[^)]*\)))/i.test(helpers.userAgent)
				},
				isiOS: delurkWinPhone(function() {
					return /(iPhone|iPad|iPod)/i.test(helpers.userAgent)
				}),
				isiOSNative: function() {
					return this.isiOS() && this.iOSNativeVersion() >= 3
				},
				isiPad: function() {
					return /(iPad)/i.test(helpers.userAgent)
				},
				isMac: delurkWinPhone(function() {
					return /mac/i.test(helpers.userAgent)
				}),
				isWindowsPhone: function() {
					return /(Windows\sPhone|IEMobile)/i.test(helpers.userAgent)
				},
				isWindowsOS: function() {
					return /(Windows NT\d\.\d)/i.test(helpers.userAgent)
				},
				isIE: function() {
					return /(MSIE([0-9]{1,}[\.0-9]{0,})|Trident\/)/i.test(helpers.userAgent)
				},
				isChrome: function() {
					return "chrome" in window
				},
				isSafari: delurkWinPhone(function() {
					var userAgent;
					userAgent = helpers.userAgent;
					return /Safari/i.test(userAgent) && !/Chrome/i.test(userAgent)
				}),
				isFirefox: delurkWinPhone(function() {
					return helpers.firefoxVersion() != null
				}),
				isAndroidBrowser: function() {
					var version;
					version = helpers.androidWebkitVersion();
					return version && version < 537
				},
				isAndroidChrome: function() {
					var version;
					version = helpers.androidWebkitVersion();
					return version && version >= 537
				},
				isAndroidDevice: delurkWinPhone(function() {
					return /Android/.test(helpers.userAgent)
				}),
				isAndroidWebView: function() {
					return helpers.isAndroidChrome() && /Version\/\d+\.\d+/.test(helpers.userAgent)
				},
				isNativeWebContainer: function() {
					return window.cordova != null || /GSA\/\d+\.\d+/.test(helpers.userAgent)
				},
				isSupportedMobileOS: function() {
					return helpers.isiOS() || helpers.isAndroidDevice()
				},
				isAndroidWebapp: function() {
					var metaTag;
					if (!helpers.isAndroidChrome()) {
						return false
					}
					metaTag = document.getElementsByName("apple-mobile-web-app-capable")[0] || document.getElementsByName("mobile-web-app-capable")[0];
					return metaTag && metaTag.content === "yes"
				},
				isiOSBroken: function() {
					var chromeVersion;
					chromeVersion = helpers.iOSChromeVersion();
					if (helpers.iOSVersion() === 9 && helpers.iOSMinorVersion() === 2 && chromeVersion && chromeVersion <= 47) {
						return true
					}
					if (helpers.isiPad() && helpers.iOSVersion() === 8) {
						switch (helpers.iOSMinorVersion()) {
						case 0:
							return true;
						case 1:
							return helpers.iOSBuildVersion() < 1
						}
					}
					return false
				},
				isUserGesture: function() {
					var _ref, _ref1;
					return (_ref = (_ref1 = window.event) != null ? _ref1.type : void 0) === "click" || _ref === "touchstart" || _ref === "touchend"
				},
				isInsideFrame: function() {
					return window.top !== window.self
				},
				isFallback: function() {
					var androidVersion, criosVersion, ffVersion, iOSVersion;
					if (!("postMessage" in window) || window.postMessageDisabled || document.documentMode && document.documentMode < 8) {
						return true
					}
					androidVersion = helpers.androidVersion();
					if (androidVersion && androidVersion < 4) {
						return true
					}
					iOSVersion = helpers.iOSVersion();
					if (iOSVersion && iOSVersion < 6) {
						return true
					}
					ffVersion = helpers.firefoxVersion();
					if (ffVersion && ffVersion < 11) {
						return true
					}
					criosVersion = helpers.iOSChromeVersion();
					if (criosVersion && criosVersion < 36) {
						return true
					}
					return false
				},
				isSmallScreen: function() {
					return Math.min(window.screen.availHeight, window.screen.availWidth) <= 640 || /FakeCheckoutMobile/.test(helpers.userAgent)
				},
				pad: function(number, width, padding) {
					var leading;
					if (width == null) {
						width = 2
					}
					if (padding == null) {
						padding = "0"
					}
					number = number + "";
					if (number.length > width) {
						return number
					}
					leading = new Array(width - number.length + 1).join(padding);
					return leading + number
				},
				requestAnimationFrame: function(callback) {
					return (typeof window.requestAnimationFrame === "function" ? window.requestAnimationFrame(callback) : void 0) || (typeof window.webkitRequestAnimationFrame === "function" ? window.webkitRequestAnimationFrame(callback) : void 0) || window.setTimeout(callback, 100)
				},
				requestAnimationInterval: function(func, interval) {
					var callback, previous;
					previous = new Date;
					callback = function() {
						var frame, now, remaining;
						frame = helpers.requestAnimationFrame(callback);
						now = new Date;
						remaining = interval - (now - previous);
						if (remaining <= 0) {
							previous = now;
							func()
						}
						return frame
					};
					return callback()
				},
				getQueryParameterByName: function(name) {
					var match;
					match = RegExp("[?&]" + name + "=([^&]*)").exec(window.location.search);
					return match && decodeURIComponent(match[1].replace(/\+/g, " "))
				},
				addQueryParameter: function(url, name, value) {
					var hashParts, query;
					query = encodeURIComponent(name) + "=" + encodeURIComponent(value);
					hashParts = new String(url).split("#");
					hashParts[0] += hashParts[0].indexOf("?") !== -1 ? "&" : "?";
					hashParts[0] += query;
					return hashParts.join("#")
				},
				bind: function(element, name, callback) {
					if (element.addEventListener) {
						return element.addEventListener(name, callback, false)
					} else {
						return element.attachEvent("on" + name, callback)
					}
				},
				unbind: function(element, name, callback) {
					if (element.removeEventListener) {
						return element.removeEventListener(name, callback, false)
					} else {
						return element.detachEvent("on" + name, callback)
					}
				},
				host: function(url) {
					var parent, parser;
					parent = document.createElement("div");
					parent.innerHTML = '<a href="' + this.escape(url) + '">x</a>';
					parser = parent.firstChild;
					return "" + parser.protocol + "//" + parser.host
				},
				strip: function(html) {
					var tmp, _ref, _ref1;
					tmp = document.createElement("div");
					tmp.innerHTML = html;
					return (_ref = (_ref1 = tmp.textContent) != null ? _ref1 : tmp.innerText) != null ? _ref : ""
				},
				replaceFullWidthNumbers: function(el) {
					var char, fullWidth, halfWidth, idx, original, replaced, _i, _len, _ref;
					fullWidth = "锛愶紤锛掞紦锛旓紩锛栵紬锛橈紮";
					halfWidth = "0123456789";
					original = el.value;
					replaced = "";
					_ref = original.split("");
					for (_i = 0, _len = _ref.length; _i < _len; _i++) {
						char = _ref[_i];
						idx = fullWidth.indexOf(char);
						if (idx > -1) {
							char = halfWidth[idx]
						}
						replaced += char
					}
					if (original !== replaced) {
						return el.value = replaced
					}
				},
				setAutocomplete: function(el, type) {
					var secureCCFill;
					secureCCFill = helpers.chromeVersion() > 14 || helpers.safariVersion() > 7;
					if (type !== "cc-csc" && (!/^cc-/.test(type) || secureCCFill)) {
						el.setAttribute("x-autocompletetype", type);
						el.setAttribute("autocompletetype", type)
					} else {
						el.setAttribute("autocomplete", "off")
					}
					if (!(type === "country-name" || type === "language" || type === "sex" || type === "gender-identity")) {
						el.setAttribute("autocorrect", "off");
						el.setAttribute("spellcheck", "off")
					}
					if (!(/name|honorific/.test(type) || (type === "locality" || type === "city" || type === "adminstrative-area" || type === "state" || type === "province" || type === "region" || type === "language" || type === "org" || type === "organization-title" || type === "sex" || type === "gender-identity"))) {
						return el.setAttribute("autocapitalize", "off")
					}
				},
				hashCode: function(str) {
					var hash, i, _i, _ref;
					hash = 5381;
					for (i = _i = 0, _ref = str.length; _i < _ref; i = _i += 1) {
						hash = (hash << 5) + hash + str.charCodeAt(i)
					}
					return (hash >>> 0) % 65535
				},
				stripeUrlPrefix: function() {
					var match;
					match = window.location.hostname.match("^([a-z-]*)checkout.");
					if (match) {
						return match[1]
					} else {
						return ""
					}
				},
				clientLocale: function() {
					return (window.navigator.languages || [])[0] || window.navigator.userLanguage || window.navigator.language
				}
			};
			module.exports = helpers
		}).call(this)
	}
});
StripeCheckout.require.define({
	"lib/rpc": function(exports, require, module) {
		(function() {
			var RPC, helpers, tracker, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				},
				__slice = [].slice;
			helpers = require("lib/helpers");
			tracker = require("lib/tracker");
			RPC = function() {
				function RPC(target, options) {
					if (options == null) {
						options = {}
					}
					this.processMessage = __bind(this.processMessage, this);
					this.sendMessage = __bind(this.sendMessage, this);
					this.invoke = __bind(this.invoke, this);
					this.startSession = __bind(this.startSession, this);
					this.rpcID = 0;
					this.target = target;
					this.callbacks = {};
					this.readyQueue = [];
					this.readyStatus = false;
					this.methods = {};
					helpers.bind(window, "message", function(_this) {
						return function() {
							var args;
							args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
							return _this.message.apply(_this, args)
						}
					}(this))
				}
				RPC.prototype.startSession = function() {
					this.sendMessage("frameReady");
					return this.frameReady()
				};
				RPC.prototype.invoke = function() {
					var args, method;
					method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
					tracker.trace.rpcInvoke(method);
					return this.ready(function(_this) {
						return function() {
							return _this.sendMessage(method, args)
						}
					}(this))
				};
				RPC.prototype.message = function(e) {
					var shouldProcess;
					shouldProcess = false;
					try {
						shouldProcess = e.source === this.target
					} catch (_error) {}
					if (shouldProcess) {
						return this.processMessage(e.data)
					}
				};
				RPC.prototype.ready = function(fn) {
					if (this.readyStatus) {
						return fn()
					} else {
						return this.readyQueue.push(fn)
					}
				};
				RPC.prototype.frameCallback = function(id, result) {
					var _base;
					if (typeof(_base = this.callbacks)[id] === "function") {
						_base[id](result)
					}
					delete this.callbacks[id];
					return true
				};
				RPC.prototype.frameReady = function() {
					var callbacks, cb, _i, _len;
					this.readyStatus = true;
					callbacks = this.readyQueue.slice(0);
					for (_i = 0, _len = callbacks.length; _i < _len; _i++) {
						cb = callbacks[_i];
						cb()
					}
					return false
				};
				RPC.prototype.isAlive = function() {
					return true
				};
				RPC.prototype.sendMessage = function(method, args) {
					var err, id, message, _ref;
					if (args == null) {
						args = []
					}
					id = ++this.rpcID;
					if (typeof args[args.length - 1] === "function") {
						this.callbacks[id] = args.pop()
					}
					message = JSON.stringify({
						method: method,
						args: args,
						id: id
					});
					if (((_ref = this.target) != null ? _ref.postMessage : void 0) == null) {
						err = new Error("Unable to communicate with Checkout. Please contact support@stripe.com if the problem persists.");
						if (this.methods.rpcError != null) {
							this.methods.rpcError(err)
						} else {
							throw err
						}
						return
					}
					this.target.postMessage(message, "*");
					return tracker.trace.rpcPostMessage(method, args, id)
				};
				RPC.prototype.processMessage = function(data) {
					var method, result, _base, _name;
					try {
						data = JSON.parse(data)
					} catch (_error) {
						return
					}
					if (["frameReady", "frameCallback", "isAlive"].indexOf(data.method) !== -1) {
						result = null;
						method = this[data.method];
						if (method != null) {
							result = method.apply(this, data.args)
						}
					} else {
						result = typeof(_base = this.methods)[_name = data.method] === "function" ? _base[_name].apply(_base, data.args) : void 0
					}
					if (data.method !== "frameCallback") {
						return this.invoke("frameCallback", data.id, result)
					}
				};
				return RPC
			}();
			module.exports = RPC
		}).call(this)
	}
});
StripeCheckout.require.define({
	"lib/uuid": function(exports, require, module) {
		(function() {
			var S4;
			S4 = function() {
				return ((1 + Math.random()) * 65536 | 0).toString(16).substring(1)
			};
			module.exports.generate = function() {
				var delim;
				delim = "-";
				return S4() + S4() + delim + S4() + delim + S4() + delim + S4() + delim + S4() + S4() + S4()
			}
		}).call(this)
	}
});
StripeCheckout.require.define({
	"lib/pixel": function(exports, require, module) {
		(function() {
			var canTrack, encode, generateID, getCookie, getCookieID, getLocalStorageID, request, setCookie, track;
			generateID = function() {
				return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
					var r, v;
					r = Math.random() * 16 | 0;
					v = c === "x" ? r : r & 3 | 8;
					return v.toString(16)
				})
			};
			setCookie = function(name, value, options) {
				var cookie, expires;
				if (options == null) {
					options = {}
				}
				if (options.expires === true) {
					options.expires = -1
				}
				if (typeof options.expires === "number") {
					expires = new Date;
					expires.setTime(expires.getTime() + options.expires * 24 * 60 * 60 * 1e3);
					options.expires = expires
				}
				if (options.path == null) {
					options.path = "/"
				}
				value = (value + "").replace(/[^!#-+\--:<-\[\]-~]/g, encodeURIComponent);
				cookie = encodeURIComponent(name) + "=" + value;
				if (options.expires) {
					cookie += ";expires=" + options.expires.toGMTString()
				}
				if (options.path) {
					cookie += ";path=" + options.path
				}
				if (options.domain) {
					cookie += ";domain=" + options.domain
				}
				return document.cookie = cookie
			};
			getCookie = function(name) {
				var cookie, cookies, index, key, value, _i, _len;
				cookies = document.cookie.split("; ");
				for (_i = 0, _len = cookies.length; _i < _len; _i++) {
					cookie = cookies[_i];
					index = cookie.indexOf("=");
					key = decodeURIComponent(cookie.substr(0, index));
					value = decodeURIComponent(cookie.substr(index + 1));
					if (key === name) {
						return value
					}
				}
				return null
			};
			encode = function(param) {
				if (typeof param === "string") {
					return encodeURIComponent(param)
				} else {
					return encodeURIComponent(JSON.stringify(param))
				}
			};
			request = function(url, params, callback) {
				var image, k, v;
				if (params == null) {
					params = {}
				}
				params.i = (new Date).getTime();
				params = function() {
					var _results;
					_results = [];
					for (k in params) {
						v = params[k];
						_results.push("" + k + "=" + encode(v))
					}
					return _results
				}().join("&");
				image = new Image;
				if (callback) {
					image.onload = callback
				}
				image.src = "" + url + "?" + params;
				return true
			};
			canTrack = function() {
				var dnt, _ref;
				dnt = (_ref = window.navigator.doNotTrack) != null ? _ref.toString().toLowerCase() : void 0;
				switch (dnt) {
				case "1":
				case "yes":
				case "true":
					return false;
				default:
					return true
				}
			};
			getLocalStorageID = function() {
				var err, lsid;
				if (!canTrack()) {
					return "DNT"
				}
				try {
					lsid = localStorage.getItem("lsid");
					if (!lsid) {
						lsid = generateID();
						localStorage.setItem("lsid", lsid)
					}
					return lsid
				} catch (_error) {
					err = _error;
					return "NA"
				}
			};
			getCookieID = function() {
				var err, id;
				if (!canTrack()) {
					return "DNT"
				}
				try {
					id = getCookie("cid") || generateID();
					setCookie("cid", id, {
						expires: 360 * 20,
						domain: ".stripe.com"
					});
					return id
				} catch (_error) {
					err = _error;
					return "NA"
				}
			};
			track = function(event, params, callback) {
				var k, referrer, request_params, search, v;
				if (params == null) {
					params = {}
				}
				referrer = document.referrer;
				search = window.location.search;
				request_params = {
					event: event,
					rf: referrer,
					sc: search
				};
				for (k in params) {
					v = params[k];
					request_params[k] = v
				}
				request_params.lsid || (request_params.lsid = getLocalStorageID());
				request_params.cid || (request_params.cid = getCookieID());
				return request("https://q.stripe.com", request_params, callback)
			};
			module.exports.track = track;
			module.exports.getLocalStorageID = getLocalStorageID;
			module.exports.getCookieID = getCookieID
		}).call(this)
	}
});
StripeCheckout.require.define({
	"vendor/base64": function(exports, require, module) {
		var utf8Encode = function(string) {
				string = (string + "").replace(/\r\n/g, "\n").replace(/\r/g, "\n");
				var utftext = "",
					start, end;
				var stringl = 0,
					n;
				start = end = 0;
				stringl = string.length;
				for (n = 0; n < stringl; n++) {
					var c1 = string.charCodeAt(n);
					var enc = null;
					if (c1 < 128) {
						end++
					} else if (c1 > 127 && c1 < 2048) {
						enc = String.fromCharCode(c1 >> 6 | 192, c1 & 63 | 128)
					} else {
						enc = String.fromCharCode(c1 >> 12 | 224, c1 >> 6 & 63 | 128, c1 & 63 | 128)
					}
					if (enc !== null) {
						if (end > start) {
							utftext += string.substring(start, end)
						}
						utftext += enc;
						start = end = n + 1
					}
				}
				if (end > start) {
					utftext += string.substring(start, string.length)
				}
				return utftext
			};
		module.exports.encode = function(data) {
			var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
			var o1, o2, o3, h1, h2, h3, h4, bits, i = 0,
				ac = 0,
				enc = "",
				tmp_arr = [];
			if (!data) {
				return data
			}
			data = utf8Encode(data);
			do {
				o1 = data.charCodeAt(i++);
				o2 = data.charCodeAt(i++);
				o3 = data.charCodeAt(i++);
				bits = o1 << 16 | o2 << 8 | o3;
				h1 = bits >> 18 & 63;
				h2 = bits >> 12 & 63;
				h3 = bits >> 6 & 63;
				h4 = bits & 63;
				tmp_arr[ac++] = b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4)
			} while (i < data.length);
			enc = tmp_arr.join("");
			switch (data.length % 3) {
			case 1:
				enc = enc.slice(0, -2) + "==";
				break;
			case 2:
				enc = enc.slice(0, -1) + "=";
				break
			}
			return enc
		}
	}
});
StripeCheckout.require.define({
	"lib/tracker": function(exports, require, module) {
		(function() {
			var base64, config, isEventNameExisting, mixpanel, pixel, stateParameters, trace, traceSerialize, track, tracker, uuid, __indexOf = [].indexOf ||
			function(item) {
				for (var i = 0, l = this.length; i < l; i++) {
					if (i in this && this[i] === item) return i
				}
				return -1
			};
			uuid = require("lib/uuid");
			pixel = require("lib/pixel");
			base64 = require("vendor/base64");
			config = {
				enabled: false,
				tracingEnabled: false,
				eventNamePrefix: "checkout.",
				distinctId: uuid.generate(),
				mixpanelKey: null
			};
			stateParameters = {};
			tracker = {};
			tracker.setEnabled = function(enabled) {
				return config.enabled = enabled
			};
			tracker.setTracingEnabled = function(enabled) {
				return config.tracingEnabled = enabled
			};
			tracker.setDistinctID = function(value) {
				if (value) {
					return config.distinctId = value
				}
			};
			tracker.getDistinctID = function() {
				return config.distinctId
			};
			tracker.setMixpanelKey = function(mixpanelKey) {
				return config.mixpanelKey = mixpanelKey
			};
			tracker.track = {
				outerOpen: function(parameters) {
					var requiredKeys;
					requiredKeys = ["key"];
					return track("outer.open", parameters, requiredKeys, {
						appendStateParameters: false
					})
				},
				manhattanStatusSet: function(isEnabled) {
					return track("outer.manhattanStatus", {
						isEnabled: isEnabled
					})
				},
				open: function(options) {
					var k, v;
					for (k in options) {
						v = options[k];
						stateParameters["option-" + k] = v
					}
					return track("open")
				},
				close: function(parameters) {
					return track("close", parameters, ["withToken"])
				},
				keyOverride: function(values) {
					return track("config.keyOverride", values, ["configure", "open"])
				},
				localeOverride: function(values) {
					return track("config.localeOverride", values, ["configure", "open"])
				},
				imageOverride: function(values) {
					return track("config.imageOverride", values, ["configure", "open"])
				},
				rememberMe: function(parameters) {
					return track("checkbox.rememberMe", parameters, ["checked"])
				},
				authorizeAccount: function() {
					return track("account.authorize")
				},
				login: function() {
					return track("account.authorize.success")
				},
				wrongVerificationCode: function() {
					return track("account.authorize.fail")
				},
				keepMeLoggedIn: function(parameters) {
					return track("checkbox.keepMeLoggedIn", parameters, ["checked"])
				},
				logout: function() {
					return track("account.logout")
				},
				submit: function() {
					return track("submit")
				},
				invalid: function(parameters) {
					if (parameters["err"] == null && parameters["fields"] == null) {
						throw new Error("Cannot track invalid because err or fields should be provided")
					}
					return track("invalid", parameters)
				},
				tokenError: function(msg) {
					return track("token.error", {
						message: msg,
						type: "exception"
					})
				},
				moreInfo: function() {
					return track("moreInfoLink.click")
				},
				accountCreateSuccess: function() {
					return track("account.create.success")
				},
				accountCreateFail: function() {
					return track("account.create.fail")
				},
				addressAutocompleteShow: function() {
					return track("addressAutoComplete.show")
				},
				addressAutocompleteResultSelected: function() {
					return track("addressAutocomplete.result.selected")
				},
				back: function(parameters) {
					return track("back", parameters, ["from_step", "to_step"])
				},
				token: function(parameters) {
					return track("token", parameters, ["stripe_token"])
				},
				i18nLocKeyMissing: function(key) {
					return track("i18n.loc.missingKey", {
						template_key: key
					})
				},
				i18nLocPartiallyReplacedTemplate: function(key, value) {
					return track("i18n.loc.partiallyReplacedTemplate", {
						template_key: key,
						template_value: value
					})
				},
				i18nFormatLocaleMissing: function(locale) {
					return track("i18n.format.localeMissing", {
						locale: locale
					})
				},
				phoneVerificationShow: function() {
					return track("phoneVerification.show")
				},
				phoneVerificationCreate: function(parameters) {
					return track("phoneVerification.create", parameters, ["use_sms"])
				},
				phoneVerificationAuthorize: function(parameters) {
					return track("fraudCodeVerification.authorize", parameters, ["valid"])
				},
				addressVerificationShow: function() {
					return track("addressVerification.show")
				},
				alert: function(parameters) {
					return track("alert", parameters)
				}
			};
			tracker.trace = {
				trigger: function(eventName, args) {
					var EXCLUDED_EVENTS;
					EXCLUDED_EVENTS = ["didResize", "viewAddedToDOM", "valueDidChange", "checkedDidChange", "keyUp", "keyDown", "keyPress", "keyInput", "click", "blur"];
					eventName = eventName.split(".");
					if (eventName[eventName.length - 1] === "checkout") {
						eventName.pop()
					}
					eventName = eventName.join(".");
					if (__indexOf.call(EXCLUDED_EVENTS, eventName) < 0) {
						if (this._triggerQueue == null) {
							this._triggerQueue = {}
						}
						this._triggerQueue[eventName] = traceSerialize(args);
						return this._triggerTimeout != null ? this._triggerTimeout : this._triggerTimeout = setTimeout(function(_this) {
							return function() {
								var _ref;
								_ref = _this._triggerQueue;
								for (eventName in _ref) {
									args = _ref[eventName];
									trace("trigger." + eventName, {
										args: args
									})
								}
								_this._triggerQueue = {};
								return _this._triggerTimeout = null
							}
						}(this), 0)
					}
				},
				rpcInvoke: function(method) {
					return trace("rpc.invoke." + method)
				},
				rpcPostMessage: function(method, args, id) {
					return trace("rpc.postMessage." + method, {
						id: id,
						args: traceSerialize(args)
					})
				}
			};
			tracker.state = {
				setUIType: function(type) {
					return stateParameters["st-ui-type"] = type
				},
				setUIIntegration: function(integration) {
					return stateParameters["st-ui-integration"] = integration
				},
				setAccountsEnabled: function(bool) {
					return stateParameters["st-accounts-enabled"] = bool
				},
				setRememberMeEnabled: function(bool) {
					return stateParameters["st-remember-me-enabled"] = bool
				},
				setRememberMeChecked: function(bool) {
					return stateParameters["st-remember-me-checked"] = bool
				},
				setAccountCreated: function(bool) {
					return stateParameters["st-account-created"] = bool
				},
				setLoggedIn: function(bool) {
					return stateParameters["st-logged-in"] = bool
				},
				setVariants: function(variants) {
					var k, v, _results;
					_results = [];
					for (k in variants) {
						v = variants[k];
						_results.push(stateParameters["st-variant-" + k] = v)
					}
					return _results
				},
				setPhoneVerificationShown: function(bool) {
					return stateParameters["st-phone-verification-shown"] = bool
				},
				setAddressVerificationShown: function(bool) {
					return stateParameters["st-address-verification-shown"] = bool
				},
				setAlipayShouldDisplay: function(bool) {
					return stateParameters["st-alipay-should-display"] = bool
				},
				setRequestedLocale: function(locale) {
					return stateParameters["st-locale"] = locale
				}
			};
			tracker.dontTrack = function(fn) {
				var enabled;
				enabled = config.enabled;
				config.enabled = false;
				fn();
				return config.enabled = enabled
			};
			isEventNameExisting = function(eventName) {
				var exists, k, v, _ref;
				exists = false;
				_ref = tracker.events;
				for (k in _ref) {
					v = _ref[k];
					if (v === eventName) {
						exists = true;
						break
					}
				}
				return exists
			};
			trace = function(eventName, parameters, requiredKeys, options) {
				if (parameters == null) {
					parameters = {}
				}
				if (requiredKeys == null) {
					requiredKeys = []
				}
				if (options == null) {
					options = {}
				}
				if (!config.tracingEnabled) {
					return
				}
				eventName = "trace." + eventName;
				options.excludeMixpanel = true;
				return track.apply(this, arguments)
			};
			track = function(eventName, parameters, requiredKeys, options) {
				var fullEventName, k, key, missingKeys, v, _i, _len;
				if (parameters == null) {
					parameters = {}
				}
				if (requiredKeys == null) {
					requiredKeys = []
				}
				if (options == null) {
					options = {}
				}
				if (!config.enabled) {
					return
				}
				missingKeys = function() {
					var _i, _len, _results;
					_results = [];
					for (_i = 0, _len = requiredKeys.length; _i < _len; _i++) {
						key = requiredKeys[_i];
						if (!(key in parameters)) {
							_results.push(key)
						}
					}
					return _results
				}();
				if (missingKeys.length > 0) {
					throw new Error("Missing required data (" + missingKeys.join(", ") + ") for tracking " + eventName + ".")
				}
				parameters.distinct_id = config.distinctId;
				parameters.eventId = uuid.generate();
				if (options.appendStateParameters == null) {
					options.appendStateParameters = true
				}
				if (options.appendStateParameters) {
					for (k in stateParameters) {
						v = stateParameters[k];
						parameters[k] = v
					}
				}
				parameters.h = screen.height;
				parameters.w = screen.width;
				for (v = _i = 0, _len = parameters.length; _i < _len; v = ++_i) {
					k = parameters[v];
					if (v instanceof Array) {
						v.sort()
					}
				}
				fullEventName = "" + config.eventNamePrefix + eventName;
				if (!options.excludeMixpanel) {
					mixpanel.track(fullEventName, parameters)
				}
				return pixel.track(fullEventName, parameters)
			};
			mixpanel = {};
			mixpanel.track = function(eventName, options) {
				var dataStr, properties;
				if (options == null) {
					options = {}
				}
				if (!(typeof $ !== "undefined" && $ !== null && config.mixpanelKey != null)) {
					return
				}
				properties = $.extend({
					token: config.mixpanelKey,
					userAgent: window.navigator.userAgent
				}, options);
				delete properties["stripe_token"];
				dataStr = base64.encode(JSON.stringify({
					event: eventName,
					properties: properties
				}));
				return (new Image).src = "https://api.mixpanel.com/track/?ip=1&img=1&data=" + dataStr
			};
			traceSerialize = function(value) {
				var k, obj, v;
				if (value instanceof Array) {
					return JSON.stringify(function() {
						var _i, _len, _results;
						_results = [];
						for (_i = 0, _len = value.length; _i < _len; _i++) {
							v = value[_i];
							_results.push(traceSerialize(v))
						}
						return _results
					}())
				} else if (value != null && value.target != null && value.type != null) {
					return traceSerialize({
						type: value.type,
						target_id: value.target.id
					})
				} else if (value instanceof Object) {
					if (value.constructor === Object) {
						obj = {};
						for (k in value) {
							v = value[k];
							obj[k] = traceSerialize(v)
						}
						return JSON.stringify(obj)
					} else {
						return value.toString()
					}
				} else {
					return value
				}
			};
			module.exports = tracker
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/lib/fallbackRpc": function(exports, require, module) {
		(function() {
			var FallbackRPC, cacheBust, interval, lastHash, re, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};
			cacheBust = 1;
			interval = null;
			lastHash = null;
			re = /^#?\d+&/;
			FallbackRPC = function() {
				function FallbackRPC(target, host) {
					this.invokeTarget = __bind(this.invokeTarget, this);
					this.target = target;
					this.host = host
				}
				FallbackRPC.prototype.invokeTarget = function(message) {
					var url;
					message = +new Date + cacheBust+++"&" + encodeURIComponent(message);
					url = this.host + "";
					return this.target.location = url.replace(/#.*$/, "") + "#" + message
				};
				FallbackRPC.prototype.receiveMessage = function(callback, delay) {
					if (delay == null) {
						delay = 100
					}
					interval && clearInterval(interval);
					return interval = setInterval(function() {
						var hash;
						hash = decodeURIComponent(window.location.hash);
						if (hash !== lastHash && re.test(hash)) {
							window.location.hash = "";
							lastHash = hash;
							return callback({
								data: hash.replace(re, "")
							})
						}
					}, delay)
				};
				return FallbackRPC
			}();
			module.exports = FallbackRPC
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/lib/utils": function(exports, require, module) {
		(function() {
			var $, $$, addClass, append, css, hasAttr, hasClass, insertAfter, insertBefore, parents, remove, resolve, text, trigger, __indexOf = [].indexOf ||
			function(item) {
				for (var i = 0, l = this.length; i < l; i++) {
					if (i in this && this[i] === item) return i
				}
				return -1
			};
			$ = function(sel) {
				return document.querySelectorAll(sel)
			};
			$$ = function(cls) {
				var el, reg, _i, _len, _ref, _results;
				if (typeof document.getElementsByClassName === "function") {
					return document.getElementsByClassName(cls)
				} else if (typeof document.querySelectorAll === "function") {
					return document.querySelectorAll("." + cls)
				} else {
					reg = new RegExp("(^|\\s)" + cls + "(\\s|$)");
					_ref = document.getElementsByTagName("*");
					_results = [];
					for (_i = 0, _len = _ref.length; _i < _len; _i++) {
						el = _ref[_i];
						if (reg.test(el.className)) {
							_results.push(el)
						}
					}
					return _results
				}
			};
			hasAttr = function(element, attr) {
				var node;
				if (typeof element.hasAttribute === "function") {
					return element.hasAttribute(attr)
				} else {
					node = element.getAttributeNode(attr);
					return !!(node && (node.specified || node.nodeValue))
				}
			};
			trigger = function(element, name, data, bubble) {
				if (data == null) {
					data = {}
				}
				if (bubble == null) {
					bubble = true
				}
				if (window.jQuery) {
					return jQuery(element).trigger(name, data)
				}
			};
			addClass = function(element, name) {
				return element.className += " " + name
			};
			hasClass = function(element, name) {
				return __indexOf.call(element.className.split(" "), name) >= 0
			};
			css = function(element, css) {
				return element.style.cssText += ";" + css
			};
			insertBefore = function(element, child) {
				return element.parentNode.insertBefore(child, element)
			};
			insertAfter = function(element, child) {
				return element.parentNode.insertBefore(child, element.nextSibling)
			};
			append = function(element, child) {
				return element.appendChild(child)
			};
			remove = function(element) {
				var _ref;
				return (_ref = element.parentNode) != null ? _ref.removeChild(element) : void 0
			};
			parents = function(node) {
				var ancestors;
				ancestors = [];
				while ((node = node.parentNode) && node !== document && __indexOf.call(ancestors, node) < 0) {
					ancestors.push(node)
				}
				return ancestors
			};
			resolve = function(url) {
				var parser;
				parser = document.createElement("a");
				parser.href = url;
				return "" + parser.href
			};
			text = function(element, value) {
				if ("innerText" in element) {
					element.innerText = value
				} else {
					element.textContent = value
				}
				return value
			};
			module.exports = {
				$: $,
				$$: $$,
				hasAttr: hasAttr,
				trigger: trigger,
				addClass: addClass,
				hasClass: hasClass,
				css: css,
				insertBefore: insertBefore,
				insertAfter: insertAfter,
				append: append,
				remove: remove,
				parents: parents,
				resolve: resolve,
				text: text
			}
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/controllers/app": function(exports, require, module) {
		(function() {
			var App, Checkout, RPC, TokenCallback, tracker, utils, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};
			Checkout = require("outer/controllers/checkout");
			TokenCallback = require("outer/controllers/tokenCallback");
			RPC = require("lib/rpc");
			tracker = require("lib/tracker");
			utils = require("outer/lib/utils");
			App = function() {
				function App(options) {
					var _ref, _ref1;
					if (options == null) {
						options = {}
					}
					this.setForceManhattan = __bind(this.setForceManhattan, this);
					this.getHost = __bind(this.getHost, this);
					this.setHost = __bind(this.setHost, this);
					this.configure = __bind(this.configure, this);
					this.close = __bind(this.close, this);
					this.open = __bind(this.open, this);
					this.configurations = {};
					this.checkouts = {};
					this.constructorOptions = {
						host: "https://checkout.stripe.com",
						forceManhattan: false
					};
					this.timeLoaded = Math.floor((new Date).getTime() / 1e3);
					this.totalButtons = 0;
					if (((_ref = window.Prototype) != null ? (_ref1 = _ref.Version) != null ? _ref1.indexOf("1.6") : void 0 : void 0) === 0) {
						console.error("Stripe Checkout is not compatible with your version of Prototype.js. Please upgrade to version 1.7 or greater.")
					}
				}
				App.prototype.open = function(options, buttonId) {
					var checkout, k, mergedOptions, v, _ref;
					if (options == null) {
						options = {}
					}
					if (buttonId == null) {
						buttonId = null
					}
					mergedOptions = {
						referrer: document.referrer,
						url: document.URL,
						timeLoaded: this.timeLoaded
					};
					if (buttonId && this.configurations[buttonId]) {
						_ref = this.configurations[buttonId];
						for (k in _ref) {
							v = _ref[k];
							mergedOptions[k] = v
						}
					}
					for (k in options) {
						v = options[k];
						mergedOptions[k] = v
					}
					if (mergedOptions.image) {
						mergedOptions.image = utils.resolve(mergedOptions.image)
					}
					this.validateOptions(options, "open");
					if (buttonId) {
						checkout = this.checkouts[buttonId];
						if (options.token != null || options.onToken != null) {
							checkout.setOnToken(new TokenCallback(options))
						}
					} else {
						checkout = new Checkout(new TokenCallback(options), this.constructorOptions)
					}
					this.trackOpen(checkout, mergedOptions);
					return checkout.open(mergedOptions)
				};
				App.prototype.close = function(buttonId) {
					var _ref;
					return (_ref = this.checkouts[buttonId]) != null ? _ref.close() : void 0
				};
				App.prototype.configure = function(buttonId, options) {
					if (options == null) {
						options = {}
					}
					if (buttonId instanceof Object) {
						options = buttonId;
						buttonId = "button" + this.totalButtons++
					}
					if (options.image) {
						options.image = utils.resolve(options.image)
					}
					this.validateOptions(options, "configure");
					this.configurations[buttonId] = options;
					this.checkouts[buttonId] = new Checkout(new TokenCallback(options), this.constructorOptions);
					this.checkouts[buttonId].preload(options);
					return {
						open: function(_this) {
							return function(options) {
								return _this.open(options, buttonId)
							}
						}(this),
						close: function(_this) {
							return function() {
								return _this.close(buttonId)
							}
						}(this)
					}
				};
				App.prototype.validateOptions = function(options, which) {
					var url;
					try {
						return JSON.stringify(options)
					} catch (_error) {
						url = "https://stripe.com/docs/checkout#integration-custom";
						throw new Error("Stripe Checkout was unable to serialize the options passed to StripeCheckout." + which + "(). Please consult the doumentation to confirm that you're supplying values of the expected type: " + url)
					}
				};
				App.prototype.setHost = function(host) {
					return this.constructorOptions.host = host
				};
				App.prototype.getHost = function() {
					return this.constructorOptions.host
				};
				App.prototype.setForceManhattan = function(force) {
					return this.constructorOptions.forceManhattan = !! force
				};
				App.prototype.trackOpen = function(checkout, options) {
					tracker.setEnabled(!options.notrack);
					return tracker.track.outerOpen({
						key: options.key,
						lsid: "NA",
						cid: "NA"
					})
				};
				return App
			}();
			module.exports = App
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/controllers/button": function(exports, require, module) {
		(function() {
			var $$, Button, addClass, append, hasAttr, hasClass, helpers, insertAfter, parents, text, trigger, _ref, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};
			_ref = require("outer/lib/utils"), $$ = _ref.$$, hasClass = _ref.hasClass, addClass = _ref.addClass, trigger = _ref.trigger, append = _ref.append, text = _ref.text, parents = _ref.parents, insertAfter = _ref.insertAfter, hasAttr = _ref.hasAttr;
			helpers = require("lib/helpers");
			Button = function() {
				Button.totalButtonId = 0;
				Button.load = function(app) {
					var button, el, element;
					element = $$("stripe-button");
					element = function() {
						var _i, _len, _results;
						_results = [];
						for (_i = 0, _len = element.length; _i < _len; _i++) {
							el = element[_i];
							if (!hasClass(el, "active")) {
								_results.push(el)
							}
						}
						return _results
					}();
					element = element[element.length - 1];
					if (!element) {
						return
					}
					addClass(element, "active");
					button = new Button(element, app);
					return button.append()
				};

				function Button(scriptEl, app) {
					this.parseOptions = __bind(this.parseOptions, this);
					this.parentHead = __bind(this.parentHead, this);
					this.parentForm = __bind(this.parentForm, this);
					this.onToken = __bind(this.onToken, this);
					this.open = __bind(this.open, this);
					this.submit = __bind(this.submit, this);
					this.append = __bind(this.append, this);
					this.render = __bind(this.render, this);
					var _base;
					this.scriptEl = scriptEl;
					this.app = app;
					this.document = this.scriptEl.ownerDocument;
					this.nostyle = helpers.isFallback();
					this.options = this.parseOptions();
					(_base = this.options).label || (_base.label = "Pay with Card");
					this.options.token = this.onToken;
					this.$el = document.createElement("button");
					this.$el.setAttribute("type", "submit");
					this.$el.className = "stripe-button-el";
					helpers.bind(this.$el, "click", this.submit);
					helpers.bind(this.$el, "touchstart", function() {});
					this.render()
				}
				Button.prototype.render = function() {
					this.$el.innerHTML = "";
					this.$span = document.createElement("span");
					text(this.$span, this.options.label);
					if (!this.nostyle) {
						this.$el.style.visibility = "hidden";
						this.$span.style.display = "block";
						this.$span.style.minHeight = "30px"
					}
					this.$style = document.createElement("link");
					this.$style.setAttribute("type", "text/css");
					this.$style.setAttribute("rel", "stylesheet");
					this.$style.setAttribute("href", this.app.getHost() + "/v3/checkout/button-qpwW2WfkB0oGWVWIASjIOQ.css");
					return append(this.$el, this.$span)
				};
				Button.prototype.append = function() {
					var head;
					if (this.scriptEl) {
						insertAfter(this.scriptEl, this.$el)
					}
					if (!this.nostyle) {
						head = this.parentHead();
						if (head) {
							append(head, this.$style)
						}
					}
					if (this.$form = this.parentForm()) {
						helpers.unbind(this.$form, "submit", this.submit);
						helpers.bind(this.$form, "submit", this.submit)
					}
					if (!this.nostyle) {
						setTimeout(function(_this) {
							return function() {
								return _this.$el.style.visibility = "visible"
							}
						}(this), 1e3)
					}
					this.app.setHost(helpers.host(this.scriptEl.src));
					return this.appHandler = this.app.configure(this.options, {
						form: this.$form
					})
				};
				Button.prototype.disable = function() {
					return this.$el.setAttribute("disabled", true)
				};
				Button.prototype.enable = function() {
					return this.$el.removeAttribute("disabled")
				};
				Button.prototype.isDisabled = function() {
					return hasAttr(this.$el, "disabled")
				};
				Button.prototype.submit = function(e) {
					if (typeof e.preventDefault === "function") {
						e.preventDefault()
					}
					if (!this.isDisabled()) {
						this.open()
					}
					return false
				};
				Button.prototype.open = function() {
					return this.appHandler.open(this.options)
				};
				Button.prototype.onToken = function(token, args) {
					var $input, $tokenInput, $tokenTypeInput, key, value;
					trigger(this.scriptEl, "token", token);
					if (this.$form) {
						$tokenInput = this.renderInput("stripeToken", token.id);
						append(this.$form, $tokenInput);
						$tokenTypeInput = this.renderInput("stripeTokenType", token.type);
						append(this.$form, $tokenTypeInput);
						if (token.email) {
							append(this.$form, this.renderInput("stripeEmail", token.email))
						}
						if (args) {
							for (key in args) {
								value = args[key];
								$input = this.renderInput(this.formatKey(key), value);
								append(this.$form, $input)
							}
						}
						this.$form.submit()
					}
					return this.disable()
				};
				Button.prototype.formatKey = function(key) {
					var arg, args, _i, _len;
					args = key.split("_");
					key = "";
					for (_i = 0, _len = args.length; _i < _len; _i++) {
						arg = args[_i];
						if (arg.length > 0) {
							key = key + arg.substr(0, 1).toUpperCase() + arg.substr(1).toLowerCase()
						}
					}
					return "stripe" + key
				};
				Button.prototype.renderInput = function(name, value) {
					var input;
					input = document.createElement("input");
					input.type = "hidden";
					input.name = name;
					input.value = value;
					return input
				};
				Button.prototype.parentForm = function() {
					var el, elements, _i, _len, _ref1;
					elements = parents(this.$el);
					for (_i = 0, _len = elements.length; _i < _len; _i++) {
						el = elements[_i];
						if (((_ref1 = el.tagName) != null ? _ref1.toLowerCase() : void 0) === "form") {
							return el
						}
					}
					return null
				};
				Button.prototype.parentHead = function() {
					var _ref1, _ref2;
					return ((_ref1 = this.document) != null ? _ref1.head : void 0) || ((_ref2 = this.document) != null ? _ref2.getElementsByTagName("head")[0] : void 0) || this.document.body
				};
				Button.prototype.parseOptions = function() {
					var attr, match, options, _i, _len, _ref1;
					options = {};
					_ref1 = this.scriptEl.attributes;
					for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
						attr = _ref1[_i];
						match = attr.name.match(/^data-(.+)$/);
						if (match != null ? match[1] : void 0) {
							options[match[1]] = attr.value
						}
					}
					return options
				};
				return Button
			}();
			module.exports = Button
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/controllers/checkout": function(exports, require, module) {
		(function() {
			var Checkout, FallbackView, IframeView, TabView, helpers, tracker, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};
			helpers = require("lib/helpers");
			IframeView = require("outer/views/iframeView");
			TabView = require("outer/views/tabView");
			FallbackView = require("outer/views/fallbackView");
			tracker = require("lib/tracker");
			Checkout = function() {
				Checkout.activeView = null;

				function Checkout(tokenCallback, options) {
					this.shouldUseManhattan = __bind(this.shouldUseManhattan, this);
					this.onTokenCallback = __bind(this.onTokenCallback, this);
					this.preload = __bind(this.preload, this);
					this.open = __bind(this.open, this);
					this.createView = __bind(this.createView, this);
					this.setOnToken = __bind(this.setOnToken, this);
					this.host = options.host;
					this.forceManhattan = options.forceManhattan;
					this.opened = false;
					this.setOnToken(tokenCallback);
					this.shouldPopup = helpers.isSupportedMobileOS() && !(helpers.isNativeWebContainer() || helpers.isAndroidWebapp() || helpers.isiOSWebView() || helpers.isiOSBroken());
					this.shouldUseManhattan(this.createView)
				}
				Checkout.prototype.setOnToken = function(tokenCallback) {
					var _ref;
					this.tokenCallback = tokenCallback;
					this.onToken = function(_this) {
						return function(data) {
							return tokenCallback.trigger(data.token, data.args, _this.onTokenCallback)
						}
					}(this);
					return (_ref = this.view) != null ? _ref.onToken = this.onToken : void 0
				};
				Checkout.prototype.createView = function(useManhattan) {
					var path, viewClass;
					if (useManhattan == null) {
						useManhattan = false
					}
					if (this.view != null) {
						return
					}
					tracker.track.manhattanStatusSet(useManhattan);
					if (helpers.isFallback()) {
						viewClass = FallbackView;
						path = "/v3/fallback/v1Sn8LtEcoTbqO8b7JtLQ.html"
					} else {
						if (this.shouldPopup) {
							viewClass = TabView
						} else {
							viewClass = IframeView
						}
						if (useManhattan) {
							path = "/m/v3/index-b79e64557e8abd54946c50690a95d6fd.html"
						} else {
							path = "/v3/1KEFxlJCskQEy38g9UVvQ.html"
						}
					}
					path = "" + path + "?distinct_id=" + tracker.getDistinctID();
					this.view = new viewClass(this.onToken, this.host, path);
					if (this.preloadOptions != null) {
						this.view.preload(this.preloadOptions);
						return this.preloadOptions = null
					}
				};
				Checkout.prototype.open = function(options) {
					var iframeFallback;
					if (options == null) {
						options = {}
					}
					this.createView();
					this.opened = true;
					if (Checkout.activeView && Checkout.activeView !== this.view) {
						Checkout.activeView.close()
					}
					Checkout.activeView = this.view;
					options.supportsTokenCallback = this.tokenCallback.supportsTokenCallback();
					iframeFallback = function() {
						if (!(this.view instanceof TabView)) {
							return
						}
						this.view = new IframeView(this.onToken, this.host, "/v3/1KEFxlJCskQEy38g9UVvQ.html");
						return this.open(options)
					};
					if (helpers.isiOSChrome() && !helpers.isUserGesture()) {
						return iframeFallback()
					}
					return this.view.open(options, function(_this) {
						return function(status) {
							if (!status) {
								return iframeFallback()
							}
						}
					}(this))
				};
				Checkout.prototype.close = function() {
					var _ref;
					return (_ref = this.view) != null ? _ref.close() : void 0
				};
				Checkout.prototype.preload = function(options) {
					if (this.view != null) {
						return this.view.preload(options)
					} else {
						return this.preloadOptions = options
					}
				};
				Checkout.prototype.onTokenCallback = function() {
					return this.view.triggerTokenCallback.apply(this.view, arguments)
				};
				Checkout.prototype.shouldUseManhattan = function(cb) {
					var manhattanRequest;
					if (true || helpers.isFallback() || this.shouldPopup) {
						cb(false);
						return
					}
					if (this.manhattanFlagState != null) {
						cb(this.manhattanFlagState)
					}
					manhattanRequest = new XMLHttpRequest;
					manhattanRequest.onreadystatechange = function(_this) {
						return function() {
							var data;
							if (manhattanRequest.readyState !== 4) {
								return
							}
							if (manhattanRequest.status === 200) {
								data = JSON.parse(manhattanRequest.responseText);
								if (_this.forceManhattan != null) {
									_this.manhattanFlagState = _this.forceManhattan
								} else {
									_this.manhattanFlagState = !! data.is_on
								}
							} else {
								_this.manhattanFlagState = false
							}
							return cb(_this.manhattanFlagState)
						}
					}(this);
					manhattanRequest.open("GET", this.host + "/api/outer/manhattan", true);
					return manhattanRequest.send()
				};
				return Checkout
			}();
			module.exports = Checkout
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/controllers/tokenCallback": function(exports, require, module) {
		(function() {
			var TokenCallback, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				};
			TokenCallback = function() {
				function TokenCallback(options) {
					this.supportsTokenCallback = __bind(this.supportsTokenCallback, this);
					this.trigger = __bind(this.trigger, this);
					if (options.token) {
						this.fn = options.token;
						this.version = 1
					} else if (options.onToken) {
						this.fn = options.onToken;
						this.version = 2
					}
				}
				TokenCallback.prototype.trigger = function(token, addresses, callback) {
					var data, k, shipping, v;
					if (this.version === 2) {
						data = {
							token: token
						};
						shipping = null;
						for (k in addresses) {
							v = addresses[k];
							if (/^shipping_/.test(k)) {
								if (shipping == null) {
									shipping = {}
								}
								shipping[k.replace(/^shipping_/, "")] = v
							}
						}
						if (shipping != null) {
							data.shipping = shipping
						}
						return this.fn(data, callback)
					} else {
						return this.fn(token, addresses)
					}
				};
				TokenCallback.prototype.supportsTokenCallback = function() {
					return this.version > 1
				};
				return TokenCallback
			}();
			module.exports = TokenCallback
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/views/fallbackView": function(exports, require, module) {
		(function() {
			var FallbackRPC, FallbackView, View, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				},
				__hasProp = {}.hasOwnProperty,
				__extends = function(child, parent) {
					for (var key in parent) {
						if (__hasProp.call(parent, key)) child[key] = parent[key]
					}

					function ctor() {
						this.constructor = child
					}
					ctor.prototype = parent.prototype;
					child.prototype = new ctor;
					child.__super__ = parent.prototype;
					return child
				};
			FallbackRPC = require("outer/lib/fallbackRpc");
			View = require("outer/views/view");
			FallbackView = function(_super) {
				__extends(FallbackView, _super);

				function FallbackView() {
					this.triggerTokenCallback = __bind(this.triggerTokenCallback, this);
					this.close = __bind(this.close, this);
					this.open = __bind(this.open, this);
					FallbackView.__super__.constructor.apply(this, arguments)
				}
				FallbackView.prototype.open = function(options, callback) {
					var message, url;
					FallbackView.__super__.open.apply(this, arguments);
					url = this.host + this.path;
					this.frame = window.open(url, "stripe_checkout_app", "width=400,height=400,location=yes,resizable=yes,scrollbars=yes");
					if (this.frame == null) {
						alert("Disable your popup blocker to proceed with checkout.");
						url = "https://stripe.com/docs/checkout#integration-more-runloop";
						throw new Error("To learn how to prevent the Stripe Checkout popup from being blocked, please visit " + url)
					}
					this.rpc = new FallbackRPC(this.frame, url);
					this.rpc.receiveMessage(function(_this) {
						return function(e) {
							var data;
							try {
								data = JSON.parse(e.data)
							} catch (_error) {
								return
							}
							return _this.onToken(data)
						}
					}(this));
					message = JSON.stringify(this.options);
					this.rpc.invokeTarget(message);
					return callback(true)
				};
				FallbackView.prototype.close = function() {
					var _ref;
					return (_ref = this.frame) != null ? _ref.close() : void 0
				};
				FallbackView.prototype.triggerTokenCallback = function(err) {
					if (err) {
						return alert(err)
					}
				};
				return FallbackView
			}(View);
			module.exports = FallbackView
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/views/iframeView": function(exports, require, module) {
		(function() {
			var IframeView, RPC, View, helpers, ready, utils, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				},
				__hasProp = {}.hasOwnProperty,
				__extends = function(child, parent) {
					for (var key in parent) {
						if (__hasProp.call(parent, key)) child[key] = parent[key]
					}

					function ctor() {
						this.constructor = child
					}
					ctor.prototype = parent.prototype;
					child.prototype = new ctor;
					child.__super__ = parent.prototype;
					return child
				};
			utils = require("outer/lib/utils");
			helpers = require("lib/helpers");
			RPC = require("lib/rpc");
			View = require("outer/views/view");
			ready = require("vendor/ready");
			IframeView = function(_super) {
				__extends(IframeView, _super);

				function IframeView() {
					this.configure = __bind(this.configure, this);
					this.removeFrame = __bind(this.removeFrame, this);
					this.removeTouchOverlay = __bind(this.removeTouchOverlay, this);
					this.showTouchOverlay = __bind(this.showTouchOverlay, this);
					this.attachIframe = __bind(this.attachIframe, this);
					this.setToken = __bind(this.setToken, this);
					this.closed = __bind(this.closed, this);
					this.close = __bind(this.close, this);
					this.preload = __bind(this.preload, this);
					this.opened = __bind(this.opened, this);
					this.open = __bind(this.open, this);
					return IframeView.__super__.constructor.apply(this, arguments)
				}
				IframeView.prototype.open = function(options, callback) {
					IframeView.__super__.open.apply(this, arguments);
					return ready(function(_this) {
						return function() {
							var left, loaded, _ref;
							_this.originalOverflowValue = document.body.style.overflow;
							if (_this.frame == null) {
								_this.configure()
							}
							if (typeof $ !== "undefined" && $ !== null ? (_ref = $.fn) != null ? _ref.modal : void 0 : void 0) {
								$(document).off("focusin.bs.modal").off("focusin.modal")
							}
							_this.frame.style.display = "block";
							if (_this.shouldShowTouchOverlay()) {
								_this.showTouchOverlay();
								_this.frame.style.top = (window.scrollY || window.pageYOffset) + "px";
								left = (window.scrollX || window.pageXOffset) + (window.innerWidth - _this.iframeWidth()) / 2;
								left = Math.min(window.innerWidth - _this.iframeWidth(), Math.max(0, left));
								left = Math.max(0, left);
								_this.frame.style.left = left + "px"
							}
							loaded = false;
							setTimeout(function() {
								if (loaded) {
									return
								}
								loaded = true;
								callback(false);
								return _this.removeFrame()
							}, 8e3);
							return _this.rpc.ready(function() {
								if (loaded) {
									return
								}
								loaded = true;
								callback(true);
								_this.rpc.invoke("render", "", "iframe", _this.options);
								document.body.style.overflow = "hidden";
								return _this.rpc.invoke("open", {
									timeLoaded: _this.options.timeLoaded
								})
							})
						}
					}(this))
				};
				IframeView.prototype.opened = function() {
					var _base;
					return typeof(_base = this.options).opened === "function" ? _base.opened() : void 0
				};
				IframeView.prototype.preload = function(options) {
					return ready(function(_this) {
						return function() {
							_this.configure();
							return _this.rpc.invoke("preload", options)
						}
					}(this))
				};
				IframeView.prototype.iframeWidth = function() {
					if (helpers.isSmallScreen()) {
						return 328
					} else {
						return 380
					}
				};
				IframeView.prototype.close = function() {
					if ( !! this.rpc.target.window) {
						return this.rpc.invoke("close")
					}
				};
				IframeView.prototype.closed = function(e) {
					var tokenReceived, _base;
					tokenReceived = this.token != null;
					document.body.style.overflow = this.originalOverflowValue;
					this.removeFrame();
					clearTimeout(this.tokenTimeout);
					if (tokenReceived) {
						this.onToken(this.token)
					}
					this.token = null;
					if (typeof(_base = this.options).closed === "function") {
						_base.closed()
					}
					if ((e != null ? e.type : void 0) === "error.close") {
						return alert(e.message)
					} else if (!tokenReceived) {
						return this.preload(this.options)
					}
				};
				IframeView.prototype.setToken = function(data) {
					this.token = data;
					return this.tokenTimeout != null ? this.tokenTimeout : this.tokenTimeout = setTimeout(function(_this) {
						return function() {
							_this.onToken(_this.token);
							_this.tokenTimeout = null;
							return _this.token = null
						}
					}(this), 3e3)
				};
				IframeView.prototype.attachIframe = function() {
					var cssText, iframe;
					iframe = document.createElement("iframe");
					iframe.setAttribute("frameBorder", "0");
					iframe.setAttribute("allowtransparency", "true");
					cssText = "z-index: 9999;\ndisplay: none;\nbackground: transparent;\nbackground: rgba(0,0,0,0.005);\nborder: 0px none transparent;\noverflow-x: hidden;\noverflow-y: auto;\nvisibility: hidden;\nmargin: 0;\npadding: 0;\n-webkit-tap-highlight-color: transparent;\n-webkit-touch-callout: none;";
					if (this.shouldShowTouchOverlay()) {
						cssText += "position: absolute;\nwidth: " + this.iframeWidth() + "px;\nheight: 100%;"
					} else {
						cssText += "position: fixed;\nleft: 0;\ntop: 0;\nwidth: 100%;\nheight: 100%;"
					}
					iframe.style.cssText = cssText;
					helpers.bind(iframe, "load", function() {
						return iframe.style.visibility = "visible"
					});
					iframe.src = this.host + this.path;
					iframe.className = iframe.name = "stripe_checkout_app";
					utils.append(document.body, iframe);
					return iframe
				};
				IframeView.prototype.showTouchOverlay = function() {
					var toRepaint;
					if (this.overlay) {
						return
					}
					this.overlay = document.createElement("div");
					this.overlay.style.cssText = "z-index: 9998;\nbackground: #000;\nopacity: 0;\nborder: 0px none transparent;\noverflow: none;\nmargin: 0;\npadding: 0;\n-webkit-tap-highlight-color: transparent;\n-webkit-touch-callout: none;\nposition: fixed;\nleft: 0;\ntop: 0;\nwidth: 200%;\nheight: 200%;\ntransition: opacity 320ms ease;\n-webkit-transition: opacity 320ms ease;\n-moz-transition: opacity 320ms ease;\n-ms-transition: opacity 320ms ease;";
					utils.append(document.body, this.overlay);
					toRepaint = this.overlay.offsetHeight;
					return this.overlay.style.opacity = "0.5"
				};
				IframeView.prototype.removeTouchOverlay = function() {
					var overlay;
					if (!this.overlay) {
						return
					}
					overlay = this.overlay;
					overlay.style.opacity = "0";
					setTimeout(function() {
						return utils.remove(overlay)
					}, 400);
					return this.overlay = null
				};
				IframeView.prototype.removeFrame = function() {
					var frame;
					if (this.shouldShowTouchOverlay()) {
						this.removeTouchOverlay()
					}
					frame = this.frame;
					setTimeout(function() {
						return utils.remove(frame)
					}, 500);
					return this.frame = null
				};
				IframeView.prototype.configure = function() {
					if (this.frame != null) {
						this.removeFrame()
					}
					this.frame = this.attachIframe();
					this.rpc = new RPC(this.frame.contentWindow, {
						host: this.host
					});
					this.rpc.methods.closed = this.closed;
					this.rpc.methods.setToken = this.setToken;
					return this.rpc.methods.opened = this.opened
				};
				IframeView.prototype.shouldShowTouchOverlay = function() {
					return helpers.isSupportedMobileOS()
				};
				return IframeView
			}(View);
			module.exports = IframeView
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/views/tabView": function(exports, require, module) {
		(function() {
			var RPC, TabView, View, helpers, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				},
				__hasProp = {}.hasOwnProperty,
				__extends = function(child, parent) {
					for (var key in parent) {
						if (__hasProp.call(parent, key)) child[key] = parent[key]
					}

					function ctor() {
						this.constructor = child
					}
					ctor.prototype = parent.prototype;
					child.prototype = new ctor;
					child.__super__ = parent.prototype;
					return child
				};
			RPC = require("lib/rpc");
			helpers = require("lib/helpers");
			View = require("outer/views/view");
			TabView = function(_super) {
				__extends(TabView, _super);

				function TabView() {
					this.closed = __bind(this.closed, this);
					this.checkForClosedTab = __bind(this.checkForClosedTab, this);
					this.setToken = __bind(this.setToken, this);
					this.fullPath = __bind(this.fullPath, this);
					this.close = __bind(this.close, this);
					this.open = __bind(this.open, this);
					TabView.__super__.constructor.apply(this, arguments);
					this.closedTabInterval = null;
					this.color = null;
					this.colorSet = false
				}
				TabView.prototype.open = function(options, callback) {
					var targetName, url, _base, _ref, _ref1;
					TabView.__super__.open.apply(this, arguments);
					try {
						if ((_ref = this.frame) != null) {
							_ref.close()
						}
					} catch (_error) {}
					if (window.name === "stripe_checkout_tabview") {
						window.name = ""
					}
					if (helpers.isiOSChrome()) {
						targetName = "_blank"
					} else {
						targetName = "stripe_checkout_tabview"
					}
					this.frame = window.open(this.fullPath(), targetName);
					if (!this.frame && ((_ref1 = this.options.key) != null ? _ref1.indexOf("test") : void 0) !== -1) {
						url = "https://stripe.com/docs/checkout#integration-more-runloop";
						console.error("Stripe Checkout was unable to open a new window, possibly due to a popup blocker.\nTo provide the best experience for your users, follow the guide at " + url + ".\nThis message will only appear when using a test publishable key.")
					}
					if (!this.frame || this.frame === window) {
						this.close();
						callback(false);
						return
					}
					if (typeof(_base = this.frame).focus === "function") {
						_base.focus()
					}
					this.rpc = new RPC(this.frame, {
						host: this.host
					});
					this.rpc.methods.setToken = this.setToken;
					this.rpc.methods.closed = this.closed;
					return this.rpc.ready(function(_this) {
						return function() {
							var _base1;
							callback(true);
							_this.rpc.invoke("render", "", "tab", _this.options);
							_this.rpc.invoke("open");
							if (typeof(_base1 = _this.options).opened === "function") {
								_base1.opened()
							}
							return _this.checkForClosedTab()
						}
					}(this))
				};
				TabView.prototype.close = function() {
					if (this.frame && this.frame !== window) {
						return this.frame.close()
					}
				};
				TabView.prototype.fullPath = function() {
					return this.host + this.path
				};
				TabView.prototype.setToken = function(data) {
					this.token = data;
					return this.tokenTimeout != null ? this.tokenTimeout : this.tokenTimeout = setTimeout(function(_this) {
						return function() {
							_this.onToken(_this.token);
							_this.tokenTimeout = null;
							return _this.token = null
						}
					}(this), 3e3)
				};
				TabView.prototype.checkForClosedTab = function() {
					if (this.closedTabInterval) {
						clearInterval(this.closedTabInterval)
					}
					return this.closedTabInterval = setInterval(function(_this) {
						return function() {
							if (!_this.frame || !_this.frame.postMessage || _this.frame.closed) {
								return _this.closed()
							}
						}
					}(this), 100)
				};
				TabView.prototype.closed = function() {
					var _base;
					clearInterval(this.closedTabInterval);
					clearTimeout(this.tokenTimeout);
					if (this.token != null) {
						this.onToken(this.token)
					}
					return typeof(_base = this.options).closed === "function" ? _base.closed() : void 0
				};
				return TabView
			}(View);
			module.exports = TabView
		}).call(this)
	}
});
StripeCheckout.require.define({
	"outer/views/view": function(exports, require, module) {
		(function() {
			var View, __bind = function(fn, me) {
					return function() {
						return fn.apply(me, arguments)
					}
				},
				__slice = [].slice;
			View = function() {
				function View(onToken, host, path) {
					this.triggerTokenCallback = __bind(this.triggerTokenCallback, this);
					this.open = __bind(this.open, this);
					this.onToken = onToken;
					this.host = host;
					this.path = path
				}
				View.prototype.open = function(options, callback) {
					return this.options = options
				};
				View.prototype.close = function() {};
				View.prototype.preload = function(options) {};
				View.prototype.triggerTokenCallback = function() {
					var args;
					args = arguments;
					return this.rpc.ready(function(_this) {
						return function() {
							var _ref;
							return (_ref = _this.rpc).invoke.apply(_ref, ["tokenCallback"].concat(__slice.call(args)))
						}
					}(this))
				};
				return View
			}();
			module.exports = View
		}).call(this)
	}
});
(function() {
	var App, Button, app, require, _ref, _ref1, _ref2;
	require = require || this.StripeCheckout.require;
	Button = require("outer/controllers/button");
	App = require("outer/controllers/app");
	if (((_ref = this.StripeCheckout) != null ? _ref.__app : void 0) == null) {
		this.StripeCheckout || (this.StripeCheckout = {});
		this.StripeCheckout.__app = app = new App;
		this.StripeCheckout.open = app.open;
		this.StripeCheckout.configure = app.configure;
		this.StripeButton = this.StripeCheckout;
		if (((_ref1 = this.StripeCheckout) != null ? _ref1.__forceManhattan : void 0) != null) {
			app.setForceManhattan(this.StripeCheckout.__forceManhattan)
		}
		if (((_ref2 = this.StripeCheckout) != null ? _ref2.__host : void 0) && this.StripeCheckout.__host !== "") {
			app.setHost(this.StripeCheckout.__host)
		}
	}
	Button.load(this.StripeCheckout.__app)
}).call(this);