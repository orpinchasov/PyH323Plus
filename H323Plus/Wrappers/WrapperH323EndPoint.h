#ifndef WRAPPERH323ENDPOINT_H
#define WRAPPERH323ENDPOINT_H

#include <Python.h>

#include <ptlib.h>
#include <h323.h>

class WrapperH323EndPoint : public H323EndPoint {
public:
    PyObject *m_obj;

    WrapperH323EndPoint(PyObject *obj);
    ~WrapperH323EndPoint();
    
    virtual PBoolean OnIncomingCall(H323Connection &connection,
                                    const H323SignalPDU &setupPDU,
                                    H323SignalPDU &alertingPDU);
    virtual void OnConnectionEstablished(H323Connection &connection,
                                         const PString &token);
    virtual void OnConnectionCleared(H323Connection &connection,
                                     const PString &token);
    virtual PBoolean OpenAudioChannel(H323Connection &connection,
                                      PBoolean isEncoding,
                                      unsigned bufferSize,
                                      H323AudioCodec &codec);
    virtual PBoolean OnStartLogicalChannel(H323Connection &connection,
                                           H323Channel &channel);
};

#endif /* WRAPPERH323ENDPOINT_H */