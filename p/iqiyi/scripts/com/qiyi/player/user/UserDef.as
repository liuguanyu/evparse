package com.qiyi.player.user {
	public class UserDef extends Object {
		
		public function UserDef() {
			super();
		}
		
		private static var userTypeBegin:int = 1;
		
		public static const USER_TYPE_BEGIN:int = userTypeBegin;
		
		public static const USER_TYPE_QIYI:int = userTypeBegin;
		
		public static const USER_TYPE_END:int = ++userTypeBegin;
		
		public static const USER_TYPE_COUNT:int = USER_TYPE_END - USER_TYPE_BEGIN;
		
		private static var userLevelBegin:int = 0;
		
		public static const USER_LEVEL_BEGIN:int = userLevelBegin;
		
		public static const USER_LEVEL_NORMAL:int = userLevelBegin;
		
		public static const USER_LEVEL_PRIMARY:int = ++userLevelBegin;
		
		public static const USER_LEVEL_END:int = ++userLevelBegin;
		
		public static const USER_LEVEL_COUNT:int = USER_LEVEL_END - USER_LEVEL_BEGIN;
		
		private static var userSexBegin:int = 0;
		
		public static const USER_SEX_BEGIN:int = userSexBegin;
		
		public static const USER_SEX_NONE:int = userSexBegin;
		
		public static const USER_SEX_MALE:int = ++userSexBegin;
		
		public static const USER_SEX_FEMALE:int = ++userSexBegin;
		
		public static const USER_SEX_END:int = ++userSexBegin;
		
		public static const USER_SEX_COUNT:int = USER_SEX_END - USER_SEX_BEGIN;
		
		private static var userLimitationBegin:int = 0;
		
		public static const USER_LIMITATION_BEGIN:int = userLimitationBegin;
		
		public static const USER_LIMITATION_NONE:int = userLimitationBegin;
		
		public static const USER_LIMITATION_UPPER:int = ++userLimitationBegin;
		
		public static const USER_LIMITATION_CLOSING:int = ++userLimitationBegin;
		
		public static const USER_LIMITATION_END:int = ++userLimitationBegin;
		
		public static const USER_LIMITATION_COUNT:int = USER_LIMITATION_END - USER_LIMITATION_BEGIN;
		
		private static var userLocalSexStateBegin:int = 0;
		
		public static const USER_LOCAL_SEX_STATE_BEGIN:int = userLocalSexStateBegin;
		
		public static const USER_LOCAL_SEX_STATE_NONE:int = userLocalSexStateBegin;
		
		public static const USER_LOCAL_SEX_STATE_LOADING:int = ++userLocalSexStateBegin;
		
		public static const USER_LOCAL_SEX_STATE_COMPLETE:int = ++userLocalSexStateBegin;
		
		public static const USER_LOCAL_SEX_STATE_END:int = ++userLocalSexStateBegin;
		
		public static const USER_LOCAL_SEX_STATE_COUNT:int = USER_LOCAL_SEX_STATE_END - USER_LOCAL_SEX_STATE_BEGIN;
	}
}
