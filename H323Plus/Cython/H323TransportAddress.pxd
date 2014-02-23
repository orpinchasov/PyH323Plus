from c_H323TransportAddress cimport c_H323TransportAddress

cdef class H323TransportAddress:
    cdef c_H323TransportAddress *thisptr