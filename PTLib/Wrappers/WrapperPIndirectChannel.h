#ifndef WRAPPERPINDIRECTCHANNEL_H
#define WRAPPERPINDIRECTCHANNEL_H

#include <Python.h>

#include <ptlib.h>

class WrapperPIndirectChannel : public PIndirectChannel {
public:
    PyObject *m_obj;

    WrapperPIndirectChannel(PyObject *obj);
    ~WrapperPIndirectChannel();

    virtual PBoolean Close();
    virtual PBoolean IsOpen() const;
    virtual PBoolean Read(void *buf, PINDEX len);
    virtual PINDEX GetLastReadCount() const;
    virtual PBoolean Write(const void *buf, PINDEX len);
};

#endif /* WRAPPERPINDIRECTCHANNEL_H */