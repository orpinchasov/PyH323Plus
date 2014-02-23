include "ptlib.pxi"

from c_H323AudioCodec cimport c_H323AudioCodec

from PIndirectChannel cimport PIndirectChannel

cdef class H323AudioCodec:
    def __init__(self):
        self._is_cast = False

    def __dealloc__(self):
       if self.thisptr and not self._is_cast:
           del self.thisptr

    def AttachChannel(self, channel, autoDelete=True):
        return self.thisptr.AttachChannel((<PIndirectChannel>channel).thisptr, autoDelete)

cdef class cast_H323AudioCodec(H323AudioCodec):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef H323AudioCodec cast_to_H323AudioCodec(c_H323AudioCodec *c):
    result = cast_H323AudioCodec()
    result.thisptr = c
    return result