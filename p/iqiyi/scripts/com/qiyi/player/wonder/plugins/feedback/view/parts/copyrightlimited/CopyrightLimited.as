package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import feedback.OverseaUI;
	import flash.text.TextField;
	import feedback.DownLoadBtn;
	import flash.display.SimpleButton;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import gs.TweenLite;
	import gs.easing.Back;
	import flash.display.DisplayObject;
	
	public class CopyrightLimited extends Sprite implements IDestroy
	{
		
		private static const TEXT_TITLE_PLATFORM_LIMIT:String = "很抱歉，当前平台暂无法播放。";
		
		private static const TEXT_TITLE_AREA_LIMIT:String = "很抱歉，由于版权原因暂无法播放。";
		
		private static const TEXT_CLIENT_EXTEND:String = "<font color=\'#699f00\'>爱奇艺视频桌面版</font>说不定还能看，去试试？";
		
		private static const TEXT_DOWNLOAD_BTN:String = "立刻下载安装";
		
		private static const TEXT_LINK:String = "如果您有其他问题，<font color=\'#ffffff\'>" + "<a href=\'event:onTextEventClick\'><u>请告知我们</u></a></font> 我们将尽快查找原因。";
		
		private static const TEXT_ENGLISH_AREA_LIMIT:String = "Sorry, this video is not available in " + "your region due to copyright limitations.";
		
		private static const TEXT_ENGLISH_PLATFORM_LIMIT:String = "The current platform temporarily unable to play";
		
		public var _thisW:int = 596;
		
		public var _thisH:int = 198;
		
		private var _overseaUI:OverseaUI;
		
		private var _titleTF:TextField;
		
		private var _clientExtendTF:TextField;
		
		private var _downLoadBtn:DownLoadBtn;
		
		private var _downLoadTF:TextField;
		
		private var _linkTF:TextField;
		
		private var _englistTF:TextField;
		
		private var _preBtn:TriangleBtn;
		
		private var _nextBtn:TriangleBtn;
		
		private var _leftText:TextField;
		
		private var _rightText:TextField;
		
		private var _rightTextLink:Sprite;
		
		private var _videoItemArray:Array = null;
		
		private var _maskMC:Sprite = null;
		
		private var _loadInContainer:Sprite = null;
		
		public function CopyrightLimited(param1:uint)
		{
			super();
			this._overseaUI = new OverseaUI();
			switch(param1)
			{
				case FeedbackDef.FEEDBACK_LIMITED_PLATFORM:
					this._titleTF = FastCreator.createLabel(TEXT_TITLE_PLATFORM_LIMIT,16777215,18);
					this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_PLATFORM_LIMIT,10066329,12);
					break;
				case FeedbackDef.FEEDBACK_LIMITED_AREA:
					this._titleTF = FastCreator.createLabel(TEXT_TITLE_AREA_LIMIT,16777215,18);
					this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_AREA_LIMIT,10066329,12);
					break;
				default:
					this._titleTF = FastCreator.createLabel(TEXT_TITLE_AREA_LIMIT,16777215,18);
					this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_AREA_LIMIT,10066329,12);
			}
			this._titleTF.x = (this._overseaUI.width - this._titleTF.width) * 0.5;
			this._overseaUI.addChild(this._titleTF);
			this._clientExtendTF = FastCreator.createLabel(TEXT_CLIENT_EXTEND,16777215,12);
			this._clientExtendTF.htmlText = TEXT_CLIENT_EXTEND;
			this._clientExtendTF.x = (this._overseaUI.width - this._clientExtendTF.width) * 0.5;
			this._clientExtendTF.y = 42;
			this._overseaUI.addChild(this._clientExtendTF);
			this._downLoadBtn = new DownLoadBtn();
			this._downLoadBtn.x = (this._overseaUI.width - this._downLoadBtn.width) * 0.5;
			this._downLoadBtn.y = 75;
			this._overseaUI.addChild(this._downLoadBtn);
			this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN,16777215,16);
			this._downLoadTF.selectable = this._downLoadTF.mouseEnabled = false;
			this._downLoadTF.x = this._downLoadBtn.x + 18;
			this._downLoadTF.y = this._downLoadBtn.y + (this._downLoadBtn.height - this._downLoadTF.height) * 0.5;
			this._overseaUI.addChild(this._downLoadTF);
			this._linkTF = FastCreator.createLabel(TEXT_LINK,10066329);
			this._linkTF.x = (this._overseaUI.width - this._linkTF.width) * 0.5;
			this._linkTF.y = 127;
			this._overseaUI.addChild(this._linkTF);
			this._englistTF.x = (this._overseaUI.width - this._englistTF.width) * 0.5;
			this._englistTF.y = 150;
			this._overseaUI.addChild(this._englistTF);
			this._preBtn = new TriangleBtn(32,TriangleBtn.FACE_LEFT);
			this._nextBtn = new TriangleBtn(32,TriangleBtn.FACE_RIGHT);
			this._leftText = FastCreator.createLabel("这些也精彩",10066329,16,"",true);
			this._rightText = FastCreator.createLabel("更多",8562957,16,"",true);
			this._rightTextLink = new Sprite();
			this._rightTextLink.addChild(this._rightText);
			this._rightTextLink.mouseChildren = false;
			this._rightTextLink.buttonMode = true;
			this._rightTextLink.addEventListener(MouseEvent.CLICK,this.onMoreClick);
			this._rightTextLink.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
			this._rightTextLink.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
			this._preBtn.addEventListener(MouseEvent.CLICK,this.onPreBtnClick);
			this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNextBtnClick);
			this._maskMC = new Sprite();
			this._loadInContainer = new Sprite();
			this.getVideoData();
			this.initUI();
		}
		
		public function get downLoadBtn() : SimpleButton
		{
			return this._downLoadBtn;
		}
		
		public function get linkTextField() : TextField
		{
			return this._linkTF;
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			x = (param1 - this._overseaUI.width) * 0.5;
			y = (param2 - height) / 2 + 15;
		}
		
		private function getVideoData() : void
		{
			var _loc1:int = FeedbackDef.OPEN_VIDEOS.item.length();
			this._videoItemArray = new Array();
			var _loc2:* = 0;
			while(_loc2 < _loc1)
			{
				this._videoItemArray[_loc2] = new OpenVideoItem(FeedbackDef.OPEN_VIDEOS.item[_loc2].@video_url,FeedbackDef.OPEN_VIDEOS.item[_loc2].@pic_url,FeedbackDef.OPEN_VIDEOS.item[_loc2].@title);
				this._videoItemArray[_loc2].x = _loc2 * (this._thisW - 86) / 4;
				this._videoItemArray[_loc2].y = 0;
				this._loadInContainer.addChild(this._videoItemArray[_loc2]);
				_loc2++;
			}
		}
		
		private function initUI() : void
		{
			this._leftText.y = this._overseaUI.y + this._overseaUI.height + 20;
			this._rightTextLink.y = this._leftText.y;
			this._loadInContainer.x = this._overseaUI.x;
			this._loadInContainer.y = this._leftText.y + this._leftText.height;
			this._maskMC.x = this._loadInContainer.x;
			this._maskMC.y = this._loadInContainer.y;
			this._maskMC.graphics.beginFill(16711680);
			this._maskMC.graphics.drawRect(0,0,504,this._thisH);
			this._maskMC.graphics.endFill();
			this._loadInContainer.mask = this._maskMC;
			this._leftText.x = this._loadInContainer.x;
			this._rightTextLink.x = this._loadInContainer.x + this._overseaUI.width - this._rightTextLink.width + 15;
			this._preBtn.x = this._loadInContainer.x - this._preBtn.width - 10;
			this._preBtn.y = this._loadInContainer.y + (124 - this._preBtn.height) * 0.5;
			this._nextBtn.x = this._loadInContainer.x + this._overseaUI.width + 30;
			this._nextBtn.y = this._preBtn.y;
			addChild(this._loadInContainer);
			addChild(this._overseaUI);
			addChild(this._leftText);
			addChild(this._rightTextLink);
			addChild(this._maskMC);
			addChild(this._preBtn);
			addChild(this._nextBtn);
		}
		
		private function onMoreClick(param1:MouseEvent) : void
		{
			navigateToURL(new URLRequest(FeedbackDef.OPEN_VIDEOS_LIST_URL),"_blank");
		}
		
		private function onRollOver(param1:MouseEvent) : void
		{
			this._rightText.setTextFormat(new TextFormat(FastCreator.FONT_MSYH,16,10066329,true,null,true));
		}
		
		private function onRollOut(param1:MouseEvent) : void
		{
			this._rightText.setTextFormat(new TextFormat(FastCreator.FONT_MSYH,16,8562957,true,null,true));
		}
		
		private function onPreBtnClick(param1:MouseEvent) : void
		{
			var _loc2:* = 0;
			var _loc3:Object = null;
			if(!this._videoItemArray)
			{
				return;
			}
			if(this._videoItemArray.length > 4)
			{
				_loc2 = 0;
				while(_loc2 < 4)
				{
					_loc3 = this._videoItemArray.pop();
					_loc3.x = this._videoItemArray[0].x - (this._thisW - 86) / 4;
					this._videoItemArray.unshift(_loc3);
					_loc2++;
				}
				TweenLite.to(this._loadInContainer,1,{
					"x":this._loadInContainer.x + (this._thisW - 86) / 1,
					"onComplete":this.enableBtns,
					"ease":Back.easeOut
				});
				this.disableBtns();
			}
		}
		
		private function onNextBtnClick(param1:MouseEvent) : void
		{
			var _loc2:* = 0;
			var _loc3:Object = null;
			if(!this._videoItemArray)
			{
				return;
			}
			if(this._videoItemArray.length > 4)
			{
				_loc2 = 0;
				while(_loc2 < 4)
				{
					_loc3 = this._videoItemArray.shift();
					_loc3.x = this._videoItemArray[this._videoItemArray.length - 1].x + (this._thisW - 86) / 4;
					this._videoItemArray.push(_loc3);
					_loc2++;
				}
				TweenLite.to(this._loadInContainer,1,{
					"x":this._loadInContainer.x - (this._thisW - 86) / 1,
					"onComplete":this.enableBtns,
					"ease":Back.easeOut
				});
				this.disableBtns();
			}
		}
		
		private function enableBtns() : void
		{
			this._preBtn.addEventListener(MouseEvent.CLICK,this.onPreBtnClick);
			this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNextBtnClick);
			this._preBtn.enable = true;
			this._nextBtn.enable = true;
		}
		
		private function disableBtns() : void
		{
			this._preBtn.removeEventListener(MouseEvent.CLICK,this.onPreBtnClick);
			this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onNextBtnClick);
			this._preBtn.enable = false;
			this._nextBtn.enable = false;
		}
		
		public function destroy() : void
		{
			var _loc1:DisplayObject = null;
			this._preBtn.removeEventListener(MouseEvent.CLICK,this.onPreBtnClick);
			this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onNextBtnClick);
			if((this._overseaUI) && (this._overseaUI.parent))
			{
				while(this._overseaUI.numChildren > 0)
				{
					_loc1 = this._overseaUI.getChildAt(0);
					this._overseaUI.removeChild(_loc1);
					_loc1 = null;
				}
				removeChild(this._overseaUI);
				this._overseaUI = null;
			}
			while(numChildren > 0)
			{
				_loc1 = getChildAt(0);
				if(_loc1.parent)
				{
					removeChild(_loc1);
				}
				_loc1 = null;
			}
		}
	}
}
