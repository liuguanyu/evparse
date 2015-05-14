package com.qiyi.player.wonder.plugins.scenetile.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class SceneTileStreamLimitOpenCloseCommand extends SimpleCommand
	{
		
		public function SceneTileStreamLimitOpenCloseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:SceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			var _loc3:EnumItem = param1.getBody() as EnumItem;
			if(_loc3)
			{
				_loc2.limitDifinition = _loc3;
				if(_loc2.hasStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN))
				{
					_loc2.removeStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
				}
				else
				{
					PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
					_loc2.addStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
				}
			}
		}
	}
}
