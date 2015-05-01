package com.qiyi.player.wonder.plugins.recommend.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	
	public class RecommendOpenCloseCommand extends SimpleCommand {
		
		public function RecommendOpenCloseCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:RecommendProxy = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
			if(Boolean(param1.getBody())) {
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_END_POPUP);
				_loc2_.addStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
				PingBack.getInstance().recommendationPanelPing();
			} else {
				_loc2_.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
			}
		}
	}
}
