package com.sohu.tv.mediaplayer.ui {
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.controls.*;
	import ebing.events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.net.URLLoaderUtil;
	import ebing.net.JSON;
	
	public class DefinitionSettingPanel extends Sprite {
		
		public function DefinitionSettingPanel(param1:Object) {
			super();
			this.newFunc();
			this.drawSkin(param1.skin);
			this.addEvent();
		}
		
		private var _super_btn:ButtonUtil;
		
		private var _hd_btn:ButtonUtil;
		
		private var _common_btn:ButtonUtil;
		
		private var _original_btn:ButtonUtil;
		
		private var _auto_btn:ButtonUtil;
		
		private var _h2644k_btn:ButtonUtil;
		
		private var _h2654k_btn:ButtonUtil;
		
		private var _autoFix:String = "";
		
		private var _ver:String = "";
		
		private var _more_xml:Object;
		
		private var _verStr:String = "普清版";
		
		private var _bandwidth:uint = 0;
		
		private var _arrBtnVis:Array;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private function newFunc() : void {
		}
		
		private function drawSkin(param1:MovieClip) : void {
			this._super_btn = new ButtonUtil({"skin":param1.super_btn});
			this._hd_btn = new ButtonUtil({"skin":param1.hd_btn});
			this._common_btn = new ButtonUtil({"skin":param1.common_btn});
			this._original_btn = new ButtonUtil({"skin":param1.original_btn});
			this._h2644k_btn = new ButtonUtil({"skin":param1.h2644k_btn});
			this._h2654k_btn = new ButtonUtil({"skin":param1.h2654k_btn});
			this._auto_btn = new ButtonUtil({"skin":param1.auto_btn});
			addChild(this._super_btn);
			addChild(this._hd_btn);
			addChild(this._common_btn);
			addChild(this._original_btn);
			addChild(this._h2644k_btn);
			addChild(this._h2654k_btn);
			addChild(this._auto_btn);
			this._width = this._auto_btn.width;
			this._height = 152;
			this._hd_btn.visible = this._common_btn.visible = this._super_btn.visible = this._original_btn.visible = this._h2644k_btn.visible = this._h2654k_btn.visible = false;
			this._arrBtnVis = new Array();
			this.resize();
		}
		
		private function speedFun() : void {
			var t:uint = 0;
			var _so:SharedObject = null;
			var _url:String = null;
			if(!PlayerConfig.isMyTvVideo && !PlayerConfig.isLive && !PlayerConfig.isFms) {
				t = new Date().getTime();
				_so = SharedObject.getLocal("vmsPlayer","/");
				if(!(_so.data.bw == undefined) && !(_so.data.bw == "") && !(String(_so.data.bw) == "0")) {
					this._bandwidth = _so.data.bw;
				}
				_url = "http://hot.vrs.sohu.com/vrs_flash.action?vid=" + PlayerConfig.vid + "&bw=" + this._bandwidth + "&af=1" + "&t=" + t;
				new URLLoaderUtil().load(5,function(param1:Object):void {
					var _loc2_:String = null;
					if(param1.info == "success") {
						_loc2_ = param1.data;
						_more_xml = new JSON().parse(_loc2_);
						if(_more_xml.fnor == 0) {
							if(_more_xml.data.version == 1) {
								_verStr = "高清版";
							} else if(_more_xml.data.version == 2) {
								_verStr = "普清版";
							} else if(_more_xml.data.version == 21) {
								_verStr = "超清版";
							} else if(_more_xml.data.version == 31) {
								_verStr = "原画版";
							} else if(_more_xml.data.version == 51) {
								_verStr = "极清版";
							} else if(_more_xml.data.version == 53) {
								_verStr = "极致版";
							}
							
							
							
							
							
						}
					}
				},_url);
			}
		}
		
		private function setOk() : void {
			this.close();
			dispatchEvent(new Event("settingFinish"));
		}
		
		public function resize() : void {
			var _loc1_:* = 0;
			this._arrBtnVis = [];
			if(PlayerConfig.h2654kVid) {
				this._arrBtnVis.push(this._h2654k_btn);
			} else {
				this._h2654k_btn.visible = false;
			}
			if(PlayerConfig.h2644kVid) {
				this._arrBtnVis.push(this._h2644k_btn);
			} else {
				this._h2644k_btn.visible = false;
			}
			if(PlayerConfig.oriVid) {
				this._arrBtnVis.push(this._original_btn);
			} else {
				this._original_btn.visible = false;
			}
			if(PlayerConfig.superVid) {
				this._arrBtnVis.push(this._super_btn);
			} else {
				this._super_btn.visible = false;
			}
			if(PlayerConfig.hdVid) {
				this._arrBtnVis.push(this._hd_btn);
			} else {
				this._hd_btn.visible = false;
			}
			if(PlayerConfig.norVid) {
				this._arrBtnVis.push(this._common_btn);
			} else {
				this._common_btn.visible = false;
			}
			this._arrBtnVis.push(this._auto_btn);
			if(!(this._arrBtnVis == null) && this._arrBtnVis.length > 0) {
				_loc1_ = 0;
				while(_loc1_ < this._arrBtnVis.length) {
					this._arrBtnVis[_loc1_].x = 0;
					this._arrBtnVis[_loc1_].y = 30 * _loc1_ + 30 * (5 - this._arrBtnVis.length);
					this._arrBtnVis[_loc1_].visible = true;
					_loc1_++;
				}
			}
		}
		
		private function addEvent() : void {
			this._h2654k_btn.addEventListener(MouseEventUtil.CLICK,this.acme);
			this._h2644k_btn.addEventListener(MouseEventUtil.CLICK,this.extreme);
			this._super_btn.addEventListener(MouseEventUtil.CLICK,this.superr);
			this._hd_btn.addEventListener(MouseEventUtil.CLICK,this.hd);
			this._common_btn.addEventListener(MouseEventUtil.CLICK,this.common);
			this._original_btn.addEventListener(MouseEventUtil.CLICK,this.original);
			this._auto_btn.addEventListener(MouseEventUtil.CLICK,this.auto);
		}
		
		private function acme(param1:MouseEventUtil) : void {
			this.close();
			dispatchEvent(new Event("showAcmePanel"));
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_H265&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function extreme(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			this._hd_btn.enabled = true;
			this._common_btn.enabled = true;
			this._original_btn.enabled = true;
			this._auto_btn.enabled = true;
			this._h2654k_btn.enabled = true;
			this._ver = "51";
			this._autoFix = "";
			this.setOk();
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_H264&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function superr(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			this._hd_btn.enabled = true;
			this._common_btn.enabled = true;
			this._original_btn.enabled = true;
			this._auto_btn.enabled = true;
			this._ver = "21";
			this._autoFix = "";
			this.setOk();
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_720P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function hd(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			this._super_btn.enabled = true;
			this._common_btn.enabled = true;
			this._original_btn.enabled = true;
			this._auto_btn.enabled = true;
			this._ver = "1";
			this._autoFix = "";
			this.setOk();
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_480P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function common(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			this._super_btn.enabled = true;
			this._hd_btn.enabled = true;
			this._original_btn.enabled = true;
			this._auto_btn.enabled = true;
			this._ver = "2";
			this._autoFix = "";
			this.setOk();
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_320P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function original(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			this._super_btn.enabled = true;
			this._hd_btn.enabled = true;
			this._common_btn.enabled = true;
			this._auto_btn.enabled = true;
			this._ver = "31";
			this._autoFix = "";
			this.setOk();
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_1080P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function auto(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			this._super_btn.enabled = true;
			this._hd_btn.enabled = true;
			this._common_btn.enabled = true;
			this._original_btn.enabled = true;
			this._autoFix = "1";
			this._ver = "";
			this.speedFun();
			this.setOk();
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Auto&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		public function get ver() : String {
			return this._ver;
		}
		
		public function get autoFix() : String {
			return this._autoFix;
		}
		
		public function open() : void {
			var _loc1_:SharedObject = null;
			var _loc2_:String = null;
			this.resize();
			this.visible = true;
			_loc1_ = SharedObject.getLocal("vmsPlayer","/");
			this._ver = String(_loc1_.data.ver);
			this._autoFix = String(_loc1_.data.af);
			if(this._autoFix == "1" || this._autoFix == "2") {
				this._auto_btn.enabled = false;
				this._super_btn.enabled = true;
				this._hd_btn.enabled = true;
				this._common_btn.enabled = true;
				this._original_btn.enabled = true;
				this._h2654k_btn.enabled = true;
				this._h2644k_btn.enabled = true;
			} else {
				if(this._ver == null || this._ver == "" || this._ver == "undefined") {
					this._autoFix = "1";
					_loc1_.data.af = this._autoFix;
					try {
						_loc2_ = _loc1_.flush();
						if(_loc2_ == SharedObjectFlushStatus.PENDING) {
							_loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
					this._auto_btn.enabled = false;
					this._super_btn.enabled = true;
					this._hd_btn.enabled = true;
					this._common_btn.enabled = true;
					this._original_btn.enabled = true;
					this._h2654k_btn.enabled = true;
					this._h2644k_btn.enabled = true;
				} else {
					this._auto_btn.enabled = true;
					if(PlayerConfig.h2644kVid == PlayerConfig.currentVid) {
						this._h2644k_btn.enabled = false;
						this._h2654k_btn.enabled = this._super_btn.enabled = this._hd_btn.enabled = this._common_btn.enabled = this._original_btn.enabled = true;
					} else if(PlayerConfig.superVid == PlayerConfig.currentVid) {
						this._super_btn.enabled = false;
						this._h2644k_btn.enabled = this._h2644k_btn.enabled = this._hd_btn.enabled = this._common_btn.enabled = this._original_btn.enabled = true;
					} else if(PlayerConfig.oriVid == PlayerConfig.currentVid) {
						this._original_btn.enabled = false;
						this._h2644k_btn.enabled = this._h2644k_btn.enabled = this._hd_btn.enabled = this._common_btn.enabled = this._super_btn.enabled = true;
					} else if(PlayerConfig.hdVid == PlayerConfig.currentVid) {
						this._hd_btn.enabled = false;
						this._h2644k_btn.enabled = this._h2644k_btn.enabled = this._original_btn.enabled = this._common_btn.enabled = this._super_btn.enabled = true;
					} else {
						this._common_btn.enabled = false;
						this._h2644k_btn.enabled = this._h2644k_btn.enabled = this._hd_btn.enabled = this._original_btn.enabled = this._super_btn.enabled = true;
					}
					
					
					
				}
				if(this._ver == null || this._ver == "" || this._ver == "undefined") {
				}
			}
		}
		
		public function close() : void {
			this.visible = false;
		}
		
		private function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			param1.target.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		override public function get width() : Number {
			return this._width;
		}
		
		override public function get height() : Number {
			return this._height;
		}
	}
}
