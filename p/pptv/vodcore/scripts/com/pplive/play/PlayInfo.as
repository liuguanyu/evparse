package com.pplive.play
{
	import flash.net.URLVariables;
	import com.pplive.util.URI;
	import com.pplive.p2p.struct.Constants;
	
	public class PlayInfo extends Object
	{
		
		private var _host:String;
		
		private var _fileName:String;
		
		private var _key:String;
		
		private var _k:String;
		
		private var _type:String;
		
		private var _ft:String;
		
		private var _variables:String;
		
		private var _bwType:uint;
		
		private var _segments:Vector.<SegmentInfo>;
		
		private var _backupHostVector:Vector.<String>;
		
		private var _duration:uint;
		
		private var _isVip:Boolean;
		
		private var _draghost:String;
		
		public function PlayInfo(param1:String, param2:String, param3:String, param4:String, param5:uint, param6:Vector.<SegmentInfo>, param7:Vector.<String>, param8:Boolean = false, param9:String = "", param10:String = "type=web.fpp", param11:String = "0", param12:String = null)
		{
			super();
			this._host = param1;
			this._fileName = param2;
			this._key = param3;
			this._k = param9;
			this._type = param10;
			this._ft = param11;
			this._variables = param4;
			this._bwType = param5;
			this._segments = param6;
			this._backupHostVector = param7;
			this._isVip = param8;
			this._draghost = param12;
			this.calcDuration();
		}
		
		private function calcDuration() : void
		{
			var _loc1:Number = 0;
			var _loc2:uint = this.segments.length;
			var _loc3:uint = 0;
			while(_loc3 < _loc2)
			{
				_loc1 = _loc1 + this.segments[_loc3].duration;
				_loc3++;
			}
			this._duration = _loc1;
		}
		
		public function constructDrmURL(param1:uint, param2:String = null) : String
		{
			if(param2 == null)
			{
				var param2:String = this._host;
			}
			return "http://" + param2 + "/" + param1 + "/0/1023/" + this.fileName + "?fpp.ver=" + Version.version + (this._type?"&" + this._type:"&type=web.fpp") + "&k=" + this._k + "&get_drm_header=true";
		}
		
		public function constructCdnURL(param1:uint, param2:String = null, param3:uint = 0, param4:uint = 0) : String
		{
			var _loc5:String = null;
			if(param2 == null)
			{
				var param2:String = this._host;
			}
			if(param3 == 0 && param4 == 0)
			{
				_loc5 = "http://" + param2 + "/" + param1 + "/" + this.fileName;
			}
			else
			{
				_loc5 = "http://" + param2 + "/" + param1 + "/" + param3 + "/" + param4 + "/" + this.fileName;
			}
			_loc5 = _loc5 + ("?fpp.ver=" + Version.version);
			return this.addVariables(_loc5);
		}
		
		private function addVariables(param1:String) : String
		{
			if(this._key)
			{
				var param1:String = param1 + ("&key=" + this._key);
			}
			if(this._k)
			{
				param1 = param1 + ("&k=" + this._k);
			}
			if(this._type)
			{
				param1 = param1 + ("&" + this._type);
			}
			else
			{
				param1 = param1 + "&type=web.fpp";
			}
			if(this._variables)
			{
				param1 = param1 + ("&" + this._variables);
			}
			return param1;
		}
		
		public function constructKernelUrl(param1:uint, param2:String, param3:URLVariables = null) : String
		{
			var _loc5:* = undefined;
			var _loc4:URI = new URI("");
			_loc4.protocol = "http";
			_loc4.host = Constants.KERNEL_HOST;
			_loc4.port = Constants.KERNEL_MAGIC_PORT;
			_loc4.path = "/ppvaplaybyopen";
			_loc4.variables.url = this.constructCdnURL(param1);
			_loc4.variables.id = param2;
			_loc4.variables.BWType = this._bwType;
			_loc4.variables.source = 1;
			if((this._backupHostVector) && this._backupHostVector.length > 0)
			{
				_loc4.variables.bakhost = this._backupHostVector.join("@");
			}
			if(param3)
			{
				for(_loc5 in param3)
				{
					_loc4.variables[_loc5] = param3[_loc5];
				}
			}
			return _loc4.toString(true);
		}
		
		public function get host() : String
		{
			return this._host;
		}
		
		public function get fileName() : String
		{
			return this._fileName;
		}
		
		public function get key() : String
		{
			return this._key;
		}
		
		public function get bwType() : uint
		{
			return this._bwType;
		}
		
		public function get segments() : Vector.<SegmentInfo>
		{
			return this._segments;
		}
		
		public function get backupHosts() : Vector.<String>
		{
			return this._backupHostVector;
		}
		
		public function get duration() : uint
		{
			return this._duration;
		}
		
		public function get isVip() : Boolean
		{
			return this._isVip;
		}
		
		public function set isVip(param1:Boolean) : void
		{
			this._isVip = param1;
		}
		
		public function get variables() : String
		{
			return this._variables;
		}
		
		public function get ft() : String
		{
			return this._ft;
		}
		
		public function get draghost() : String
		{
			return this._draghost;
		}
		
		public function toString() : String
		{
			return "host: " + this._host + "\n" + "fileName: " + this._fileName + "\n" + "key: " + this._key + "\n" + "k: " + this._k + "\n" + "bwtype: " + this._bwType + "\n" + "segments: " + this._segments.toString() + "\n" + "duration: " + this._duration + "\n" + "variables: " + this._variables + "\n";
		}
	}
}
