# -*- coding: utf-8 -*-
# uint.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse: lib/flash/uint, support flash uint() (action script 3) in python3. 
# version 0.0.6.0 test201505102228
# author sceext <sceext@foxmail.com> 2009EisF2015, 2015.05. 
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

# functions

# convert data to uint format
def uint(num):
    n = int(num)	# int is of 4 bytes
    b = None
    out = None
    try:	# fix for overflow, may not be right
        b = n.to_bytes(4, 'little', signed=True)
    except OverflowError as err:
        try:
            b = n.to_bytes(8, 'little', signed=True)
        except OverflowError as err2:
            # print('DEBUG: flash.uint() 8 Bytes failed')
            try:
                b = n.to_bytes(16, 'little', signed=True)
            except OverflowError as err3:
                print('DEBUG: flash.uint() 16 Bytes failed')
                try:
                    b = n.to_bytes(32, 'little', signed=True)
                except OverflowError as err4:
                    print('DEBUG: flash.uint() 32 Bytes failed')
                    try:
                        b = n.to_bytes(64, 'little', signed=True)
                    except OverflowError as err5:
                        print('DEBUG: flash.uint() 64 Bytes failed')
                        b = n.to_bytes(128, 'little', signed=True)
    finally:
        out = int.from_bytes(b[:4], 'little', signed=False)
    return out

# end uint.py


