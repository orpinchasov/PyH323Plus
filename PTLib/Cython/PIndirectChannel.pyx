include "ptlib.pxi"

cimport cpython.ref as cpy_ref

from c_PIndirectChannel cimport c_PIndirectChannel, memcpy

cdef class PIndirectChannel:
    """This is a channel that operates indirectly through another channel(s). This
    allows for a protocol to operate through a "channel" mechanism and for its
    low level byte exchange (Read and Write) to operate via a completely
    different channel, eg TCP or Serial port etc.
    """

    def __init__(self):
        """Create a new indirect channel without any channels to redirect to."""

        self.thisptr = new c_PIndirectChannel(<cpy_ref.PyObject*>self)

    def __dealloc__(self):
        """Close the indirect channel."""

        if self.thisptr:
            del self.thisptr

cdef public api PBoolean cy_call_Close(object self,
                                       bint *error) with gil:
    """Close the channel."""

    try:
        func = getattr(self, "Close")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func()

cdef public api PBoolean cy_call_IsOpen(object self,
                                        bint *error) with gil:
    """Determine if the channel is currently open and read
    and write operations can be executed on it.
    """

    try:
        func = getattr(self, "IsOpen")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func()

cdef public api PBoolean cy_call_Read(object self,
                                      bint *error,
                                      void *buf,
                                      PINDEX length) with gil:
    """Low level read from the channel. This function may block until the
    requested number of characters were read or the read timeout was
    reached.
    """

    cdef char * buffer
    cdef int rc

    try:
        func = getattr(self, "Read")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        # "func" should return a boolean success code
        # and the read buffer
        result = func(<char *>buf, length)
        rc = result[0]
        buffer = <char *>result[1]
        # It's important here to use the Python
        # object's length (result[1]) rather
        # than the C object's length (buffer)
        # which obviously doesn't work
        memcpy(buf, buffer, len(result[1]))
        return rc

cdef public api PINDEX cy_call_GetLastReadCount(object self,
                                                bint *error) with gil:
    """Get the number of bytes read by the last Read() call."""

    try:
        func = getattr(self, "GetLastReadCount")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func()

cdef public api PBoolean cy_call_Write(object self,
                                       bint *error,
                                       const void *buf,
                                       PINDEX length) with gil:
    """Low level write to the channel. This function will block until the
    requested number of characters are written or the write timeout is
    reached.
    """

    try:
        func = getattr(self, "Write")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        # Create a Pythonic buffer from the given data
        # one character at a time
        buffer = ""
        for i in xrange(length):
            buffer += chr((<unsigned char *>buf)[i])

        return func(buffer, length)