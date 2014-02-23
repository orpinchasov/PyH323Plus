include "ptlib.pxi"

from c_PIndirectChannel cimport c_PIndirectChannel

cdef extern from "codecs.h":
    cdef cppclass c_H323AudioCodec "H323AudioCodec":
        # The actual object used as the first argument is
        # PChannel. PIndirectChannel is a descendent class
        # used in our program
        PBoolean AttachChannel(c_PIndirectChannel * channel, PBoolean autoDelete)