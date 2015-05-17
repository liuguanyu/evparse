package com.pplive.p2p.struct
{
	import com.pplive.p2p.BootStrapConfig;
	
	public class PeerInfo extends Object
	{
		
		private var _version:uint;
		
		protected var _id:String;
		
		private var _uploadPriority:uint;
		
		private var _trackerPriority:uint;
		
		private var _priority:uint;
		
		public function PeerInfo(param1:uint, param2:String, param3:uint, param4:uint)
		{
			super();
			this._version = param1;
			this._id = param2;
			this._uploadPriority = param3;
			this._trackerPriority = param4;
			this._priority = BootStrapConfig.PEER_PRIORITY == "tracker"?this._trackerPriority:this._uploadPriority;
		}
		
		public function get version() : uint
		{
			return this._version;
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function get uploadPriority() : uint
		{
			return this._uploadPriority;
		}
		
		public function get trackerPriority() : uint
		{
			return this._trackerPriority;
		}
		
		public function get priority() : uint
		{
			return this._priority;
		}
		
		public function update(param1:PeerInfo) : void
		{
			this._uploadPriority = param1.uploadPriority;
			this._trackerPriority = param1.trackerPriority;
			this._priority = BootStrapConfig.PEER_PRIORITY == "tracker"?this._trackerPriority:this._uploadPriority;
		}
		
		public function toString() : String
		{
			return "";
		}
	}
}
