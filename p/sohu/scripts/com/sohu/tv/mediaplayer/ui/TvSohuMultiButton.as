package com.sohu.tv.mediaplayer.ui {
	import ebing.controls.ButtonUtil;
	import flash.display.*;
	import flash.utils.*;
	
	public class TvSohuMultiButton extends Sprite {
		
		public function TvSohuMultiButton(param1:Object) {
			super();
			this._arrSkin = new Array();
			this._arrBtn = new Array();
			this._arrSkin = param1.arrSkin;
			this.newFunc();
			this.drawSkin();
			this.addEvent();
		}
		
		protected var _enabled_boo:Boolean = true;
		
		private var _arrSkin:Array;
		
		private var _arrBtn:Array;
		
		private var _btnVisNum:Number = 0;
		
		private function newFunc() : void {
		}
		
		private function drawSkin() : void {
			var _loc2_:ButtonUtil = null;
			var _loc1_:* = 0;
			while(_loc1_ < this._arrSkin.length) {
				_loc2_ = new ButtonUtil({"skin":this._arrSkin[_loc1_]});
				this._arrBtn.push(_loc2_);
				addChild(_loc2_);
				_loc2_.visible = false;
				_loc1_++;
			}
		}
		
		private function addEvent() : void {
		}
		
		public function set hasBtnVis(param1:int) : void {
			this._btnVisNum = param1;
			var _loc2_:* = 0;
			while(_loc2_ < this._arrBtn.length) {
				if(_loc2_ == param1) {
					this._arrBtn[_loc2_].visible = true;
				} else {
					this._arrBtn[_loc2_].visible = false;
				}
				_loc2_++;
			}
		}
		
		public function onlyBtnEnabled(param1:int, param2:Boolean) : void {
			this._arrBtn[param1].enabled = param2;
		}
		
		public function get btnVisNum() : Number {
			return this._btnVisNum;
		}
		
		public function set enabled(param1:Boolean) : void {
			var _loc2_:* = 0;
			if(this._enabled_boo != param1) {
				this._enabled_boo = param1;
				if(param1) {
					_loc2_ = 0;
					while(_loc2_ < this._arrBtn.length) {
						this._arrBtn[_loc2_].enabled = true;
						_loc2_++;
					}
				} else {
					_loc2_ = 0;
					while(_loc2_ < this._arrBtn.length) {
						this._arrBtn[_loc2_].enabled = false;
						_loc2_++;
					}
				}
			}
		}
		
		public function get enabled() : Boolean {
			return this._enabled_boo;
		}
	}
}
