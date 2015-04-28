# -*- coding: utf-8 -*-
# flash.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# flash: support some flash functions (action script 3) in python3. 
# version 0.0.1.0 test201504282146
# author sceext <sceext@foxmail.com> 2009EisF2015, 2015.04. 
# copyright 2015 sceext
#
# This is FREE SOFTWARE, released under GNU GPLv3+ 
# please see README.md and LICENSE for more information. 
#
#    evparse : EisF Video Parse, evdh Video Parse. 
#    Copyright (C) 2015 sceext <sceext@foxmail.com> 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# import

import time

# global vars
_GET_TIMER_START_MS = 0

# functions

def _get_ms():
    return int(round(time.time() * 1e3))

def getTimer(start=0):
    _GET_TIMER_START_MS -= start
    return (_get_ms - _GET_TIMER_START_MS)

# init

# init for getTimer()
_GET_TIMER_START_MS = _get_ms()

# end flash.py


