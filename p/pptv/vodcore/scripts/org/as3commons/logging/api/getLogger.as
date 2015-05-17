package org.as3commons.logging.api
{
	public function getLogger(param1:* = null, param2:String = null) : ILogger
	{
		if((param1) && !(param1 is String))
		{
			var param1:* = toLogName(param1);
		}
		return LOGGER_FACTORY.getNamedLogger(param1,param2);
	}
}
