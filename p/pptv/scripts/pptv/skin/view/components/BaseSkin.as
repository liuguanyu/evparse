package pptv.skin.view.components
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import cn.pplive.player.view.ui.SmartClickPanel;
   import flash.display.Sprite;
   
   public class BaseSkin extends MovieClip
   {
      
      protected var _controlMc:MovieClip = null;
      
      protected var _contrlBgMc:MovieClip = null;
      
      protected var _playpauseMc:MovieClip = null;
      
      protected var _nextMc:SimpleButton = null;
      
      protected var _codeMc:SimpleButton = null;
      
      protected var _soundMc:MovieClip = null;
      
      protected var _fullscreenMc:MovieClip = null;
      
      protected var _topMc:MovieClip = null;
      
      protected var _bigPlayMc:SimpleButton = null;
      
      protected var _startFreshMc:MovieClip = null;
      
      protected var _loadingMc:MovieClip = null;
      
      protected var _logoMc:MovieClip = null;
      
      protected var _errorMc:MovieClip = null;
      
      protected var _optionMc:SimpleButton = null;
      
      protected var _shareMc:SimpleButton = null;
      
      protected var _adjustMc:MovieClip = null;
      
      protected var _shareEditorMc:MovieClip = null;
      
      protected var _vodprogressMc:MovieClip = null;
      
      protected var _playerTipMc:MovieClip = null;
      
      protected var _settingMc:MovieClip = null;
      
      protected var _hdMc:MovieClip = null;
      
      protected var _theatreMc:MovieClip = null;
      
      protected var _timeMc:MovieClip = null;
      
      protected var _barrageMc:MovieClip = null;
      
      protected var _accelerateMc:MovieClip = null;
      
      protected var _smartClickPanel:SmartClickPanel = null;
      
      protected var _subTitleMc:SimpleButton = null;
      
      protected var _subTitleShowMc:MovieClip = null;
      
      protected var _handyMc:MovieClip = null;
      
      protected var _leftMc:Sprite = null;
      
      protected var _rightMc:Sprite = null;
      
      protected var _handyArr:Array;
      
      protected var _leftArr:Array;
      
      protected var _rightArr:Array;
      
      protected var _objArr:Array;
      
      protected var _elementNum:Number = 0;
      
      protected var _showWidth:Number = NaN;
      
      protected var _showHeight:Number = NaN;
      
      public function BaseSkin()
      {
         this._handyArr = [];
         this._leftArr = [];
         this._rightArr = [];
         this._objArr = [];
         super();
      }
   }
}
