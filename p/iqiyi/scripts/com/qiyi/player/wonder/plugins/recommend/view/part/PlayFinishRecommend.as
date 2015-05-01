package com.qiyi.player.wonder.plugins.recommend.view.part {
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendVO;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.geom.Rectangle;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.recommend.view.RecommendEvent;
	import flash.geom.Point;
	
	public class PlayFinishRecommend extends Sprite {
		
		public function PlayFinishRecommend(param1:Vector.<RecommendVO>, param2:uint = 0) {
			this._recommendVector = new Vector.<PlayFinishRecommendItem>();
			super();
			this._recommendData = param1;
			this._channelID = param2;
			if((this._recommendData) && this._recommendData.length > 0) {
				this.initPanel();
			}
		}
		
		private var _song:SoundChannel;
		
		private var _recommendData:Vector.<RecommendVO>;
		
		private var _channelID:uint = 0;
		
		private var _showWidth:Number = 0;
		
		private var _showHeight:Number = 0;
		
		private var _recommendVector:Vector.<PlayFinishRecommendItem>;
		
		public function get showHeight() : Number {
			return this._showHeight;
		}
		
		public function get showWidth() : Number {
			return this._showWidth;
		}
		
		private function initPanel() : void {
			var item:PlayFinishRecommendItem = null;
			var request:URLRequest = null;
			var soundFactory:Sound = null;
			var rec:Rectangle = null;
			var isbig:Boolean = false;
			var isCustomize:Boolean = false;
			try {
				request = new URLRequest(RecommendDef.SOUND_URL);
				soundFactory = new Sound();
				soundFactory.load(request);
				this._song = soundFactory.play();
			}
			catch(name_9:Error) {
			}
			var i:uint = 0;
			while(i < this._recommendData.length) {
				rec = PlayFinishRecommendUtils.getRecommendItemRectangle(i);
				isbig = i == 0?true:false;
				if(i == this._recommendData.length - 1 && (this._channelID == ChannelEnum.ENTERTAINMENT.id || this._channelID == ChannelEnum.HUMOR.id || this._channelID == ChannelEnum.NEWS.id || this._channelID == ChannelEnum.FINANCE.id)) {
					isCustomize = true;
				} else {
					isCustomize = false;
				}
				item = new PlayFinishRecommendItem(this._recommendData[i],rec.width,rec.height,isbig,isCustomize);
				item.x = rec.x;
				item.y = rec.y;
				this._recommendVector.push(item);
				addChild(item);
				item.addEventListener(MouseEvent.CLICK,this.onItemMouseClick);
				i++;
			}
		}
		
		private function onItemMouseClick(param1:MouseEvent) : void {
			var _loc2_:PlayFinishRecommendItem = param1.currentTarget as PlayFinishRecommendItem;
			if(_loc2_.isCustomize) {
				dispatchEvent(new RecommendEvent(RecommendEvent.Evt_CustomizeItemClick));
			} else {
				dispatchEvent(new RecommendEvent(RecommendEvent.Evt_OpenVideo,_loc2_.data));
			}
		}
		
		public function resize(param1:Number, param2:Number) : void {
			var _loc3_:Point = PlayFinishRecommendUtils.getShowPoint(param1,param2);
			this._showHeight = _loc3_.x * (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP);
			this._showWidth = _loc3_.y == 0?200:_loc3_.y * (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP);
			var _loc4_:* = 0;
			while(_loc4_ < this._recommendVector.length) {
				this._recommendVector[_loc4_].visible = true;
				if(this._recommendVector[_loc4_].row > _loc3_.x || this._recommendVector[_loc4_].col > _loc3_.y) {
					this._recommendVector[_loc4_].visible = false;
				}
				_loc4_++;
			}
		}
		
		public function destroy() : void {
			var _loc1_:PlayFinishRecommendItem = null;
			this._song = null;
			this._recommendData = null;
			while(this._recommendVector.length > 0) {
				_loc1_ = this._recommendVector.shift();
				_loc1_.removeEventListener(MouseEvent.CLICK,this.onItemMouseClick);
				removeChild(_loc1_);
				_loc1_.destroy();
				_loc1_ = null;
			}
			this._recommendVector.length = 0;
			this._recommendVector = null;
		}
	}
}
