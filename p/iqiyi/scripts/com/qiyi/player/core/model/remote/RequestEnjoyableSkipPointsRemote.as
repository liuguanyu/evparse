package com.qiyi.player.core.model.remote
{
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import flash.utils.Dictionary;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import com.qiyi.player.core.Config;
	import flash.events.Event;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import com.qiyi.player.core.model.impls.SkipPointInfo;
	import com.qiyi.player.base.logging.Log;
	
	public class RequestEnjoyableSkipPointsRemote extends BaseRemoteObject
	{
		
		private var _holder:ICorePlayer;
		
		private var _skipPointTypeArr:Array;
		
		private var _skipPointMap:Dictionary;
		
		private var _skipPointInfoDurationMap:Dictionary;
		
		private var _tvid:String;
		
		private var _log:ILogger;
		
		public function RequestEnjoyableSkipPointsRemote(param1:ICorePlayer, param2:String)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.actors.RequestEnjoyableSkipPointsRemote");
			super(0,"RequestEnjoyableSkipPointsRemote");
			_retryMaxCount = Config.requestSkipPointsMaxRetry;
			_timeout = Config.requestSkipPointsTimeout;
			this._holder = param1;
			this._tvid = param2;
			this._skipPointTypeArr = [];
			this._skipPointMap = new Dictionary();
			this._skipPointInfoDurationMap = new Dictionary();
		}
		
		public function get skipPointTypeArr() : Array
		{
			return this._skipPointTypeArr;
		}
		
		public function get skipPointMap() : Dictionary
		{
			return this._skipPointMap;
		}
		
		public function get skipPointInfoDurationMap() : Dictionary
		{
			return this._skipPointInfoDurationMap;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			this._skipPointTypeArr = null;
			this._skipPointMap = null;
			this._skipPointInfoDurationMap = null;
		}
		
		override protected function getRequest() : URLRequest
		{
			var _loc1:* = Config.ENJOYABLE_SKIP_POINT_URL + this._tvid + "/";
			return new URLRequest(_loc1);
		}
		
		override protected function onComplete(param1:Event) : void
		{
			var json:Object = null;
			var gen:Array = null;
			var j:int = 0;
			var item:Object = null;
			var time:Array = null;
			var gender:EnumItem = null;
			var timeArr:Array = null;
			var timeMap:Dictionary = null;
			var l:int = 0;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			try
			{
				_data = _loader.data;
				if(!(_data == null) && !(_data == ""))
				{
					json = com.adobe.serialization.json.JSON.decode(_data as String);
					if(json.code == "A00000")
					{
						gen = json.data as Array;
						if((gen) && gen.length > 0)
						{
							j = 0;
							while(j < gen.length)
							{
								item = gen[j];
								if(item)
								{
									time = item.data as Array;
									if(time)
									{
										gender = this.parseGender(int(item.gender));
										this._skipPointTypeArr.push(gender);
										timeArr = new Array(time.length);
										timeMap = new Dictionary();
										l = 0;
										while(l < time.length)
										{
											timeArr[l] = int(time[l].t) * 1000;
											timeMap[timeArr[l]] = this.parseData(time[l].data as Array);
											l++;
										}
										this._skipPointMap[gender] = timeMap;
										timeArr.sort(Array.NUMERIC);
										this._skipPointInfoDurationMap[gender] = timeArr;
									}
								}
								j++;
							}
						}
					}
					else
					{
						this._log.debug("RequestEnjoyableSkipPointsRemote result code: " + json.code);
					}
				}
				else
				{
					this._log.debug("RequestEnjoyableSkipPointsRemote result is empty!");
				}
				super.onComplete(event);
			}
			catch(e:Error)
			{
				_log.debug("RequestEnjoyableSkipPointsRemote result DataError!");
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
		
		private function parseGender(param1:int) : EnumItem
		{
			if(param1 == 1)
			{
				return SkipPointEnum.ENJOYABLE_SUB_MALE;
			}
			if(param1 == -1)
			{
				return SkipPointEnum.ENJOYABLE_SUB_FEMALE;
			}
			return SkipPointEnum.ENJOYABLE_SUB_COMMON;
		}
		
		private function parseData(param1:Array) : Vector.<SkipPointInfo>
		{
			var _loc5:Object = null;
			var _loc2:SkipPointInfo = null;
			var _loc3:Vector.<SkipPointInfo> = new Vector.<SkipPointInfo>();
			var _loc4:* = 0;
			while(_loc4 < param1.length)
			{
				_loc5 = param1[_loc4];
				if(_loc5)
				{
					_loc2 = new SkipPointInfo();
					if(int(_loc5.type) == 1)
					{
						_loc2.skipPointType = SkipPointEnum.ENJOYABLE;
					}
					_loc2.startTime = int(_loc5.start) * 1000;
					_loc2.endTime = int(_loc5.end) * 1000;
					_loc3.push(_loc2);
				}
				_loc4++;
			}
			return _loc3;
		}
	}
}
