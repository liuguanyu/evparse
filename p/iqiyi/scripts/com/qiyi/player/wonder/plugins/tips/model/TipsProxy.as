package com.qiyi.player.wonder.plugins.tips.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.logging.Log;
	
	public class TipsProxy extends Proxy implements IStatus
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.tips.model.TipsProxy";
		
		private var _status:Status;
		
		private var _definitionLagTimesArr:Array;
		
		private var _isFocusFirstTips:Boolean = false;
		
		private var _isFocusSecondTips:Boolean = false;
		
		private var _loader:URLLoader;
		
		private var _request:URLRequest;
		
		private var _isLoader:Boolean = false;
		
		private var _log:ILogger;
		
		public function TipsProxy(param1:Object = null)
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.tips.model.TipsProxy");
			super(NAME,param1);
			this._status = new Status(TipsDef.STATUS_BEGIN,TipsDef.STATUS_END);
			this._definitionLagTimesArr = [];
			this._status.addStatus(TipsDef.STATUS_VIEW_INIT);
		}
		
		public function get isLoader() : Boolean
		{
			return this._isLoader;
		}
		
		public function get status() : Status
		{
			return this._status;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= TipsDef.STATUS_BEGIN && param1 < TipsDef.STATUS_END && !this._status.hasStatus(param1))
			{
				if(param1 == TipsDef.STATUS_OPEN && !this._status.hasStatus(TipsDef.STATUS_VIEW_INIT))
				{
					this._status.addStatus(TipsDef.STATUS_VIEW_INIT);
					sendNotification(TipsDef.NOTIFIC_ADD_STATUS,TipsDef.STATUS_VIEW_INIT);
				}
				this._status.addStatus(param1);
				if(param2)
				{
					sendNotification(TipsDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= TipsDef.STATUS_BEGIN && param1 < TipsDef.STATUS_END && (this._status.hasStatus(param1)))
			{
				this._status.removeStatus(param1);
				if(param2)
				{
					sendNotification(TipsDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean
		{
			return this._status.hasStatus(param1);
		}
		
		public function getHotChatTipsTimesByIndex(param1:uint) : Boolean
		{
			switch(param1)
			{
				case 0:
					return this._isFocusFirstTips;
				case 1:
					return this._isFocusSecondTips;
				default:
					return true;
			}
		}
		
		public function setHotChatTipsTimesByIndex(param1:uint) : void
		{
			switch(param1)
			{
				case 0:
					this._isFocusFirstTips = true;
					break;
				case 1:
					this._isFocusSecondTips = true;
					break;
			}
		}
		
		public function clearHotChatTipsTimes() : void
		{
			this._isFocusSecondTips = false;
			this._isFocusFirstTips = false;
		}
		
		public function requestUseTicket(param1:String) : void
		{
			if(this._isLoader)
			{
				return;
			}
			this._isLoader = true;
			this._request = new URLRequest(SystemConfig.MEMBER_TICKET_USE_URL + "?aid=" + param1 + "&platform=b6c13e26323c537d&version=1.0" + Math.random());
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,this.onCompleteHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			this._loader.load(this._request);
		}
		
		private function onCompleteHandler(param1:Event) : void
		{
			var obj:Object = null;
			var javascriptAPIProxy:JavascriptAPIProxy = null;
			var event:Event = param1;
			this._isLoader = false;
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(this._loader.data);
				this._log.info("TipsProxy requestUseTicket : " + this._loader.data);
				if(obj.code == "A00000")
				{
					javascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					javascriptAPIProxy.callJsRefreshPage();
				}
			}
			catch(e:Error)
			{
				_log.info("TipsProxy requestUseTicket : json decode error");
			}
		}
		
		private function onErrorHander(param1:*) : void
		{
			this._isLoader = false;
			this._log.info("TipsProxy requestUseTicket : error");
		}
		
		public function lagDownDefinition(param1:int) : Boolean
		{
			var _loc2:uint = new Date().time;
			this._definitionLagTimesArr.push(_loc2);
			var _loc3:* = 0;
			while(_loc3 < this._definitionLagTimesArr.length)
			{
				if(_loc2 - this._definitionLagTimesArr[_loc3] > param1)
				{
					this._definitionLagTimesArr.splice(_loc3,1);
				}
				_loc3++;
			}
			if(this._definitionLagTimesArr.length >= TipsDef.MAX_DEFINITION_STUCK)
			{
				this._definitionLagTimesArr.length = 0;
				return true;
			}
			return false;
		}
	}
}
