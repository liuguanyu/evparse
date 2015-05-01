package com.qiyi.player.wonder.body.controller.jscommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	
	public class CallJSPlayerStatusCommand extends SimpleCommand {
		
		public function CallJSPlayerStatusCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc3_.callJsPlayerStateChange(param1.getBody() as String,_loc2_.curActor.loadMovieParams.tvid,_loc2_.curActor.loadMovieParams.vid);
		}
	}
}
