package com.qiyi.player.wonder.plugins.continueplay.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import flash.display.Sprite;
	import common.CommonPageTurningArrow;
	import com.qiyi.player.wonder.plugins.continueplay.view.parts.ContinueLoading;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import flash.display.DisplayObjectContainer;
	import gs.TweenLite;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.continueplay.view.parts.ContinueItemView;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	
	public class ContinuePlayView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayView";
		
		private const GAP_SIDES:int = 24;
		
		private const GAP_ARROW_TO_CONTENT:int = 18;
		
		private const GAP_CONTENT:int = 13;
		
		private const ARROW_W:int = 33;
		
		private const V_GAP:int = 14;
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _continueInfoList:Vector.<ContinueInfo>;
		
		private var _isInitUI:Boolean = false;
		
		private var _listView:Sprite;
		
		private var _leftArrow:CommonPageTurningArrow;
		
		private var _rightArrow:CommonPageTurningArrow;
		
		private var _contentView:Sprite;
		
		private var _contentViewCon:Sprite;
		
		private var _contentMaskView:Sprite;
		
		private var _leftLoadingTip:ContinueLoading;
		
		private var _rightLoadingTip:ContinueLoading;
		
		private var _curPage:int;
		
		private var _totalPage:int;
		
		private var _startContinueInfo:ContinueInfo;
		
		private var _endContinueInfo:ContinueInfo;
		
		private var _hasPre:Boolean;
		
		private var _hasNext:Boolean;
		
		private var _isRequestPre:Boolean;
		
		private var _isShowLeftTip:Boolean;
		
		private var _isShowRightTip:Boolean;
		
		private var _playingTvid:String = "";
		
		private var _playingVid:String = "";
		
		private var _delayRemoveArr:Array;
		
		private var _contentViewTweening:Boolean = false;
		
		public function ContinuePlayView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void
		{
			this._userInfoVO = param1;
		}
		
		public function get currentPage() : int
		{
			return this._curPage;
		}
		
		public function get totalPage() : int
		{
			return this._totalPage;
		}
		
		public function get isShowLeftTip() : Boolean
		{
			return this._isShowLeftTip;
		}
		
		public function set isShowLeftTip(param1:Boolean) : void
		{
			this._isShowLeftTip = param1;
		}
		
		public function get isShowRightTip() : Boolean
		{
			return this._isShowRightTip;
		}
		
		public function set isShowRightTip(param1:Boolean) : void
		{
			this._isShowRightTip = param1;
		}
		
		public function onAddStatus(param1:int) : void
		{
			var _loc2:* = 0;
			this._status.addStatus(param1);
			switch(param1)
			{
				case ContinuePlayDef.STATUS_OPEN:
					this.open();
					break;
				case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS:
					this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
					this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
					this._isShowLeftTip = false;
					if((this._leftLoadingTip) && (this._leftLoadingTip.parent))
					{
						removeChild(this._leftLoadingTip);
						this.enableLeftArrow(true);
					}
					break;
				case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING:
					this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
					this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
					if((this._status.hasStatus(ContinuePlayDef.STATUS_OPEN)) && this._curPage <= 2 && (this._isShowLeftTip))
					{
						this._leftLoadingTip.x = this._leftArrow.x - this._leftArrow.width / 2 - this._leftLoadingTip.width / 2;
						addChild(this._leftLoadingTip);
					}
					break;
				case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED:
					this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
					this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
					this._isShowLeftTip = false;
					if((this._leftLoadingTip) && (this._leftLoadingTip.parent))
					{
						removeChild(this._leftLoadingTip);
						this.enableLeftArrow(true);
					}
					if((this._status.hasStatus(ContinuePlayDef.STATUS_OPEN)) && (this._status.hasStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW)) && this._curPage == 2)
					{
						this.updateTotalPage(0);
						this.switchoverPage(this.getPerPageCount(),true,false);
						this.updatePlayingView();
					}
					break;
				case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS:
					this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
					this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
					this._isShowRightTip = false;
					if((this._rightLoadingTip) && (this._rightLoadingTip.parent))
					{
						removeChild(this._rightLoadingTip);
						this.enableRightArrow(true);
					}
					break;
				case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING:
					this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
					this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
					if((this._status.hasStatus(ContinuePlayDef.STATUS_OPEN)) && this._curPage - this._totalPage <= 1 && (this._isShowRightTip))
					{
						this._rightLoadingTip.x = this._rightArrow.x + this._rightArrow.width / 2 - this._rightLoadingTip.width / 2;
						addChild(this._rightLoadingTip);
					}
					break;
				case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED:
					this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
					this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
					this._isShowRightTip = false;
					if((this._rightLoadingTip) && (this._rightLoadingTip.parent))
					{
						removeChild(this._rightLoadingTip);
						this.enableRightArrow(true);
					}
					if((this._status.hasStatus(ContinuePlayDef.STATUS_OPEN)) && (this._status.hasStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW)) && this._curPage == this._totalPage - 1)
					{
						_loc2 = this._endContinueInfo.index - this._startContinueInfo.index + 1;
						this.updateTotalPage(this._continueInfoList[this._continueInfoList.length - 1].index - _loc2 + 1);
						this.switchoverPage(_loc2,true,true);
						this.updatePlayingView();
					}
					break;
				case ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW:
					this.enableLeftArrow(false);
					break;
				case ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW:
					this.enableRightArrow(false);
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case ContinuePlayDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			var _loc3:* = 0;
			var _loc4:* = 0;
			if(isOnStage)
			{
				if(this._startContinueInfo)
				{
					_loc3 = this.getPerPageCount();
					_loc4 = this._endContinueInfo.index;
					if(_loc4 - this._startContinueInfo.index > _loc3 - 1)
					{
						this._endContinueInfo = this._continueInfoList[this._startContinueInfo.index + _loc3 - 1];
					}
				}
				this.switchoverPage(this._curPage,false,true);
				this.updatePlayingView();
				this.updateLayout();
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				TweenLite.killTweensOf(this._listView);
				if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
				{
					this._listView.y = 5;
					this._listView.alpha = 0;
					this.onCloseTweenComplete();
				}
				else
				{
					this._listView.y = 0;
					this._listView.alpha = 1;
					TweenLite.to(this._listView,0.5,{
						"y":5,
						"alpha":0,
						"onComplete":this.onCloseTweenComplete
					});
				}
			}
		}
		
		public function updateOpenParam(param1:Vector.<ContinueInfo>, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : void
		{
			this._continueInfoList = param1;
			this._hasPre = param3;
			this._hasNext = param4;
			if(param2)
			{
				this.updateTotalPage(this.getContinueInfoIndex(this._playingTvid,this._playingVid));
			}
		}
		
		public function updateOpenView() : void
		{
			if(this._status.hasStatus(ContinuePlayDef.STATUS_OPEN))
			{
				this.switchoverPlayingPage();
				this.updatePlayingView();
				this.updateArrowBtn();
				this.updateLayout();
			}
		}
		
		public function setCurPlaying(param1:String, param2:String) : void
		{
			this._playingTvid = param1;
			this._playingVid = param2;
			if(this._status.hasStatus(ContinuePlayDef.STATUS_OPEN))
			{
				this.updatePlayingView();
			}
		}
		
		public function switchPageInfo() : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc1:int = this.getPerPageCount();
			if(this._status.hasStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW))
			{
				if(this._startContinueInfo)
				{
					_loc2 = this.getContinueInfoIndex(this._startContinueInfo.loadMovieParams.tvid,this._startContinueInfo.loadMovieParams.vid);
					_loc3 = _loc2;
					_loc2 = _loc3 - _loc1 + 1;
					if(_loc2 < 0)
					{
						_loc2 = 0;
						if(this._continueInfoList.length >= _loc1)
						{
							_loc3 = _loc1 - 1;
						}
					}
					this._startContinueInfo = this._continueInfoList[_loc2];
					this._endContinueInfo = this._continueInfoList[_loc3];
					this.updateTotalPage(_loc2,false);
				}
			}
			else if(this._status.hasStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW))
			{
				if(this._endContinueInfo)
				{
					_loc2 = this.getContinueInfoIndex(this._endContinueInfo.loadMovieParams.tvid,this._endContinueInfo.loadMovieParams.vid);
					_loc3 = _loc2 + _loc1 - 1;
					if(_loc3 >= this._continueInfoList.length)
					{
						_loc3 = this._continueInfoList.length - 1;
					}
					this._startContinueInfo = this._continueInfoList[_loc2];
					this._endContinueInfo = this._continueInfoList[_loc3];
					this.updateTotalPage(_loc2,false);
				}
			}
			
		}
		
		public function updateCurrentPageIndex() : void
		{
			var _loc1:* = 0;
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc4:* = 0;
			if(this._startContinueInfo)
			{
				_loc1 = this._endContinueInfo.index - this._startContinueInfo.index + 1;
				_loc2 = this.getContinueInfoIndex(this._startContinueInfo.loadMovieParams.tvid,this._startContinueInfo.loadMovieParams.vid);
				_loc3 = this.getPerPageCount();
				_loc4 = _loc2 % _loc3;
				this._endContinueInfo = this._continueInfoList[_loc2 + _loc1 - 1];
				if(_loc4 == 0)
				{
					this._totalPage = Math.ceil(1 * this._continueInfoList.length / _loc3);
					this._curPage = _loc2 / _loc3 + 1;
				}
				else
				{
					this._totalPage = Math.ceil(1 * (this._continueInfoList.length - _loc4) / _loc3) + 1;
					this._curPage = (_loc2 - _loc4) / _loc3 + 2;
				}
				if(this._curPage > this._totalPage)
				{
					this._curPage = this._totalPage;
				}
			}
		}
		
		public function getPerPageCount() : int
		{
			var _loc4:* = 0;
			var _loc1:int = GlobalStage.stage.stageWidth;
			var _loc2:int = GlobalStage.stage.stageHeight;
			var _loc3:* = 0;
			if(_loc1 == 1280)
			{
				_loc3 = 9;
			}
			else
			{
				_loc4 = _loc1 - this.GAP_SIDES * 2 - this.ARROW_W * 2 - this.GAP_ARROW_TO_CONTENT * 2;
				_loc3 = Math.floor(_loc4 / (ContinueItemView.RECT_W + this.GAP_CONTENT));
				if(_loc3 > 11)
				{
					_loc3 = 11;
				}
			}
			return _loc3;
		}
		
		public function updateArrowBtn() : void
		{
			if(this._curPage >= this._totalPage)
			{
				if(this._totalPage > 1)
				{
					this.enableLeftArrow(true);
				}
				else if(!this._hasPre || this._curPage <= 2 && (this._isShowLeftTip))
				{
					this.enableLeftArrow(false);
				}
				
				if(!this._hasNext || this._curPage - this._totalPage <= 1 && (this._isShowRightTip))
				{
					this.enableRightArrow(false);
				}
			}
			else
			{
				if(this._curPage <= 1)
				{
					if(!this._hasPre || (this._isShowLeftTip))
					{
						this.enableLeftArrow(false);
					}
				}
				else
				{
					this.enableLeftArrow(true);
				}
				this.enableRightArrow(true);
			}
			if(this._curPage <= 2 && (this._isShowLeftTip) && !this._leftLoadingTip.parent)
			{
				this.enableLeftArrow(false);
				addChild(this._leftLoadingTip);
			}
			else if((this._leftLoadingTip.parent) && (this._status.hasStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW)))
			{
				removeChild(this._leftLoadingTip);
			}
			
			if(this._totalPage - this._curPage <= 1 && (this._isShowRightTip) && !this._rightLoadingTip.parent)
			{
				this.enableRightArrow(false);
				addChild(this._rightLoadingTip);
			}
			else if((this._rightLoadingTip.parent) && (this._status.hasStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW)))
			{
				removeChild(this._rightLoadingTip);
			}
			
		}
		
		override protected function onAddToStage() : void
		{
			super.onAddToStage();
			if(!this._isInitUI)
			{
				this.initUI();
				this._isInitUI = true;
			}
			this.switchoverPlayingPage();
			this.updatePlayingView();
			this.updateArrowBtn();
			this.updateLayout();
			TweenLite.killTweensOf(this._listView);
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
			{
				this._listView.y = 0;
				this._listView.alpha = 1;
			}
			else
			{
				this._listView.y = 5;
				this._listView.alpha = 0;
				TweenLite.to(this._listView,0.5,{
					"y":0,
					"alpha":1
				});
			}
		}
		
		override protected function onRemoveFromStage() : void
		{
			super.onRemoveFromStage();
			TweenLite.killTweensOf(this._listView);
		}
		
		private function initUI() : void
		{
			this._listView = new Sprite();
			addChild(this._listView);
			this._leftArrow = new CommonPageTurningArrow();
			this._leftArrow.buttonMode = true;
			this._leftArrow.useHandCursor = true;
			this._leftArrow.y = (this.V_GAP * 2 + ContinueItemView.RECT_H - this._leftArrow.height) / 2;
			this._leftArrow.addEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
			this._leftArrow.addEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
			this._leftArrow.addEventListener(MouseEvent.CLICK,this.onLeftArrowClick);
			this._leftArrow.scaleX = -1;
			this._listView.addChild(this._leftArrow);
			this._rightArrow = new CommonPageTurningArrow();
			this._rightArrow.buttonMode = true;
			this._rightArrow.useHandCursor = true;
			this._rightArrow.y = this._leftArrow.y;
			this._rightArrow.addEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
			this._rightArrow.addEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
			this._rightArrow.addEventListener(MouseEvent.CLICK,this.onRightArrowClick);
			this._listView.addChild(this._rightArrow);
			this._contentViewCon = new Sprite();
			this._contentViewCon.y = this.V_GAP;
			this._listView.addChild(this._contentViewCon);
			this._contentView = new Sprite();
			this._contentViewCon.addChild(this._contentView);
			this._contentMaskView = FastCreator.createRectSprite(1,ContinueItemView.RECT_H + 2);
			this._contentMaskView.y = this.V_GAP - 1;
			this._listView.addChild(this._contentMaskView);
			this._contentView.mask = this._contentMaskView;
			this._leftLoadingTip = new ContinueLoading();
			this._leftLoadingTip.y = this._contentView.y - this._leftLoadingTip.height;
			this._rightLoadingTip = new ContinueLoading();
			this._rightLoadingTip.y = this._leftLoadingTip.y;
		}
		
		private function onLeftArrowOver(param1:MouseEvent) : void
		{
			this._leftArrow.gotoAndStop(2);
		}
		
		private function onLeftArrowOut(param1:MouseEvent) : void
		{
			this._leftArrow.gotoAndStop(1);
		}
		
		private function onRightArrowOver(param1:MouseEvent) : void
		{
			this._rightArrow.gotoAndStop(2);
		}
		
		private function onRightArrowOut(param1:MouseEvent) : void
		{
			this._rightArrow.gotoAndStop(1);
		}
		
		private function onLeftArrowClick(param1:MouseEvent) : void
		{
			dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_SwitchOverPage,true));
			var _loc2:int = this.getPerPageCount();
			var _loc3:int = this._startContinueInfo.index;
			if(this._curPage <= 2)
			{
				if(this._curPage == 2)
				{
					if(_loc3 == _loc2)
					{
						this.arrowClick(true,_loc2);
					}
					else if(this._hasPre)
					{
						this.enableLeftArrow(false);
						if((this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS)) || (this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED)))
						{
							dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_ArrowClick,true));
						}
						else if(this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING))
						{
							this._leftLoadingTip.x = this._leftArrow.x - this._leftArrow.width / 2 - this._leftLoadingTip.width / 2;
							addChild(this._leftLoadingTip);
							this._isShowLeftTip = true;
						}
						
					}
					else
					{
						this.arrowClick(true,_loc2);
					}
					
				}
				else if(this._hasPre)
				{
					this.enableLeftArrow(false);
					if((this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS)) || (this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED)))
					{
						dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_ArrowClick,true));
					}
					else if(this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING))
					{
						this._leftLoadingTip.x = this._leftArrow.x - this._leftArrow.width / 2 - this._leftLoadingTip.width / 2;
						addChild(this._leftLoadingTip);
						this._isShowLeftTip = true;
					}
					
				}
				
			}
			else
			{
				this.arrowClick(true,_loc2);
			}
		}
		
		private function onRightArrowClick(param1:MouseEvent) : void
		{
			dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_SwitchOverPage,false));
			var _loc2:int = this.getPerPageCount();
			var _loc3:int = this._endContinueInfo.index;
			if(this._curPage >= this._totalPage - 1)
			{
				if(this._curPage == this._totalPage - 1)
				{
					if(this._continueInfoList.length - _loc3 - 1 == _loc2)
					{
						this.arrowClick(false,_loc2);
					}
					else if(this._hasNext)
					{
						this.enableRightArrow(false);
						if((this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS)) || (this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED)))
						{
							dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_ArrowClick,false));
						}
						else if(this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING))
						{
							this._rightLoadingTip.x = this._rightArrow.x + this._rightArrow.width / 2 - this._rightLoadingTip.width / 2;
							addChild(this._rightLoadingTip);
							this._isShowRightTip = true;
						}
						
					}
					else
					{
						this.arrowClick(false,_loc2);
					}
					
				}
				else if(this._hasNext)
				{
					this.enableRightArrow(false);
					if((this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS)) || (this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED)))
					{
						dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_ArrowClick,false));
					}
					else if(this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING))
					{
						this._rightLoadingTip.x = this._rightArrow.x + this._rightArrow.width / 2 - this._rightLoadingTip.width / 2;
						addChild(this._rightLoadingTip);
						this._isShowRightTip = true;
					}
					
				}
				else
				{
					this.arrowClick(false,_loc2);
				}
				
			}
			else
			{
				this.arrowClick(false,_loc2);
			}
		}
		
		private function arrowClick(param1:Boolean, param2:int) : void
		{
			if(param1)
			{
				this.updateTotalPage(this._startContinueInfo.index - param2 + 1);
				if((this._hasPre) && !this._status.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING) && this._startContinueInfo.index < ContinuePlayDef.REMAIN_NUM_TO_REQUEST)
				{
					dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_SwitchPageTriggerRequest,true));
				}
				this.switchoverPage(param2,true,false);
				this.updatePlayingView();
			}
			else
			{
				this.updateTotalPage(this._endContinueInfo.index);
				if((this._hasNext) && !this._status.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING) && this._continueInfoList.length - this._endContinueInfo.index - 1 < ContinuePlayDef.REMAIN_NUM_TO_REQUEST)
				{
					dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_SwitchPageTriggerRequest,false));
				}
				this.switchoverPage(param2,true,true);
				this.updatePlayingView();
			}
		}
		
		private function enableLeftArrow(param1:Boolean) : void
		{
			if(param1)
			{
				this._leftArrow.gotoAndStop(1);
				this._leftArrow.mouseChildren = true;
				this._leftArrow.mouseEnabled = true;
				if(!this._leftArrow.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this._leftArrow.addEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
					this._leftArrow.addEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
				}
			}
			else
			{
				this._leftArrow.removeEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
				this._leftArrow.removeEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
				this._leftArrow.mouseChildren = false;
				this._leftArrow.mouseEnabled = false;
				this._leftArrow.gotoAndStop(3);
			}
		}
		
		private function enableRightArrow(param1:Boolean) : void
		{
			if(param1)
			{
				this._rightArrow.gotoAndStop(1);
				this._rightArrow.mouseChildren = true;
				this._rightArrow.mouseEnabled = true;
				if(!this._rightArrow.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this._rightArrow.addEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
					this._rightArrow.addEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
				}
			}
			else
			{
				this._rightArrow.removeEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
				this._rightArrow.removeEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
				this._rightArrow.mouseChildren = false;
				this._rightArrow.mouseEnabled = false;
				this._rightArrow.gotoAndStop(3);
			}
		}
		
		private function switchoverPage(param1:int, param2:Boolean, param3:Boolean) : void
		{
			var _loc8:* = 0;
			var _loc9:* = 0;
			if(this._continueInfoList == null || this._continueInfoList.length == 0)
			{
				return;
			}
			if(!param2)
			{
				var param3:* = true;
			}
			var _loc4:int = this._startContinueInfo.index;
			var _loc5:int = this._endContinueInfo.index + 1;
			var _loc6:* = 0;
			TweenLite.killTweensOf(this._contentView,true);
			this.clearDelayContentViewChild();
			var _loc7:ContinueItemView = null;
			if(!param2)
			{
				while(this._contentView.numChildren > 0)
				{
					_loc7 = this._contentView.getChildAt(0) as ContinueItemView;
					_loc7.removeEventListener(MouseEvent.CLICK,this.onListItemClick);
					this._contentView.removeChildAt(0);
				}
				this._contentView.x = 0;
			}
			else
			{
				_loc8 = this._contentView.numChildren;
				this._delayRemoveArr = new Array(_loc8);
				_loc6 = 0;
				while(_loc6 < _loc8)
				{
					this._delayRemoveArr[_loc6] = this._contentView.getChildAt(_loc6);
					_loc6++;
				}
				_loc9 = 0;
				if(param3)
				{
					_loc9 = this._contentView.x - param1 * (this.GAP_CONTENT + ContinueItemView.RECT_W);
				}
				else
				{
					_loc9 = this._contentView.x + param1 * (this.GAP_CONTENT + ContinueItemView.RECT_W);
				}
				this._contentViewTweening = true;
				TweenLite.to(this._contentView,0.5,{
					"x":_loc9,
					"onComplete":this.onContentViewTweenComplete
				});
			}
			_loc6 = _loc4;
			while(_loc6 < _loc5)
			{
				_loc7 = new ContinueItemView();
				_loc7.setContinueInfo(this._continueInfoList[_loc6]);
				_loc7.addEventListener(MouseEvent.CLICK,this.onListItemClick);
				if(param3)
				{
					_loc7.x = this._contentView.numChildren * (this.GAP_CONTENT + ContinueItemView.RECT_W);
				}
				else
				{
					_loc7.x = -(_loc5 - _loc6) * (this.GAP_CONTENT + ContinueItemView.RECT_W);
				}
				this._contentView.addChild(_loc7);
				_loc6++;
			}
		}
		
		private function getContinueInfoIndex(param1:String, param2:String) : int
		{
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc3:* = 0;
			if(!(param1 == "") && !(param2 == ""))
			{
				_loc4 = this._continueInfoList.length;
				_loc5 = 0;
				while(_loc5 < _loc4)
				{
					if(this._continueInfoList[_loc5].loadMovieParams.tvid == param1 && this._continueInfoList[_loc5].loadMovieParams.vid == param2)
					{
						_loc3 = this._continueInfoList[_loc5].index;
						break;
					}
					_loc5++;
				}
			}
			return _loc3;
		}
		
		private function switchoverPlayingPage() : void
		{
			if(!(this._playingTvid == "") && !(this._playingVid == ""))
			{
				this.switchoverPage(this.getPerPageCount(),false,true);
			}
		}
		
		private function clearDelayContentViewChild() : void
		{
			var _loc1:* = 0;
			var _loc2:* = 0;
			var _loc3:ContinueItemView = null;
			if(this._delayRemoveArr)
			{
				_loc1 = this._delayRemoveArr.length;
				_loc2 = 0;
				_loc3 = null;
				_loc2 = 0;
				while(_loc2 < _loc1)
				{
					_loc3 = this._delayRemoveArr[_loc2] as ContinueItemView;
					_loc3.removeEventListener(MouseEvent.CLICK,this.onListItemClick);
					this._contentView.removeChild(_loc3);
					_loc2++;
				}
				this._delayRemoveArr = null;
				_loc1 = this._contentView.numChildren;
				_loc2 = 0;
				while(_loc2 < _loc1)
				{
					_loc3 = this._contentView.getChildAt(_loc2) as ContinueItemView;
					_loc3.x = _loc2 * (this.GAP_CONTENT + ContinueItemView.RECT_W);
					_loc2++;
				}
				this._contentView.x = 0;
			}
		}
		
		private function onContentViewTweenComplete() : void
		{
			this.updateArrowBtn();
			this._contentViewTweening = false;
			this.clearDelayContentViewChild();
			dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_SwitchOverPageDone));
		}
		
		private function updatePlayingView() : void
		{
			var _loc1:int = this._contentView.numChildren;
			var _loc2:ContinueItemView = null;
			var _loc3:ContinueInfo = null;
			var _loc4:* = 0;
			while(_loc4 < _loc1)
			{
				_loc2 = this._contentView.getChildAt(_loc4) as ContinueItemView;
				if(_loc2)
				{
					_loc3 = _loc2.getContinueInfo();
					if(_loc3)
					{
						if(_loc3.loadMovieParams.tvid == this._playingTvid && _loc3.loadMovieParams.vid == this._playingVid)
						{
							_loc2.isPlaying = true;
						}
						else
						{
							_loc2.isPlaying = false;
						}
					}
				}
				_loc4++;
			}
		}
		
		private function updateTotalPage(param1:int, param2:Boolean = true) : void
		{
			var _loc3:int = param1 < 0?0:param1;
			var _loc4:int = this.getPerPageCount();
			var _loc5:int = _loc3 % _loc4;
			if(this._continueInfoList.length > _loc4)
			{
				if(_loc5 == 0)
				{
					this._totalPage = Math.ceil(1 * this._continueInfoList.length / _loc4);
					this._curPage = _loc3 / _loc4 + 1;
				}
				else
				{
					this._totalPage = Math.ceil(1 * (this._continueInfoList.length - _loc5) / _loc4) + 1;
					this._curPage = (_loc3 - _loc5) / _loc4 + 2;
				}
			}
			else
			{
				_loc3 = 0;
				this._curPage = 1;
				this._totalPage = 1;
			}
			if(this._curPage > this._totalPage)
			{
				this._curPage = this._totalPage;
			}
			if(param2)
			{
				this._startContinueInfo = this._continueInfoList[_loc3];
				if(_loc3 + _loc4 < this._continueInfoList.length)
				{
					this._endContinueInfo = this._continueInfoList[_loc3 + _loc4 - 1];
				}
				else
				{
					this._endContinueInfo = this._continueInfoList[this._continueInfoList.length - 1];
				}
			}
		}
		
		private function updateLayout() : void
		{
			var _loc1:int = this.GAP_SIDES;
			this._leftArrow.x = _loc1 + this.ARROW_W;
			_loc1 = _loc1 + (this.ARROW_W + this.GAP_ARROW_TO_CONTENT);
			this._contentMaskView.x = _loc1 - 2;
			this._contentViewCon.x = _loc1;
			var _loc2:int = this.getPerPageCount();
			var _loc3:* = 0;
			var _loc4:* = 0;
			while(_loc4 < _loc2)
			{
				_loc3 = _loc3 + (ContinueItemView.RECT_W + this.GAP_CONTENT);
				_loc1 = _loc1 + (ContinueItemView.RECT_W + this.GAP_CONTENT);
				if(_loc4 == _loc2 - 1)
				{
					_loc1 = _loc1 - this.GAP_CONTENT;
				}
				_loc4++;
			}
			this._contentMaskView.width = _loc3;
			_loc1 = _loc1 + this.GAP_ARROW_TO_CONTENT;
			this._rightArrow.x = _loc1;
			var _loc5:int = _loc1 + this.ARROW_W + this.GAP_SIDES;
			this._listView.graphics.clear();
			this._listView.graphics.beginFill(1,0.5);
			this._listView.graphics.drawRoundRect(0,0,_loc5,ContinueItemView.RECT_H + this.V_GAP * 2,10,10);
			this._listView.graphics.endFill();
			x = GlobalStage.stage.stageWidth / 2 - this._listView.width / 2;
			y = GlobalStage.stage.stageHeight - 155;
		}
		
		private function onCloseTweenComplete() : void
		{
			if(isOnStage)
			{
				super.close();
				TweenLite.killTweensOf(this._contentView,true);
				this.clearDelayContentViewChild();
				dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_Close));
			}
		}
		
		private function onListItemClick(param1:MouseEvent) : void
		{
			var _loc2:ContinueItemView = param1.currentTarget as ContinueItemView;
			if(_loc2)
			{
				dispatchEvent(new ContinuePlayEvent(ContinuePlayEvent.Evt_ListItemClick,_loc2.getContinueInfo()));
			}
		}
	}
}
