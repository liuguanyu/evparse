package com.qiyi.player.wonder.body.controller.initcommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.body.view.AppView;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.IUser;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	
	public class InitPlayerCommand extends SimpleCommand
	{
		
		public function InitPlayerCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			var _loc8:JavascriptAPIProxy = null;
			super.execute(param1);
			var _loc2:AppView = param1.getBody() as AppView;
			var _loc3:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc4:int = GlobalStage.stage.stageWidth;
			var _loc5:int = GlobalStage.stage.stageHeight;
			var _loc6:Number = SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE)?_loc5:_loc5 - BodyDef.VIDEO_BOTTOM_RESERVE;
			_loc3.curActor.init(_loc2.curVideoLayer,FlashVarConfig.useGPU);
			_loc3.curActor.setArea(0,0,_loc4,_loc6);
			_loc3.preActor.init(_loc2.preVideoLayer,FlashVarConfig.useGPU);
			_loc3.preActor.setArea(0,0,_loc4,_loc6);
			if(!SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_LOGO) || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && FlashVarConfig.os == FlashVarConfig.OS_XP)
			{
				_loc3.curActor.floatLayer.showLogo = false;
				_loc3.preActor.floatLayer.showLogo = false;
			}
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
			{
				_loc3.curActor.floatLayer.showBrand = false;
				_loc3.preActor.floatLayer.showBrand = false;
			}
			var _loc7:IUser = UserManager.getInstance().user;
			if(_loc7)
			{
				if(_loc7.limitationType == UserDef.USER_LIMITATION_UPPER)
				{
					sendNotification(FeedbackDef.NOTIFIC_OPEN_CLOSE,true);
				}
				else if(_loc7.limitationType == UserDef.USER_LIMITATION_CLOSING)
				{
					_loc8 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc8.callJsRecharge("Q00311");
				}
				else if(FlashVarConfig.autoPlay)
				{
					sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
				}
				else
				{
					sendNotification(BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE);
				}
				
				
			}
			else if(FlashVarConfig.autoPlay)
			{
				sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
			}
			else
			{
				sendNotification(BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE);
			}
			
		}
	}
}
