from c_H323ListenerTCP cimport c_H323ListenerTCP

cdef class H323ListenerTCP:
    cdef c_H323ListenerTCP *thisptr
