package com.sohu.tv.mediaplayer.ui {
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.controls.*;
	import ebing.events.*;
	import ebing.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import ebing.net.LoaderUtil;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class TvSohuErrorMsg extends Sprite {
		
		public function TvSohuErrorMsg(param1:Number, param2:Number, param3:String, param4:Boolean = false, param5:Boolean = false) {
			super();
			this._owner = this;
			this._width = param1;
			this._msg = param3;
			this._isPwd = param5;
			this._isSkin = param4;
			this._height = this._isSkin?param2 - 42:param2;
			this.init();
		}
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _bg:Sprite;
		
		private var _msg:String = "";
		
		private var _isPwd:Boolean = false;
		
		private var _owner;
		
		private var _isTipErr:Boolean = false;
		
		private var _isSkin:Boolean = false;
		
		private var _pwdStr:String = "";
		
		private var pwdPanel;
		
		private var errSp:Sprite;
		
		private var errorRecomm;
		
		private function init() : void {
			this.newFunc();
			this.drawSkin();
			this.addEvent();
		}
		
		private function newFunc() : void {
		}
		
		private function drawSkin() : void {
			var bitmapData:BitmapData = null;
			var bit:Bitmap = null;
			var txt:String = null;
			var tf:TextFormat = null;
			var limit:TextField = null;
			var ico:Sprite = null;
			var icoTxt:TextField = null;
			var tri:Shape = null;
			var aa:TextFormat = null;
			var bp:BitmapData = null;
			var bitmap:Bitmap = null;
			this._bg = new Sprite();
			if(!this._isSkin) {
				bitmapData = new BitmapData(this._width,this._height,true,4.294967295E9);
				bitmapData.noise(0,36,83,15,false);
				bit = new Bitmap(bitmapData);
				this._bg.addChildAt(bit,0);
			} else {
				Utils.drawRect(this._bg,0,0,this._width,this._height,0,1);
			}
			this._owner.addChild(this._bg);
			if(this._isPwd) {
				txt = this._msg == null || this._msg == "undefined"?"  ":this._msg;
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						pwdPanel = obj.data.content;
						_owner.addChild(pwdPanel);
						pwdPanel.pwd_txt.displayAsPassword = true;
						pwdPanel.pwd_txt.maxChars = 25;
						if(_isTipErr) {
							pwdPanel.err_txt.text = txt;
						} else {
							pwdPanel.err_txt = "";
						}
						pwdPanel.ok_btn.addEventListener(MouseEvent.MOUSE_UP,function(param1:*):void {
							_pwdStr = escape(Utils.cleanVar(pwdPanel.pwd_txt.text));
							dispatchEvent(new Event("loadAndPlay"));
							_isTipErr = true;
						});
					}
				},null,PlayerConfig.swfHost + "panel/PwdPanel.swf");
			} else {
				this.errSp = new Sprite();
				tf = new TextFormat();
				tf.size = 14;
				tf.leading = 10;
				tf.font = "微软雅黑";
				tf.align = TextFormatAlign.LEFT;
				limit = new TextField();
				limit.wordWrap = true;
				limit.textColor = 11776947;
				limit.width = 350;
				limit.htmlText = this._msg == null || this._msg == "undefined"?"  ":this._msg;
				limit.addEventListener(TextEvent.LINK,this.linkHandler);
				limit.setTextFormat(tf);
				ico = new Sprite();
				icoTxt = new TextField();
				tri = new Shape();
				tri.graphics.lineStyle(0,10790052);
				tri.graphics.beginFill(10790052,1);
				tri.graphics.moveTo(23.5,2);
				tri.graphics.curveTo(24,1,26,2);
				tri.graphics.lineTo(47,38);
				tri.graphics.curveTo(49,41,47,41);
				tri.graphics.lineTo(4,42);
				tri.graphics.curveTo(2,41,4,38);
				tri.graphics.lineTo(23.5,2);
				tri.graphics.endFill();
				ico.addChild(tri);
				aa = new TextFormat();
				aa.size = 30;
				aa.bold = true;
				aa.font = "Arial";
				icoTxt.text = "!";
				icoTxt.textColor = 0;
				icoTxt.setTextFormat(aa);
				bp = new BitmapData(icoTxt.width,icoTxt.height,true,0);
				bp.draw(icoTxt);
				bitmap = new Bitmap(bp);
				ico.addChild(bitmap);
				bitmap.x = 19;
				bitmap.y = 6;
				ico.mouseEnabled = false;
				this.errSp.addChild(ico);
				ico.scaleX = ico.scaleY = 0.8;
				this.errSp.addChild(ico);
				this.errSp.addChild(limit);
				limit.x = ico.x + 40;
				limit.y = ico.y + 10;
				this._owner.addChild(this.errSp);
			}
			this.showErrRecomm();
			this.setEleStatus();
		}
		
		private function addEvent() : void {
		}
		
		private function linkHandler(param1:TextEvent) : void {
			ErrorSenderPQ.getInstance().sendFeedback();
		}
		
		private function showErrRecomm() : void {
			new LoaderUtil().load(10,function(param1:Object):void {
				var obj:Object = param1;
				if(obj.info == "success") {
					errorRecomm = obj.data.content;
					_owner.addChild(errorRecomm);
					errorRecomm.init(_width,_height);
					errorRecomm.addEventListener("INIT_COMPLETE",function(param1:Event):void {
						setEleStatus();
					});
					SendRef.getInstance().sendPQVPC("PL_A_503_V");
					try {
						VerLog.msg(errorRecomm["version"]);
					}
					catch(evt:Error) {
					}
				}
			},null,PlayerConfig.swfHost + "panel/ErrorRecommend.swf");
		}
		
		public function resize(param1:Number, param2:Number) : void {
			this._width = param1;
			this._height = this._isSkin?param2 - 42:param2;
			this.changeBg();
			this.setEleStatus();
		}
		
		private function changeBg() : void {
			var _loc1_:BitmapData = null;
			var _loc2_:Bitmap = null;
			if(!this._isSkin) {
				while(this._bg.numChildren) {
					this._bg.removeChildAt(0);
				}
				if(this._width > 0 && this._height > 0) {
					_loc1_ = new BitmapData(this._width,this._height,true,4.294967295E9);
					_loc1_.noise(0,36,83,15,false);
					_loc2_ = new Bitmap(_loc1_);
					this._bg.addChildAt(_loc2_,0);
				}
			} else {
				this._bg.width = this._width;
				this._bg.height = this._height;
			}
		}
		
		private function setEleStatus() : void {
			if((this._isPwd) && !(this.pwdPanel == null)) {
				if(this._height > this.pwdPanel.height && !(PlayerConfig.cooperator == "imovie")) {
					if(this.errorRecomm != null) {
						this.errorRecomm.resize(this._width,this._height - this.pwdPanel.height);
						Utils.setCenter(this.errorRecomm,this._bg);
						Utils.setCenterByNumber(this.pwdPanel,this._width,this._height - this.errorRecomm.height);
						this.errorRecomm.y = this.pwdPanel.height + this.pwdPanel.y;
						this.errorRecomm.visible = true;
					} else {
						Utils.setCenterByNumber(this.pwdPanel,this._width,this._height);
					}
				} else {
					Utils.setCenterByNumber(this.pwdPanel,this._width,this._height);
					if(this.errorRecomm != null) {
						this.errorRecomm.visible = false;
					}
				}
			} else if(this.errSp != null) {
				if(this._height > this.errSp.height && !(PlayerConfig.cooperator == "imovie")) {
					if(this.errorRecomm != null) {
						this.errorRecomm.resize(this._width,this._height - this.errSp.height);
						Utils.setCenter(this.errorRecomm,this._bg);
						Utils.setCenterByNumber(this.errSp,this._width,this._height - this.errorRecomm.height);
						this.errorRecomm.y = this.errSp.height + this.errSp.y;
						this.errorRecomm.visible = true;
					} else {
						Utils.setCenterByNumber(this.errSp,this._width,this._height);
					}
				} else {
					Utils.setCenterByNumber(this.errSp,this._width,this._height);
					if(this.errorRecomm != null) {
						this.errorRecomm.visible = false;
					}
				}
			}
			
		}
		
		public function get pwdStr() : String {
			return this._pwdStr;
		}
	}
}
