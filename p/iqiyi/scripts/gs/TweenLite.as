package gs
{
	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	import gs.plugins.*;
	import gs.utils.tween.*;
	
	public class TweenLite extends Object
	{
		
		private static var _timer:Timer = new Timer(2000);
		
		public static var defaultEase:Function = TweenLite.easeOut;
		
		public static const version:Number = 10.092;
		
		public static var plugins:Object = {};
		
		public static var currentTime:uint;
		
		public static var masterList:Dictionary = new Dictionary(false);
		
		protected static var _reservedProps:Object = {
			"ease":1,
			"delay":1,
			"overwrite":1,
			"onComplete":1,
			"onCompleteParams":1,
			"runBackwards":1,
			"startAt":1,
			"onUpdate":1,
			"onUpdateParams":1,
			"roundProps":1,
			"onStart":1,
			"onStartParams":1,
			"persist":1,
			"renderOnStart":1,
			"proxiedEase":1,
			"easeParams":1,
			"yoyo":1,
			"loop":1,
			"onCompleteListener":1,
			"onUpdateListener":1,
			"onStartListener":1,
			"orientToBezier":1,
			"timeScale":1
		};
		
		public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
		
		public static var timingSprite:Sprite = new Sprite();
		
		public static var overwriteManager:Object;
		
		private static var _tlInitted:Boolean;
		
		public var started:Boolean;
		
		public var delay:Number;
		
		protected var _hasUpdate:Boolean;
		
		protected var _hasPlugins:Boolean;
		
		public var initted:Boolean;
		
		public var active:Boolean;
		
		public var startTime:Number;
		
		public var target:Object;
		
		public var duration:Number;
		
		public var gc:Boolean;
		
		public var tweens:Array;
		
		public var vars:Object;
		
		public var ease:Function;
		
		public var exposedVars:Object;
		
		public var initTime:Number;
		
		public var combinedTimeScale:Number;
		
		public function TweenLite(param1:Object, param2:Number, param3:Object)
		{
			super();
			if(param1 == null)
			{
				return;
			}
			if(!_tlInitted)
			{
				TweenPlugin.activate([TintPlugin,RemoveTintPlugin,FramePlugin,AutoAlphaPlugin,VisiblePlugin,VolumePlugin,EndArrayPlugin]);
				currentTime = getTimer();
				timingSprite.addEventListener(Event.ENTER_FRAME,updateAll,false,0,true);
				if(overwriteManager == null)
				{
					overwriteManager = {
						"mode":1,
						"enabled":false
					};
				}
				_timer.addEventListener("timer",killGarbage,false,0,true);
				_timer.start();
				_tlInitted = true;
			}
			this.vars = param3;
			this.duration = (param2) || (0.001);
			this.delay = (param3.delay) || (0);
			this.combinedTimeScale = (param3.timeScale) || (1);
			this.active = Boolean(param2 == 0 && this.delay == 0);
			this.target = param1;
			if(typeof this.vars.ease != "function")
			{
				this.vars.ease = defaultEase;
			}
			if(this.vars.easeParams != null)
			{
				this.vars.proxiedEase = this.vars.ease;
				this.vars.ease = easeProxy;
			}
			this.ease = this.vars.ease;
			this.exposedVars = this.vars.isTV == true?this.vars.exposedVars:this.vars;
			this.tweens = [];
			this.initTime = currentTime;
			this.startTime = this.initTime + this.delay * 1000;
			var _loc4:int = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1?overwriteManager.mode:int(param3.overwrite);
			if(!(param1 in masterList) || _loc4 == 1)
			{
				masterList[param1] = [this];
			}
			else
			{
				masterList[param1].push(this);
			}
			if(this.vars.runBackwards == true && !(this.vars.renderOnStart == true) || (this.active))
			{
				initTweenVals();
				if(this.active)
				{
					render(this.startTime + 1);
				}
				else
				{
					render(this.startTime);
				}
				if(!(this.exposedVars.visible == null) && this.vars.runBackwards == true && this.target is DisplayObject)
				{
					this.target.visible = this.exposedVars.visible;
				}
			}
		}
		
		public static function updateAll(param1:Event = null) : void
		{
			var _loc4:Array = null;
			var _loc5:* = 0;
			var _loc6:TweenLite = null;
			var _loc2:uint = currentTime = getTimer();
			var _loc3:Dictionary = masterList;
			for each(_loc4 in _loc3)
			{
				_loc5 = _loc4.length - 1;
				while(_loc5 > -1)
				{
					_loc6 = _loc4[_loc5];
					if(_loc6.active)
					{
						_loc6.render(_loc2);
					}
					else if(_loc6.gc)
					{
						_loc4.splice(_loc5,1);
					}
					else if(_loc2 >= _loc6.startTime)
					{
						_loc6.activate();
						_loc6.render(_loc2);
					}
					
					
					_loc5--;
				}
			}
		}
		
		public static function removeTween(param1:TweenLite, param2:Boolean = true) : void
		{
			if(param1 != null)
			{
				if(param2)
				{
					param1.clear();
				}
				param1.enabled = false;
			}
		}
		
		public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
		{
			var _loc3:Array = null;
			var _loc4:* = 0;
			var _loc5:TweenLite = null;
			if(!(param1 == null) && param1 in masterList)
			{
				_loc3 = masterList[param1];
				_loc4 = _loc3.length - 1;
				while(_loc4 > -1)
				{
					_loc5 = _loc3[_loc4];
					if((param2) && !_loc5.gc)
					{
						_loc5.complete(false);
					}
					_loc5.clear();
					_loc4--;
				}
				delete masterList[param1];
				true;
			}
		}
		
		public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
		{
			param3.runBackwards = true;
			return new TweenLite(param1,param2,param3);
		}
		
		public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
		{
			return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
		}
		
		protected static function killGarbage(param1:TimerEvent) : void
		{
			var _loc3:Object = null;
			var _loc2:Dictionary = masterList;
			for(_loc3 in _loc2)
			{
				if(_loc2[_loc3].length == 0)
				{
					delete _loc2[_loc3];
					true;
				}
			}
		}
		
		public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
		{
			return new TweenLite(param2,0,{
				"delay":param1,
				"onComplete":param2,
				"onCompleteParams":param3,
				"overwrite":0
			});
		}
		
		public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
		{
			return new TweenLite(param1,param2,param3);
		}
		
		public function get enabled() : Boolean
		{
			return this.gc?false:true;
		}
		
		public function set enabled(param1:Boolean) : void
		{
			var _loc2:Array = null;
			var _loc3:* = false;
			var _loc4:* = 0;
			if(param1)
			{
				if(!(this.target in masterList))
				{
					masterList[this.target] = [this];
				}
				else
				{
					_loc2 = masterList[this.target];
					_loc4 = _loc2.length - 1;
					while(_loc4 > -1)
					{
						if(_loc2[_loc4] == this)
						{
							_loc3 = true;
							break;
						}
						_loc4--;
					}
					if(!_loc3)
					{
						_loc2[_loc2.length] = this;
					}
				}
			}
			this.gc = param1?false:true;
			if(this.gc)
			{
				this.active = false;
			}
			else
			{
				this.active = this.started;
			}
		}
		
		public function clear() : void
		{
			this.tweens = [];
			this.vars = this.exposedVars = {"ease":this.vars.ease};
			_hasUpdate = false;
		}
		
		public function render(param1:uint) : void
		{
			var _loc3:* = NaN;
			var _loc4:TweenInfo = null;
			var _loc5:* = 0;
			var _loc2:Number = (param1 - this.startTime) * 0.001;
			if(_loc2 >= this.duration)
			{
				_loc2 = this.duration;
				_loc3 = this.ease == this.vars.ease || this.duration == 0.001?1:0;
			}
			else
			{
				_loc3 = this.ease(_loc2,0,1,this.duration);
			}
			_loc5 = this.tweens.length - 1;
			while(_loc5 > -1)
			{
				_loc4 = this.tweens[_loc5];
				_loc4.target[_loc4.property] = _loc4.start + _loc3 * _loc4.change;
				_loc5--;
			}
			if(_hasUpdate)
			{
				this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
			}
			if(_loc2 == this.duration)
			{
				complete(true);
			}
		}
		
		public function activate() : void
		{
			this.started = this.active = true;
			if(!this.initted)
			{
				initTweenVals();
			}
			if(this.vars.onStart != null)
			{
				this.vars.onStart.apply(null,this.vars.onStartParams);
			}
			if(this.duration == 0.001)
			{
				this.startTime = this.startTime - 1;
			}
		}
		
		public function initTweenVals() : void
		{
			var _loc1:String = null;
			var _loc2:* = 0;
			var _loc3:* = undefined;
			var _loc4:TweenInfo = null;
			if(!(this.exposedVars.timeScale == undefined) && (this.target.hasOwnProperty("timeScale")))
			{
				this.tweens[this.tweens.length] = new TweenInfo(this.target,"timeScale",this.target.timeScale,this.exposedVars.timeScale - this.target.timeScale,"timeScale",false);
			}
			for(_loc1 in this.exposedVars)
			{
				if(!(_loc1 in _reservedProps))
				{
					if(_loc1 in plugins)
					{
						_loc3 = new plugins[_loc1]();
						if(_loc3.onInitTween(this.target,this.exposedVars[_loc1],this) == false)
						{
							this.tweens[this.tweens.length] = new TweenInfo(this.target,_loc1,this.target[_loc1],typeof this.exposedVars[_loc1] == "number"?this.exposedVars[_loc1] - this.target[_loc1]:Number(this.exposedVars[_loc1]),_loc1,false);
						}
						else
						{
							this.tweens[this.tweens.length] = new TweenInfo(_loc3,"changeFactor",0,1,_loc3.overwriteProps.length == 1?_loc3.overwriteProps[0]:"_MULTIPLE_",true);
							_hasPlugins = true;
						}
					}
					else
					{
						this.tweens[this.tweens.length] = new TweenInfo(this.target,_loc1,this.target[_loc1],typeof this.exposedVars[_loc1] == "number"?this.exposedVars[_loc1] - this.target[_loc1]:Number(this.exposedVars[_loc1]),_loc1,false);
					}
				}
			}
			if(this.vars.runBackwards == true)
			{
				_loc2 = this.tweens.length - 1;
				while(_loc2 > -1)
				{
					_loc4 = this.tweens[_loc2];
					_loc4.start = _loc4.start + _loc4.change;
					_loc4.change = -_loc4.change;
					_loc2--;
				}
			}
			if(this.vars.onUpdate != null)
			{
				_hasUpdate = true;
			}
			if((TweenLite.overwriteManager.enabled) && this.target in masterList)
			{
				overwriteManager.manageOverwrites(this,masterList[this.target]);
			}
			this.initted = true;
		}
		
		protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
		{
			return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
		}
		
		public function killVars(param1:Object) : void
		{
			if(overwriteManager.enabled)
			{
				overwriteManager.killVars(param1,this.exposedVars,this.tweens);
			}
		}
		
		public function complete(param1:Boolean = false) : void
		{
			var _loc2:* = 0;
			if(!param1)
			{
				if(!this.initted)
				{
					initTweenVals();
				}
				this.startTime = currentTime - this.duration * 1000 / this.combinedTimeScale;
				render(currentTime);
				return;
			}
			if(_hasPlugins)
			{
				_loc2 = this.tweens.length - 1;
				while(_loc2 > -1)
				{
					if((this.tweens[_loc2].isPlugin) && !(this.tweens[_loc2].target.onComplete == null))
					{
						this.tweens[_loc2].target.onComplete();
					}
					_loc2--;
				}
			}
			if(this.vars.persist != true)
			{
				this.enabled = false;
			}
			if(this.vars.onComplete != null)
			{
				this.vars.onComplete.apply(null,this.vars.onCompleteParams);
			}
		}
	}
}
