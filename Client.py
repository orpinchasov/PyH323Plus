import sys
sys.path.append("PTLib/Build")
sys.path.append("H323Plus/Build")

from PLibraryProcess import PLibraryProcess
from Address import Address
from PIndirectChannel import PIndirectChannel

from H323ListenerTCP import H323ListenerTCP
from H323EndPoint import H323EndPoint

from PTrace import Initialise

import wave
import time
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='H323 VoIP Client.')

    parser.add_argument('-o', '--output-file', type=str, default=None,
                        help='output file name')
    parser.add_argument('-f', '--input-file', type=str, default=None,
                        help='input file name')
    parser.add_argument('-i', '--interface', type=str, default='*',
                        help='interface (default \'*\')')
    parser.add_argument('-g', '--gatekeeper', type=str, default=None,
                        help='gatekeeper address')
    parser.add_argument('-u', '--user', type=str, default=None, action='append',
                        help='set local alias name(s)')
    parser.add_argument('-p', '--port', type=int, default=1720,
                        help='listening port (default 1720)')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('-l', '--listen', action='store_true',
                       help='listen for incoming calls')
    group.add_argument('-d', '--destination', type=str, default=None,
                       help='identifier of destination endpoint')

    args = parser.parse_args()
    return args

class WavChannel(PIndirectChannel):
    SAMPLES_PER_SECOND = 8000
    DEFAULT_WAVE_PARAMETERS = (1, 2, SAMPLES_PER_SECOND, 40000, 'NONE', 'not compressed')

    def __init__(self, input_filename=None, output_filename=None):
        super(WavChannel, self).__init__()

        if input_filename:
            self._input_wav = wave.open(input_filename, "rb")
        else:
            self._input_wav = None

        if output_filename:
            self._output_wav = wave.open(output_filename, "wb")
            self._output_wav.setparams(WavChannel.DEFAULT_WAVE_PARAMETERS)
        else:
            self._output_wav = None

        self._read_previous_time = time.time()
        self._write_previous_time = time.time()

    def IsOpen(self):
        return True

    def Close(self):
        if self._input_wav:
            self._input_wav.close()
            self._input_wav = None
        if self._output_wav:
            self._output_wav.close()
            self._output_wav = None

        return True

    def Read(self, buf, length):
        if self._input_wav is not None:
            b = self._input_wav.readframes(length / 2)
        else:
            b = "\x00" * length
        self._last_read_count = length

        while (time.time() < self._read_previous_time +
                (1.0 / (WavChannel.SAMPLES_PER_SECOND / (length / 2)))):
            time.sleep(0)
        self._read_previous_time = time.time()

        return (True, b)

    def GetLastReadCount(self):
        return self._last_read_count

    def Write(self, buf, length):
        if self._output_wav is not None:
            self._output_wav.writeframes(buf)

        while (time.time() < self._write_previous_time +
                (1.0 / (WavChannel.SAMPLES_PER_SECOND / (length / 2)))):
            time.sleep(0)
        self._write_previous_time = time.time()

        return True

class Client(H323EndPoint):
    def __init__(self, input_filename=None, output_filename=None):
        super(Client, self).__init__()

        self._input_filename = input_filename
        self._output_filename = output_filename

    def initialise(self, interface, port, user=None, gatekeeper=None):
        if user is not None:
            self.SetLocalUserName(user[0])
            for name in user[1:]:
                self.AddAliasName(name)

        self.LoadBaseFeatureSet()
        self.AddAllCapabilities(0, 0x7fffffff, '*')
        self.AddAllUserInputCapabilities(0, 0x7fffffff)

        address = Address(interface)
        listener = H323ListenerTCP(self, address, port)
        if not self.StartListener(listener):
            print "Failed to start listener on %s:%d" % (address, port)
            return False

        if gatekeeper is not None:
            if not self.UseGatekeeper(gatekeeper):
                print "Failed to register with gatekeeper at %s" % (gatekeeper,)
                return False

        return True

    def OnIncomingCall(self, connection, setupPDU, alertingPDU):
        print "Incoming call", connection
        return True

    def OnConnectionEstablished(self, connection, token):
        print "Connection established, token =", token

    def OnConnectionCleared(self, connection, token):
        print "Connection cleared, token =", token

    def OpenAudioChannel(self, connection, isEncoding, bufferSize, codec):
        print "Opening audio channel (%s, %s, %d, %s)" % (connection, isEncoding, bufferSize, codec)

        if isEncoding:
            # Send data
            wav_channel = WavChannel(input_filename = self._input_filename)
        else:
            # Receive data
            wav_channel = WavChannel(output_filename = self._output_filename)

        return codec.AttachChannel(wav_channel, autoDelete = False)

def main():
    args = parse_args()

    print args

    client = Client()
    client.initialise(args.interface, args.port, args.user, args.gatekeeper)

    if args.listen:
        print "Waiting for incoming calls for \"%s\"" % (client.GetLocalUserName(),)
    elif args.destination is not None:
        print "Initiating call to \"%s\"" % (args.destination,)
        client.MakeCall(args.destination, None)
    else:
        print "Not enough arguments"

    print "Press any key to quit"
    raw_input()

    client.ClearAllCalls(wait = False)
    # Allow the connection to clear
    time.sleep(1)

if __name__ == '__main__':
    p = PLibraryProcess("", "", 1, 0, 0, 0)

    main()
