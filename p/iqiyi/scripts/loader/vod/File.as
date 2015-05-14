package loader.vod
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.net.NetStream;
	
	public class File extends EventDispatcher
	{
		
		public static const Evt_P2P_Final_Error:String = "Evt_P2P_Final_Error";
		
		public static const Evt_P2P_StateChange:String = "Evt_P2P_CDN_Error";
		
		private var _init:Boolean = false;
		
		private var _fileState:FileState;
		
		private var _key:String;
		
		private var _data:VideoData;
		
		public function File(param1:String)
		{
			super();
			this._key = param1;
		}
		
		private function stateChange() : void
		{
			dispatchEvent(new Event(Evt_P2P_StateChange));
		}
		
		private function finalFail() : void
		{
			dispatchEvent(new Event(Evt_P2P_Final_Error));
		}
		
		public function get fileState() : FileState
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				return this._fileState;
			}
		}
		
		public function initFile(param1:DisplayObjectContainer, param2:NetStream, param3:String, param4:String, param5:Number, param6:Number, param7:Array, param8:Array, param9:Number, param10:String, param11:Number, param12:Number, param13:String, param14:String, param15:Number, param16:String, param17:Boolean, param18:Boolean, param19:String, param20:Object, param21:Boolean, param22:String) : void
		{
			var var_34:DisplayObjectContainer = param1;
			var var_35:NetStream = param2;
			var var_36:String = param3;
			var var_37:String = param4;
			var var_38:Number = param5;
			var var_39:Number = param6;
			var var_40:Array = param7;
			var var_41:Array = param8;
			var var_42:Number = param9;
			var var_43:String = param10;
			var var_44:Number = param11;
			var var_45:Number = param12;
			var var_46:String = param13;
			var var_47:String = param14;
			var var_48:Number = param15;
			var var_49:String = param16;
			var var_50:Boolean = param17;
			var var_51:Boolean = param18;
			var var_52:String = param19;
			var var_53:Object = param20;
			var var_54:Boolean = param21;
			var var_55:String = param22;
			try
			{
				this._file["initFile"](this.finalFail,this.stateChange,var_34,var_35,var_36,var_37,var_38,var_39,var_40,var_41,var_42,var_43,var_44,var_45,var_46,var_47,var_48,var_49,var_50,var_51,var_52,var_53,var_54,var_55);
				this._fileState = new FileState(this._key);
			}
			catch(name_1:Error)
			{
				var_53["info"]("__P2P__ : init Error" + " : " + name_1.message);
			}
			this._init = true;
		}
		
		public function set startTime(param1:Number) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["startTime"] = param1;
				return;
			}
		}
		
		public function set metaInfo(param1:Array) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["metaInfo"] = param1;
				return;
			}
		}
		
		public function set endTime(param1:Number) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["endTime"] = param1;
				return;
			}
		}
		
		public function set playing(param1:Boolean) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["playing"] = param1;
				return;
			}
		}
		
		public function set expectPlayTime(param1:uint) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["expectPlayTime"] = param1;
				return;
			}
		}
		
		public function seek(param1:int, param2:Number, param3:Number, param4:int = 0) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["seek"](param1,param2 + "_" + param3,param4);
				return;
			}
		}
		
		public function read() : VideoData
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				var _loc1:Object = this._file["read"]();
				if(_loc1)
				{
					if(!this._data)
					{
						this._data = new VideoData();
					}
					this._data.data = _loc1;
					return this._data;
				}
				return null;
			}
		}
		
		public function readFrom(param1:int) : VideoData
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				if(!this._data)
				{
					this._data = new VideoData();
				}
				var _loc2:Object = this._file["readFrom"](param1);
				if(_loc2)
				{
					if(!this._data)
					{
						this._data = new VideoData();
					}
					this._data.data = _loc2;
					return this._data;
				}
				return null;
			}
		}
		
		public function set fragments(param1:Array) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["fragments"] = param1;
				return;
			}
		}
		
		public function set lag(param1:Boolean) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["lag"] = param1;
				return;
			}
		}
		
		public function set userPause(param1:Boolean) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["userPause"] = param1;
				return;
			}
		}
		
		public function get bufferLength() : int
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				return this._file["bufferLength"];
			}
		}
		
		public function get realBuff() : int
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				return this._file["realBuff"];
			}
		}
		
		public function get eof() : Boolean
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				return this._file["eof"];
			}
		}
		
		public function get done() : Boolean
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				return this._file["done"];
			}
		}
		
		public function setToggleLoading(param1:Boolean) : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				this._file["setToggleLoading"] = param1;
				return;
			}
		}
		
		public function clear() : void
		{
			if(!this._init)
			{
				throw "File need be init first!";
			}
			else
			{
				P2PFileLoader.instance.deleteFile(this._key);
				return;
			}
		}
		
		public function destroy() : void
		{
			this._file["destroy"]();
		}
		
		private function get _file() : Object
		{
			return P2PFileLoader.instance.method_1(this._key);
		}
	}
}
