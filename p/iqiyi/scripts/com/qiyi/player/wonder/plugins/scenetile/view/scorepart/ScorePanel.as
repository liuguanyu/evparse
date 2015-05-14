package com.qiyi.player.wonder.plugins.scenetile.view.scorepart
{
	import flash.display.Sprite;
	import common.CommonBg;
	import scenetile.ScoreCloseBtn;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileEvent;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import flash.display.DisplayObject;
	
	public class ScorePanel extends Sprite
	{
		
		private static const FRAME_NAME_RED_HEART:String = "_redHeart";
		
		private static const FRAME_NAME_GRAY_HEART:String = "_grayHeart";
		
		private static const STR_SCORE_DESCRIBE:String = "喜欢就评价一下吧：";
		
		private static const STR_SCORE_EXPLAIN:String = "越多评价，推荐给您的视频越准确哦！！";
		
		private var _bg:CommonBg;
		
		private var _closeBtn:ScoreCloseBtn;
		
		private var _tfVideoName:TextField;
		
		private var _tfCurVideoScore:TextField;
		
		private var _tfFixed:TextField;
		
		private var _tfHeartDescribe:TextField;
		
		private var _tfLevelDescribe:TextField;
		
		private var _tfScoreExplain:TextField;
		
		private var _mcScoreHeartVector:Vector.<ScoreHeartItem>;
		
		private var _videoName:String = "";
		
		private var _curScoreNum:Number = 0;
		
		public function ScorePanel(param1:String, param2:Number)
		{
			super();
			this._videoName = param1;
			this._curScoreNum = param2;
			this.initPanel();
		}
		
		private function initPanel() : void
		{
			var _loc1:ScoreHeartItem = null;
			this._bg = new CommonBg();
			this._bg.width = 310;
			this._bg.height = 126;
			addChild(this._bg);
			this._tfVideoName = FastCreator.createLabel(this._videoName,16777215,16,TextFieldAutoSize.LEFT);
			this._tfVideoName.x = 12;
			this._tfVideoName.y = 17;
			addChild(this._tfVideoName);
			this._tfCurVideoScore = FastCreator.createLabel("8.0",16711680,18,TextFieldAutoSize.CENTER);
			this._tfCurVideoScore.x = 200;
			this._tfCurVideoScore.y = 16;
			addChild(this._tfCurVideoScore);
			this._tfFixed = FastCreator.createLabel("分",10066329,12,TextFieldAutoSize.CENTER);
			this._tfFixed.x = this._tfCurVideoScore.x + this._tfCurVideoScore.width;
			this._tfFixed.y = 21;
			addChild(this._tfFixed);
			this._tfHeartDescribe = FastCreator.createLabel(STR_SCORE_DESCRIBE,16777215,14,TextFieldAutoSize.LEFT);
			this._tfHeartDescribe.x = 12;
			this._tfHeartDescribe.y = 52;
			addChild(this._tfHeartDescribe);
			if(this._curScoreNum > 0)
			{
				this._tfCurVideoScore.visible = this._tfFixed.visible = true;
				this._tfCurVideoScore.text = this._curScoreNum.toString();
				this._tfCurVideoScore.x = this._tfVideoName.x + this._tfVideoName.textWidth + 15;
				this._tfFixed.x = this._tfCurVideoScore.x + this._tfCurVideoScore.width;
			}
			else
			{
				this._tfCurVideoScore.visible = this._tfFixed.visible = false;
			}
			this._mcScoreHeartVector = new Vector.<ScoreHeartItem>();
			var _loc2:uint = 0;
			while(_loc2 < SceneTileDef.SCORE_MAX_LEVEL)
			{
				_loc1 = new ScoreHeartItem(_loc2);
				_loc1.heartState(FRAME_NAME_GRAY_HEART);
				_loc1.addEventListener(MouseEvent.CLICK,this.onHeartItemClick);
				_loc1.addEventListener(MouseEvent.ROLL_OVER,this.onHeartItemRollOver);
				_loc1.addEventListener(MouseEvent.ROLL_OUT,this.onHeartItemRollOut);
				_loc1.x = this._tfHeartDescribe.x + this._tfHeartDescribe.textWidth + _loc1.width * _loc2;
				_loc1.y = this._tfHeartDescribe.y + (this._tfHeartDescribe.height - _loc1.height) / 2;
				addChild(_loc1);
				this._mcScoreHeartVector.push(_loc1);
				_loc2++;
			}
			this._tfLevelDescribe = FastCreator.createLabel(SceneTileDef.SCORE_LEVEL_DESCRIBE[0],16777215,12,TextFieldAutoSize.CENTER);
			this._tfLevelDescribe.x = this._mcScoreHeartVector[SceneTileDef.SCORE_MAX_LEVEL - 1].x + this._mcScoreHeartVector[SceneTileDef.SCORE_MAX_LEVEL - 1].width + 8;
			this._tfLevelDescribe.y = this._tfHeartDescribe.y + 1;
			this._tfLevelDescribe.visible = false;
			addChild(this._tfLevelDescribe);
			this._tfScoreExplain = FastCreator.createLabel(STR_SCORE_EXPLAIN,16777215,14);
			this._tfScoreExplain.x = 12;
			this._tfScoreExplain.y = 88;
			addChild(this._tfScoreExplain);
			this._closeBtn = new ScoreCloseBtn();
			this._closeBtn.x = this._bg.width - this._closeBtn.width / 2 - 5;
			this._closeBtn.y = -this._closeBtn.height / 2 + 5;
			addChild(this._closeBtn);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		private function onHeartItemClick(param1:MouseEvent) : void
		{
			var _loc2:ScoreHeartItem = param1.currentTarget as ScoreHeartItem;
			if(_loc2)
			{
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreHeartClick,_loc2.index));
			}
			dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
		}
		
		private function onHeartItemRollOver(param1:MouseEvent) : void
		{
			var _loc2:ScoreHeartItem = param1.target as ScoreHeartItem;
			if(_loc2)
			{
				this.updateHeartState(_loc2.index);
				this._tfLevelDescribe.visible = true;
				this._tfLevelDescribe.text = SceneTileDef.SCORE_LEVEL_DESCRIBE[_loc2.index];
			}
		}
		
		private function onHeartItemRollOut(param1:MouseEvent) : void
		{
			var _loc2:ScoreHeartItem = param1.target as ScoreHeartItem;
			if(_loc2)
			{
				this.updateHeartState(-1);
				this._tfLevelDescribe.visible = false;
			}
		}
		
		private function updateHeartState(param1:int) : void
		{
			var _loc2:uint = 0;
			while(_loc2 < SceneTileDef.SCORE_MAX_LEVEL)
			{
				if(_loc2 <= param1)
				{
					this._mcScoreHeartVector[_loc2].heartState(FRAME_NAME_RED_HEART);
				}
				else
				{
					this._mcScoreHeartVector[_loc2].heartState(FRAME_NAME_GRAY_HEART);
				}
				_loc2++;
			}
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void
		{
			PingBack.getInstance().userActionPing(PingBackDef.SCORE_CLOSE_BTN_CLICK);
			dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
		}
		
		public function destory() : void
		{
			var _loc1:ScoreHeartItem = null;
			var _loc2:DisplayObject = null;
			this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
			while(this._mcScoreHeartVector.length > 0)
			{
				_loc1 = this._mcScoreHeartVector.shift();
				_loc1.removeEventListener(MouseEvent.CLICK,this.onHeartItemClick);
				_loc1.removeEventListener(MouseEvent.ROLL_OVER,this.onHeartItemRollOver);
				_loc1.removeEventListener(MouseEvent.ROLL_OUT,this.onHeartItemRollOut);
				_loc1.destory();
				_loc1 = null;
			}
			while(numChildren > 0)
			{
				_loc2 = getChildAt(0);
				if(_loc2.parent)
				{
					_loc2.parent.removeChild(_loc2);
				}
				_loc2 = null;
			}
		}
	}
}
