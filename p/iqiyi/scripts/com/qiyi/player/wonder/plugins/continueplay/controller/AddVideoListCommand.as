package com.qiyi.player.wonder.plugins.continueplay.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	
	public class AddVideoListCommand extends SimpleCommand {
		
		public function AddVideoListCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:Array = param1.getBody().list as Array;
			var _loc3_:int = param1.getBody().index;
			var _loc4_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc5_:int = _loc2_.length;
			var _loc6_:Object = null;
			var _loc7_:ContinueInfo = null;
			var _loc8_:Vector.<ContinueInfo> = new Vector.<ContinueInfo>(_loc5_);
			var _loc9_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc10_:* = false;
			if((_loc9_.curActor.movieModel) && (_loc9_.curActor.movieModel.channelID == ChannelEnum.FINANCE.id || _loc9_.curActor.movieModel.channelID == ChannelEnum.ENTERTAINMENT.id || _loc9_.curActor.movieModel.channelID == ChannelEnum.LIFE_MICRO_VIDEO.id || _loc9_.curActor.movieModel.channelID == ChannelEnum.FASHION.id || _loc9_.curActor.movieModel.channelID == ChannelEnum.SPORTS.id || _loc9_.curActor.movieModel.channelID == ChannelEnum.NEWS.id)) {
				_loc10_ = true;
			}
			if(param1.getBody().source == undefined) {
				_loc4_.dataSource = ContinuePlayDef.SOURCE_DEFAULT_VALUE;
			} else {
				_loc4_.dataSource = int(param1.getBody().source) == ContinuePlayDef.SOURCE_QIYU_VALUE?ContinuePlayDef.SOURCE_QIYU_VALUE:_loc4_.dataSource;
			}
			if(int(param1.getBody().source) != ContinuePlayDef.SOURCE_AD_VALUE) {
				_loc4_.taid = param1.getBody().taid == undefined?"":param1.getBody().taid;
				_loc4_.tcid = param1.getBody().tcid == undefined?"":param1.getBody().tcid;
			}
			if(_loc3_ == -1) {
				_loc3_ = _loc4_.continueInfoCount;
			}
			if(_loc5_) {
				if(_loc3_ == 0) {
					_loc4_.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
				} else {
					_loc4_.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
				}
				if(param1.getBody().before != undefined) {
					_loc4_.hasPreNeedLoad = String(param1.getBody().before) == "true";
				}
				if(param1.getBody().after != undefined) {
					_loc4_.hasNextNeedLoad = String(param1.getBody().after) == "true";
				}
				var _loc11_:* = 0;
				while(_loc11_ < _loc5_) {
					_loc6_ = _loc2_[_loc11_];
					_loc7_ = new ContinueInfo();
					_loc7_.loadMovieParams.tvid = _loc6_.tvid;
					_loc7_.loadMovieParams.vid = _loc6_.vid;
					_loc7_.loadMovieParams.movieIsMember = _loc6_.isMemberVideo == "true";
					_loc7_.loadMovieParams.albumId = _loc6_.albumId == undefined?"":_loc6_.albumId;
					_loc7_.imageURL = _loc6_.imageURL == undefined?"":_loc6_.imageURL;
					_loc7_.title = _loc6_.title == undefined?"":_loc6_.title;
					_loc7_.describe = _loc6_.describe == undefined?"":_loc6_.describe;
					_loc7_.channelID = _loc6_.channelId == undefined?0:_loc6_.channelId;
					_loc7_.exclusive = _loc6_.exclusive == undefined?"":_loc6_.exclusive;
					_loc7_.vfrm = _loc6_.vfrm == undefined?"":_loc6_.vfrm;
					_loc7_.qiyiProduced = _loc6_.qiyiProduced == undefined?"":_loc6_.qiyiProduced;
					if(_loc10_) {
						_loc7_.publishTime = _loc6_.publishTime == undefined?"":_loc6_.publishTime;
					}
					if(_loc6_.isAd != undefined) {
						_loc7_.isAdVideo = _loc6_.isAd == "true";
					}
					if(_loc6_.name_2 == undefined || _loc6_.name_2 == "") {
						_loc7_.curSet = 0;
					} else {
						_loc7_.curSet = int(_loc6_.name_2);
					}
					_loc7_.cupId = _loc6_.cid == undefined?"":_loc6_.cid;
					_loc8_[_loc11_] = _loc7_;
					_loc11_++;
				}
				_loc4_.addContinueInfoList(_loc8_,_loc3_);
				return;
			}
			if(_loc3_ == 0) {
				_loc4_.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
			} else {
				_loc4_.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
			}
		}
	}
}
