include "ptlib.pxi"

from c_PProcess cimport c_PProcess_GetOSName

def GetOSName():
    return <const unsigned char *>c_PProcess_GetOSName()