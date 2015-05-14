package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	import feedback.SearchBtn;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackEvent;
	import flash.events.KeyboardEvent;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	
	public class CopyrightExpiredSearchPart extends Sprite
	{
		
		private static const TF_TITLE_SHORT:String = "请继续搜索当前视频。";
		
		private static const TF_TITLE_LONG:String = "请继续搜索当前视频，或点击热门影片。";
		
		private var _titleTF:TextField;
		
		private var _searchTF:TextField;
		
		private var _titleBg:Shape;
		
		private var _searchBtn:SearchBtn;
		
		private var _videoName:String = "";
		
		public function CopyrightExpiredSearchPart()
		{
			super();
			this._titleTF = FastCreator.createLabel(TF_TITLE_SHORT,16777215,14);
			addChild(this._titleTF);
			this._titleBg = new Shape();
			addChild(this._titleBg);
			this._searchTF = FastCreator.createInput("搜索",6710886,14);
			addChild(this._searchTF);
			this._searchBtn = new SearchBtn();
			addChild(this._searchBtn);
			this._searchBtn.addEventListener(MouseEvent.CLICK,this.onSearchBtnClick);
			GlobalStage.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
		}
		
		public function get videoName() : String
		{
			return this._videoName;
		}
		
		public function set videoName(param1:String) : void
		{
			this._videoName = param1;
			this._searchTF.text = this._videoName;
		}
		
		public function resize(param1:Number, param2:Number) : void
		{
			this._titleTF.text = param1 >= FeedbackDef.NUM_WIDTH_SHOW_SEARCH_PART && param2 >= FeedbackDef.NUM_HEIGHT_SHOW_SEARCH_PART?TF_TITLE_LONG:TF_TITLE_SHORT;
			this._titleTF.x = (param1 - this._titleTF.width) / 2;
			this._titleBg.graphics.clear();
			this._titleBg.graphics.beginFill(16777215);
			this._titleBg.graphics.drawRect(0,0,param1 >= 1000?500:param1 * 0.5,30);
			this._titleBg.graphics.endFill();
			this._titleBg.y = this._titleTF.height + 10;
			this._titleBg.x = (param1 - this._titleBg.width - this._searchBtn.width) / 2;
			this._searchTF.x = this._titleBg.x + 3;
			this._searchTF.y = this._titleBg.y + 2;
			this._searchTF.width = this._titleBg.width - 6;
			this._searchBtn.x = this._titleBg.x + this._titleBg.width;
			this._searchBtn.y = this._titleBg.y;
		}
		
		private function onSearchBtnClick(param1:MouseEvent = null) : void
		{
			if(this._searchTF.text == "" || !visible)
			{
				return;
			}
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_CopyrightSearchBtnClick,this._searchTF.text));
		}
		
		private function onKeyUp(param1:KeyboardEvent) : void
		{
			switch(param1.keyCode)
			{
				case 13:
					this.onSearchBtnClick();
					break;
			}
		}
		
		public function destory() : void
		{
			this._searchBtn.removeEventListener(MouseEvent.CLICK,this.onSearchBtnClick);
			GlobalStage.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			removeChild(this._titleTF);
			this._titleTF = null;
			this._titleBg.graphics.clear();
			removeChild(this._titleBg);
			this._titleBg = null;
			removeChild(this._searchTF);
			this._searchTF = null;
			removeChild(this._searchBtn);
			this._searchBtn = null;
		}
	}
}
