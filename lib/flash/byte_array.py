# -*- coding: utf-8 -*-
# byte_array.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse: lib/flash/byte_array, support flash ByteArray class (action script 3) in python3. 
# version 0.0.5.0 test201505102223
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

import base64

# class

class ByteArray(object):
    
    def __init__(self):
        self._data = bytearray()
        self.position = 0
    
    def __len__(self):
        return len(self._data)
    
    def __str__(self):
        return str(self._data)
    
    def __repr__(self):
        return repr(self._data)
    
    def __getitem__(self, n):
        b = self._data[n:n + 1]
        # make byte
        return int.from_bytes(b, 'little', signed=True)
    
    @property
    def bytesAvailable(self):
        return (len(self._data) - self.position)
    
    def writeUTFBytes(self, string):
        # create bytearray
        b = bytearray(string, 'utf-8')
        # just set and update data
        i = self.position
        self._data[i : i + len(b)] = b
        # increase position
        self.position += len(b)
    
    def writeByte(self, num):
        # make byte
        n = int(num)
        b = n.to_bytes(4, 'little')[:1]
        # set it
        i = self.position
        self._data[i: i + 1] = b
        self.position += 1
    
    def readByte(self):
        # get byte
        i = self.position
        b = self._data[i:i + 1]
        self.position += 1
        # make byte
        return int.from_bytes(b, 'little', signed=True)
    
    def clear(self):
        self._data = bytearray()
        self.position = 0
    
    # NOTE add by me, not a method of flash ByteArray
    def encode_base64(self):
        return base64.b64encode(self._data)
    # end ByteArray

# end byte_array.py


