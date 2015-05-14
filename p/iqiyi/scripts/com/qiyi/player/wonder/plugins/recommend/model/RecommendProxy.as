package com.qiyi.player.wonder.plugins.recommend.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import com.qiyi.player.base.logging.Log;
	
	public class RecommendProxy extends Proxy implements IStatus
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy";
		
		private var _status:Status;
		
		private var _playFinishJson:Object = null;
		
		private var _playFinishDataVector:Vector.<RecommendVO>;
		
		private var _log:ILogger;
		
		public function RecommendProxy(param1:Object = null)
		{
			this._playFinishDataVector = new Vector.<RecommendVO>();
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy");
			super(NAME,param1);
			this._status = new Status(RecommendDef.STATUS_BEGIN,RecommendDef.STATUS_END);
		}
		
		public function getArea(param1:Object) : String
		{
			if(param1 == null)
			{
				return "";
			}
			var _loc2:Object = param1.attribute;
			if((_loc2) && !(_loc2.area == undefined))
			{
				return _loc2.area;
			}
			return "";
		}
		
		public function getBkt(param1:Object) : String
		{
			if(param1 == null)
			{
				return "";
			}
			var _loc2:Object = param1.attribute;
			if((_loc2) && (!(_loc2.bkt == undefined) || !(_loc2.bucket == undefined)))
			{
				return _loc2.bkt != undefined?_loc2.bkt:_loc2.bucket;
			}
			return "";
		}
		
		public function getEventID(param1:Object) : String
		{
			if(param1 == null)
			{
				return "";
			}
			var _loc2:Object = param1.attribute;
			if((_loc2) && !(_loc2.eventId == undefined))
			{
				return _loc2.eventId;
			}
			return "";
		}
		
		public function getRecommendIDString(param1:Vector.<RecommendVO>) : String
		{
			var _loc3:uint = 0;
			var _loc2:* = "";
			if(param1.length > 0)
			{
				_loc3 = 0;
				while(_loc3 < param1.length)
				{
					if(_loc3 == param1.length - 1)
					{
						_loc2 = _loc2 + param1[_loc3].albumID;
					}
					else
					{
						_loc2 = _loc2 + (param1[_loc3].albumID + ",");
					}
					_loc3++;
				}
			}
			return _loc2;
		}
		
		public function get playFinishDataVector() : Vector.<RecommendVO>
		{
			return this._playFinishDataVector;
		}
		
		public function get playFinishJson() : Object
		{
			return this._playFinishJson;
		}
		
		public function set playFinishJson(param1:Object) : void
		{
			var _loc2:RecommendVO = null;
			var _loc4:RecommendVO = null;
			if(this._playFinishDataVector)
			{
				while(this._playFinishDataVector.length > 0)
				{
					_loc4 = this._playFinishDataVector.shift();
					_loc4.destroy();
					_loc4 = null;
				}
			}
			var _loc3:uint = 0;
			while(_loc3 < param1.mixinVideos.length)
			{
				_loc2 = new RecommendVO(_loc3,param1.mixinVideos[_loc3]);
				this._playFinishDataVector.push(_loc2);
				_loc3++;
			}
			this._playFinishJson = param1;
		}
		
		public function get status() : Status
		{
			return this._status;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= RecommendDef.STATUS_BEGIN && param1 < RecommendDef.STATUS_END && !this._status.hasStatus(param1))
			{
				if(param1 == RecommendDef.STATUS_FINISH_RECOMMEND_OPEN && !this._status.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT))
				{
					this._status.addStatus(RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT);
					sendNotification(RecommendDef.NOTIFIC_ADD_STATUS,RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT);
				}
				this._status.addStatus(param1);
				if(param2)
				{
					sendNotification(RecommendDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= RecommendDef.STATUS_BEGIN && param1 < RecommendDef.STATUS_END && (this._status.hasStatus(param1)))
			{
				this._status.removeStatus(param1);
				if(param2)
				{
					sendNotification(RecommendDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean
		{
			return this._status.hasStatus(param1);
		}
	}
}
