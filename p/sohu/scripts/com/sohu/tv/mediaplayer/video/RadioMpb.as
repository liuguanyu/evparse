package com.sohu.tv.mediaplayer.video {
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.ui.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.sohu.tv.mediaplayer.ads.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.controls.*;
	import ebing.events.*;
	import ebing.media.mpb31.*;
	import ebing.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import ebing.Utils;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	
	public class RadioMpb extends TvSohuMediaPlayback {
		
		public function RadioMpb() {
			super();
		}
		
		private static var singleton:RadioMpb;
		
		public static function getInstance() : RadioMpb {
			if(singleton == null) {
				singleton = new RadioMpb();
			}
			return singleton;
		}
		
		private var _share2_btn:TvSohuButton;
		
		private var _delete_btn:TvSohuButton;
		
		private var _collect_btn:TvSohuButton;
		
		private var _jsNext_btn:TvSohuButton;
		
		private var _collectTipMc:MovieClip;
		
		private var _closeTimeNum:Number = 0;
		
		private var _hasCollect:Boolean = false;
		
		private var _isAllowDelete:Boolean = true;
		
		private var _nextVideoInfo:Object;
		
		override protected function loadSkin(param1:String = "") : void {
			var param1:* = PlayerConfig.swfHost + "skins/radioSkin.swf";
			super.loadSkin(param1);
		}
		
		override protected function drawSkin() : void {
			this._share2_btn = new TvSohuButton({"skin":_skin["share2_btn"]});
			this._delete_btn = new TvSohuButton({"skin":_skin["delete_btn"]});
			this._collect_btn = new TvSohuButton({"skin":_skin["collect_btn"]});
			this._jsNext_btn = new TvSohuButton({"skin":_skin["js_next_btn"]});
			super.drawSkin();
			this._collectTipMc = _skin["collect_tip"];
			addChild(this._collectTipMc);
			_ctrlBtn_sp.addChild(this._collect_btn);
			_ctrlBtn_sp.addChild(this._share2_btn);
			this._collectTipMc.visible = false;
			_ctrlBtn_sp.addChild(this._jsNext_btn);
			_ctrlBtn_sp.addChild(this._delete_btn);
		}
		
		override protected function setSkinState() : void {
			super.setSkinState();
			if(_skin != null) {
				Utils.setCenter(_play_btn,_ctrlBarBg_spr);
				Utils.setCenter(_pause_btn,_ctrlBarBg_spr);
				_play_btn.y = _pause_btn.y = 8;
				this._collect_btn.x = 19;
				this._share2_btn.x = this._collect_btn.x + this._collect_btn.width + 25;
				this._jsNext_btn.y = this._delete_btn.y = this._collect_btn.y = this._share2_btn.y = 10;
				this._delete_btn.x = _play_btn.x - this._delete_btn.width - 40;
				this._jsNext_btn.x = _play_btn.x + _play_btn.width + 40;
				if(this._collectTipMc != null) {
					Utils.setCenter(this._collectTipMc,_hitArea_spr);
				}
			}
		}
		
		override protected function addEvent() : void {
			super.addEvent();
			this._share2_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.sharePanel);
			this._delete_btn.addEventListener(MouseEventUtil.MOUSE_UP,function(param1:Event):void {
				if(Eif.available) {
					if(ExternalInterface.call("window.delFav","flash")) {
						param1.target.enabled = false;
					} else {
						param1.target.enabled = true;
					}
				}
			});
			this._collect_btn.addEventListener(MouseEventUtil.MOUSE_UP,function(param1:Event):void {
				var obj:Object = null;
				var evt:Event = param1;
				if(Eif.available) {
					obj = {
						"vid":PlayerConfig.vid,
						"pid":PlayerConfig.playListId
					};
					if(ExternalInterface.call("window.addFav","flash")) {
						evt.target.enabled = false;
						evt.target.clicked = true;
						_collectTipMc.visible = true;
						_closeTimeNum = setTimeout(function():void {
							clearTimeout(_closeTimeNum);
							_collectTipMc.visible = false;
						},3000);
					} else {
						evt.target.enabled = true;
					}
				}
				if(stage.displayState == "fullScreen") {
					_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
				}
			});
			this._jsNext_btn.addEventListener(MouseEventUtil.MOUSE_UP,function(param1:Event):void {
				if(Eif.available) {
					ExternalInterface.call("window.playNextVideo");
				}
			});
			this._collectTipMc.close_btn.addEventListener(MouseEvent.MOUSE_UP,this.close);
		}
		
		private function close(param1:* = null) : void {
			clearTimeout(this._closeTimeNum);
			this._collectTipMc.visible = false;
		}
		
		override protected function adPlayProgress(param1:TvSohuAdsEvent) : void {
			super.adPlayProgress(param1);
			if(_skin != null) {
				this._share2_btn.enabled = this._delete_btn.enabled = this._collect_btn.enabled = false;
			}
		}
		
		override protected function sharePanel(param1:MouseEventUtil) : void {
			if(Eif.available) {
				ExternalInterface.call("window.doShare");
			}
			if(stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
		}
		
		override protected function onStart(param1:Event = null) : void {
			super.onStart();
			if(_skin != null) {
				this._share2_btn.enabled = this._delete_btn.enabled = this._collect_btn.enabled = true;
				if(this._hasCollect) {
					this._collect_btn.enabled = false;
					this._collect_btn.clicked = true;
				} else {
					this._collect_btn.enabled = true;
				}
				if(this._isAllowDelete) {
					this._delete_btn.enabled = true;
				} else {
					this._delete_btn.enabled = false;
				}
			}
		}
		
		public function setNextVideo(param1:Object) : void {
			this._nextVideoInfo = param1;
			if(this._nextVideoInfo.hasNext) {
				this._jsNext_btn.enabled = true;
			} else {
				this._jsNext_btn.enabled = false;
			}
		}
		
		public function setBtnState(param1:Object) : void {
			if(param1.hasCollect != null) {
				this._hasCollect = param1.hasCollect;
				if(!(TvSohuAds.getInstance().startAd.state == "playing") && !(TvSohuAds.getInstance().endAd.state == "playing")) {
					if(this._hasCollect) {
						this._collect_btn.enabled = false;
						this._collect_btn.clicked = true;
					} else {
						this._collect_btn.enabled = true;
					}
				}
			}
			if(param1.isAllowDelete != null) {
				this._isAllowDelete = param1.isAllowDelete;
				if(!(TvSohuAds.getInstance().startAd.state == "playing") && !(TvSohuAds.getInstance().endAd.state == "playing")) {
					if(this._isAllowDelete) {
						this._delete_btn.enabled = true;
					} else {
						this._delete_btn.enabled = false;
					}
				}
			}
		}
		
		override public function showPlayListPanel(param1:MouseEventUtil = null) : void {
		}
		
		override protected function showDefinitionSideBar(param1:MouseEventUtil) : void {
			var evt:MouseEventUtil = param1;
			clearTimeout(_showBsbId);
			_showBsbId = setTimeout(function():void {
				_definitionSlider.visible = true;
				_definitionSlider.open();
				_tween = TweenLite.to(_definitionSlider,0.3,{
					"alpha":1,
					"ease":Quad.easeOut
				});
			},300);
		}
		
		override public function showCommonProgress() : void {
		}
		
		override protected function showMiniProgress() : void {
		}
		
		override protected function hideDefinitionSideBar(param1:* = null) : void {
			var evt:* = param1;
			clearTimeout(_showBsbId);
			_showBsbId = setTimeout(function():void {
				if(!_definitionSlider.hitTestPoint(mouseX,mouseY) || _ctrlBar_c.mouseX <= _definitionBar.x || !(evt == null) && evt.stageX <= 0 || mouseX >= stage.stageWidth - 6 || mouseY >= stage.stageHeight - 6) {
					hideBsb();
				}
			},300);
		}
	}
}
