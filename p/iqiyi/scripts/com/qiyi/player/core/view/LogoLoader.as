package com.qiyi.player.core.view {
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import com.qiyi.player.components.DefaultLogo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.filters.GlowFilter;
	
	public class LogoLoader extends EventDispatcher {
		
		public function LogoLoader() {
			super();
		}
		
		public static const Evt_Complete:String = "complete";
		
		private const ALPHA:Number = 0.7;
		
		private const FILTERS:Array = [new GlowFilter(0,0.4,4,4,5)];
		
		private var _logo:DisplayObject;
		
		public function getLogo() : DisplayObject {
			return this._logo;
		}
		
		public function load(param1:String) : void {
			this._logo = new DefaultLogo();
			this._logo.alpha = this.ALPHA;
			this._logo.filters = this.FILTERS;
			dispatchEvent(new Event(Evt_Complete));
		}
		
		private function onUrlComplete(param1:Event) : void {
			param1.target.removeEventListener(Event.COMPLETE,this.onUrlComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onUrlError);
			param1.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUrlError);
			var _loc2_:Loader = new Loader();
			_loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLogoComplete);
			_loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLogoError);
			_loc2_.load(new URLRequest(param1.target.data));
		}
		
		private function onUrlError(param1:Event) : void {
			param1.target.removeEventListener(Event.COMPLETE,this.onUrlComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onUrlError);
			param1.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUrlError);
			this._logo = new DefaultLogo();
			this._logo.alpha = this.ALPHA;
			dispatchEvent(new Event(Evt_Complete));
		}
		
		private function onLogoComplete(param1:Event) : void {
			var cls:Class = null;
			var event:Event = param1;
			var loader:Loader = event.target.loader as Loader;
			event.target.removeEventListener(Event.COMPLETE,this.onLogoComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onLogoError);
			try {
				cls = Class(loader.contentLoaderInfo.applicationDomain.getDefinition("com.qiyi.player.components.ExternalLogo_UI"));
				this._logo = new cls() as DisplayObject;
				this._logo.alpha = this.ALPHA;
				dispatchEvent(new Event(Evt_Complete));
			}
			catch(e:Error) {
				onLogoError(null);
			}
		}
		
		private function onLogoError(param1:Event) : void {
			if(param1) {
				param1.target.removeEventListener(Event.COMPLETE,this.onLogoComplete);
				param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onLogoError);
			}
			this._logo = new DefaultLogo();
			this._logo.alpha = this.ALPHA;
			dispatchEvent(new Event(Evt_Complete));
		}
	}
}
