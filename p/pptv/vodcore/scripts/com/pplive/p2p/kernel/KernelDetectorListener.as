package com.pplive.p2p.kernel
{
	public interface KernelDetectorListener
	{
		
		function reportKernelStatus(param1:Boolean, param2:int, param3:KernelDescription = null) : void;
	}
}
