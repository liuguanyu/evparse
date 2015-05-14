package com.qiyi.player.components
{
	import flash.utils.*;
	import flash.events.*;
	import adobe.utils.*;
	import flash.accessibility.*;
	import flash.desktop.*;
	import flash.display.*;
	import flash.errors.*;
	import flash.external.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.globalization.*;
	import flash.media.*;
	import flash.net.*;
	import flash.net.drm.*;
	import flash.printing.*;
	import flash.profiler.*;
	import flash.sampler.*;
	import flash.sensors.*;
	import flash.system.*;
	import flash.text.*;
	import flash.text.ime.*;
	import flash.text.engine.*;
	import flash.ui.*;
	import flash.xml.*;
	import gs.easing.*;
	import gs.TweenLite;
	
	public dynamic class DefaultLogo extends MovieClip
	{
		
		public var logo0:MovieClip;
		
		public var logo1:MovieClip;
		
		public var logo2:MovieClip;
		
		public var initLogo:int;
		
		public var fromLogo:int;
		
		public var timeOut:uint;
		
		public var logoArray:Array;
		
		public var timeLength:Array;
		
		public var i:Number;
		
		public var logoName:String;
		
		public function DefaultLogo()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		public function switchToNext() : void
		{
			clearTimeout(this.timeOut);
			if(this.initLogo == 2)
			{
				this.initLogo = 0;
				this.fromLogo = 2;
			}
			else
			{
				this.fromLogo = this.initLogo;
				this.initLogo++;
			}
			this.dispatchEvent(new Event("qiyi_logo_changed"));
			this.switchLogo(this["logo" + this.fromLogo],this["logo" + this.initLogo]);
		}
		
		public function switchLogo(param1:Sprite, param2:Sprite) : void
		{
			var logo1:Sprite = param1;
			var logo2:Sprite = param2;
			if(!(logo1 == null) || !(logo2 == null))
			{
				try
				{
					TweenLite.to(logo1,1,{
						"delay":0,
						"alpha":0,
						"ease":Linear.easeOut
					});
					TweenLite.to(logo2,1,{
						"delay":0,
						"alpha":1,
						"ease":Linear.easeOut,
						"onComplete":this.onComplete
					});
				}
				catch(e:Error)
				{
					trace("error");
				}
			}
		}
		
		public function onComplete() : void
		{
			this.timeOut = setTimeout(this.switchToNext,this.timeLength[this.initLogo]);
		}
		
		function frame1() : *
		{
			this.initLogo = 0;
			this.fromLogo = 2;
			this.timeOut = 0;
			this.logoArray = new Array("logo0","logo1","logo2");
			this.timeLength = new Array(180000,120000,60000);
			this.i = 0;
			while(this.i < this.logoArray.length)
			{
				this.logoName = this.logoArray[this.i];
				this[this.logoName].alpha = 0;
				this.i++;
			}
			this.logo0.alpha = 1;
			this.timeOut = setTimeout(this.switchToNext,this.timeLength[this.initLogo]);
		}
	}
}
