include "ptlib.pxi"

cdef extern from "h323pdu.h":
    cdef cppclass c_H323SignalPDU "H323SignalPDU":
        c_H323SignalPDU()