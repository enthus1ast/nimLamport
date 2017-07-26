## The Lamport timestamp/clock

type 
  Lamport* = int32
 
proc newLamport*(initialValue: int32 = 0): Lamport = 
  result = initialValue

proc send*(lamport: var Lamport) = 
  try:
    lamport.inc 1
  except OverflowError:
    # in case of an overflow set to zero
    lamport = 0


proc recv*(lamport: var Lamport, remoteTimestampt: int = 0)=
  try:
    lamport = max(lamport, remoteTimestampt) + 1
  except OverflowError: 
    lamport = 0


when isMainModule:
  var timestamp = newLamport()
  var remoteTimestamp = newLamport(23) # remote runs for a time
  timestamp.recv()
  remoteTimestamp.recv()

  timestamp.recv()
  remoteTimestamp.recv()

  timestamp.recv(remoteTimestamp)
  remoteTimestamp.send()

  timestamp.recv(5)
  timestamp.recv(5)
  timestamp.recv()
  timestamp.recv()
  timestamp.recv()
  assert timestamp == 31

  remoteTimestamp.recv(timestamp)
  assert remoteTimestamp == 32
