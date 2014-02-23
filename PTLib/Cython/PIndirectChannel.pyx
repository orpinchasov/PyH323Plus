include "ptlib.pxi"

cimport cpython.ref as cpy_ref

from c_PIndirectChannel cimport c_PIndirectChannel, memcpy

cdef class PIndirectChannel:
    def __init__(self):
        self.thisptr = new c_PIndirectChannel(<cpy_ref.PyObject*>self)

    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr

cdef public api PBoolean cy_call_Close(object self,
                                       bint *error) with gil:
    try:
        func = getattr(self, "Close")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func()

cdef public api PBoolean cy_call_IsOpen(object self,
                                        bint *error) with gil:
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
    cdef char * buffer
    cdef int rc

    try:
        func = getattr(self, "Read")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

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
    try:
        func = getattr(self, "Write")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        buffer = ""
        for i in xrange(length):
            buffer += chr((<unsigned char *>buf)[i])

        return func(buffer, length)