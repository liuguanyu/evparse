package com.qiyi.player.wonder.plugins
{
	import org.puremvc.as3.patterns.facade.Facade;
	import flash.display.DisplayObjectContainer;
	
	public class AbstractPlugins extends Object
	{
		
		protected var facade:Facade;
		
		public function AbstractPlugins()
		{
			super();
		}
		
		public function init(param1:Facade) : void
		{
			this.facade = param1;
		}
		
		public function initModel(param1:Vector.<String> = null) : void
		{
			if(this.facade == null)
			{
				throw new Error("facade is null,please call init!");
			}
			else
			{
				return;
			}
		}
		
		public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void
		{
			if(this.facade == null)
			{
				throw new Error("facade is null,please call init!");
			}
			else
			{
				return;
			}
		}
		
		public function initController() : void
		{
			if(this.facade == null)
			{
				throw new Error("facade is null,please call init!");
			}
			else
			{
				return;
			}
		}
		
		public function checkModelInit(param1:String) : Boolean
		{
			if(this.facade == null)
			{
				throw new Error("facade is null,please call init!");
			}
			else
			{
				return this.facade.hasProxy(param1);
			}
		}
		
		public function checkViewInit(param1:String) : Boolean
		{
			if(this.facade == null)
			{
				throw new Error("facade is null,please call init!");
			}
			else
			{
				return this.facade.hasMediator(param1);
			}
		}
	}
}
