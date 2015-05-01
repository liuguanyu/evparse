package ebing.events {
	import flash.events.Event;
	
	public class SliderEventUtil extends Event {
		
		public function SliderEventUtil(param1:String) {
			super(param1);
		}
		
		public static const SLIDER_RATE:String = "slider_rate";
		
		public static const SLIDE_START:String = "slide_start";
		
		public static const SLIDE_END:String = "slide_end";
		
		public static const SLIDER_PREVIEW_RATE:String = "slide_preview_rate";
		
		private var K102606415927350AE742B492D4F1A00305E667373569K:Object;
		
		public function set obj(param1:Object) : void {
			this.K102606415927350AE742B492D4F1A00305E667373569K = param1;
		}
		
		public function get obj() : Object {
			return this.K102606415927350AE742B492D4F1A00305E667373569K;
		}
	}
}
