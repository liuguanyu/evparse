package com.qiyi.player.wonder.plugins.continueplay.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	
	public class AddVideoListCommand extends SimpleCommand
	{
		
		public function AddVideoListCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:Array = param1.getBody().list as Array;
			var _loc3:int = param1.getBody().index;
			var _loc4:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc5:int = _loc2.length;
			var _loc6:Object = null;
			var _loc7:ContinueInfo = null;
			var _loc8:Vector.<ContinueInfo> = new Vector.<ContinueInfo>(_loc5);
			var _loc9:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc10:* = false;
			if((_loc9.curActor.movieModel) && (_loc9.curActor.movieModel.channelID == ChannelEnum.FINANCE.id || _loc9.curActor.movieModel.channelID == ChannelEnum.ENTERTAINMENT.id || _loc9.curActor.movieModel.channelID == ChannelEnum.LIFE_MICRO_VIDEO.id || _loc9.curActor.movieModel.channelID == ChannelEnum.FASHION.id || _loc9.curActor.movieModel.channelID == ChannelEnum.SPORTS.id || _loc9.curActor.movieModel.channelID == ChannelEnum.NEWS.id))
			{
				_loc10 = true;
			}
			if(param1.getBody().source == undefined)
			{
				_loc4.dataSource = ContinuePlayDef.SOURCE_DEFAULT_VALUE;
			}
			else
			{
				_loc4.dataSource = int(param1.getBody().source) == ContinuePlayDef.SOURCE_QIYU_VALUE?ContinuePlayDef.SOURCE_QIYU_VALUE:_loc4.dataSource;
			}
			if(int(param1.getBody().source) != ContinuePlayDef.SOURCE_AD_VALUE)
			{
				_loc4.taid = param1.getBody().taid == undefined?"":param1.getBody().taid;
				_loc4.tcid = param1.getBody().tcid == undefined?"":param1.getBody().tcid;
			}
			if(_loc3 == -1)
			{
				_loc3 = _loc4.continueInfoCount;
			}
			if(_loc5)
			{
				if(_loc3 == 0)
				{
					_loc4.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
				}
				else
				{
					_loc4.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
				}
				if(param1.getBody().before != undefined)
				{
					_loc4.hasPreNeedLoad = String(param1.getBody().before) == "true";
				}
				if(param1.getBody().after != undefined)
				{
					_loc4.hasNextNeedLoad = String(param1.getBody().after) == "true";
				}
				var _loc11:* = 0;
				while(_loc11 < _loc5)
				{
					_loc6 = _loc2[_loc11];
					_loc7 = new ContinueInfo();
					_loc7.loadMovieParams.tvid = _loc6.tvid;
					_loc7.loadMovieParams.vid = _loc6.vid;
					_loc7.loadMovieParams.movieIsMember = _loc6.isMemberVideo == "true";
					_loc7.loadMovieParams.albumId = _loc6.albumId == undefined?"":_loc6.albumId;
					_loc7.imageURL = _loc6.imageURL == undefined?"":_loc6.imageURL;
					_loc7.title = _loc6.title == undefined?"":_loc6.title;
					_loc7.describe = _loc6.describe == undefined?"":_loc6.describe;
					_loc7.channelID = _loc6.channelId == undefined?0:_loc6.channelId;
					_loc7.exclusive = _loc6.exclusive == undefined?"":_loc6.exclusive;
					_loc7.vfrm = _loc6.vfrm == undefined?"":_loc6.vfrm;
					_loc7.qiyiProduced = _loc6.qiyiProduced == undefined?"":_loc6.qiyiProduced;
					if(_loc10)
					{
						_loc7.publishTime = _loc6.publishTime == undefined?"":_loc6.publishTime;
					}
					if(_loc6.isAd != undefined)
					{
						_loc7.isAdVideo = _loc6.isAd == "true";
					}
					if(_loc6.name_2 == undefined || _loc6.name_2 == "")
					{
						_loc7.curSet = 0;
					}
					else
					{
						_loc7.curSet = int(_loc6.name_2);
					}
					_loc7.cupId = _loc6.cid == undefined?"":_loc6.cid;
					_loc8[_loc11] = _loc7;
					_loc11++;
				}
				_loc4.addContinueInfoList(_loc8,_loc3);
				return;
			}
			if(_loc3 == 0)
			{
				_loc4.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
			}
			else
			{
				_loc4.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
			}
		}
	}
}
