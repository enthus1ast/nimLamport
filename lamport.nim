## The Lamport timestamp/clock

type 
  Lamport = int
 
proc newLamport*(initialValue: int = 0): Lamport = 
  result = initialValue

proc send*(lamport: var Lamport) = 
  lamport.inc 1

proc recv*(lamport: var Lamport, remoteTimestampt: int = 0)=
  lamport = max(lamport, remoteTimestampt) + 1


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