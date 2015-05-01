package com.qiyi.player.wonder.plugins.scenetile.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.common.utils.ObjectPool;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.BarrageInfo;
	import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageItem;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageExpressionImage;
	import com.qiyi.player.wonder.body.BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.Event;
	
	public class SceneTileBarrageView extends BasePanel {
		
		public function SceneTileBarrageView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _barrageItemOP:ObjectPool;
		
		private var _barrageInfoOP:ObjectPool;
		
		private var _barrageItemArray:Array;
		
		private var _bufferBIANone:Array;
		
		private var _bufferBIANoneSocket:Array;
		
		private var _bufferBIAStar:Array;
		
		private var _bufferBIARestar:Array;
		
		private var _selfSendBarrageInfoVec:Vector.<BarrageInfo>;
		
		private var _rollOverRow:uint = 0;
		
		private var _isFilterImage:Boolean = false;
		
		private var _curRowNum:uint = 6;
		
		public function set isFilterImage(param1:Boolean) : void {
			this._isFilterImage = param1;
		}
		
		private function initUI() : void {
			var _loc1_:Vector.<BarrageItem> = null;
			var _loc3_:uint = 0;
			var _loc4_:Vector.<BarrageInfo> = null;
			this._barrageItemOP = new ObjectPool();
			this._barrageInfoOP = new ObjectPool();
			this._barrageItemArray = new Array();
			var _loc2_:uint = 0;
			while(_loc2_ < SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM) {
				_loc1_ = new Vector.<BarrageItem>();
				this._barrageItemArray.push(_loc1_);
				_loc2_++;
			}
			this._bufferBIANone = new Array();
			_loc3_ = 0;
			while(_loc3_ < 4) {
				_loc4_ = new Vector.<BarrageInfo>();
				this._bufferBIANone.push(_loc4_);
				_loc3_++;
			}
			this._bufferBIANoneSocket = new Array();
			_loc3_ = 0;
			while(_loc3_ < 4) {
				_loc4_ = new Vector.<BarrageInfo>();
				this._bufferBIANoneSocket.push(_loc4_);
				_loc3_++;
			}
			this._bufferBIAStar = new Array();
			_loc3_ = 0;
			while(_loc3_ < 4) {
				_loc4_ = new Vector.<BarrageInfo>();
				this._bufferBIAStar.push(_loc4_);
				_loc3_++;
			}
			this._bufferBIARestar = new Array();
			_loc3_ = 0;
			while(_loc3_ < 4) {
				_loc4_ = new Vector.<BarrageInfo>();
				this._bufferBIARestar.push(_loc4_);
				_loc3_++;
			}
			this._selfSendBarrageInfoVec = new Vector.<BarrageInfo>();
			BarrageExpressionImage.instance.addEventListener(BarrageExpressionImage.COMPLETE,this.onFaceLoadComplete);
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case SceneTileDef.STATUS_BARRAGE_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case SceneTileDef.STATUS_BARRAGE_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			var _loc3_:BarrageItem = null;
			this._curRowNum = (param2 - BodyDef.VIDEO_BOTTOM_RESERVE - 20 * 2) / 60;
			this._curRowNum = this._curRowNum >= SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM?SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM:Math.floor(this._curRowNum);
			this._curRowNum = this._curRowNum <= SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM?SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM:Math.floor(this._curRowNum);
			var _loc4_:uint = 0;
			while(_loc4_ < this._barrageItemArray.length) {
				for each(_loc3_ in this._barrageItemArray[_loc4_]) {
					if(_loc3_.row > this._curRowNum) {
						_loc3_.visible = false;
					}
					_loc3_.onResize(param1,param2);
				}
				_loc4_++;
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ToolOpen));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ToolClose));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function hideAllBarrageItem(param1:Boolean) : void {
			var _loc2_:BarrageItem = null;
			var _loc3_:uint = 0;
			while(_loc3_ < this._barrageItemArray.length) {
				for each(_loc2_ in this._barrageItemArray[_loc3_]) {
					_loc2_.visible = param1;
					if(_loc2_.row > this._curRowNum) {
						_loc2_.visible = false;
					}
				}
				_loc3_++;
			}
		}
		
		public function updateAllBarrageItemAlpha(param1:uint) : void {
			var _loc2_:BarrageItem = null;
			var _loc3_:uint = 0;
			while(_loc3_ < this._barrageItemArray.length) {
				for each(_loc2_ in this._barrageItemArray[_loc3_]) {
					_loc2_.updateAlpha(param1);
				}
				_loc3_++;
			}
		}
		
		public function clearAllBarrageItem() : void {
			var _loc1_:BarrageItem = null;
			var _loc3_:Vector.<BarrageInfo> = null;
			var _loc4_:BarrageInfo = null;
			var _loc2_:uint = 0;
			while(_loc2_ < this._barrageItemArray.length) {
				while(this._barrageItemArray[_loc2_].length > 0) {
					_loc1_ = this._barrageItemArray[_loc2_].shift();
					_loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
					_loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
					_loc1_.clear();
					if((_loc1_) && (_loc1_.parent)) {
						_loc1_.parent.removeChild(_loc1_);
					}
					this._barrageItemOP.push(_loc1_);
					this._barrageInfoOP.push(_loc1_.barrageInfo);
				}
				_loc2_++;
			}
			for each(_loc3_ in this._bufferBIANone) {
				while(_loc3_.length > 0) {
					_loc4_ = _loc3_.pop();
					this._barrageInfoOP.push(_loc4_);
				}
			}
			for each(_loc3_ in this._bufferBIANoneSocket) {
				while(_loc3_.length > 0) {
					_loc4_ = _loc3_.pop();
					this._barrageInfoOP.push(_loc4_);
				}
			}
			for each(_loc3_ in this._bufferBIAStar) {
				while(_loc3_.length > 0) {
					_loc4_ = _loc3_.pop();
					this._barrageInfoOP.push(_loc4_);
				}
			}
			for each(_loc3_ in this._bufferBIARestar) {
				while(_loc3_.length > 0) {
					_loc4_ = _loc3_.pop();
					this._barrageInfoOP.push(_loc4_);
				}
			}
		}
		
		public function updateSelfBarrageInfo(param1:BarrageInfo) : void {
			this._selfSendBarrageInfoVec.push(param1);
		}
		
		public function updateBufferBarrageInfo(param1:Vector.<BarrageInfo>, param2:Boolean = false) : void {
			var _loc3_:BarrageInfo = null;
			if(param1 == null) {
				return;
			}
			this.checkBufferIsFull(this._bufferBIANone);
			this.checkBufferIsFull(this._bufferBIANoneSocket);
			this.checkBufferIsFull(this._bufferBIARestar);
			this.checkBufferIsFull(this._bufferBIAStar);
			var _loc4_:uint = 0;
			while(_loc4_ < param1.length) {
				_loc3_ = this._barrageInfoOP.pop() as BarrageInfo;
				if(_loc3_ == null) {
					_loc3_ = new BarrageInfo();
				}
				_loc3_.update(param1[_loc4_].contentId,param1[_loc4_].showTime,param1[_loc4_].content,param1[_loc4_].likes,param1[_loc4_].fontSize,param1[_loc4_].fontColor,param1[_loc4_].position,param1[_loc4_].contentType,param1[_loc4_].bgType,param1[_loc4_].userInfo);
				if(_loc3_.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR) {
					this._bufferBIAStar[_loc3_.position].unshift(_loc3_);
				} else if(_loc3_.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_RESTAR) {
					this._bufferBIARestar[_loc3_.position].unshift(_loc3_);
				} else if(param2) {
					this._bufferBIANoneSocket[_loc3_.position].unshift(_loc3_);
				} else {
					this._bufferBIANone[_loc3_.position].unshift(_loc3_);
				}
				
				
				_loc4_++;
			}
		}
		
		private function checkBufferIsFull(param1:Array) : void {
			var _loc2_:BarrageInfo = null;
			var _loc4_:Vector.<BarrageInfo> = null;
			var _loc5_:uint = 0;
			var _loc6_:Vector.<BarrageInfo> = null;
			var _loc3_:uint = 0;
			for each(_loc4_ in param1) {
				_loc3_ = _loc3_ + _loc4_.length;
			}
			if(_loc3_ >= SceneTileDef.BARRAGE_BUFFER_BARRAGEINFO_NUM) {
				_loc5_ = 0;
				for each(_loc6_ in param1) {
					while(_loc6_.length > SceneTileDef.BARRAGE_BUFFER_BARRAGEINFO_NUM / 2) {
						_loc2_ = _loc6_.pop();
						this._barrageInfoOP.push(_loc2_);
						_loc5_++;
					}
				}
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_BarrageDeleteInfo,_loc5_));
			}
		}
		
		public function updateBarrageItemCoordinate(param1:Boolean) : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		public function checkAddBarrageItem(param1:Boolean, param2:uint, param3:Boolean) : void {
			var _loc4_:uint = 0;
			var _loc5_:Vector.<BarrageInfo> = null;
			if(this._selfSendBarrageInfoVec.length > 0) {
				_loc4_ = this.getRowByDisplayArea(this._selfSendBarrageInfoVec[0].position,param3);
				this.addBarrageItem(this._selfSendBarrageInfoVec,_loc4_,param2,param1,true,false,param3);
			}
			for each(_loc5_ in this._bufferBIAStar) {
				if(_loc5_.length > 0) {
					_loc4_ = this.getRowByDisplayArea(_loc5_[0].position,param3,true);
					this.addBarrageItem(_loc5_,_loc4_,param2,param1,false,this._isFilterImage,param3);
				}
			}
			for each(_loc5_ in this._bufferBIARestar) {
				if(_loc5_.length > 0) {
					_loc4_ = this.getRowByDisplayArea(_loc5_[0].position,param3);
					this.addBarrageItem(_loc5_,_loc4_,param2,param1,false,this._isFilterImage,param3);
				}
			}
			for each(_loc5_ in this._bufferBIANoneSocket) {
				if(_loc5_.length > 0) {
					_loc4_ = this.getRowByDisplayArea(_loc5_[0].position,param3);
					this.addBarrageItem(_loc5_,_loc4_,param2,param1,false,this._isFilterImage,param3);
				}
			}
			for each(_loc5_ in this._bufferBIANone) {
				if(_loc5_.length > 0) {
					_loc4_ = this.getRowByDisplayArea(_loc5_[0].position,param3);
					this.addBarrageItem(_loc5_,_loc4_,param2,param1,false,this._isFilterImage,param3);
				}
			}
		}
		
		private function addBarrageItem(param1:Vector.<BarrageInfo>, param2:uint, param3:uint, param4:Boolean, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false) : void {
			var _loc9_:* = NaN;
			var _loc8_:Vector.<BarrageItem> = this._barrageItemArray[param2 - 1] as Vector.<BarrageItem>;
			if(_loc8_.length > 0) {
				_loc9_ = _loc8_[_loc8_.length - 1].x + _loc8_[_loc8_.length - 1].width;
				if((param7) && param2 <= SceneTileDef.BARRAGE_STAR_ROW_NUM) {
					if(_loc9_ <= GlobalStage.stage.stageWidth - 100) {
						this.creatBarrageItem(param1,param2,param3,param4,param5,param6);
					}
				} else if(_loc9_ <= GlobalStage.stage.stageWidth - 300) {
					this.creatBarrageItem(param1,param2,param3,param4,param5,param6);
				}
				
			} else {
				this.creatBarrageItem(param1,param2,param3,param4,param5,param6);
			}
		}
		
		private function creatBarrageItem(param1:Vector.<BarrageInfo>, param2:uint, param3:uint, param4:Boolean, param5:Boolean = false, param6:Boolean = false) : void {
			var _loc7_:Vector.<BarrageItem> = this._barrageItemArray[param2 - 1] as Vector.<BarrageItem>;
			var _loc8_:BarrageItem = this._barrageItemOP.pop() as BarrageItem;
			if(_loc8_ == null) {
				_loc8_ = new BarrageItem();
			} else {
				_loc8_.clear();
			}
			_loc8_.row = param2;
			_loc8_.isSelfSend = param5;
			_loc8_.isFilterImage = param6;
			_loc8_.preBarrageItem = _loc7_.length > 0?_loc7_[_loc7_.length - 1]:null;
			_loc8_.barrageInfo = param1.shift();
			_loc8_.x = GlobalStage.stage.stageWidth - param2 * 10;
			_loc8_.updateAlpha(param3);
			_loc8_.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
			_loc8_.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
			_loc8_.addEventListener(MouseEvent.CLICK,this.onItemClick);
			_loc8_.visible = param4;
			addChild(_loc8_);
			_loc7_.push(_loc8_);
		}
		
		public function checkRemoveBarrageItem() : void {
			var _loc3_:BarrageItem = null;
			var _loc4_:* = NaN;
			var _loc1_:uint = Math.ceil(Math.random() * SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM);
			var _loc2_:Vector.<BarrageItem> = this._barrageItemArray[_loc1_ - 1] as Vector.<BarrageItem>;
			if(_loc2_ == null) {
				return;
			}
			if(_loc2_.length > 0) {
				_loc4_ = _loc2_[0].x + _loc2_[0].width;
				if(_loc4_ < -10) {
					_loc3_ = _loc2_.shift();
					_loc3_.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
					_loc3_.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
					_loc3_.clear();
					if((_loc3_) && (_loc3_.parent)) {
						_loc3_.parent.removeChild(_loc3_);
					}
					this._barrageItemOP.push(_loc3_);
					this._barrageInfoOP.push(_loc3_.barrageInfo);
				}
			}
		}
		
		private function getRowByDisplayArea(param1:uint, param2:Boolean, param3:Boolean = false) : uint {
			var _loc5_:uint = 0;
			var _loc4_:uint = 0;
			if(param2) {
				if(!param3) {
					_loc5_ = this._curRowNum - SceneTileDef.BARRAGE_STAR_ROW_NUM;
					_loc5_ = _loc5_ < SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM?SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM:_loc5_;
					switch(param1) {
						case SceneTileDef.BARRAGE_POSITION_NONE:
							_loc4_ = Math.ceil(Math.random() * _loc5_);
							break;
						case SceneTileDef.BARRAGE_POSITION_UP:
							_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[_loc5_ - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
							break;
						case SceneTileDef.BARRAGE_POSITION_CENTRE:
							_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[_loc5_ - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[_loc5_ - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
							break;
						case SceneTileDef.BARRAGE_POSITION_DOWN:
							_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[_loc5_ - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0] + SceneTileDef.BARRAGE_POSITION_ROW[_loc5_ - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[_loc5_ - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][2]);
							break;
						default:
							_loc4_ = Math.ceil(Math.random() * _loc5_);
					}
					_loc4_ = _loc4_ + SceneTileDef.BARRAGE_STAR_ROW_NUM;
				} else {
					_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_STAR_ROW_NUM);
				}
			} else {
				switch(param1) {
					case SceneTileDef.BARRAGE_POSITION_NONE:
						_loc4_ = Math.ceil(Math.random() * this._curRowNum);
						break;
					case SceneTileDef.BARRAGE_POSITION_UP:
						_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
						break;
					case SceneTileDef.BARRAGE_POSITION_CENTRE:
						_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
						break;
					case SceneTileDef.BARRAGE_POSITION_DOWN:
						_loc4_ = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0] + SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][2]);
						break;
					default:
						_loc4_ = Math.ceil(Math.random() * this._curRowNum);
				}
			}
			return _loc4_ <= 0?1:_loc4_;
		}
		
		private function onRollOver(param1:MouseEvent) : void {
			var _loc2_:BarrageItem = param1.target as BarrageItem;
			if(_loc2_) {
				_loc2_.addDepictLayer();
				this._rollOverRow = _loc2_.row;
			}
		}
		
		private function onRollOut(param1:MouseEvent) : void {
			var _loc2_:BarrageItem = param1.target as BarrageItem;
			if(_loc2_) {
				_loc2_.removeDepictLayer();
			}
			this._rollOverRow = 0;
		}
		
		private function onItemClick(param1:MouseEvent) : void {
			var _loc2_:BarrageItem = param1.target as BarrageItem;
			if((_loc2_) && !_loc2_.isSelfSend) {
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_BarrageItemClick,_loc2_));
			}
		}
		
		private function onFaceLoadComplete(param1:Event) : void {
		}
	}
}
