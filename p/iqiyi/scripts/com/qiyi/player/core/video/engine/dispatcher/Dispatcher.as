package com.qiyi.player.core.video.engine.dispatcher {
	import flash.events.EventDispatcher;
	import com.qiyi.player.base.rpc.IRemoteObject;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.model.remote.AuthenticationRemote;
	import com.qiyi.player.core.model.remote.FirstDispatchRemote;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.video.events.DispatcherEvent;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.core.model.remote.MemberDispatchRemote;
	import com.qiyi.player.core.model.remote.SecondDispatchRemote;
	import com.qiyi.player.base.logging.Log;
	
	public class Dispatcher extends EventDispatcher {
		
		public function Dispatcher(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.dispatcher.Dispatcher");
			super();
			this._holder = param1;
		}
		
		private var _ro:IRemoteObject;
		
		private var _segment:Segment;
		
		private var _url:String;
		
		private var _startPos:int;
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function start(param1:Segment, param2:int = -1) : void {
			this._log.info("Dispatcher (index: " + param1.index + ") start!");
			this._segment = param1;
			this._startPos = param2;
			if(this._holder.runtimeData.movieIsMember) {
				this._ro = new AuthenticationRemote(param1.index,this._holder);
			} else {
				this._ro = new FirstDispatchRemote(param1,this._holder);
			}
			this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRemoteObjectStatusChanged);
			this._ro.initialize();
		}
		
		private function onRemoteObjectStatusChanged(param1:RemoteObjectEvent) : void {
			if(this._ro == null) {
				return;
			}
			this._ro.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRemoteObjectStatusChanged);
			if(this._ro.status == RemoteObjectStatusEnum.Success) {
				if(!this.gotoNextProcess()) {
					this._log.info("Dispatcher (index: " + this._segment.index + ") success!");
					dispatchEvent(new DispatcherEvent(DispatcherEvent.Evt_Success,this._url));
				}
			} else {
				this._log.info("Dispatcher (index: " + this._segment.index + ") failed! errno=" + ErrorCodeUtils.getErrorCodeByRemoteObject(this._ro,this._ro.status));
				dispatchEvent(new DispatcherEvent(DispatcherEvent.Evt_Failed,this._ro));
			}
		}
		
		private function gotoNextProcess() : Boolean {
			if(this._ro is AuthenticationRemote) {
				if(this._ro.getData().code == "A00000") {
					this._ro.destroy();
					this._ro = new MemberDispatchRemote(this._segment,this._startPos,this._holder);
					this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRemoteObjectStatusChanged);
					this._ro.initialize();
				} else {
					this._log.info("failed to Authentication. code = " + this._ro.getData().code);
					dispatchEvent(new DispatcherEvent(DispatcherEvent.Evt_Failed,this._ro));
				}
			} else if(this._ro is FirstDispatchRemote) {
				this._ro.destroy();
				this._ro = new SecondDispatchRemote(this._segment,this._startPos,this._holder);
				this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRemoteObjectStatusChanged);
				this._ro.initialize();
			} else {
				this._url = this._ro.getData().l;
				return false;
			}
			
			return true;
		}
		
		public function stop() : void {
			if(this._ro) {
				this._ro.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRemoteObjectStatusChanged);
				this._ro.destroy();
				this._ro = null;
				this._log.info("Dispatcher(index: " + this._segment.index + ") stop!");
			}
			this._segment = null;
		}
	}
}
