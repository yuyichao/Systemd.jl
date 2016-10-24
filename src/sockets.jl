#

# Linux specific

module AF
"Unspecified."
const UNSPEC = 0
"Local to host (pipes and file-domain)."
const LOCAL = 1
"POSIX name for `AF.LOCAL`."
const UNIX = LOCAL
"Another non-standard name for `AF.LOCAL`."
const FILE = LOCAL
"IP protocol family."
const INET = 2
"Amateur Radio AX.25."
const AX25 = 3
"Novell Internet Protocol."
const IPX = 4
"Appletalk DDP."
const APPLETALK = 5
"Amateur radio NetROM."
const NETROM = 6
"Multiprotocol bridge."
const BRIDGE = 7
"ATM PVCs."
const ATMPVC = 8
"Reserved for X.25 project."
const X25 = 9
"IP version 6."
const INET6 = 10
"Amateur Radio X.25 PLP."
const ROSE = 11
"Reserved for DECnet project."
const DECnet = 12
"Reserved for 802.2LLC project."
const NETBEUI = 13
"Security callback pseudo AF."
const SECURITY = 14
"PF_KEY key management API."
const KEY = 15
const NETLINK = 16
"Alias to emulate 4.4BSD."
const ROUTE = NETLINK
"Packet family."
const PACKET = 17
"Ash."
const ASH = 18
"Acorn Econet."
const ECONET = 19
"ATM SVCs."
const ATMSVC = 20
"RDS sockets."
const RDS = 21
"Linux SNA Project"
const SNA = 22
"IRDA sockets."
const IRDA = 23
"PPPoX sockets."
const PPPOX = 24
"Wanpipe API sockets."
const WANPIPE = 25
"Linux LLC."
const LLC = 26
"Native InfiniBand address."
const IB = 27
"MPLS."
const MPLS = 28
"Controller Area Network."
const CAN = 29
"TIPC sockets."
const TIPC = 30
"Bluetooth sockets."
const BLUETOOTH = 31
"IUCV sockets."
const IUCV = 32
"RxRPC sockets."
const RXRPC = 33
"mISDN sockets."
const ISDN = 34
"Phonet sockets."
const PHONET = 35
"IEEE 802.15.4 sockets."
const IEEE802154 = 36
"CAIF sockets."
const CAIF = 37
"Algorithm sockets."
const ALG = 38
"NFC sockets."
const NFC = 39
"vSockets."
const VSOCK = 40
"Kernel Connection Multiplexor."
const KCM = 41
"For now.."
const MAX = 42
end

const PF = AF

module SOCK
"Sequenced, reliable, connection-based byte streams."
const STREAM = 1
"Connectionless, unreliable datagrams of fixed maximum length."
const DGRAM = 2
"Raw protocol interface."
const RAW = 3
"Reliably-delivered messages."
const RDM = 4
"Sequenced, reliable, connection-based, datagrams of fixed maximum length."
const SEQPACKET = 5
"Datagram Congestion Control Protocol."
const DCCP = 6
"""
Linux specific way of getting packets at the dev level.
For writing rarp and other similar things on the user level.
"""
const PACKET = 10
# Flags to be ORed into the type parameter of socket and socketpair and
# used for the flags parameter of paccept.
"Atomically set close-on-exec flag for the new descriptor(s)."
const CLOEXEC = 0o2000000
"Atomically mark descriptor(s) as non-blocking."
const NONBLOCK = 0o0004000
end
