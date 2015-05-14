package com.qiyi.player.wonder.plugins.scenetile.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import scenetile.PlayBtn;
	import flash.display.Sprite;
	import flash.text.TextField;
	import scenetile.FullhdTip;
	import scenetile.FullhdTipCloseBtn;
	import flash.display.Loader;
	import flash.display.Shape;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import flash.geom.Point;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.plugins.scenetile.view.toolpart.ToolStarHeadImageItem;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.filters.GlowFilter;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	public class SceneTileToolView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _playBtn:PlayBtn;
		
		private var _spVideoName:Sprite;
		
		private var _tfVideoName:TextField;
		
		private var _sceneTileTip:FullhdTip;
		
		private var _tipCloseBtn:FullhdTipCloseBtn;
		
		private var _sceneTileTipTF:TextField;
		
		private var _sceneTileTipBtnX:int;
		
		private var _gap:int;
		
		private var _loader:Loader;
		
		private var _imageContainer:Sprite;
		
		private var _starHeadContainer:Sprite;
		
		private var _border:Shape;
		
		public function SceneTileToolView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function get playBtn() : PlayBtn
		{
			return this._playBtn;
		}
		
		public function set sceneTileTipBtnX(param1:int) : void
		{
			this._sceneTileTipBtnX = param1 - 2;
			this._sceneTileTip.x = this._sceneTileTipBtnX + 25 - this._sceneTileTip.width / 2;
		}
		
		public function set sceneTileTipBtnY(param1:int) : void
		{
			this._gap = param1;
			this._sceneTileTip.y = GlobalStage.stage.stageHeight - this._sceneTileTip.height - this._gap;
		}
		
		public function setGap(param1:int) : void
		{
			this._gap = param1;
			var _loc2:int = GlobalStage.stage.stageHeight - this._sceneTileTip.height - this._gap;
			TweenLite.to(this._sceneTileTip,0.5,{
				"y":_loc2,
				"onComplete":this.onTweenComplete
			});
		}
		
		public function get sceneTileTipX() : int
		{
			return localToGlobal(new Point(this._sceneTileTip.x,0)).x;
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void
		{
			this._userInfoVO = param1;
		}
		
		public function updateSceneTileTip() : void
		{
			this._sceneTileTip.x = this._sceneTileTipBtnX + 25 - this._sceneTileTip.width / 2;
			this._sceneTileTip.y = GlobalStage.stage.stageHeight - this._sceneTileTip.height - this._gap;
		}
		
		public function onAddStatus(param1:int) : void
		{
			this._status.addStatus(param1);
			switch(param1)
			{
				case SceneTileDef.STATUS_TOOL_OPEN:
					this.open();
					break;
				case SceneTileDef.STATUS_PLAY_BTN_SHOW:
					addChild(this._playBtn);
					break;
				case SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW:
					this._sceneTileTip.x = this._sceneTileTipBtnX + 25 - this._sceneTileTip.width / 2;
					addChild(this._sceneTileTip);
					break;
				case SceneTileDef.STATUS_VIDEO_NAME_SHOW:
					TweenLite.killTweensOf(this.onDelayedCallComplete);
					TweenLite.killTweensOf(this._spVideoName);
					this._spVideoName.visible = true;
					this._spVideoName.alpha = 1;
					break;
				case SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW:
					this._starHeadContainer.visible = true;
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case SceneTileDef.STATUS_TOOL_OPEN:
					this.close();
					break;
				case SceneTileDef.STATUS_PLAY_BTN_SHOW:
					if(this._playBtn.parent)
					{
						this._playBtn.gotoAndStop(1);
						removeChild(this._playBtn);
					}
					break;
				case SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW:
					if(this._sceneTileTip.parent)
					{
						removeChild(this._sceneTileTip);
					}
					break;
				case SceneTileDef.STATUS_VIDEO_NAME_SHOW:
					this._spVideoName.visible = false;
					break;
				case SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW:
					this._starHeadContainer.visible = false;
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			this._playBtn.x = 22;
			this._playBtn.y = param2 - 140;
			if(this._imageContainer != null)
			{
				this._imageContainer.width = GlobalStage.stage.stageWidth;
				this._imageContainer.height = GlobalStage.stage.stageHeight;
			}
			if(this._starHeadContainer)
			{
				this._starHeadContainer.x = param1 - this._starHeadContainer.numChildren * 55 - 120;
				this._starHeadContainer.y = param2 - 120;
			}
			this.updateSceneTileTip();
		}
		
		public function updateStarHeadImage(param1:Object) : void
		{
			var _loc2:ToolStarHeadImageItem = null;
			var _loc3:Array = null;
			var _loc4:ToolStarHeadImageItem = null;
			var _loc5:* = 0;
			while(this._starHeadContainer.numChildren > 0)
			{
				_loc2 = this._starHeadContainer.removeChildAt(0) as ToolStarHeadImageItem;
				_loc2.destroy();
				_loc2 = null;
			}
			if((param1) && (param1.stars))
			{
				_loc3 = param1.stars as Array;
				_loc5 = 0;
				while(_loc5 < _loc3.length)
				{
					if(_loc3[_loc5].icon)
					{
						_loc4 = new ToolStarHeadImageItem(_loc3[_loc5].icon,_loc5);
						_loc4.x = _loc5 * 55;
						this._starHeadContainer.addChild(_loc4);
					}
					_loc5++;
				}
			}
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function updateVideoNamePosition(param1:String, param2:Boolean) : void
		{
			if(param2)
			{
				this._tfVideoName.text = "即将播放：" + param1;
				this._spVideoName.x = 80;
				this._spVideoName.y = 25;
			}
			else
			{
				this._tfVideoName.text = param1;
				this._spVideoName.x = 40;
				this._spVideoName.y = 25;
				TweenLite.delayedCall(3,this.onDelayedCallComplete);
			}
		}
		
		private function onDelayedCallComplete() : void
		{
			TweenLite.killTweensOf(this.onDelayedCallComplete);
			TweenLite.to(this._spVideoName,1,{"alpha":0});
		}
		
		public function drawBorder() : void
		{
			this._border.graphics.clear();
			this._border.graphics.lineStyle(1,1579032);
			this._border.graphics.moveTo(0,0);
			this._border.graphics.lineTo(GlobalStage.stage.stageWidth - 1,0);
			this._border.graphics.lineTo(GlobalStage.stage.stageWidth - 1,GlobalStage.stage.stageHeight - 1);
			this._border.graphics.lineTo(0,GlobalStage.stage.stageHeight - 1);
			this._border.graphics.lineTo(0,0);
		}
		
		public function clearBorder() : void
		{
			this._border.graphics.clear();
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ToolOpen));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ToolClose));
			}
		}
		
		override protected function onAddToStage() : void
		{
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void
		{
			super.onRemoveFromStage();
		}
		
		private function initUI() : void
		{
			this._imageContainer = new Sprite();
			if(!FlashVarConfig.autoPlay)
			{
				addChild(this._imageContainer);
				this._imageContainer.graphics.beginFill(0);
				this._imageContainer.graphics.drawRect(0,0,GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
				this._imageContainer.graphics.endFill();
				this._imageContainer.mouseEnabled = this._imageContainer.mouseChildren = false;
			}
			this._playBtn = new PlayBtn();
			this._playBtn.buttonMode = this._playBtn.useHandCursor = true;
			this._playBtn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
			{
				_playBtn.gotoAndStop(2);
			});
			this._playBtn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
			{
				_playBtn.gotoAndStop(1);
			});
			if(this._status.hasStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW))
			{
				addChild(this._playBtn);
			}
			this._spVideoName = new Sprite();
			addChild(this._spVideoName);
			this._spVideoName.visible = false;
			this._tfVideoName = FastCreator.createLabel("videoName",16777215,16,TextFieldAutoSize.LEFT);
			this._tfVideoName.filters = [new GlowFilter(0,0.6,3,3,3)];
			this._spVideoName.addChild(this._tfVideoName);
			this._sceneTileTip = new FullhdTip();
			this._sceneTileTipTF = FastCreator.createLabel("一键看槽点",16777215);
			this._sceneTileTipTF.x = (this._sceneTileTip.width - this._sceneTileTipTF.width) / 2 - 5;
			this._sceneTileTipTF.y = 0;
			this._sceneTileTip.addChild(this._sceneTileTipTF);
			this._tipCloseBtn = new FullhdTipCloseBtn();
			this._tipCloseBtn.x = this._sceneTileTip.width - this._tipCloseBtn.width - 3;
			this._tipCloseBtn.y = (this._sceneTileTip.height - this._tipCloseBtn.height) / 2 - 3;
			this._sceneTileTip.addChild(this._tipCloseBtn);
			this._tipCloseBtn.addEventListener(MouseEvent.CLICK,this.onTipCloseBtnClick);
			this._starHeadContainer = new Sprite();
			this._starHeadContainer.mouseEnabled = this._starHeadContainer.mouseChildren = false;
			addChild(this._starHeadContainer);
			this._border = new Shape();
			GlobalStage.stage.addChild(this._border);
		}
		
		private function onTweenComplete() : void
		{
			this._sceneTileTip.x = this._sceneTileTipBtnX + 25 - this._sceneTileTip.width / 2;
			this._sceneTileTip.y = GlobalStage.stage.stageHeight - this._sceneTileTip.height - this._gap;
		}
		
		public function requestUnAutoPlayImage() : void
		{
			if((FlashVarConfig.autoPlay) || FlashVarConfig.imageUrl == "")
			{
				return;
			}
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			this._loader.load(new URLRequest(FlashVarConfig.imageUrl));
		}
		
		private function onComplete(param1:Event) : void
		{
			if(isOnStage)
			{
				this._imageContainer.addChild(this._loader);
				this._loader.width = GlobalStage.stage.stageWidth;
				this._loader.height = GlobalStage.stage.stageHeight;
			}
		}
		
		private function onIOError(param1:Event) : void
		{
		}
		
		public function destroyImageLoader() : void
		{
			if(!(this._imageContainer == null) && (this._imageContainer.parent))
			{
				this._imageContainer.graphics.clear();
				removeChild(this._imageContainer);
			}
			if(this._loader == null)
			{
				return;
			}
			if(this._loader.parent)
			{
				this._imageContainer.removeChild(this._loader);
			}
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			this._loader = null;
		}
		
		private function onTipCloseBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_TipCloseBtnClick));
		}
	}
}
