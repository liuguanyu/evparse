package com.qiyi.player.core.player {
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class LoadMovieParams extends Object {
		
		public function LoadMovieParams() {
			this.autoDefinitionlimit = DefinitionEnum.HIGH;
			super();
		}
		
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
		
		public function clone() : LoadMovieParams {
			var _loc1_:LoadMovieParams = new LoadMovieParams();
			_loc1_.tvid = this.tvid;
			_loc1_.vid = this.vid;
			_loc1_.albumId = this.albumId;
			_loc1_.startTime = this.startTime;
			_loc1_.endTime = this.endTime;
			_loc1_.prepareToPlayEnd = this.prepareToPlayEnd;
			_loc1_.prepareToSkipPoint = this.prepareToSkipPoint;
			_loc1_.cacheServerIP = this.cacheServerIP;
			_loc1_.vrsDomain = this.vrsDomain;
			_loc1_.communicationId = this.communicationId;
			_loc1_.movieIsMember = this.movieIsMember;
			_loc1_.recordHistory = this.recordHistory;
			_loc1_.useHistory = this.useHistory;
			_loc1_.tg = this.tg;
			_loc1_.autoDefinitionlimit = this.autoDefinitionlimit;
			_loc1_.collectionID = this.collectionID;
			return _loc1_;
		}
	}
}
