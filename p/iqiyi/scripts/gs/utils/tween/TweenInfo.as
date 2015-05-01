package gs.utils.tween {
	public class TweenInfo extends Object {
		
		public function TweenInfo(param1:Object, param2:String, param3:Number, param4:Number, param5:String, param6:Boolean) {
			super();
			this.target = param1;
			this.property = param2;
			this.start = param3;
			this.change = param4;
			this.name = param5;
			this.isPlugin = param6;
		}
		
		public var start:Number;
		
		public var name:String;
		
		public var change:Number;
		
		public var target:Object;
		
		public var property:String;
		
		public var isPlugin:Boolean;
	}
}
