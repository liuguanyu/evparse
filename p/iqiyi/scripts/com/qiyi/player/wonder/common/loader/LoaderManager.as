package com.qiyi.player.wonder.common.loader
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class LoaderManager extends Object
	{
		
		private static var _instance:LoaderManager;
		
		public static const TYPE_LOADER:String = "TYPE_LOADER";
		
		public static const TYPE_URLlOADER:String = "TYPE_URLlOADER";
		
		private var _waitLoadVec:Vector.<LoaderVO>;
		
		private var _commonLoader:CommonLoader;
		
		private var _inited:Boolean = false;
		
		private var _loading:Boolean = false;
		
		public function LoaderManager()
		{
			super();
		}
		
		public static function get instance() : LoaderManager
		{
			return _instance = _instance || new LoaderManager();
		}
		
		public function init() : void
		{
			if(this._inited)
			{
				return;
			}
			this._waitLoadVec = new Vector.<LoaderVO>();
			this._commonLoader = new CommonLoader();
			this._inited = true;
		}
		
		public function loader(param1:String, param2:Function = null, param3:Function = null, param4:String = "TYPE_LOADER", param5:uint = 0) : void
		{
			var _loc7:uint = 0;
			if(!this._inited)
			{
				this.init();
			}
			var _loc6:LoaderVO = new LoaderVO(param1,param2,param3,param4,param5);
			if(!this._loading)
			{
				this.tryLoader(_loc6);
			}
			else
			{
				_loc7 = 0;
				while(_loc7 < this._waitLoadVec.length)
				{
					if(this._waitLoadVec[_loc7] == _loc6)
					{
						return;
					}
					_loc7++;
				}
				this._waitLoadVec.push(_loc6);
			}
		}
		
		private function tryLoader(param1:LoaderVO) : void
		{
			this._loading = true;
			this._commonLoader.startLoad(param1);
			this._commonLoader.addEventListener(CommonLoader.EVENT_COMPLETE,this.onCompleteHandler);
			this._commonLoader.addEventListener(CommonLoader.EVENT_ERROR,this.onErrorHandler);
		}
		
		private function onCompleteHandler(param1:CommonEvent) : void
		{
			this._loading = false;
			this._commonLoader.removeEventListener(CommonLoader.EVENT_COMPLETE,this.onCompleteHandler);
			this._commonLoader.removeEventListener(CommonLoader.EVENT_ERROR,this.onErrorHandler);
			if(this._waitLoadVec.length > 0)
			{
				this.tryLoader(this._waitLoadVec.pop());
			}
		}
		
		private function onErrorHandler(param1:CommonEvent) : void
		{
			this._loading = false;
			this._commonLoader.removeEventListener(CommonLoader.EVENT_COMPLETE,this.onCompleteHandler);
			this._commonLoader.removeEventListener(CommonLoader.EVENT_ERROR,this.onErrorHandler);
			if(this._waitLoadVec.length > 0)
			{
				this.tryLoader(this._waitLoadVec.pop());
			}
		}
	}
}
