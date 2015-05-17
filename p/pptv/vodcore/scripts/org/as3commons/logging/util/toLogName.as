package org.as3commons.logging.util
{
	public function toLogName(param1:* = null) : String
	{
		if(param1 == null)
		{
			return param1;
		}
		return getQualifiedClassName(param1).replace("::",".");
	}
}
