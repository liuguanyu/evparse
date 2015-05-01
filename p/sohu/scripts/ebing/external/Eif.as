package ebing.external {
	import flash.external.ExternalInterface;
	
	public class Eif extends Object {
		
		public function Eif() {
			super();
		}
		
		private static var K1026062E4518109D9049C2B9268ABC9D766011373569K:Boolean;
		
		private static var K102606659EE8BF4DE248C2A0D5F08B940201D4373569K:Boolean = false;
		
		public static function get available() : Boolean {
			if(!K102606659EE8BF4DE248C2A0D5F08B940201D4373569K) {
				K102606659EE8BF4DE248C2A0D5F08B940201D4373569K = true;
				try {
					K1026062E4518109D9049C2B9268ABC9D766011373569K = ExternalInterface.call("eval","document.URL") == null?false:true;
				}
				catch(evt:SecurityError) {
					K1026062E4518109D9049C2B9268ABC9D766011373569K = false;
				}
			}
			if(!K102606659EE8BF4DE248C2A0D5F08B940201D4373569K) {
				return K1026062E4518109D9049C2B9268ABC9D766011373569K;
			}
			return K1026062E4518109D9049C2B9268ABC9D766011373569K;
		}
	}
}
