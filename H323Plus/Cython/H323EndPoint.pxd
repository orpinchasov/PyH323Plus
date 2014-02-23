from c_H323EndPoint cimport c_H323EndPoint

cdef class H323EndPoint:
    cdef c_H323EndPoint *thisptr