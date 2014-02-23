include "ptlib.pxi"

cdef extern from "transports.h":
    cdef cppclass c_H323TransportAddress "H323TransportAddress":
        c_H323TransportAddress()
        c_H323TransportAddress(const char *)
        