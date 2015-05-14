package com.qiyi.player.wonder.body.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.body.model.actors.PlayerActor;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.base.logging.Log;
	
	public class PlayerProxy extends Proxy
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.body.model.PlayerProxy";
		
		private var _curActor:PlayerActor;
		
		private var _preActor:PlayerActor;
		
		private var _invalid:Boolean = false;
		
		private var _log:ILogger;
		
		public function PlayerProxy(param1:Object = null)
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.body.model.PlayerProxy");
			super(NAME,param1);
			this._curActor = new PlayerActor(facade);
			this._curActor.isPreload = false;
			this._preActor = new PlayerActor(facade);
			this._preActor.isPreload = true;
		}
		
		public function get curActor() : PlayerActor
		{
			return this._curActor;
		}
		
		public function get preActor() : PlayerActor
		{
			return this._preActor;
		}
		
		public function get invalid() : Boolean
		{
			return this._invalid;
		}
		
		public function set invalid(param1:Boolean) : void
		{
			this._invalid = param1;
		}
		
		public function switchPreActor() : void
		{
			var _loc1:PlayerActor = this._curActor;
			this._curActor = this._preActor;
			this._curActor.isPreload = false;
			this._preActor = _loc1;
			this._preActor.isPreload = true;
			this._preActor.stop();
			this._log.info("switchPreActor,curTvid:" + this._curActor.loadMovieParams.tvid + ", curVid:" + this._curActor.loadMovieParams.vid);
			sendNotification(BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR);
		}
	}
}
