package com.qiyi.player.wonder.common.utils
{
	public class ConstUtils extends Object
	{
		
		public static const S_2_MS:uint = 1000;
		
		public static const MIN_2_S:uint = 60;
		
		public static const H_2_MIN:uint = 60;
		
		public static const D_2_H:uint = 24;
		
		public static const MIN_2_MS:uint = MIN_2_S * S_2_MS;
		
		public static const H_2_MS:uint = H_2_MIN * MIN_2_MS;
		
		public static const D_2_MS:uint = D_2_H * H_2_MS;
		
		public static const H_2_S:uint = H_2_MIN * MIN_2_S;
		
		public static const D_2_S:uint = D_2_H * H_2_S;
		
		public static const D_2_MIN:uint = D_2_H * H_2_MIN;
		
		public function ConstUtils()
		{
			super();
		}
	}
}
