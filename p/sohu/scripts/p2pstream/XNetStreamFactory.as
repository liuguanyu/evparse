package p2pstream {
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import ppwebswc.class_1;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	
	public class XNetStreamFactory extends EventDispatcher {
		 {
			var _loc1_:* = false;
			var _loc2_:* = true;
			_loc2_;
			_loc2_;
			_loc1_;
			_loc1_;
		}
		
		public function XNetStreamFactory(param1:Function, param2:String = null) {
			var _loc3_:* = false;
			var _loc4_:* = true;
			_loc3_;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc3_;
			_loc3_;
			super();
			_loc3_;
			this.prepareProperties("callBack",param1);
			_loc3_;
			_loc3_;
			_loc3_;
			_loc3_;
			this.prepareProperties("libraryUrl",param2);
		}
		
		protected static var _reportInfo:Object = new Object();
		
		public static const PARTNERID:String = "sohu";
		
		public static function checkCompatibility() : Boolean {
			var _loc1_:* = false;
			var _loc2_:* = true;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			method_11();
			_loc2_;
			_loc2_;
			return method_9();
		}
		
		protected static var isInitialized:Boolean = false;
		
		protected static function method_9(param1:Boolean = true) : Boolean {
			var _loc3_:* = true;
			var _loc4_:* = false;
			_loc4_;
			var _loc2_:* = false;
			_loc4_;
			_loc4_;
			_loc3_;
			_loc3_;
			_loc4_;
			_loc4_;
			_loc3_;
			_loc2_ = !Capabilities.isDebugger;
			_loc3_;
			_loc4_;
			_loc3_;
			_loc3_;
			_loc4_;
			_loc4_;
			_loc4_;
			if((method_12) && (method_10) && (_loc2_)) {
				_loc3_;
				return true;
			}
			_loc4_;
			if((param1) && (!hasReported)) {
				_loc4_;
				_loc3_;
				_loc3_;
				hasReported = true;
				if(!method_12) {
					_loc4_;
					_loc3_;
					_loc3_;
					FactoryReporter.sendReport(FactoryReporter.FLASH_VERSION_OVERDUE,_reportInfo);
				} else if(!method_10) {
					_loc3_;
					FactoryReporter.sendReport(FactoryReporter.PLANT_VERSION_NOT_SATISFIED,_reportInfo);
					_loc4_;
				} else {
					FactoryReporter.sendReport(FactoryReporter.FLASH_VERSION_DEBUGER,_reportInfo);
				}
				
			}
			return false;
		}
		
		protected static var hasReported:Boolean = false;
		
		protected static function get method_10() : Boolean {
			var _loc2_:* = true;
			var _loc3_:* = false;
			_loc2_;
			_loc2_;
			_loc3_;
			var _loc1_:String = Capabilities.version;
			_loc2_;
			_loc2_;
			_loc2_;
			_loc3_;
			_loc3_;
			_loc2_;
			if(_loc1_.indexOf("WIN") >= 0 || _loc1_.indexOf("MAC") >= 0) {
				_loc3_;
				return true;
			}
			return false;
		}
		
		protected static var _startTime:Number;
		
		public static function getClass(param1:String) : Class {
			var _loc2_:* = false;
			var _loc3_:* = true;
			_loc2_;
			_loc2_;
			_loc3_;
			_loc3_;
			_loc3_;
			_loc3_;
			if(loader == null) {
				return null;
			}
			return loader.getClass(param1);
		}
		
		protected static var loader:class_1;
		
		protected static function method_11() : void {
			var _loc1_:* = false;
			var _loc2_:* = true;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc2_;
			_loc2_;
			if(!isInitialized) {
				_loc1_;
				_loc1_;
				_loc2_;
				_loc2_;
				isInitialized = true;
				_loc1_;
				_loc1_;
			}
		}
		
		protected static function get method_12() : Boolean {
			var _loc4_:* = false;
			var _loc5_:* = true;
			_loc5_;
			_loc5_;
			_loc4_;
			_loc5_;
			_loc4_;
			_loc4_;
			var _loc1_:String = Capabilities.version;
			_loc4_;
			_loc4_;
			var _loc2_:Number = new Number(_loc1_.split(" ")[1].split(",")[0]);
			_loc5_;
			_loc5_;
			var _loc3_:Number = new Number(_loc1_.split(" ")[1].split(",")[1]);
			_loc4_;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc5_;
			_loc5_;
			_loc5_;
			if((_loc2_ > 10) || (_loc2_ == 10) && (_loc3_ >= 1)) {
				_loc5_;
				_loc5_;
				return true;
			}
			return false;
		}
		
		public function prepareProperties(param1:String, param2:Object) : void {
			var _loc3_:* = true;
			var _loc4_:* = false;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc3_;
			if(param1.indexOf("callBack") == 0) {
				_loc3_;
				var_3 = param2 as Function;
				_loc3_;
				_loc3_;
			} else if(param1.indexOf("libraryUrl") == 0) {
				_loc3_;
				_loc3_;
				var_1 = param2 as String;
				_loc3_;
				_loc3_;
			}
			
		}
		
		protected var var_1:String = "";
		
		protected var var_2:Timer;
		
		protected function method_1(param1:Event) : void {
			var _loc2_:* = true;
			var _loc3_:* = false;
			_loc3_;
			_loc3_;
			_loc2_;
			_reportInfo.t = getTimer() - _startTime;
			_loc2_;
			FactoryReporter.sendReport(FactoryReporter.DOWNLOAD_SUCCESS,_reportInfo);
			if(var_2 != null) {
				_loc2_;
				_loc2_;
				var_2.stop();
				_loc2_;
				_loc3_;
				var_2.removeEventListener(TimerEvent.TIMER,method_2);
				_loc2_;
			}
			var_5 = true;
			var_3();
			_loc3_;
			_loc3_;
		}
		
		protected function method_2(param1:TimerEvent) : void {
			var _loc2_:* = false;
			var _loc3_:* = true;
			_loc3_;
			_loc2_;
			_loc2_;
			var_2.stop();
			var_2.removeEventListener(TimerEvent.TIMER,method_2);
			_loc2_;
			_loc2_;
			_loc3_;
			_loc3_;
			_loc2_;
			loader.removeEventListener(class_1.LOAD_ERROR,method_3);
			_loc3_;
			_loc2_;
			_loc2_;
			loader.removeEventListener(class_1.SECURITY_ERROR,method_3);
			_loc3_;
			loader.removeEventListener(class_1.CLASS_LOADED,method_1);
			method_3(null);
			_loc3_;
			_loc3_;
		}
		
		protected var var_3:Function;
		
		protected function method_3(param1:Event) : void {
			var _loc2_:* = true;
			var _loc3_:* = false;
			_loc3_;
			_loc3_;
			_loc3_;
			_loc2_;
			_loc2_;
			_reportInfo.t = getTimer() - _startTime;
			_loc3_;
			if(var_2 != null) {
				_loc2_;
				_loc2_;
				var_2.stop();
				_loc3_;
				_loc3_;
				var_2.removeEventListener(TimerEvent.TIMER,method_2);
			}
			if(param1 == null) {
				_loc2_;
				_loc2_;
				FactoryReporter.sendReport(FactoryReporter.DOWNLOAD_TIMEOUT,_reportInfo);
				_loc2_;
				_loc2_;
			} else {
				_reportInfo.e = param1.type;
				FactoryReporter.sendReport(FactoryReporter.DOWNLOAD_ERROR,_reportInfo);
				_loc2_;
				_loc2_;
				_loc3_;
				_loc3_;
			}
			var_5 = false;
			_loc2_;
			_loc2_;
			_loc2_;
			var_3();
			_loc2_;
		}
		
		public function load(param1:int = 6000, param2:Boolean = true) : void {
			var _loc3_:* = true;
			var _loc4_:* = false;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc4_;
			_loc3_;
			_loc3_;
			_startTime = getTimer();
			_loc3_;
			_loc3_;
			_loc4_;
			if(!method_9()) {
				_loc4_;
				var_5 = false;
				_loc3_;
				_loc4_;
				var_3();
				_loc4_;
			} else {
				loader = new class_1();
				_loc4_;
				_loc4_;
				_loc3_;
				_loc3_;
				loader.addEventListener(class_1.LOAD_ERROR,method_3);
				_loc4_;
				_loc4_;
				_loc4_;
				loader.addEventListener(class_1.SECURITY_ERROR,method_3);
				_loc3_;
				_loc3_;
				loader.addEventListener(class_1.CLASS_LOADED,method_1);
				loader.load(var_1,param2);
				if(param1 > 0) {
					_loc4_;
					_loc3_;
					_loc3_;
					var_2 = new Timer(param1,1);
					_loc4_;
					_loc3_;
					var_2.addEventListener(TimerEvent.TIMER,method_2);
					var_2.start();
				}
			}
		}
		
		protected var var_4:Boolean = false;
		
		public function get isSuccess() : Boolean {
			var _loc1_:* = false;
			var _loc2_:* = true;
			_loc1_;
			_loc1_;
			_loc2_;
			_loc2_;
			return var_5;
		}
		
		protected var var_5:Boolean;
	}
}
