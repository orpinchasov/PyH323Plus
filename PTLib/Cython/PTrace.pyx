# Tracing module for PTLib applications

from c_PTrace cimport c_PTrace_Initialise, c_Timestamp, c_Thread, c_Blocks

def Initialise(logging_level, logging_path=None, flags=c_Timestamp | c_Thread | c_Blocks):
    if logging_path is None:
        c_PTrace_Initialise(logging_level, NULL, flags)
    else:
        c_PTrace_Initialise(logging_level, <const char *>logging_path, flags)
