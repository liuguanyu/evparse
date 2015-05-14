package com.qiyi.player.core.player
{
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class LoadMovieParams extends Object
	{
		
		public var tvid:String;
		
		public var vid:String;
		
		public var albumId:String;
		
		public var startTime:int = -1;
		
		public var endTime:int = -1;
		
		public var prepareToPlayEnd:int = -1;
		
		public var prepareToSkipPoint:int = -1;
		
		public var prepareLeaveSkipPoint:int = -1;
		
		public var cacheServerIP:String = "";
		
		public var vrsDomain:String = "";
		
		public var communicationId:String = "afbe8fd3d73448c9";
		
		public var movieIsMember:Boolean = false;
		
		public var recordHistory:Boolean = true;
		
		public var useHistory:Boolean = true;
		
		public var tg:String = "";
		
		public var autoDefinitionlimit:EnumItem;
		
		public var collectionID:String = "";
		
		public function LoadMovieParams()
		{
			this.autoDefinitionlimit = DefinitionEnum.HIGH;
			super();
		}
		
		public function clone() : LoadMovieParams
		{
			var _loc1:LoadMovieParams = new LoadMovieParams();
			_loc1.tvid = this.tvid;
			_loc1.vid = this.vid;
			_loc1.albumId = this.albumId;
			_loc1.startTime = this.startTime;
			_loc1.endTime = this.endTime;
			_loc1.prepareToPlayEnd = this.prepareToPlayEnd;
			_loc1.prepareToSkipPoint = this.prepareToSkipPoint;
			_loc1.cacheServerIP = this.cacheServerIP;
			_loc1.vrsDomain = this.vrsDomain;
			_loc1.communicationId = this.communicationId;
			_loc1.movieIsMember = this.movieIsMember;
			_loc1.recordHistory = this.recordHistory;
			_loc1.useHistory = this.useHistory;
			_loc1.tg = this.tg;
			_loc1.autoDefinitionlimit = this.autoDefinitionlimit;
			_loc1.collectionID = this.collectionID;
			return _loc1;
		}
	}
}
