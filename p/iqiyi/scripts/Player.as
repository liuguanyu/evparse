package
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.body.view.AppView;
	import flash.events.Event;
	import flash.system.Security;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import com.qiyi.player.core.model.utils.LogManager;
	import com.qiyi.player.core.CoreManager;
	import com.qiyi.player.core.model.def.PlatformEnum;
	import com.qiyi.player.core.model.def.PlayerTypeEnum;
	import com.qiyi.player.base.uuid.UUIDManager;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import com.iqiyi.components.tooltip.ToolTip;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.common.lso.LSO;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import flash.utils.getTimer;
	import com.qiyi.player.wonder.AppFacade;
	
	public class Player extends Sprite
	{
		
		private var _appView:AppView;
		
		public function Player()
		{
			super();
			if(stage)
			{
				this.onAddToStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
			}
		}
		
		public function get appView() : AppView
		{
			return this._appView;
		}
		
		private function onAddToStage(param1:Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			this.initProcessesTimeInfo();
			var _loc2:* = "";
			if((loaderInfo) && (loaderInfo.parameters))
			{
				_loc2 = loaderInfo.parameters.yhls;
			}
			PingBack.getInstance().sendPlayerLoadSuccess(_loc2);
			this.init();
		}
		
		private function init() : void
		{
			this.initFlashVar();
			this.initCore();
		}
		
		private function initFlashVar() : void
		{
			FlashVarConfig.init(loaderInfo.parameters);
			SwitchManager.getInstance().initByFlashVar(FlashVarConfig.components);
		}
		
		private function initCore() : void
		{
			var _loc3:SoundTransform = null;
			if((loaderInfo.parameters.hasOwnProperty("masflag")) && loaderInfo.parameters.masflag == "true")
			{
				_loc3 = new SoundTransform();
				_loc3.volume = 0;
				SoundMixer.soundTransform = _loc3;
			}
			LogManager.initLog(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE);
			var _loc1:* = "";
			if(loaderInfo.parameters.flashP2PCoreUrl)
			{
				_loc1 = loaderInfo.parameters.flashP2PCoreUrl.toString();
			}
			var _loc2:Boolean = CoreManager.getInstance().initialize(stage,PlatformEnum.PC,PlayerTypeEnum.MAIN_STATION,_loc1);
			if(_loc2)
			{
				this.onCoreInitComplete();
			}
			else
			{
				CoreManager.getInstance().addEventListener(CoreManager.Evt_InitComplete,this.onCoreInitComplete);
			}
			UUIDManager.instance.setWebEventID(FlashVarConfig.webEventID);
		}
		
		private function initStage() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			ToolTip.getInstance().init(stage);
			GlobalStage.initStage(stage);
		}
		
		private function initLSO() : void
		{
			LSO.getInstance().init();
		}
		
		private function initAppView() : void
		{
			this._appView = new AppView();
			addChild(this._appView);
		}
		
		private function initProcessesTimeInfo() : void
		{
			var curDate:Date = null;
			var diff:Number = NaN;
			try
			{
				if((loaderInfo.parameters.hasOwnProperty("browserType")) && !(loaderInfo.parameters.browserType == ""))
				{
					ProcessesTimeRecord.browserType = String(loaderInfo.parameters.browserType);
				}
				if((loaderInfo.parameters.hasOwnProperty("pageTmpltType")) && !(loaderInfo.parameters.pageTmpltType == ""))
				{
					ProcessesTimeRecord.pageTmpltType = String(loaderInfo.parameters.pageTmpltType);
				}
				if((loaderInfo.parameters.hasOwnProperty("playerCTime")) && Number(loaderInfo.parameters.playerCTime) > 0)
				{
					curDate = new Date();
					diff = curDate.getTime() - Number(loaderInfo.parameters.playerCTime);
					if(diff > 0)
					{
						ProcessesTimeRecord.usedTime_selfLoaded = diff;
					}
				}
			}
			catch(e:Error)
			{
				ProcessesTimeRecord.browserType = "";
				ProcessesTimeRecord.pageTmpltType = "";
				ProcessesTimeRecord.usedTime_selfLoaded = 0;
			}
		}
		
		private function onCoreInitComplete(param1:Event = null) : void
		{
			this.initStage();
			this.initLSO();
			this.initAppView();
			if(FlashVarConfig.autoPlay)
			{
				ProcessesTimeRecord.STime_showVideo = getTimer();
			}
			else
			{
				ProcessesTimeRecord.needRecord = false;
			}
			AppFacade.getInstance().startup(this);
		}
	}
}
