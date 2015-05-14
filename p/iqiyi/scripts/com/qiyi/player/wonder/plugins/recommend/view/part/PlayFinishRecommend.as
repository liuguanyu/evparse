package com.qiyi.player.wonder.plugins.recommend.view.part
{
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
	
	public class PlayFinishRecommend extends Sprite
	{
		
		private var _song:SoundChannel;
		
		private var _recommendData:Vector.<RecommendVO>;
		
		private var _channelID:uint = 0;
		
		private var _showWidth:Number = 0;
		
		private var _showHeight:Number = 0;
		
		private var _recommendVector:Vector.<PlayFinishRecommendItem>;
		
		public function PlayFinishRecommend(param1:Vector.<RecommendVO>, param2:uint = 0)
		{
			this._recommendVector = new Vector.<PlayFinishRecommendItem>();
			super();
			this._recommendData = param1;
			this._channelID = param2;
			if((this._recommendData) && this._recommendData.length > 0)
			{
				this.initPanel();
			}
		}
		
		public function get showHeight() : Number
		{
			return this._showHeight;
		}
		
		public function get showWidth() : Number
		{
			return this._showWidth;
		}
		
		private function initPanel() : void
		{
			var item:PlayFinishRecommendItem = null;
			var request:URLRequest = null;
			var soundFactory:Sound = null;
			var rec:Rectangle = null;
			var isbig:Boolean = false;
			var isCustomize:Boolean = false;
			try
			{
				request = new URLRequest(RecommendDef.SOUND_URL);
				soundFactory = new Sound();
				soundFactory.load(request);
				this._song = soundFactory.play();
			}
			catch(name_9:Error)
			{
			}
			var i:uint = 0;
			while(i < this._recommendData.length)
			{
				rec = PlayFinishRecommendUtils.getRecommendItemRectangle(i);
				isbig = i == 0?true:false;
				if(i == this._recommendData.length - 1 && (this._channelID == ChannelEnum.ENTERTAINMENT.id || this._channelID == ChannelEnum.HUMOR.id || this._channelID == ChannelEnum.NEWS.id || this._channelID == ChannelEnum.FINANCE.id))
				{
					isCustomize = true;
				}
				else
				{
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
		
		private function onItemMouseClick(param1:MouseEvent) : void
		{
			var _loc2:PlayFinishRecommendItem = param1.currentTarget as PlayFinishRecommendItem;
			if(_loc2.isCustomize)
			{
				dispatchEvent(new RecommendEvent(RecommendEvent.Evt_CustomizeItemClick));
			}
			else
			{
				dispatchEvent(new RecommendEvent(RecommendEvent.Evt_OpenVideo,_loc2.data));
			}
		}
		
		public function resize(param1:Number, param2:Number) : void
		{
			var _loc3:Point = PlayFinishRecommendUtils.getShowPoint(param1,param2);
			this._showHeight = _loc3.x * (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP);
			this._showWidth = _loc3.y == 0?200:_loc3.y * (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP);
			var _loc4:* = 0;
			while(_loc4 < this._recommendVector.length)
			{
				this._recommendVector[_loc4].visible = true;
				if(this._recommendVector[_loc4].row > _loc3.x || this._recommendVector[_loc4].col > _loc3.y)
				{
					this._recommendVector[_loc4].visible = false;
				}
				_loc4++;
			}
		}
		
		public function destroy() : void
		{
			var _loc1:PlayFinishRecommendItem = null;
			this._song = null;
			this._recommendData = null;
			while(this._recommendVector.length > 0)
			{
				_loc1 = this._recommendVector.shift();
				_loc1.removeEventListener(MouseEvent.CLICK,this.onItemMouseClick);
				removeChild(_loc1);
				_loc1.destroy();
				_loc1 = null;
			}
			this._recommendVector.length = 0;
			this._recommendVector = null;
		}
	}
}
