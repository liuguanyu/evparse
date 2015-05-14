package com.qiyi.player.wonder.plugins.scenetile.view
{
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
	
	public class SceneTileBarrageView extends BasePanel
	{
		
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
		
		public function SceneTileBarrageView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function set isFilterImage(param1:Boolean) : void
		{
			this._isFilterImage = param1;
		}
		
		private function initUI() : void
		{
			var _loc1:Vector.<BarrageItem> = null;
			var _loc3:uint = 0;
			var _loc4:Vector.<BarrageInfo> = null;
			this._barrageItemOP = new ObjectPool();
			this._barrageInfoOP = new ObjectPool();
			this._barrageItemArray = new Array();
			var _loc2:uint = 0;
			while(_loc2 < SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM)
			{
				_loc1 = new Vector.<BarrageItem>();
				this._barrageItemArray.push(_loc1);
				_loc2++;
			}
			this._bufferBIANone = new Array();
			_loc3 = 0;
			while(_loc3 < 4)
			{
				_loc4 = new Vector.<BarrageInfo>();
				this._bufferBIANone.push(_loc4);
				_loc3++;
			}
			this._bufferBIANoneSocket = new Array();
			_loc3 = 0;
			while(_loc3 < 4)
			{
				_loc4 = new Vector.<BarrageInfo>();
				this._bufferBIANoneSocket.push(_loc4);
				_loc3++;
			}
			this._bufferBIAStar = new Array();
			_loc3 = 0;
			while(_loc3 < 4)
			{
				_loc4 = new Vector.<BarrageInfo>();
				this._bufferBIAStar.push(_loc4);
				_loc3++;
			}
			this._bufferBIARestar = new Array();
			_loc3 = 0;
			while(_loc3 < 4)
			{
				_loc4 = new Vector.<BarrageInfo>();
				this._bufferBIARestar.push(_loc4);
				_loc3++;
			}
			this._selfSendBarrageInfoVec = new Vector.<BarrageInfo>();
			BarrageExpressionImage.instance.addEventListener(BarrageExpressionImage.COMPLETE,this.onFaceLoadComplete);
		}
		
		public function onAddStatus(param1:int) : void
		{
			this._status.addStatus(param1);
			switch(param1)
			{
				case SceneTileDef.STATUS_BARRAGE_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case SceneTileDef.STATUS_BARRAGE_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			var _loc3:BarrageItem = null;
			this._curRowNum = (param2 - BodyDef.VIDEO_BOTTOM_RESERVE - 20 * 2) / 60;
			this._curRowNum = this._curRowNum >= SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM?SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM:Math.floor(this._curRowNum);
			this._curRowNum = this._curRowNum <= SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM?SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM:Math.floor(this._curRowNum);
			var _loc4:uint = 0;
			while(_loc4 < this._barrageItemArray.length)
			{
				for each(_loc3 in this._barrageItemArray[_loc4])
				{
					if(_loc3.row > this._curRowNum)
					{
						_loc3.visible = false;
					}
					_loc3.onResize(param1,param2);
				}
				_loc4++;
			}
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
		
		public function onUserInfoChanged(param1:UserInfoVO) : void
		{
			this._userInfoVO = param1;
		}
		
		public function hideAllBarrageItem(param1:Boolean) : void
		{
			var _loc2:BarrageItem = null;
			var _loc3:uint = 0;
			while(_loc3 < this._barrageItemArray.length)
			{
				for each(_loc2 in this._barrageItemArray[_loc3])
				{
					_loc2.visible = param1;
					if(_loc2.row > this._curRowNum)
					{
						_loc2.visible = false;
					}
				}
				_loc3++;
			}
		}
		
		public function updateAllBarrageItemAlpha(param1:uint) : void
		{
			var _loc2:BarrageItem = null;
			var _loc3:uint = 0;
			while(_loc3 < this._barrageItemArray.length)
			{
				for each(_loc2 in this._barrageItemArray[_loc3])
				{
					_loc2.updateAlpha(param1);
				}
				_loc3++;
			}
		}
		
		public function clearAllBarrageItem() : void
		{
			var _loc1:BarrageItem = null;
			var _loc3:Vector.<BarrageInfo> = null;
			var _loc4:BarrageInfo = null;
			var _loc2:uint = 0;
			while(_loc2 < this._barrageItemArray.length)
			{
				while(this._barrageItemArray[_loc2].length > 0)
				{
					_loc1 = this._barrageItemArray[_loc2].shift();
					_loc1.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
					_loc1.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
					_loc1.clear();
					if((_loc1) && (_loc1.parent))
					{
						_loc1.parent.removeChild(_loc1);
					}
					this._barrageItemOP.push(_loc1);
					this._barrageInfoOP.push(_loc1.barrageInfo);
				}
				_loc2++;
			}
			for each(_loc3 in this._bufferBIANone)
			{
				while(_loc3.length > 0)
				{
					_loc4 = _loc3.pop();
					this._barrageInfoOP.push(_loc4);
				}
			}
			for each(_loc3 in this._bufferBIANoneSocket)
			{
				while(_loc3.length > 0)
				{
					_loc4 = _loc3.pop();
					this._barrageInfoOP.push(_loc4);
				}
			}
			for each(_loc3 in this._bufferBIAStar)
			{
				while(_loc3.length > 0)
				{
					_loc4 = _loc3.pop();
					this._barrageInfoOP.push(_loc4);
				}
			}
			for each(_loc3 in this._bufferBIARestar)
			{
				while(_loc3.length > 0)
				{
					_loc4 = _loc3.pop();
					this._barrageInfoOP.push(_loc4);
				}
			}
		}
		
		public function updateSelfBarrageInfo(param1:BarrageInfo) : void
		{
			this._selfSendBarrageInfoVec.push(param1);
		}
		
		public function updateBufferBarrageInfo(param1:Vector.<BarrageInfo>, param2:Boolean = false) : void
		{
			var _loc3:BarrageInfo = null;
			if(param1 == null)
			{
				return;
			}
			this.checkBufferIsFull(this._bufferBIANone);
			this.checkBufferIsFull(this._bufferBIANoneSocket);
			this.checkBufferIsFull(this._bufferBIARestar);
			this.checkBufferIsFull(this._bufferBIAStar);
			var _loc4:uint = 0;
			while(_loc4 < param1.length)
			{
				_loc3 = this._barrageInfoOP.pop() as BarrageInfo;
				if(_loc3 == null)
				{
					_loc3 = new BarrageInfo();
				}
				_loc3.update(param1[_loc4].contentId,param1[_loc4].showTime,param1[_loc4].content,param1[_loc4].likes,param1[_loc4].fontSize,param1[_loc4].fontColor,param1[_loc4].position,param1[_loc4].contentType,param1[_loc4].bgType,param1[_loc4].userInfo);
				if(_loc3.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
				{
					this._bufferBIAStar[_loc3.position].unshift(_loc3);
				}
				else if(_loc3.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_RESTAR)
				{
					this._bufferBIARestar[_loc3.position].unshift(_loc3);
				}
				else if(param2)
				{
					this._bufferBIANoneSocket[_loc3.position].unshift(_loc3);
				}
				else
				{
					this._bufferBIANone[_loc3.position].unshift(_loc3);
				}
				
				
				_loc4++;
			}
		}
		
		private function checkBufferIsFull(param1:Array) : void
		{
			var _loc2:BarrageInfo = null;
			var _loc4:Vector.<BarrageInfo> = null;
			var _loc5:uint = 0;
			var _loc6:Vector.<BarrageInfo> = null;
			var _loc3:uint = 0;
			for each(_loc4 in param1)
			{
				_loc3 = _loc3 + _loc4.length;
			}
			if(_loc3 >= SceneTileDef.BARRAGE_BUFFER_BARRAGEINFO_NUM)
			{
				_loc5 = 0;
				for each(_loc6 in param1)
				{
					while(_loc6.length > SceneTileDef.BARRAGE_BUFFER_BARRAGEINFO_NUM / 2)
					{
						_loc2 = _loc6.pop();
						this._barrageInfoOP.push(_loc2);
						_loc5++;
					}
				}
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_BarrageDeleteInfo,_loc5));
			}
		}
		
		public function updateBarrageItemCoordinate(param1:Boolean) : void
		{
			var _loc2:BarrageItem = null;
			var _loc4:uint = 0;
			var _loc5:* = NaN;
			var _loc6:* = NaN;
			var _loc3:uint = 0;
			while(_loc3 < this._barrageItemArray.length)
			{
				if(this._rollOverRow != _loc3 + 1)
				{
					if((param1) && _loc3 < SceneTileDef.BARRAGE_STAR_ROW_NUM)
					{
						_loc5 = 0;
						_loc4 = 0;
						while(_loc4 < this._barrageItemArray[_loc3].length)
						{
							_loc5 = _loc5 + (this._barrageItemArray[_loc3][_loc4].width + SceneTileDef.BARRAGE_ITEM_GAP);
							_loc4++;
						}
						_loc6 = (GlobalStage.stage.stageWidth - _loc5) / 2;
						_loc4 = 0;
						while(_loc4 < this._barrageItemArray[_loc3].length)
						{
							if(_loc5 >= GlobalStage.stage.stageWidth - SceneTileDef.BARRAGE_ITEM_GAP * 2)
							{
								_loc5 = _loc5 - (this._barrageItemArray[_loc3][_loc4].width + SceneTileDef.BARRAGE_ITEM_GAP);
								_loc6 = (GlobalStage.stage.stageWidth - _loc5) / 2;
								this._barrageItemArray[_loc3][_loc4].updateCoordinateOnStar();
							}
							else
							{
								this._barrageItemArray[_loc3][_loc4].updateCoordinateOnStar(_loc6);
								_loc6 = _loc6 + (this._barrageItemArray[_loc3][_loc4].width + SceneTileDef.BARRAGE_ITEM_GAP);
							}
							_loc4++;
						}
					}
					else
					{
						for each(_loc2 in this._barrageItemArray[_loc3])
						{
							_loc2.updateCoordinate();
						}
					}
				}
				_loc3++;
			}
		}
		
		public function checkAddBarrageItem(param1:Boolean, param2:uint, param3:Boolean) : void
		{
			var _loc4:uint = 0;
			var _loc5:Vector.<BarrageInfo> = null;
			if(this._selfSendBarrageInfoVec.length > 0)
			{
				_loc4 = this.getRowByDisplayArea(this._selfSendBarrageInfoVec[0].position,param3);
				this.addBarrageItem(this._selfSendBarrageInfoVec,_loc4,param2,param1,true,false,param3);
			}
			for each(_loc5 in this._bufferBIAStar)
			{
				if(_loc5.length > 0)
				{
					_loc4 = this.getRowByDisplayArea(_loc5[0].position,param3,true);
					this.addBarrageItem(_loc5,_loc4,param2,param1,false,this._isFilterImage,param3);
				}
			}
			for each(_loc5 in this._bufferBIARestar)
			{
				if(_loc5.length > 0)
				{
					_loc4 = this.getRowByDisplayArea(_loc5[0].position,param3);
					this.addBarrageItem(_loc5,_loc4,param2,param1,false,this._isFilterImage,param3);
				}
			}
			for each(_loc5 in this._bufferBIANoneSocket)
			{
				if(_loc5.length > 0)
				{
					_loc4 = this.getRowByDisplayArea(_loc5[0].position,param3);
					this.addBarrageItem(_loc5,_loc4,param2,param1,false,this._isFilterImage,param3);
				}
			}
			for each(_loc5 in this._bufferBIANone)
			{
				if(_loc5.length > 0)
				{
					_loc4 = this.getRowByDisplayArea(_loc5[0].position,param3);
					this.addBarrageItem(_loc5,_loc4,param2,param1,false,this._isFilterImage,param3);
				}
			}
		}
		
		private function addBarrageItem(param1:Vector.<BarrageInfo>, param2:uint, param3:uint, param4:Boolean, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false) : void
		{
			var _loc9:* = NaN;
			var _loc8:Vector.<BarrageItem> = this._barrageItemArray[param2 - 1] as Vector.<BarrageItem>;
			if(_loc8.length > 0)
			{
				_loc9 = _loc8[_loc8.length - 1].x + _loc8[_loc8.length - 1].width;
				if((param7) && param2 <= SceneTileDef.BARRAGE_STAR_ROW_NUM)
				{
					if(_loc9 <= GlobalStage.stage.stageWidth - 100)
					{
						this.creatBarrageItem(param1,param2,param3,param4,param5,param6);
					}
				}
				else if(_loc9 <= GlobalStage.stage.stageWidth - 300)
				{
					this.creatBarrageItem(param1,param2,param3,param4,param5,param6);
				}
				
			}
			else
			{
				this.creatBarrageItem(param1,param2,param3,param4,param5,param6);
			}
		}
		
		private function creatBarrageItem(param1:Vector.<BarrageInfo>, param2:uint, param3:uint, param4:Boolean, param5:Boolean = false, param6:Boolean = false) : void
		{
			var _loc7:Vector.<BarrageItem> = this._barrageItemArray[param2 - 1] as Vector.<BarrageItem>;
			var _loc8:BarrageItem = this._barrageItemOP.pop() as BarrageItem;
			if(_loc8 == null)
			{
				_loc8 = new BarrageItem();
			}
			else
			{
				_loc8.clear();
			}
			_loc8.row = param2;
			_loc8.isSelfSend = param5;
			_loc8.isFilterImage = param6;
			_loc8.preBarrageItem = _loc7.length > 0?_loc7[_loc7.length - 1]:null;
			_loc8.barrageInfo = param1.shift();
			_loc8.x = GlobalStage.stage.stageWidth - param2 * 10;
			_loc8.updateAlpha(param3);
			_loc8.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
			_loc8.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
			_loc8.addEventListener(MouseEvent.CLICK,this.onItemClick);
			_loc8.visible = param4;
			addChild(_loc8);
			_loc7.push(_loc8);
		}
		
		public function checkRemoveBarrageItem() : void
		{
			var _loc3:BarrageItem = null;
			var _loc4:* = NaN;
			var _loc1:uint = Math.ceil(Math.random() * SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM);
			var _loc2:Vector.<BarrageItem> = this._barrageItemArray[_loc1 - 1] as Vector.<BarrageItem>;
			if(_loc2 == null)
			{
				return;
			}
			if(_loc2.length > 0)
			{
				_loc4 = _loc2[0].x + _loc2[0].width;
				if(_loc4 < -10)
				{
					_loc3 = _loc2.shift();
					_loc3.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
					_loc3.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
					_loc3.clear();
					if((_loc3) && (_loc3.parent))
					{
						_loc3.parent.removeChild(_loc3);
					}
					this._barrageItemOP.push(_loc3);
					this._barrageInfoOP.push(_loc3.barrageInfo);
				}
			}
		}
		
		private function getRowByDisplayArea(param1:uint, param2:Boolean, param3:Boolean = false) : uint
		{
			var _loc5:uint = 0;
			var _loc4:uint = 0;
			if(param2)
			{
				if(!param3)
				{
					_loc5 = this._curRowNum - SceneTileDef.BARRAGE_STAR_ROW_NUM;
					_loc5 = _loc5 < SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM?SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM:_loc5;
					switch(param1)
					{
						case SceneTileDef.BARRAGE_POSITION_NONE:
							_loc4 = Math.ceil(Math.random() * _loc5);
							break;
						case SceneTileDef.BARRAGE_POSITION_UP:
							_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[_loc5 - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
							break;
						case SceneTileDef.BARRAGE_POSITION_CENTRE:
							_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[_loc5 - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[_loc5 - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
							break;
						case SceneTileDef.BARRAGE_POSITION_DOWN:
							_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[_loc5 - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0] + SceneTileDef.BARRAGE_POSITION_ROW[_loc5 - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[_loc5 - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][2]);
							break;
						default:
							_loc4 = Math.ceil(Math.random() * _loc5);
					}
					_loc4 = _loc4 + SceneTileDef.BARRAGE_STAR_ROW_NUM;
				}
				else
				{
					_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_STAR_ROW_NUM);
				}
			}
			else
			{
				switch(param1)
				{
					case SceneTileDef.BARRAGE_POSITION_NONE:
						_loc4 = Math.ceil(Math.random() * this._curRowNum);
						break;
					case SceneTileDef.BARRAGE_POSITION_UP:
						_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
						break;
					case SceneTileDef.BARRAGE_POSITION_CENTRE:
						_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0]);
						break;
					case SceneTileDef.BARRAGE_POSITION_DOWN:
						_loc4 = Math.ceil(Math.random() * SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][0] + SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][1] + SceneTileDef.BARRAGE_POSITION_ROW[this._curRowNum - SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM][2]);
						break;
					default:
						_loc4 = Math.ceil(Math.random() * this._curRowNum);
				}
			}
			return _loc4 <= 0?1:_loc4;
		}
		
		private function onRollOver(param1:MouseEvent) : void
		{
			var _loc2:BarrageItem = param1.target as BarrageItem;
			if(_loc2)
			{
				_loc2.addDepictLayer();
				this._rollOverRow = _loc2.row;
			}
		}
		
		private function onRollOut(param1:MouseEvent) : void
		{
			var _loc2:BarrageItem = param1.target as BarrageItem;
			if(_loc2)
			{
				_loc2.removeDepictLayer();
			}
			this._rollOverRow = 0;
		}
		
		private function onItemClick(param1:MouseEvent) : void
		{
			var _loc2:BarrageItem = param1.target as BarrageItem;
			if((_loc2) && !_loc2.isSelfSend)
			{
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_BarrageItemClick,_loc2));
			}
		}
		
		private function onFaceLoadComplete(param1:Event) : void
		{
		}
	}
}
