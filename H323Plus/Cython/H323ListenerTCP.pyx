include "ptlib.pxi"

from c_H323ListenerTCP cimport c_H323ListenerTCP
from H323EndPoint cimport H323EndPoint
from Address cimport Address

cdef class H323ListenerTCP:
    def __init__(self, endpoint, binding, port, exclusive=False):
        self.thisptr = new c_H323ListenerTCP(((<H323EndPoint>endpoint).thisptr)[0], ((<Address>binding).thisptr)[0], port, exclusive)