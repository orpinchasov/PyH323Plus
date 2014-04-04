include "ptlib.pxi"

from c_H323ListenerTCP cimport c_H323ListenerTCP
from H323EndPoint cimport H323EndPoint
from Address cimport Address

cdef class H323ListenerTCP:
    """This class manages H323 connections using TCP/IP transport."""

    def __init__(self, endpoint, binding, port, exclusive=False):
        """Create a new listener for the TCP/IP protocol."""

        self.thisptr = new c_H323ListenerTCP(((<H323EndPoint>endpoint).thisptr)[0], ((<Address>binding).thisptr)[0], port, exclusive)

    # Don't use a __dealloc__ method here since the
    # object shouldn't be deleted when no more references
    # to it remain. It should continue to run in a
    # background thread