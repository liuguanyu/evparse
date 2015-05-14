package com.qiyi.player.core.model.utils
{
	import flash.utils.Timer;
	import flash.net.URLLoader;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	
	public class IRS extends Object
	{
		
		private var toHart:Timer;
		
		private var aoHartBak:Array;
		
		private var aoHartCount:Array;
		
		private var vRunStatus:String;
		
		private var vDebugInfo:String;
		
		private var vShareInfo:String;
		
		private var vSessionID:String;
		
		private var vVideoID:String;
		
		private var vPlayTime:int;
		
		private var vActCount:int;
		
		private var vRunTime:int;
		
		private var vSetID:int;
		
		private var varLoader:URLLoader;
		
		private var vPlayName:String;
		
		private var vUrl:String;
		
		public var _MaxSave:int = 10;
		
		public var _CheckStep:int = 5;
		
		public var _MaxStepCount:int = 3;
		
		public var _IWT_UAID:String = "UA-youku-03";
		
		public var _IWT_URL:String = "http://irs01.com/irt";
		
		public var _IWT_FDir:String = "/";
		
		public var _IWT_FMark:String = "irs_ftrack";
		
		public var _IWT_FVer:String = "v1.8";
		
		public var _IWT_Debug:Boolean = false;
		
		public function IRS()
		{
			var _loc1:* = 0;
			super();
			if(this.aoHartBak == null)
			{
				this.aoHartBak = new Array(this._MaxSave);
				this.aoHartCount = new Array(this._MaxSave);
				_loc1 = 0;
				while(_loc1 < this.aoHartBak.length)
				{
					this.aoHartBak[_loc1] = -1;
					this.aoHartCount[_loc1] = 0;
					_loc1++;
				}
				this.vRunTime = 0;
				this.vDebugInfo = "";
				this.vSetID = -1;
				this.vSessionID = null;
				this.vVideoID = null;
				this.vRunStatus = "load";
			}
			if(this.toHart == null)
			{
				this.toHart = new Timer(1000,0);
				this.toHart.addEventListener(TimerEvent.TIMER,this.RunTimeHandler);
				this.toHart.start();
			}
			this.vSessionID = this.UvidLoadSet();
		}
		
		public function IRS_NewPlay(param1:String, param2:int, param3:Boolean, param4:String, param5:String, param6:String) : void
		{
			var uVideoID:String = param1;
			var uTotalTime:int = param2;
			var uPlay:Boolean = param3;
			var uPlayName:String = param4;
			var uUrl:String = param5;
			var uMuid:String = param6;
			this.DebugInfo("IRS_NewPlay：" + uVideoID + "|" + uTotalTime);
			this.vSetID = this.HartSaveSet(-1,0);
			if(this.vSetID != -1)
			{
				this.vPlayTime = 0;
				this.vActCount = 0;
				this.vVideoID = uVideoID;
				this.vPlayName = uPlayName;
				if(uUrl == null)
				{
					try
					{
						if(ExternalInterface.available)
						{
							this.vUrl = ExternalInterface.call("eval","window.location.href");
						}
						else
						{
							this.vUrl = "";
						}
					}
					catch(e:Error)
					{
						vUrl = "error";
					}
				}
				else
				{
					this.vUrl = uUrl;
				}
				if(uUrl == null)
				{
					this.DataSaveSet(this.vSetID,this._IWT_UAID,this.vSessionID,this.vVideoID,uTotalTime,0,0,0,0,this.vPlayName,this.vUrl,uMuid);
					this.doDataSend(this.vSetID,"A");
					if(uPlay)
					{
						this.IRS_UserACT("play");
					}
				}
				else
				{
					this.DataSaveSet(this.vSetID,this._IWT_UAID,this.vSessionID,this.vVideoID,uTotalTime,0,0,0,0,this.vPlayName,this.vUrl,uMuid);
					this.doDataSend(this.vSetID,"A");
					if(uPlay)
					{
						this.IRS_UserACT("play");
					}
				}
			}
			else
			{
				this.DebugInfo("vSetID无效，IRSNewPlay出错!");
			}
		}
		
		public function IRS_UserACT(param1:String) : void
		{
			if(param1 == "play" || param1 == "pause")
			{
				this.vActCount++;
				this.vRunStatus = param1;
			}
			else if(param1 == "drag")
			{
				this.vActCount++;
			}
			else if(param1 == "end")
			{
				this.vActCount++;
				this.vRunStatus = param1;
				this.doDataCheck();
				if(this.vSetID != -1)
				{
					this.doDataSend(this.vSetID,"B");
					this.vSetID = -1;
				}
			}
			else if(param1 == "stop")
			{
				this.vActCount++;
				this.vRunStatus = param1;
			}
			else
			{
				this.DebugInfo("IRS_UserACT参数不合法!");
			}
			
			
			
		}
		
		public function IRS_GetXValue(param1:String) : String
		{
			if(this[param1] != null)
			{
				return this[param1].toString();
			}
			return "Null";
		}
		
		public function IRS_FlashClear() : void
		{
			var soHart_Clear:SharedObject = null;
			var j:int = 0;
			try
			{
				soHart_Clear = SharedObject.getLocal(this._IWT_FMark,this._IWT_FDir);
				soHart_Clear.clear();
			}
			catch(e:Error)
			{
				DebugInfo("清除FT_Hart失败!" + e);
			}
			soHart_Clear = null;
			j = 0;
			while(j < this._MaxSave)
			{
				try
				{
					soHart_Clear = SharedObject.getLocal(this._IWT_FMark + "_" + j,this._IWT_FDir);
					soHart_Clear.clear();
				}
				catch(e:Error)
				{
					DebugInfo("清除FT_Data_" + j + "失败!" + e);
				}
				soHart_Clear = null;
				j++;
			}
			this.vSetID = -1;
			this.vVideoID = null;
			this.vRunStatus = "clear";
		}
		
		private function RunTimeHandler(param1:TimerEvent) : void
		{
			this.vRunTime++;
			if(this.vRunTime % this._CheckStep == 0)
			{
				this.doDataCheck();
			}
			if(this.vRunStatus == "play" && !(this.vSetID == -1))
			{
				this.vPlayTime++;
			}
		}
		
		private function doDataCheck() : void
		{
			var _loc2:* = 0;
			this.DebugInfo("调用:doDataCheck检查是否有历史数据");
			var _loc1:Array = this.HartLoadSet();
			if(_loc1 != null)
			{
				if(this.vSetID != -1)
				{
					_loc1[this.vSetID]++;
					this.HartSaveSet(this.vSetID,_loc1[this.vSetID]);
					this.DataSaveSet(this.vSetID,null,this.vSessionID,null,-2,this.vPlayTime,this.vActCount,_loc1[this.vSetID],-2,null,null,null);
				}
				_loc2 = 0;
				while(_loc2 < _loc1.length)
				{
					if(_loc1[_loc2] == this.aoHartBak[_loc2] && !(_loc1[_loc2] == -1))
					{
						this.aoHartCount[_loc2]++;
						if(this.aoHartCount[_loc2] >= this._MaxStepCount)
						{
							this.aoHartCount[_loc2] = 0;
							this.doDataSend(_loc2,"C");
							break;
						}
						break;
					}
					this.aoHartBak[_loc2] = _loc1[_loc2];
					this.aoHartCount[_loc2] = 0;
					_loc2++;
				}
			}
		}
		
		private function doDataSend(param1:int, param2:String) : void
		{
			var _loc3:Array = null;
			var _loc4:String = null;
			var _loc5:URLRequest = null;
			if(param1 != -1)
			{
				_loc3 = this.DataLoadSet(param1) as Array;
				if(_loc3 != null)
				{
					_loc4 = this._IWT_URL;
					_loc4 = _loc4 + ("?_iwt_id=" + _loc3[2]);
					_loc4 = _loc4 + ("&_iwt_UA=" + _loc3[1]);
					_loc4 = _loc4 + ("&jsonp=SetID" + param2 + param1);
					_loc4 = _loc4 + ("&_iwt_p1=" + param2 + "-" + _loc3[0] + "-" + _loc3[8]);
					_loc4 = _loc4 + ("&_iwt_p2=" + _loc3[3]);
					_loc4 = _loc4 + ("&_iwt_p3=" + _loc3[4] + "-" + _loc3[5] + "-" + _loc3[6] + "-" + _loc3[7]);
					_loc4 = _loc4 + ("&_iwt_p4=" + encodeURI(_loc3[9]));
					_loc4 = _loc4 + ("&_iwt_p5=" + encodeURI(_loc3[10]));
					_loc4 = _loc4 + ("&_iwt_muid=" + encodeURI(_loc3[11]));
					_loc4 = _loc4 + ("&r=" + int(Math.random() * 9999));
					if(_loc3[8] < 2)
					{
						this.DataSaveSet(_loc3[0],null,null,null,-2,-2,-2,-2,_loc3[8] + 1,_loc3[9],_loc3[10],null);
					}
					else
					{
						this.DataSaveSet(_loc3[0],null,null,null,-2,-2,-2,-2,_loc3[8] + 1,_loc3[9],_loc3[10],_loc3[11]);
						this.HartSaveSet(param1,-1);
					}
					this.varLoader = new URLLoader();
					_loc5 = new URLRequest(_loc4);
					this.varLoader.addEventListener(Event.COMPLETE,this.loaderCompleteHandler);
					this.varLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadersecurityError);
					this.varLoader.addEventListener(IOErrorEvent.IO_ERROR,this.loaderioError);
					this.varLoader.load(_loc5);
					if(param2 == "A")
					{
						this.DebugInfo("开始播放视频A点发送doDataSend_" + param2 + ":" + this.varLoader);
					}
					else if(param2 == "B")
					{
						this.DebugInfo("正常结束播放B点发送doDataSend_" + param2 + ":" + this.varLoader);
					}
					else if(param2 == "C")
					{
						this.DebugInfo("历史播放记录C点补发doDataSend_" + param2 + ":" + this.varLoader);
					}
					
					
				}
				else
				{
					this.DebugInfo("意外调用:doDataSend_" + param2 + "|uSetID:" + param1);
				}
			}
		}
		
		private function loaderCompleteHandler(param1:Event) : void
		{
			var _loc3:* = 0;
			var _loc4:String = null;
			var _loc5:* = 0;
			var _loc6:* = 0;
			var _loc2:String = this.varLoader.data;
			if(_loc2 != null)
			{
				_loc6 = _loc2.indexOf("SetID");
				_loc5 = _loc2.indexOf("(");
				if(_loc6 == 0 && !(_loc5 == -1))
				{
					this.vSessionID = _loc2.substr(_loc5 + 2,23);
					_loc3 = int(_loc2.substring(6,_loc5));
					_loc4 = _loc2.substr(5,1);
					this.DebugInfo("loaderComplete:" + _loc2 + "|" + this.vSessionID + "|" + _loc3 + "|" + _loc4);
					if(_loc4 == "A")
					{
						this.UvidSaveSet(this.vSessionID);
					}
					if(_loc4 == "B")
					{
						this.HartSaveSet(_loc3,-1);
						this.vSetID = -1;
					}
					if(_loc4 == "C")
					{
						this.HartSaveSet(_loc3,-1);
					}
				}
				else
				{
					this.DebugInfo("异常格式的返回值 loaderComplete:" + _loc2);
				}
			}
			else
			{
				this.DebugInfo("异常的网络返回值 loaderComplete:" + _loc2);
			}
		}
		
		private function loadersecurityError(param1:Event) : void
		{
			this.DebugInfo("loadersecurityError:" + param1);
		}
		
		private function loaderioError(param1:Event) : void
		{
			this.DebugInfo("loaderioError:" + param1);
		}
		
		private function UvidSaveSet(param1:String) : void
		{
			var soUvid_Save:SharedObject = null;
			var uSessionID:String = param1;
			try
			{
				soUvid_Save = SharedObject.getLocal(this._IWT_FMark + "_UV",this._IWT_FDir);
			}
			catch(e:Error)
			{
				DebugInfo("创建FT_Uvid失败!" + e);
			}
			soUvid_Save.data["FT_Uvid"] = uSessionID;
			try
			{
				soUvid_Save.flush();
			}
			catch(e:Error)
			{
				DebugInfo("保存FT_Uvid出错!");
			}
			soUvid_Save = null;
		}
		
		private function UvidLoadSet() : String
		{
			var soUvid_Load:SharedObject = null;
			try
			{
				soUvid_Load = SharedObject.getLocal(this._IWT_FMark + "_UV",this._IWT_FDir);
			}
			catch(e:Error)
			{
				DebugInfo("读取FT_Uvid失败!" + e);
			}
			if(soUvid_Load.data["FT_Uvid"] != null)
			{
				return soUvid_Load.data["FT_Uvid"];
			}
			return null;
		}
		
		private function DataSaveSet(param1:int, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:int, param9:int, param10:String, param11:String, param12:String) : void
		{
			var soData_Save:SharedObject = null;
			var aoData_Save:Array = null;
			var uSetID:int = param1;
			var uUAID:String = param2;
			var uSessionID:String = param3;
			var uVideoID:String = param4;
			var uTotalTime:int = param5;
			var uPlayTime:int = param6;
			var uActCount:int = param7;
			var uLiveHart:int = param8;
			var uSendCount:int = param9;
			var uPlayName:String = param10;
			var uUrl:String = param11;
			var uMuid:String = param12;
			if(uSetID != -1)
			{
				try
				{
					soData_Save = SharedObject.getLocal(this._IWT_FMark + "_" + uSetID,this._IWT_FDir);
				}
				catch(e:Error)
				{
					DebugInfo("创建FT_Data失败!" + e);
				}
				if(soData_Save.data["FT_Data"] is Array)
				{
					soData_Save.data["FT_Data"][0] = uSetID;
					if(uUAID != null)
					{
						soData_Save.data["FT_Data"][1] = uUAID;
					}
					if(uSessionID != null)
					{
						soData_Save.data["FT_Data"][2] = uSessionID;
					}
					if(uVideoID != null)
					{
						soData_Save.data["FT_Data"][3] = uVideoID;
					}
					if(uTotalTime != -2)
					{
						soData_Save.data["FT_Data"][4] = uTotalTime;
					}
					if(uPlayTime != -2)
					{
						soData_Save.data["FT_Data"][5] = uPlayTime;
					}
					if(uActCount != -2)
					{
						soData_Save.data["FT_Data"][6] = uActCount;
					}
					if(uLiveHart != -2)
					{
						soData_Save.data["FT_Data"][7] = uLiveHart;
					}
					if(uSendCount != -2)
					{
						soData_Save.data["FT_Data"][8] = uSendCount;
					}
					if(uPlayName != null)
					{
						soData_Save.data["FT_Data"][9] = uPlayName;
					}
					if(uUrl != null)
					{
						soData_Save.data["FT_Data"][10] = uUrl;
					}
					if(uMuid != null)
					{
						soData_Save.data["FT_Data"][11] = uMuid;
					}
					try
					{
						soData_Save.flush();
					}
					catch(e:Error)
					{
						DebugInfo("保存FT_Data出错!");
					}
					soData_Save = null;
				}
				else
				{
					aoData_Save = new Array(10);
					aoData_Save[0] = uSetID;
					aoData_Save[1] = uUAID;
					aoData_Save[2] = uSessionID;
					aoData_Save[3] = uVideoID;
					aoData_Save[4] = uTotalTime;
					aoData_Save[5] = uPlayTime;
					aoData_Save[6] = uActCount;
					aoData_Save[7] = uLiveHart;
					aoData_Save[8] = uSendCount;
					aoData_Save[9] = uPlayName;
					aoData_Save[10] = uUrl;
					aoData_Save[11] = uMuid;
					soData_Save.data["FT_Data"] = aoData_Save;
					try
					{
						soData_Save.flush();
					}
					catch(e:Error)
					{
						DebugInfo("保存FT_Data出错!");
					}
					soData_Save = null;
				}
				this.ShareInfo();
			}
		}
		
		private function DataLoadSet(param1:int) : Array
		{
			var soData_Load:SharedObject = null;
			var aoData_Load:Array = null;
			var uSetID:int = param1;
			try
			{
				soData_Load = SharedObject.getLocal(this._IWT_FMark + "_" + uSetID,this._IWT_FDir);
			}
			catch(e:Error)
			{
				DebugInfo("读取FT_Data失败!" + e);
			}
			if(soData_Load.data["FT_Data"] is Array)
			{
				aoData_Load = soData_Load.data["FT_Data"] as Array;
				soData_Load = null;
				return aoData_Load;
			}
			return null;
		}
		
		private function HartSaveSet(param1:int, param2:int) : int
		{
			var soHart_Save:SharedObject = null;
			var aoHart_Save:Array = null;
			var MaxTime:int = 0;
			var MaxID:int = 0;
			var i:int = 0;
			var j:int = 0;
			var uSetID:int = param1;
			var uLiveHart:int = param2;
			try
			{
				soHart_Save = SharedObject.getLocal(this._IWT_FMark,this._IWT_FDir);
			}
			catch(e:Error)
			{
				DebugInfo("创建FT_Hart失败!" + e);
			}
			if(soHart_Save.data["FT_Hart"] is Array)
			{
				if(uSetID != -1)
				{
					soHart_Save.data["FT_Hart"][uSetID] = uLiveHart;
					try
					{
						soHart_Save.flush();
					}
					catch(e:Error)
					{
						DebugInfo("保存FT_Hart出错!" + e);
					}
					this.DebugInfo("更新FT_Hart数据! uSetID:" + uSetID + "LiveHart:" + uLiveHart);
				}
				else
				{
					aoHart_Save = soHart_Save.data["FT_Hart"];
					i = 0;
					while(i < aoHart_Save.length)
					{
						if(aoHart_Save[i] == -1)
						{
							uSetID = i;
							break;
						}
						if(MaxTime < aoHart_Save[i])
						{
							MaxTime = aoHart_Save[i];
							MaxID = i;
						}
						i++;
					}
					if(uSetID == -1)
					{
						uSetID = MaxID;
					}
					aoHart_Save[uSetID] = uLiveHart;
					soHart_Save.data["FT_Hart"] = aoHart_Save;
					try
					{
						soHart_Save.flush();
					}
					catch(e:Error)
					{
						DebugInfo("保存FT_Hart出错!" + e);
					}
					this.DebugInfo("获得新FT_Hart位置! uSetID:" + uSetID);
				}
			}
			else
			{
				aoHart_Save = new Array(this._MaxSave);
				j = 0;
				while(j < aoHart_Save.length)
				{
					aoHart_Save[j] = -1;
					j++;
				}
				uSetID = 0;
				aoHart_Save[uSetID] = uLiveHart;
				soHart_Save.data["FT_Hart"] = aoHart_Save;
				try
				{
					soHart_Save.flush();
				}
				catch(e:Error)
				{
					DebugInfo("保存FT_Hart出错!" + e);
				}
				this.DebugInfo("新用户，获得新FT_Hart位置! uSetID:" + uSetID);
			}
			soHart_Save = null;
			this.ShareInfo();
			return uSetID;
		}
		
		private function HartLoadSet() : Array
		{
			var soHart_Load:SharedObject = null;
			var aoHart_Load:Array = null;
			try
			{
				soHart_Load = SharedObject.getLocal(this._IWT_FMark,this._IWT_FDir);
			}
			catch(e:Error)
			{
				DebugInfo("读取FT_Hart失败!" + e);
			}
			if(soHart_Load.data["FT_Hart"] is Array)
			{
				aoHart_Load = soHart_Load.data["FT_Hart"] as Array;
				soHart_Load = null;
				return aoHart_Load;
			}
			return null;
		}
		
		private function ShareInfo() : void
		{
			var _loc1:Array = null;
			var _loc2:Array = null;
			var _loc3:* = 0;
			var _loc4:* = 0;
			if(this._IWT_Debug)
			{
				this.vShareInfo = "ShareObject:" + this._IWT_FMark + ".FT_Hart\n";
				_loc1 = this.HartLoadSet();
				if(_loc1 != null)
				{
					_loc4 = 0;
					while(_loc4 < _loc1.length)
					{
						this.vShareInfo = this.vShareInfo + ("FT_Hart[" + _loc4 + "]=" + _loc1[_loc4] + "\n");
						_loc4++;
					}
				}
				_loc3 = 0;
				while(_loc3 < this._MaxSave)
				{
					_loc2 = this.DataLoadSet(_loc3);
					if(_loc2 != null)
					{
						this.vShareInfo = this.vShareInfo + ("\nShareObject:" + this._IWT_FMark + ".FT_Data_" + _loc3 + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[0]=" + _loc2[0] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[1]=" + _loc2[1] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[2]=" + _loc2[2] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[3]=" + _loc2[3] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[4]=" + _loc2[4] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[5]=" + _loc2[5] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[6]=" + _loc2[6] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[7]=" + _loc2[7] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[8]=" + _loc2[8] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[9]=" + _loc2[9] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[10]=" + _loc2[10] + "\n");
						this.vShareInfo = this.vShareInfo + ("FT_Data_" + _loc3 + "[11]=" + _loc2[11] + "\n");
					}
					_loc3++;
				}
			}
			else
			{
				this.vShareInfo = "Debug Off!";
			}
		}
		
		private function DebugInfo(param1:String) : void
		{
			if(this._IWT_Debug)
			{
				if(this.vDebugInfo.split("\n").length > 15)
				{
					this.vDebugInfo = this.vDebugInfo.substr(this.vDebugInfo.indexOf("\n") + 1,9999);
				}
				this.vDebugInfo = this.vDebugInfo + (param1 + "\n");
			}
			else
			{
				this.vDebugInfo = "Debug Off!";
			}
		}
		
		public function destroy() : void
		{
			if(this.toHart)
			{
				this.toHart.removeEventListener(TimerEvent.TIMER,this.RunTimeHandler);
				this.toHart.stop();
				this.toHart = null;
			}
		}
	}
}
