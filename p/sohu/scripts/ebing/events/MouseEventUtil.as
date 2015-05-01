package ebing.events {
	import flash.events.MouseEvent;
	
	public class MouseEventUtil extends MouseEvent {
		
		public function MouseEventUtil(param1:String) {
			super(param1);
		}
		
		public static const MOUSE_STATUS:String = "mouse_status";
		
		public static const MOUSE_UP:String = "mouse_up";
		
		public static const MOUSE_OVER:String = "mouse_over";
		
		public static const MOUSE_DOWN:String = "mouse_down";
		
		public static const MOUSE_OUT:String = "mouse_out";
		
		public static const DOUBLE_CLICK:String = "double_click";
		
		public static const CLICK:String = "click_hjh";
		
		public static const MOUSE_MOVE:String = "mouse_move";
		
		public static const DRAG_OVER:String = "drag_over";
		
		public static const DRAG_OUT:String = "drag_out";
		
		public static const RELEASE_OUTSIDE:String = "down_outside";
		
		private var K102606415927350AE742B492D4F1A00305E667373569K:Object;
		
		public function set obj(param1:Object) : void {
			this.K102606415927350AE742B492D4F1A00305E667373569K = param1;
		}
		
		public function get obj() : Object {
			return this.K102606415927350AE742B492D4F1A00305E667373569K;
		}
	}
}
