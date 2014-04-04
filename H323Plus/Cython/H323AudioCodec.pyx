include "ptlib.pxi"

from c_H323AudioCodec cimport c_H323AudioCodec

from PIndirectChannel cimport PIndirectChannel

cdef class H323AudioCodec:
    """Implements a specific codec instance used to transfer data
    via the logical channels opened and managed by the
    H323 control channel.
    """

    def __dealloc__(self):
        """Destroy the codec."""

        if self.thisptr and not self._is_cast:
            del self.thisptr

    def AttachChannel(self, channel, autoDelete=True):
        """Attach the raw data channel for use by codec.
        The channel connects the codec (audio or video) with hardware
        to read/write data.

        NOTE: autoDelete should not be used because
        of Python/C++ interference
        """

        return self.thisptr.AttachChannel((<PIndirectChannel>channel).thisptr, autoDelete)

cdef class cast_H323AudioCodec(H323AudioCodec):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef H323AudioCodec cast_to_H323AudioCodec(c_H323AudioCodec *c):
    result = cast_H323AudioCodec()
    result.thisptr = c
    return result