include "ptlib.pxi"

from c_H323AudioCodec cimport c_H323AudioCodec

cdef class H323AudioCodec:
    cdef c_H323AudioCodec *thisptr
    cdef bool _is_cast

cdef H323AudioCodec cast_to_H323AudioCodec(c_H323AudioCodec *c)