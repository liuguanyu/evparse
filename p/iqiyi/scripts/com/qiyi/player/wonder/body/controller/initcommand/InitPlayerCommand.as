package com.qiyi.player.wonder.body.controller.initcommand {
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
	
	public class InitPlayerCommand extends SimpleCommand {
		
		public function InitPlayerCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			var _loc8_:JavascriptAPIProxy = null;
			super.execute(param1);
			var _loc2_:AppView = param1.getBody() as AppView;
			var _loc3_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc4_:int = GlobalStage.stage.stageWidth;
			var _loc5_:int = GlobalStage.stage.stageHeight;
			var _loc6_:Number = SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE)?_loc5_:_loc5_ - BodyDef.VIDEO_BOTTOM_RESERVE;
			_loc3_.curActor.init(_loc2_.curVideoLayer,FlashVarConfig.useGPU);
			_loc3_.curActor.setArea(0,0,_loc4_,_loc6_);
			_loc3_.preActor.init(_loc2_.preVideoLayer,FlashVarConfig.useGPU);
			_loc3_.preActor.setArea(0,0,_loc4_,_loc6_);
			if(!SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_LOGO) || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && FlashVarConfig.os == FlashVarConfig.OS_XP) {
				_loc3_.curActor.floatLayer.showLogo = false;
				_loc3_.preActor.floatLayer.showLogo = false;
			}
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) {
				_loc3_.curActor.floatLayer.showBrand = false;
				_loc3_.preActor.floatLayer.showBrand = false;
			}
			var _loc7_:IUser = UserManager.getInstance().user;
			if(_loc7_) {
				if(_loc7_.limitationType == UserDef.USER_LIMITATION_UPPER) {
					sendNotification(FeedbackDef.NOTIFIC_OPEN_CLOSE,true);
				} else if(_loc7_.limitationType == UserDef.USER_LIMITATION_CLOSING) {
					_loc8_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc8_.callJsRecharge("Q00311");
				} else if(FlashVarConfig.autoPlay) {
					sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
				} else {
					sendNotification(BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE);
				}
				
				
			} else if(FlashVarConfig.autoPlay) {
				sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
			} else {
				sendNotification(BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE);
			}
			
		}
	}
}
