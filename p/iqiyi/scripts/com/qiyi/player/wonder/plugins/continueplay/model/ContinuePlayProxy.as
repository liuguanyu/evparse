package com.qiyi.player.wonder.plugins.continueplay.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import flash.utils.Dictionary;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.logging.Log;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import flash.external.ExternalInterface;
	
	public class ContinuePlayProxy extends Proxy implements IStatus
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy";
		
		private var _status:Status;
		
		private var _continueInfoList:Vector.<ContinueInfo>;
		
		private var _continueInfoIndexMap:Dictionary;
		
		private var _isContinue:Boolean = true;
		
		private var _isJSContinue:Boolean = false;
		
		private var _JSContinueTitle:String = "";
		
		private var _isCyclePlay:Boolean;
		
		private var _hasPreNeedLoad:Boolean;
		
		private var _hasNextNeedLoad:Boolean;
		
		private var _dataSource:uint = 0;
		
		private var _switchVideoType:int = 0;
		
		private var _taid:String = "";
		
		private var _tcid:String = "";
		
		private var _playerProxy:PlayerProxy;
		
		private var _log:ILogger;
		
		public function ContinuePlayProxy(param1:Object = null)
		{
			var var_1:Object = param1;
			this._log = Log.getLogger(NAME);
			super(NAME,var_1);
			this._status = new Status(ContinuePlayDef.STATUS_BEGIN,ContinuePlayDef.STATUS_END);
			this._continueInfoList = new Vector.<ContinueInfo>();
			this._continueInfoIndexMap = new Dictionary();
			this._isCyclePlay = FlashVarConfig.cyclePlay;
			this._status.addStatus(ContinuePlayDef.STATUS_VIEW_INIT);
			try
			{
				ExternalInterface.addCallback("getContinueData",this.getContinueData);
				ExternalInterface.addCallback("getSwitchVideoType",this.getSwitchVideoType);
			}
			catch(error:Error)
			{
				_log.warn("ContinuePlayProxy add call back error!");
			}
		}
		
		public function get taid() : String
		{
			return this._taid;
		}
		
		public function set taid(param1:String) : void
		{
			this._taid = param1;
		}
		
		public function get tcid() : String
		{
			return this._tcid;
		}
		
		public function set tcid(param1:String) : void
		{
			this._tcid = param1;
		}
		
		public function get status() : Status
		{
			return this._status;
		}
		
		public function get hasPreNeedLoad() : Boolean
		{
			return this._hasPreNeedLoad;
		}
		
		public function set hasPreNeedLoad(param1:Boolean) : void
		{
			this._hasPreNeedLoad = param1;
		}
		
		public function get hasNextNeedLoad() : Boolean
		{
			return this._hasNextNeedLoad;
		}
		
		public function set hasNextNeedLoad(param1:Boolean) : void
		{
			this._hasNextNeedLoad = param1;
		}
		
		public function get continueInfoList() : Vector.<ContinueInfo>
		{
			return this._continueInfoList;
		}
		
		public function get continueInfoCount() : int
		{
			return this._continueInfoList.length;
		}
		
		public function get isContinue() : Boolean
		{
			return this._isContinue;
		}
		
		public function set isContinue(param1:Boolean) : void
		{
			this._isContinue = param1;
		}
		
		public function get isJSContinue() : Boolean
		{
			return this._isJSContinue;
		}
		
		public function set isJSContinue(param1:Boolean) : void
		{
			this._isJSContinue = param1;
		}
		
		public function get JSContinueTitle() : String
		{
			return this._JSContinueTitle;
		}
		
		public function set JSContinueTitle(param1:String) : void
		{
			this._JSContinueTitle = param1;
		}
		
		public function get isCyclePlay() : Boolean
		{
			return this._isCyclePlay;
		}
		
		public function set isCyclePlay(param1:Boolean) : void
		{
			this._isCyclePlay = param1;
			sendNotification(ContinuePlayDef.NOTIFIC_CYCLE_PLAY_CHANGED,this._isCyclePlay);
		}
		
		public function get switchVideoType() : int
		{
			return this._switchVideoType;
		}
		
		public function get dataSource() : uint
		{
			return this._dataSource;
		}
		
		public function set dataSource(param1:uint) : void
		{
			this._dataSource = param1;
		}
		
		public function set switchVideoType(param1:int) : void
		{
			this._switchVideoType = param1;
			sendNotification(ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED,this._switchVideoType);
		}
		
		public function injectPlayerProxy(param1:PlayerProxy) : void
		{
			this._playerProxy = param1;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= ContinuePlayDef.STATUS_BEGIN && param1 < ContinuePlayDef.STATUS_END && !this._status.hasStatus(param1))
			{
				if(param1 == ContinuePlayDef.STATUS_OPEN && !this._status.hasStatus(ContinuePlayDef.STATUS_VIEW_INIT))
				{
					this._status.addStatus(ContinuePlayDef.STATUS_VIEW_INIT);
					sendNotification(ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.STATUS_VIEW_INIT);
				}
				switch(param1)
				{
					case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS:
						this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
						this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
						break;
					case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING:
						this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
						this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
						break;
					case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED:
						this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
						this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
						break;
					case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS:
						this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
						this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
						break;
					case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING:
						this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
						this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
						break;
					case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED:
						this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
						this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
						break;
				}
				this._status.addStatus(param1);
				if(param2)
				{
					sendNotification(ContinuePlayDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= ContinuePlayDef.STATUS_BEGIN && param1 < ContinuePlayDef.STATUS_END && (this._status.hasStatus(param1)))
			{
				this._status.removeStatus(param1);
				if(param2)
				{
					sendNotification(ContinuePlayDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean
		{
			return this._status.hasStatus(param1);
		}
		
		public function addContinueInfoList(param1:Vector.<ContinueInfo>, param2:int) : void
		{
			var _loc3:int = param1.length;
			var _loc4:* = 0;
			while(_loc4 < _loc3)
			{
				this._continueInfoList.splice(param2 + _loc4,0,param1[_loc4]);
				_loc4++;
			}
			if(this._continueInfoList.length > 0)
			{
				this._isJSContinue = false;
				this._JSContinueTitle = "";
			}
			this.updateContinueInfoIndex();
			sendNotification(ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,{
				"add":true,
				"addCount":_loc3
			});
		}
		
		public function removeContinueInfoList(param1:Vector.<String>, param2:Vector.<String>) : void
		{
			var _loc3:int = param1.length;
			var _loc4:* = "";
			var _loc5:* = "";
			var _loc6:* = "";
			var _loc7:* = 0;
			var _loc8:* = 0;
			while(_loc8 < _loc3)
			{
				_loc4 = param1[_loc8];
				_loc5 = param2[_loc8];
				_loc6 = _loc4 + _loc5;
				if(this._continueInfoIndexMap[_loc6] != undefined)
				{
					_loc7 = this._continueInfoIndexMap[_loc6];
					this._continueInfoList.splice(_loc7,1);
					delete this._continueInfoIndexMap[_loc6];
					true;
				}
				_loc8++;
			}
			this.updateContinueInfoIndex();
			sendNotification(ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,{"add":false});
		}
		
		public function clearContinueInfo() : void
		{
			if(this._continueInfoList.length > 0)
			{
				this._continueInfoList = new Vector.<ContinueInfo>();
				this._continueInfoIndexMap = new Dictionary();
				sendNotification(ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,{"add":false});
			}
		}
		
		public function findContinueInfoAt(param1:int) : ContinueInfo
		{
			if(param1 >= 0 && param1 < this._continueInfoList.length)
			{
				return this._continueInfoList[param1];
			}
			return null;
		}
		
		public function findContinueInfo(param1:String, param2:String) : ContinueInfo
		{
			var _loc4:* = 0;
			var _loc3:String = param1 + param2;
			if(this._continueInfoIndexMap[_loc3] != undefined)
			{
				_loc4 = this._continueInfoIndexMap[_loc3];
				return this._continueInfoList[_loc4];
			}
			return null;
		}
		
		public function findNextContinueInfo(param1:String, param2:String) : ContinueInfo
		{
			var _loc4:* = 0;
			var _loc3:String = param1 + param2;
			if(this._continueInfoIndexMap[_loc3] != undefined)
			{
				_loc4 = this._continueInfoIndexMap[_loc3];
				if(_loc4 != this.continueInfoCount - 1)
				{
					return this._continueInfoList[_loc4 + 1];
				}
			}
			return null;
		}
		
		public function findPreContinueInfo(param1:String, param2:String) : ContinueInfo
		{
			var _loc4:* = 0;
			var _loc3:String = param1 + param2;
			if(this._continueInfoIndexMap[_loc3] != undefined)
			{
				_loc4 = this._continueInfoIndexMap[_loc3];
				if(_loc4 > 0)
				{
					return this._continueInfoList[_loc4 - 1];
				}
			}
			return null;
		}
		
		public function cloneContinueInfoList() : Vector.<ContinueInfo>
		{
			return this._continueInfoList.concat();
		}
		
		public function getPageContinueInfoList(param1:int, param2:int) : Vector.<ContinueInfo>
		{
			var _loc3:int = Math.ceil(this._continueInfoList.length / param1);
			var _loc4:* = 0;
			var _loc5:* = 0;
			if(param2 >= _loc3)
			{
				_loc4 = (_loc3 - 1) * param1;
				_loc5 = this._continueInfoList.length;
			}
			else
			{
				_loc4 = (param2 - 1) * param1;
				_loc5 = _loc4 + param1;
			}
			var _loc6:Vector.<ContinueInfo> = new Vector.<ContinueInfo>();
			var _loc7:int = _loc4;
			while(_loc7 < _loc5)
			{
				_loc6.push(this._continueInfoList[_loc7]);
				_loc7++;
			}
			return _loc6;
		}
		
		private function updateContinueInfoIndex() : void
		{
			var _loc1:int = this._continueInfoList.length;
			var _loc2:* = "";
			var _loc3:* = 0;
			while(_loc3 < _loc1)
			{
				_loc2 = this._continueInfoList[_loc3].loadMovieParams.tvid + this._continueInfoList[_loc3].loadMovieParams.vid;
				this._continueInfoList[_loc3].index = _loc3;
				this._continueInfoIndexMap[_loc2] = _loc3;
				_loc3++;
			}
		}
		
		private function getContinueData() : String
		{
			var _loc5:ContinueInfo = null;
			var _loc6:ContinueInfo = null;
			var _loc1:* = false;
			var _loc2:* = false;
			var _loc3:LoadMovieParams = this._playerProxy.curActor.loadMovieParams;
			if(_loc3)
			{
				_loc5 = this.findPreContinueInfo(_loc3.tvid,_loc3.vid);
				_loc1 = !(_loc5 == null);
				_loc6 = this.findNextContinueInfo(_loc3.tvid,_loc3.vid);
				_loc2 = !(_loc6 == null);
			}
			var _loc4:Object = {};
			_loc4.hasPre = _loc1?"1":"0";
			_loc4.hasNext = _loc2?"1":"0";
			return com.adobe.serialization.json.JSON.encode(_loc4);
		}
		
		private function getSwitchVideoType() : String
		{
			if(this._switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO)
			{
				return "0";
			}
			if(this._switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_FLASH_LIST)
			{
				return "1";
			}
			if(this._switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_JS_LIST)
			{
				return "3";
			}
			return "2";
		}
	}
}
