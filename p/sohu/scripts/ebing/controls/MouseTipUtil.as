package ebing.controls {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import ebing.Utils;
	
	public class MouseTipUtil extends Sprite {
		
		public function MouseTipUtil(param1:Object) {
			super();
			this.init(param1);
		}
		
		private var K1026038049549CA0244D9DB3AAA160A22B0E8F373566K:MouseTipUtil;
		
		private var _label_str:String;
		
		private var K1026033C9ABCB48E534235BDF01E3FA8A96E44373566K:Boolean;
		
		private var _skin_spr:Sprite;
		
		private var K102603D1D7832D22B24109B998FC2FA18BE446373566K:Object;
		
		private var _label_txt:TextField;
		
		private var K1026032013E4D58259428E9D69E5E85E41F892373566K:Sprite;
		
		private var K102603813A9C20460B43F197E63C255EACD10A373566K:Sprite;
		
		public function init(param1:Object) : void {
			this.K1026033C9ABCB48E534235BDF01E3FA8A96E44373566K = param1.showNonius;
			this._skin_spr = param1.skin;
			this.K102603D1D7832D22B24109B998FC2FA18BE446373566K = param1.isSuit;
			this.sysInit();
		}
		
		private function sysInit() : void {
			this.K1026038049549CA0244D9DB3AAA160A22B0E8F373566K = this;
			this.K1026032013E4D58259428E9D69E5E85E41F892373566K = this._skin_spr["nonius"];
			this.K102603813A9C20460B43F197E63C255EACD10A373566K = this._skin_spr["bg"];
			addChild(this.K1026032013E4D58259428E9D69E5E85E41F892373566K);
			addChild(this.K102603813A9C20460B43F197E63C255EACD10A373566K);
		}
		
		public function showTip(param1:String) : void {
			this._label_str = param1;
			if(this._skin_spr != null) {
				this._label_txt = new TextField();
				this._label_txt.mouseEnabled = false;
				this._label_txt.autoSize = TextFieldAutoSize.CENTER;
				this._label_txt.text = this._label_str;
				this._label_txt.x = this.K1026032013E4D58259428E9D69E5E85E41F892373566K.x;
				this._label_txt.y = this.K102603813A9C20460B43F197E63C255EACD10A373566K.y;
				if(this.K102603D1D7832D22B24109B998FC2FA18BE446373566K) {
					this.K102603FF398C722B80498F89ADA158A631382E373566K();
				}
				this.K102603BECD44DDB6C1446ABBFDB52146400B5C373566K();
				this.K10260363E8559A34C64D1E823173B382D46E83373566K();
			} else {
				trace("::注意:你没有给Tip对象加皮肤::");
			}
		}
		
		private function K102603FF398C722B80498F89ADA158A631382E373566K() : void {
			this.K102603813A9C20460B43F197E63C255EACD10A373566K.width = this._label_txt.width;
			this.K102603813A9C20460B43F197E63C255EACD10A373566K.height = this._label_txt.height;
			var _loc1_:Number = this.K102603813A9C20460B43F197E63C255EACD10A373566K.scaleX;
			this.K1026032013E4D58259428E9D69E5E85E41F892373566K.scaleX = this.K1026032013E4D58259428E9D69E5E85E41F892373566K.scaleY = _loc1_;
			this.K1026032013E4D58259428E9D69E5E85E41F892373566K.x = -this.K1026032013E4D58259428E9D69E5E85E41F892373566K.width / 2;
			this.K1026032013E4D58259428E9D69E5E85E41F892373566K.y = -this.K1026032013E4D58259428E9D69E5E85E41F892373566K.height - 10;
			this.K1026032013E4D58259428E9D69E5E85E41F892373566K.x = -this.K102603813A9C20460B43F197E63C255EACD10A373566K.width / 2;
		}
		
		private function K102603BECD44DDB6C1446ABBFDB52146400B5C373566K() : void {
			var _loc1_:* = false;
			var _loc2_:* = NaN;
			if(!this.K1026033C9ABCB48E534235BDF01E3FA8A96E44373566K) {
				_loc1_ = false;
				_loc2_ = -this.K102603813A9C20460B43F197E63C255EACD10A373566K.height - 10;
			} else {
				_loc1_ = true;
				_loc2_ = this.K1026032013E4D58259428E9D69E5E85E41F892373566K.y - this.K102603813A9C20460B43F197E63C255EACD10A373566K.height;
			}
			this.K1026032013E4D58259428E9D69E5E85E41F892373566K.visible = _loc1_;
			this.K102603813A9C20460B43F197E63C255EACD10A373566K.y = _loc2_;
			Utils.setCenter(this._label_txt,this.K102603813A9C20460B43F197E63C255EACD10A373566K);
		}
		
		private function K10260363E8559A34C64D1E823173B382D46E83373566K() : void {
			this._skin_spr.addChild(this._label_txt);
			this.K1026038049549CA0244D9DB3AAA160A22B0E8F373566K.addChild(this._skin_spr);
			trace("ok:" + this._skin_spr);
			this.K1026038049549CA0244D9DB3AAA160A22B0E8F373566K.startDrag(true);
		}
		
		public function removeTip() : void {
			this._skin_spr.removeChild(this._label_txt);
			this.K1026038049549CA0244D9DB3AAA160A22B0E8F373566K.stopDrag();
			trace("1:" + this._skin_spr);
			this.K1026038049549CA0244D9DB3AAA160A22B0E8F373566K.removeChild(this._skin_spr);
		}
	}
}
