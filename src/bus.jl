#

module Buses

import ..@sdcall, ..libsystemd, .._get_path, ..ID128_NULL, ..ID128, ..consume_string

const _Type = Base.Type

module Creds
const PID = UInt64(1) << 0
const TID = UInt64(1) << 1
const PPID = UInt64(1) << 2
const UID = UInt64(1) << 3
const EUID = UInt64(1) << 4
const SUID = UInt64(1) << 5
const FSUID = UInt64(1) << 6
const GID = UInt64(1) << 7
const EGID = UInt64(1) << 8
const SGID = UInt64(1) << 9
const FSGID = UInt64(1) << 10
const SUPPLEMENTARY_GIDS = UInt64(1) << 11
const COMM = UInt64(1) << 12
const TID_COMM = UInt64(1) << 13
const EXE = UInt64(1) << 14
const CMDLINE = UInt64(1) << 15
const CGROUP = UInt64(1) << 16
const UNIT = UInt64(1) << 17
const SLICE = UInt64(1) << 18
const USER_UNIT = UInt64(1) << 19
const USER_SLICE = UInt64(1) << 20
const SESSION = UInt64(1) << 21
const OWNER_UID = UInt64(1) << 22
const EFFECTIVE_CAPS = UInt64(1) << 23
const PERMITTED_CAPS = UInt64(1) << 24
const INHERITABLE_CAPS = UInt64(1) << 25
const BOUNDING_CAPS = UInt64(1) << 26
const SELINUX_CONTEXT = UInt64(1) << 27
const AUDIT_SESSION_ID = UInt64(1) << 28
const AUDIT_LOGIN_UID = UInt64(1) << 29
const TTY = UInt64(1) << 30
const UNIQUE_NAME = UInt64(1) << 31
const WELL_KNOWN_NAMES = UInt64(1) << 32
const DESCRIPTION = UInt64(1) << 33
# special flag, if on sd-bus will augment creds struct,
# in a potentially race-full way.
const AUGMENT = UInt64(1) << 63
const ALL = (UInt64(1) << 34) -1
end

module Type
const INVALID = UInt8(0)
const BYTE = UInt8('y')
const BOOLEAN = UInt8('b')
const INT16 = UInt8('n')
const UINT16 = UInt8('q')
const INT32 = UInt8('i')
const UINT32 = UInt8('u')
const INT64 = UInt8('x')
const UINT64 = UInt8('t')
const DOUBLE = UInt8('d')
const STRING = UInt8('s')
const OBJECT_PATH = UInt8('o')
const SIGNATURE = UInt8('g')
const UNIX_FD = UInt8('h')
const ARRAY = UInt8('a')
const VARIANT = UInt8('v')
const STRUCT = UInt8('r') # not actually used in signatures
const STRUCT_BEGIN = UInt8('(')
const STRUCT_END = UInt8(')')
const DICT_ENTRY = UInt8('e') # not actually used in signatures
const DICT_ENTRY_BEGIN = UInt8('{')
const DICT_ENTRY_END = UInt8('}')
end

mutable struct Bus
    ptr::Ptr{Void}
    function Bus()
        self = new()
        @sdcall(sd_bus_new, (Ref{Bus},), bus)
        finalizer(self, unref)
        return self
    end
    function Bus(ptr::Ptr{Void})
        self = new(ptr)
        finalizer(self, unref)
        return self
    end
end

Base.cconvert(::_Type{Ptr{Void}}, bus::Bus) = bus
function Base.unsafe_convert(::_Type{Ptr{Void}}, bus::Bus)
    ptr = bus.ptr
    ptr == C_NULL && throw(UndefRefError())
    ptr
end

function unref(bus::Bus)
    ptr = bus.ptr
    ptr == C_NULL && return
    bus.ptr = C_NULL
    ccall((:sd_bus_unref, libsystemd), Ptr{Void}, (Ptr{Void},), ptr)
    return
end

function default()
    bus = Bus(C_NULL)
    @sdcall(sd_bus_default, (Ref{Bus},), bus)
    return bus
end

function default_user()
    bus = Bus(C_NULL)
    @sdcall(sd_bus_default_user, (Ref{Bus},), bus)
    return bus
end

function default_system()
    bus = Bus(C_NULL)
    @sdcall(sd_bus_default_system, (Ref{Bus},), bus)
    return bus
end

function open()
    bus = Bus(C_NULL)
    @sdcall(sd_bus_open, (Ref{Bus},), bus)
    return bus
end

function open_user()
    bus = Bus(C_NULL)
    @sdcall(sd_bus_open_user, (Ref{Bus},), bus)
    return bus
end

function open_system()
    bus = Bus(C_NULL)
    @sdcall(sd_bus_open_system, (Ref{Bus},), bus)
    return bus
end

function open_system_remote(host)
    bus = Bus(C_NULL)
    @sdcall(sd_bus_open_system_remote, (Ref{Bus}, Cstring), bus, host)
    return bus
end

function open_system_machine(machine)
    bus = Bus(C_NULL)
    @sdcall(sd_bus_open_system_machine, (Ref{Bus}, Cstring), bus, machine)
    return bus
end

function start(bus::Bus)
    @sdcall(sd_bus_start, (Ptr{Void},), bus)
    return
end

function set_address(bus::Bus, address)
    @sdcall(sd_bus_set_address, (Ptr{Void}, Cstring), bus, address)
    return
end
function get_address(bus::Bus)
    address = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_bus_get_address, (Ptr{Void}, Ptr{Ptr{Cchar}}), bus, address)
    return consume_string(address[])
end

function set_fd(bus::Bus, input_fd, output_fd)
    @sdcall(sd_bus_set_fd, (Ptr{Void}, Cint, Cint), bus, input_fd, output_fd)
    return
end

function set_exec(bus::Bus, path, argv)
    @sdcall(sd_bus_set_exec, (Ptr{Void}, Cstring, Ptr{Cstring}),
            bus, path, argv)
    return
end

function set_client(bus::Bus, b::Bool)
    @sdcall(sd_bus_set_bus_client, (Ptr{Void}, Cint), bus, b)
    return
end
is_client(bus::Bus) = @sdcall(sd_bus_is_bus_client, (Ptr{Void},), bus) != 0

function set_server(bus::Bus, b::Bool, bus_id=ID128_NULL)
    @sdcall(sd_bus_set_server, (Ptr{Void}, Cint, ID128), bus, b, bus_id)
    return
end
is_server(bus::Bus) = @sdcall(sd_bus_is_server, (Ptr{Void},), bus) != 0

function set_anonymous(bus::Bus, b::Bool)
    @sdcall(sd_bus_set_anonymous, (Ptr{Void}, Cint), bus, b)
    return
end
is_anonymous(bus::Bus) = @sdcall(sd_bus_is_anonymous, (Ptr{Void},), bus) != 0

function set_trusted(bus::Bus, b::Bool)
    @sdcall(sd_bus_set_trusted, (Ptr{Void}, Cint), bus, b)
    return
end
is_trusted(bus::Bus) = @sdcall(sd_bus_is_trusted, (Ptr{Void},), bus) != 0

function set_monitor(bus::Bus, b::Bool)
    @sdcall(sd_bus_set_monitor, (Ptr{Void}, Cint), bus, b)
    return
end
is_monitor(bus::Bus) = @sdcall(sd_bus_is_monitor, (Ptr{Void},), bus) != 0

function set_description(bus::Bus, desc)
    @sdcall(sd_bus_set_description, (Ptr{Void}, Cstring), bus, desc)
    return
end
function get_description(bus::Bus)
    desc = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_bus_get_description, (Ptr{Void}, Ptr{Ptr{Cchar}}), bus, desc)
    return consume_string(desc[])
end

function negotiate_creds(bus::Bus, b::Bool, mask=UInt64(0))
    @sdcall(sd_bus_negotiate_creds, (Ptr{Void}, Cint, UInt64), bus, b, mask)
    return
end
function negotiate_timestamp(bus::Bus, b::Bool)
    @sdcall(sd_bus_negotiate_timestamp, (Ptr{Void}, Cint), bus, b)
    return
end
function negotiate_fd(bus::Bus, b::Bool)
    @sdcall(sd_bus_negotiate_fd, (Ptr{Void}, Cint), bus, b)
    return
end

can_send(bus::Bus, typ) = @sdcall(sd_bus_can_send, (Ptr{Void}, UInt8),
                                  bus, typ) != 0
function get_creds_mask(bus::Bus, typ)
    mask = Ref{UInt64}(0)
    @sdcall(sd_bus_get_creds_mask, (Ptr{Void}, Ptr{UInt64}),
            bus, mask)
    return mask[]
end

function set_allow_interactive_authorization(bus::Bus, b::Bool)
    @sdcall(sd_bus_set_allow_interactive_authorization, (Ptr{Void}, Cint),
            bus, b)
    return
end
get_allow_interactive_authorization(bus::Bus) =
    @sdcall(sd_bus_get_allow_interactive_authorization, (Ptr{Void},), bus) != 0

function try_close(bus::Bus)
    @sdcall(sd_bus_try_close, (Ptr{Void},), bus)
    return
end
Base.close(bus::Bus) =
    ccall((:sd_bus_close, libsystemd), Void, (Ptr{Void},), bus)

function flush_close_unref(bus::Bus)
    ptr = bus.ptr
    ptr == C_NULL && return
    bus.ptr = C_NULL
    ccall((:sd_bus_flush_close_unref, libsystemd), Ptr{Void}, (Ptr{Void},), bus)
    return
end
default_flush_close() =
    ccall((:sd_bus_default_flush_close, libsystemd), Void, ())

is_open(bus::Bus) = @sdcall(sd_bus_is_open, (Ptr{Void},), bus)

function get_id(bus::Bus)
    id = Ref{ID128}()
    @sdcall(sd_bus_get_bus_id, (Ptr{Void}, Ptr{ID128}), bus, id)
    return id[]
end
function get_scope(bus::Bus)
    scope = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_bus_get_scope, (Ptr{Void}, Ptr{Ptr{Cchar}}), bus, scope)
    return consume_string(scope[])
end
function get_tid(bus::Bus)
    tid = Ref{Int32}()
    @sdcall(sd_bus_get_tid, (Ptr{Void}, Ptr{Int32}), bus, tid)
    return tid[]
end

# int sd_bus_get_owner_creds(sd_bus *bus, uint64_t creds_mask, sd_bus_creds **ret);

mutable struct Message
    ptr::Ptr{Void}
    function Message()
        self = new(C_NULL)
        finalizer(self, unref)
        return self
    end
end

Base.cconvert(::_Type{Ptr{Void}}, msg::Message) = msg
function Base.unsafe_convert(::_Type{Ptr{Void}}, msg::Message)
    ptr = msg.ptr
    ptr == C_NULL && throw(UndefRefError())
    ptr
end

function unref(msg::Message)
    ptr = msg.ptr
    ptr == C_NULL && return
    msg.ptr = C_NULL
    ccall((:sd_bus_message_unref, libsystemd), Ptr{Void}, (Ptr{Void},), ptr)
    return
end

function new_signal(bus::Bus, path, iface, member)
    msg = Message()
    @sdcall(sd_bus_message_new_signal,
            (Ptr{Void}, Ref{Message}, Cstring, Cstring, Cstring),
            bus, msg, path, iface, member)
    return msg
end

function new_method_call(bus::Bus, dest, path, iface, member)
    msg = Message()
    @sdcall(sd_bus_message_new_method_call,
            (Ptr{Void}, Ref{Message}, Cstring, Cstring, Cstring, Cstring),
            bus, msg, dest, path, iface, member)
    return msg
end

function new_method_return(bus::Bus)
    msg = Message()
    @sdcall(sd_bus_message_new_method_return,
            (Ptr{Void}, Ref{Message}), bus, msg)
    return msg
end

# int sd_bus_message_new_method_error(sd_bus_message *call, sd_bus_message **m, const sd_bus_error *e);
# int sd_bus_message_new_method_errorf(sd_bus_message *call, sd_bus_message **m, const char *name, const char *format, ...) _sd_printf_(4, 5);
# int sd_bus_message_new_method_errno(sd_bus_message *call, sd_bus_message **m, int error, const sd_bus_error *e);
# int sd_bus_message_new_method_errnof(sd_bus_message *call, sd_bus_message **m, int error, const char *format, ...) _sd_printf_(4, 5);

function get_type(msg::Message)
    typ = Ref{UInt8}(0)
    @sdcall(sd_bus_message_get_type, (Ptr{Void}, Ptr{UInt8}), msg, typ)
    return typ[]
end
function get_cookie(msg::Message)
    cookie = Ref{UInt64}(0)
    @sdcall(sd_bus_message_get_cookie, (Ptr{Void}, Ptr{UInt64}), msg, cookie)
    return cookie[]
end
function get_reply_cookie(msg::Message)
    cookie = Ref{UInt64}(0)
    @sdcall(sd_bus_message_get_reply_cookie,
            (Ptr{Void}, Ptr{UInt64}), msg, cookie)
    return cookie[]
end

function set_priority(msg::Message, priority)
    @sdcall(sd_bus_message_set_priority, (Ptr{Void}, Int64), msg, priority)
    return
end
function get_priority(msg::Message)
    priority = Ref{UInt64}(0)
    @sdcall(sd_bus_message_get_priority, (Ptr{Void}, Ptr{UInt64}), msg, priority)
    return priority[]
end

function set_expect_reply(msg::Message, b::Bool)
    @sdcall(sd_bus_message_set_expect_reply, (Ptr{Void}, Cint), msg, b)
    return
end
get_expect_reply(msg::Message) =
    @sdcall(sd_bus_message_get_expect_reply, (Ptr{Void},), msg) != 0

function set_auto_start(msg::Message, b::Bool)
    @sdcall(sd_bus_message_set_auto_start, (Ptr{Void}, Cint), msg, b)
    return
end
get_auto_start(msg::Message) =
    @sdcall(sd_bus_message_get_auto_start, (Ptr{Void},), msg) != 0

function set_allow_interactive_authorization(msg::Message, b::Bool)
    @sdcall(sd_bus_message_set_allow_interactive_authorization,
            (Ptr{Void}, Cint), msg, b)
    return
end
get_allow_interactive_authorization(msg::Message) =
    @sdcall(sd_bus_message_get_allow_interactive_authorization,
            (Ptr{Void},), msg) != 0

get_signature(msg::Message, complete::Bool=true) =
    unsafe_string(ccall((:sd_bus_message_get_signature, libsystemd),
                        Ptr{UInt8}, (Ptr{Void}, Cint), msg, complete))
get_path(msg::Message) =
    unsafe_string(ccall((:sd_bus_message_get_path, libsystemd),
                        Ptr{UInt8}, (Ptr{Void},), msg))
get_interface(msg::Message) =
    unsafe_string(ccall((:sd_bus_message_get_interface, libsystemd),
                        Ptr{UInt8}, (Ptr{Void},), msg))
get_member(msg::Message) =
    unsafe_string(ccall((:sd_bus_message_get_member, libsystemd),
                        Ptr{UInt8}, (Ptr{Void},), msg))

function set_destination(msg::Message, dest)
    @sdcall(sd_bus_message_set_destination, (Ptr{Void}, Cstring),
            msg, dest)
    return
end
get_destination(msg::Message) =
    unsafe_string(ccall((:sd_bus_message_get_destination, libsystemd),
                        Ptr{UInt8}, (Ptr{Void},), msg))

get_sender(msg::Message) =
    unsafe_string(ccall((:sd_bus_message_get_sender, libsystemd),
                        Ptr{UInt8}, (Ptr{Void},), msg))

# const sd_bus_error *sd_bus_message_get_error(sd_bus_message *m);
# int sd_bus_message_get_errno(sd_bus_message *m);

function get_monotonic_usec(msg::Message)
    usec = Ref{UInt64}(0)
    @sdcall(sd_bus_message_get_monotonic_usec, (Ptr{Void}, Ptr{UInt64}),
            msg, usec)
    return usec[]
end

function get_realtime_usec(msg::Message)
    usec = Ref{UInt64}(0)
    @sdcall(sd_bus_message_get_realtime_usec, (Ptr{Void}, Ptr{UInt64}),
            msg, usec)
    return usec[]
end

function get_seqnum(msg::Message)
    seq = Ref{UInt64}(0)
    @sdcall(sd_bus_message_get_seqnum, (Ptr{Void}, Ptr{UInt64}),
            msg, seq)
    return seq[]
end

function get_bus(msg::Message)
    ptr = ccall((:sd_bus_message_get_bus, libsystemd), Ptr{Void},
                (Ptr{Void},), msg)
    if ptr == C_NULL
        throw(UndefVarError())
    end
    Bus(ccall((:sd_bus_ref, libsystemd), Ptr{Void}, (Ptr{Void},), ptr))
end

# sd_bus_creds *sd_bus_message_get_creds(sd_bus_message *m); /* do not unref the result */

is_signal(msg::Message, iface=nothing, member=nothing) =
    @sdcall(sd_bus_message_is_signal, (Ptr{Void}, Cstring, Cstring),
            msg, _get_path(iface), _get_path(member)) != 0
is_method_call(msg::Message, iface=nothing, member=nothing) =
    @sdcall(sd_bus_message_is_method_call, (Ptr{Void}, Cstring, Cstring),
            msg, _get_path(iface), _get_path(member)) != 0
is_method_error(msg::Message, name=nothing) =
    @sdcall(sd_bus_message_is_method_error, (Ptr{Void}, Cstring),
            msg, _get_path(name)) != 0
is_empty(msg::Message) =
    @sdcall(sd_bus_message_is_empty, (Ptr{Void},), msg) != 0
has_signature(msg::Message, sig) =
    @sdcall(sd_bus_message_has_signature, (Ptr{Void}, Cstring), msg, sig) != 0

end
