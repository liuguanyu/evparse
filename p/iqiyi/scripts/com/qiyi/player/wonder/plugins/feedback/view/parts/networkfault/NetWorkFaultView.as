package com.qiyi.player.wonder.plugins.feedback.view.parts.networkfault {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import feedback.DownLoadBtn;
	import feedback.NetworkRefreshBtn;
	import feedback.NetworkHelpBtn;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	
	public class NetWorkFaultView extends Sprite implements IDestroy {
		
		public function NetWorkFaultView() {
			super();
			this.initPanel();
		}
		
		private static const TEXT_TITLE:String = "呃......播放失败了";
		
		private static const TEXT_CLIENT_EXTEND:String = "你知道用爱奇艺视频桌面版播放失败率可以少一半吗？";
		
		private static const TEXT_HELP_BTN:String = "帮助反馈";
		
		private static const TEXT_REFURBISH_BTN:String = "刷新试试";
		
		private static const TEXT_DOWNLOAD_BTN:String = "立刻下载安装";
		
		private static const TEXT_DESCRIBE:String = "您刚刚提交过反馈,我们会尽快处理";
		
		private static const DEFAULT_FONT_COLOR:TextFormat = new TextFormat(null,16,16777215);
		
		private static const HOVER_FONT_COLOR:TextFormat = new TextFormat(null,16,6921984);
		
		private var _titleTF:TextField;
		
		private var _clientExtendTF:TextField;
		
		private var _downLoadBtn:DownLoadBtn;
		
		private var _downLoadTF:TextField;
		
		private var _refreshBtn:NetworkRefreshBtn;
		
		private var _refurbishTF:TextField;
		
		private var _helpBtn:NetworkHelpBtn;
		
		private var _helpTF:TextField;
		
		private var _describeTF:TextField;
		
		private var _isFeedBacked:Boolean;
		
		private function initPanel() : void {
			this._titleTF = FastCreator.createLabel(TEXT_TITLE,16777215,18);
			addChild(this._titleTF);
			this._clientExtendTF = FastCreator.createLabel(TEXT_CLIENT_EXTEND,13421772,14);
			addChild(this._clientExtendTF);
			this._downLoadBtn = new DownLoadBtn();
			addChild(this._downLoadBtn);
			this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN,16777215,16);
			this._downLoadTF.selectable = this._downLoadTF.mouseEnabled = false;
			addChild(this._downLoadTF);
			this._helpBtn = new NetworkHelpBtn();
			addChild(this._helpBtn);
			this._helpTF = FastCreator.createLabel(TEXT_HELP_BTN,16777215,16);
			this._helpTF.selectable = this._helpTF.mouseEnabled = false;
			addChild(this._helpTF);
			this._refreshBtn = new NetworkRefreshBtn();
			addChild(this._refreshBtn);
			this._refurbishTF = FastCreator.createLabel(TEXT_REFURBISH_BTN,16777215,16);
			this._refurbishTF.selectable = this._refurbishTF.mouseEnabled = false;
			addChild(this._refurbishTF);
			this._describeTF = FastCreator.createLabel(TEXT_DESCRIBE,10066329,12);
			addChild(this._describeTF);
			this._describeTF.visible = false;
			this._refreshBtn.addEventListener(MouseEvent.ROLL_OVER,this.onBtnRollOver);
			this._refreshBtn.addEventListener(MouseEvent.ROLL_OUT,this.onBtnRollOut);
			this._helpBtn.addEventListener(MouseEvent.ROLL_OVER,this.onBtnRollOver);
			this._helpBtn.addEventListener(MouseEvent.ROLL_OUT,this.onBtnRollOut);
		}
		
		public function get downLoadBtn() : SimpleButton {
			return this._downLoadBtn;
		}
		
		public function get isFeedBacked() : Boolean {
			return this._isFeedBacked;
		}
		
		public function set isFeedBacked(param1:Boolean) : void {
			this._isFeedBacked = param1;
		}
		
		public function get helpBtn() : SimpleButton {
			return this._helpBtn;
		}
		
		public function get refreshBtn() : SimpleButton {
			return this._refreshBtn;
		}
		
		public function get rejectMsg() : TextField {
			return this._describeTF;
		}
		
		public function onResize(param1:int, param2:int) : void {
			var _loc3_:Number = 0;
			_loc3_ = _loc3_ + (this._titleTF.height + 10);
			_loc3_ = _loc3_ + (this._clientExtendTF.height + 10);
			_loc3_ = _loc3_ + (this._downLoadBtn.height + 20);
			_loc3_ = _loc3_ + (this._helpBtn.height + 20);
			_loc3_ = _loc3_ + this._describeTF.height;
			this._titleTF.x = (param1 - this._titleTF.width) * 0.5;
			this._titleTF.y = (param2 - _loc3_) * 0.5;
			this._clientExtendTF.x = (param1 - this._clientExtendTF.width) * 0.5;
			this._clientExtendTF.y = this._titleTF.y + this._titleTF.height + 10;
			this._downLoadBtn.x = (param1 - this._downLoadBtn.width) * 0.5;
			this._downLoadBtn.y = this._clientExtendTF.y + this._clientExtendTF.height + 20;
			this._downLoadTF.x = this._downLoadBtn.x + 18;
			this._downLoadTF.y = this._downLoadBtn.y + (this._downLoadBtn.height - this._downLoadTF.height) * 0.5;
			this._helpBtn.x = (param1 - this._helpBtn.width - this._refreshBtn.width) * 0.5 - 25;
			this._helpBtn.y = this._downLoadBtn.y + this._downLoadBtn.height + 20;
			this._helpTF.x = this._helpBtn.x + 18;
			this._helpTF.y = this._helpBtn.y + (this._helpBtn.height - this._helpTF.height) * 0.5;
			this._refreshBtn.x = this._helpBtn.x + this._helpBtn.width + 50;
			this._refreshBtn.y = this._helpBtn.y;
			this._refurbishTF.x = this._refreshBtn.x + 18;
			this._refurbishTF.y = this._refreshBtn.y + (this._refreshBtn.height - this._refurbishTF.height) * 0.5;
			this._describeTF.x = (param1 - this._describeTF.width) * 0.5;
			this._describeTF.y = this._refreshBtn.y + this._refreshBtn.height + 10;
		}
		
		private function onBtnRollOver(param1:MouseEvent) : void {
			switch(param1.target) {
				case this._helpBtn:
					this._helpTF.defaultTextFormat = HOVER_FONT_COLOR;
					this._helpTF.setTextFormat(HOVER_FONT_COLOR);
					break;
				case this._refreshBtn:
					this._refurbishTF.defaultTextFormat = HOVER_FONT_COLOR;
					this._refurbishTF.setTextFormat(HOVER_FONT_COLOR);
					break;
			}
		}
		
		private function onBtnRollOut(param1:MouseEvent) : void {
			switch(param1.target) {
				case this._helpBtn:
					this._helpTF.defaultTextFormat = DEFAULT_FONT_COLOR;
					this._helpTF.setTextFormat(DEFAULT_FONT_COLOR);
					break;
				case this._refreshBtn:
					this._refurbishTF.defaultTextFormat = DEFAULT_FONT_COLOR;
					this._refurbishTF.setTextFormat(DEFAULT_FONT_COLOR);
					break;
			}
		}
		
		public function destroy() : void {
			var _loc1_:DisplayObject = null;
			while(numChildren > 0) {
				_loc1_ = getChildAt(0);
				if(_loc1_.parent) {
					removeChild(_loc1_);
				}
				_loc1_ = null;
			}
		}
	}
}
