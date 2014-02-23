include "ptlib.pxi"

cdef extern from "ptlib/object.h":
    cdef enum c_Options "PTrace::Options":
        c_Blocks "PTrace::Blocks" = 1
        c_DateAndTime "PTrace::DateAndTime" = 2,
        c_Timestamp "PTrace::Timestamp" = 4,
        c_Thread "PTrace::Thread" = 8,
        c_TraceLevel "PTrace::TraceLevel" = 16,
        c_FileAndLine "PTrace::FileAndLine" = 32,
        c_ThreadAddress "PTrace::ThreadAddress" = 64,
        c_AppendToFile "PTrace::AppendToFile" = 128,
        c_GMTTime "PTrace::GMTTime" = 256,
        c_RotateDaily "PTrace::RotateDaily" = 512,
        c_RotateHourly "PTrace::RotateHourly" = 1024,
        c_RotateMinutely "PTrace::RotateMinutely" = 2048,
        c_RotateLogMask "PTrace::RotateLogMask" = c_RotateDaily + c_RotateHourly + c_RotateMinutely,
        c_SystemLogStream "PTrace::SystemLogStream" = 32768

    void c_PTrace_Initialise "PTrace::Initialise"(unsigned level, const char * filename, unsigned options)
