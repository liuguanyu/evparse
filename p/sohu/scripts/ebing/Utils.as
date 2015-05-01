package ebing {
	import flash.utils.ByteArray;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	public class Utils extends Object {
		
		public function Utils() {
			super();
			trace("ok");
		}
		
		public static function fomatTime(param1:Number) : String {
			var _loc2_:Number = param1 / 60;
			var _loc3_:String = String(Math.floor(_loc2_));
			var _loc4_:String = String(Math.floor(param1 % 60));
			if(_loc3_.length == 1) {
				_loc3_ = "0" + _loc3_;
			}
			if(_loc4_.length == 1) {
				_loc4_ = "0" + _loc4_;
			}
			return _loc3_ + ":" + _loc4_;
		}
		
		public static function fomatSpeed(param1:Number, param2:Boolean = true) : * {
			var _loc5_:Object = null;
			var param1:Number = isNaN(param1)?0:param1;
			var _loc3_:Number = 0;
			var _loc4_:* = "";
			if(param1 >= Math.pow(1024,3)) {
				_loc3_ = param1 / Math.pow(1024,3);
				_loc4_ = "GBPS";
			} else if(param1 >= Math.pow(1024,2)) {
				_loc3_ = param1 / Math.pow(1024,2);
				_loc4_ = "MBPS";
			} else if(param1 >= 1024) {
				_loc3_ = param1 / 1024;
				_loc4_ = "KBPS";
			} else {
				_loc3_ = param1;
				_loc4_ = "BPS";
			}
			
			
			_loc3_ = Utils.numberFormat(_loc3_,2);
			if(param2) {
				return _loc3_ + _loc4_;
			}
			_loc5_ = {
				"speed":_loc3_,
				"units":_loc4_
			};
			return _loc5_;
		}
		
		public static function clone(param1:Object) : * {
			var _loc2_:ByteArray = new ByteArray();
			_loc2_.writeObject(param1);
			_loc2_.position = 0;
			return _loc2_.readObject();
		}
		
		public static function debug(param1:String) : void {
		}
		
		public static function alert(param1:String) : void {
			if(Eif.available) {
				ExternalInterface.call("alert",param1);
			}
		}
		
		public static function drawRect(param1:*, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void {
			param1.graphics.beginFill(param6,param7);
			param1.graphics.drawRect(param2,param3,param4,param5);
			param1.graphics.endFill();
		}
		
		public static function drawRoundRect(param1:*, param2:Number, param3:Number, param4:Number, param5:Number, param6:*, param7:Number, param8:Number) : void {
			param1.graphics.beginFill(param7,param8);
			param1.graphics.drawRoundRect(param2,param3,param4,param5,param6);
			param1.graphics.endFill();
		}
		
		public static function drawCircle(param1:*, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void {
			param1.graphics.beginFill(param5,param6);
			param1.graphics.drawCircle(param2,param3,param4);
			param1.graphics.endFill();
		}
		
		public static function numberFormat(param1:Number, param2:uint) : Number {
			var _loc4_:uint = 0;
			var _loc3_:* = "1";
			var _loc5_:uint = 0;
			while(_loc5_ < param2) {
				_loc3_ = _loc3_ + "0";
				_loc5_++;
			}
			_loc4_ = uint(_loc3_);
			return Math.round(param1 * _loc4_) / _loc4_;
		}
		
		public static function prorata(param1:Object, param2:Number, param3:Number) : void {
			if(param1.width / param1.height > param2 / param3) {
				param1.height = param2 / param1.width * param1.height;
				param1.width = param2;
			} else if(param1.width / param1.height < param2 / param3) {
				param1.width = param3 / param1.height * param1.width;
				param1.height = param3;
			} else {
				param1.width = param2;
				param1.height = param3;
			}
			
		}
		
		public static function setCenterByNumber(param1:Object, param2:Number, param3:Number) : void {
			param1.x = Math.round((param2 - param1.width) / 2);
			param1.y = Math.round((param3 - param1.height) / 2);
		}
		
		public static function setCenter(param1:Object, param2:Object) : void {
			param1.x = Math.round(param2.x + (param2.width - param1.width) / 2);
			param1.y = Math.round(param2.y + (param2.height - param1.height) / 2);
		}
		
		public static function getMaxWidth(param1:Array) : Number {
			var K10260369E26E3832DE47FC97D12D2F3AE5C517373566K:Number = NaN;
			var ele:Array = param1;
			K10260369E26E3832DE47FC97D12D2F3AE5C517373566K = 0;
			if(ele.length > 0) {
				K10260369E26E3832DE47FC97D12D2F3AE5C517373566K = ele[0].width;
				ele.forEach(function(param1:*, param2:int, param3:Array):void {
					var _loc4_:Number = param1.width;
					if(_loc4_ > K10260369E26E3832DE47FC97D12D2F3AE5C517373566K) {
						K10260369E26E3832DE47FC97D12D2F3AE5C517373566K = _loc4_;
					}
				});
			}
			return K10260369E26E3832DE47FC97D12D2F3AE5C517373566K;
		}
		
		public static function getMaxHeight(param1:Array) : Number {
			var K102603EAD02531CD994919907D63F217355FFB373566K:Number = NaN;
			var ele:Array = param1;
			K102603EAD02531CD994919907D63F217355FFB373566K = 0;
			if(ele.length > 0) {
				K102603EAD02531CD994919907D63F217355FFB373566K = ele[0].height;
				ele.forEach(function(param1:*, param2:int, param3:Array):void {
					var _loc4_:Number = param1.height;
					if(_loc4_ > K102603EAD02531CD994919907D63F217355FFB373566K) {
						K102603EAD02531CD994919907D63F217355FFB373566K = _loc4_;
					}
				});
			}
			return K102603EAD02531CD994919907D63F217355FFB373566K;
		}
		
		public static function showHorizontalList(param1:uint, param2:Class, param3:String, param4:*, param5:uint, param6:uint, param7:uint, param8:uint, param9:Number = -1, param10:Number = 1, param11:Boolean = true) : Array {
			var _loc15_:* = undefined;
			var _loc16_:* = undefined;
			var _loc12_:Number = param9 != -1?param9:param7;
			var _loc13_:Array = new Array();
			var _loc14_:uint = 0;
			while(_loc14_ < param1) {
				_loc15_ = new (param2 as Class)();
				_loc15_.scaleX = _loc15_.scaleY = param10;
				_loc15_["index"] = _loc14_;
				_loc13_[_loc14_] = _loc15_;
				_loc15_.visible = param11;
				param4.addChild(_loc15_);
				_loc16_ = _loc15_;
				if(_loc14_ == 0) {
					_loc16_.x = param5;
					_loc16_.y = param6;
				} else if(_loc14_ % param8 != 0) {
					_loc16_.x = _loc13_[_loc14_ - 1].x + _loc13_[_loc14_ - 1].width + param7;
					_loc16_.y = _loc13_[_loc14_ - 1].y;
				} else {
					_loc16_.x = _loc13_[0].x;
					_loc16_.y = _loc13_[_loc14_ - 1].y + _loc13_[_loc14_ - 1].height + _loc12_;
				}
				
				_loc14_++;
			}
			return _loc13_;
		}
		
		public static function createUID() : String {
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc1_:* = "";
			var _loc2_:* = "0123456789abcdef";
			_loc3_ = 0;
			while(_loc3_ < 8) {
				_loc1_ = _loc1_ + _loc2_.charAt(Math.round(Math.random() * 15));
				_loc3_++;
			}
			_loc3_ = 0;
			while(_loc3_ < 3) {
				_loc1_ = _loc1_ + "-";
				_loc4_ = 0;
				while(_loc4_ < 4) {
					_loc1_ = _loc1_ + _loc2_.charAt(Math.round(Math.random() * 15));
					_loc4_++;
				}
				_loc3_++;
			}
			_loc1_ = _loc1_ + "-";
			var _loc5_:Number = new Date().getTime();
			_loc1_ = _loc1_ + ("000000000" + _loc5_.toString(16)).substr(-8);
			_loc3_ = 0;
			while(_loc3_ < 4) {
				_loc1_ = _loc1_ + _loc2_.charAt(Math.round(Math.random() * 15));
				_loc3_++;
			}
			return _loc1_;
		}
		
		public static function getType(param1:String, param2:String) : String {
			var _loc3_:Array = param1.split(param2);
			var _loc4_:Array = _loc3_[_loc3_.length - 1].split("&");
			var _loc5_:Array = _loc4_[0].split("?");
			return _loc5_[0];
		}
		
		public static function openWindow(param1:String, param2:String = "_blank", param3:String = "") : Boolean {
			var url:String = param1;
			var window:String = param2;
			var features:String = param3;
			var K1026034FAE6215F1184E7C820792AAB29CE5E7373566K:URLRequest = new URLRequest(url);
			window = window;
			var boo:Boolean = false;
			if(!Eif.available) {
				if(ExternalInterface.available) {
					try {
						navigateToURL(K1026034FAE6215F1184E7C820792AAB29CE5E7373566K,window);
						boo = true;
					}
					catch(evt:Error) {
						boo = false;
					}
				} else {
					boo = false;
				}
			} else {
				try {
					ExternalInterface.call("function(){window.open(\'" + url + "\',\'" + window + "\');}");
					boo = true;
				}
				catch(e:Error) {
					boo = false;
				}
			}
			return boo;
		}
		
		public static function trim(param1:String) : String {
			return param1.replace(new RegExp("(^\\s*)|(\\s*$)","g"),"");
		}
		
		public static function maxCharsLimit(param1:String, param2:uint, param3:Boolean = false) : String {
			var _loc5_:uint = 0;
			var _loc6_:uint = 0;
			var _loc4_:RegExp = new RegExp("[^\\x00-\\xff]","g");
			if(param1.replace(_loc4_,"mm").length > param2) {
				_loc5_ = Math.floor(param2 / 2);
				_loc6_ = _loc5_;
				while(_loc6_ < param1.length) {
					if(param1.substr(0,_loc6_).replace(_loc4_,"mm").length >= param2) {
						return param1.substr(0,_loc6_) + (param3?"...":"");
					}
					_loc6_++;
				}
			}
			return param1;
		}
		
		public static function getBrowserCookie(param1:String) : String {
			var _loc3_:String = null;
			var _loc4_:Array = null;
			var _loc5_:uint = 0;
			var _loc6_:Array = null;
			var _loc2_:* = "";
			if(Eif.available) {
				_loc3_ = ExternalInterface.call("function(){return document.cookie;}");
				if(!(_loc3_ == null) && !(_loc3_ == "undefined") && !(_loc3_ == "")) {
					_loc4_ = _loc3_.split(";");
					_loc5_ = 0;
					while(_loc5_ < _loc4_.length) {
						_loc6_ = _loc4_[_loc5_].split("=");
						if(_loc6_.length > 0) {
							if(trim(_loc6_[0]) == param1) {
								_loc2_ = _loc6_[1];
							}
						}
						_loc5_++;
					}
				}
			}
			return _loc2_;
		}
		
		public static function RegExpVersion() : Object {
			var _loc1_:Object = new Object();
			var _loc2_:RegExp = new RegExp("^(?P<platform>(\\w+)) (?P<majorVersion>(\\d+)),(?P<minorVersion>(\\d+)),(?P<buildNumber>(\\d+)),(?P<internalBuildNumber>(\\d+))$","i");
			_loc1_ = _loc2_.exec(Capabilities.version);
			return _loc1_;
		}
		
		public static function getJSVar(param1:String) : String {
			return ExternalInterface.call("function(){return " + param1 + ";}",null);
		}
		
		public static function cleanVar(param1:String) : String {
			var _loc2_:String = new String();
			var _loc3_:* = 0;
			while(_loc3_ < param1.length) {
				if(!(param1.charAt(_loc3_) == "\n") && !(param1.charAt(_loc3_) == "\r")) {
					_loc2_ = _loc2_ + param1.charAt(_loc3_);
				}
				_loc3_++;
			}
			while(_loc2_.charAt(_loc2_.length - 1) == " ") {
				_loc2_ = _loc2_.slice(0,-1);
			}
			while(_loc2_.charAt(0) == " ") {
				_loc2_ = _loc2_.slice(1);
			}
			return _loc2_;
		}
		
		public static function cleanTrim(param1:String) : String {
			return param1.replace(new RegExp("\\s","g"),"");
		}
		
		public static function cleanUnderline(param1:String) : String {
			var _loc2_:String = param1.split("_")[0];
			return _loc2_;
		}
	}
}
