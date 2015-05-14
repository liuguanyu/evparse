package com.qiyi.player.wonder.common.vo
{
	import com.qiyi.player.user.UserDef;
	
	public class UserInfoVO extends Object
	{
		
		public var isLogin:Boolean = false;
		
		public var passportID:String = "";
		
		public var userID:String = "";
		
		public var userName:String = "";
		
		public var userLevel:int;
		
		public var userType:int;
		
		public function UserInfoVO()
		{
			this.userLevel = UserDef.USER_LEVEL_NORMAL;
			this.userType = UserDef.USER_TYPE_QIYI;
			super();
		}
	}
}
