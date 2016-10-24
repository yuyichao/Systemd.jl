#

# Log levels for usage on STDERR:
#
#     println(STDERR, Systemd.NOTICE * "Hello World!")
#
# This is similar to `printk()` usage in the kernel.

"system is unusable"
const EMERG = "<0>"
"action must be taken immediately"
const ALERT = "<1>"
"critical conditions"
const CRIT = "<2>"
"error conditions"
const ERR = "<3>"
"warning conditions"
const WARNING = "<4>"
"normal but significant condition"
const NOTICE = "<5>"
"informational"
const INFO = "<6>"
"debug-level messages"
const DEBUG = "<7>"

"The first passed file descriptor is fd 3"
const LISTEN_FDS_START = 3

include("sockets.jl")

"""
    listen_fds([unset_environment::Bool]) -> Int

Returns how many file descriptors have been passed, or a negative
errno code on failure. Optionally, removes the `LISTEN_FDS` and
`LISTEN_PID` file descriptors from the environment (recommended, but
problematic in threaded environments). If `r` is the return value of
this function you'll find the file descriptors passed as fds
`Systemd.LISTEN_FDS_START` to `Systemd.LISTEN_FDS_START + r - 1`.
Raise a `SystemError` on failure.
This function call ensures that the `FD_CLOEXEC` flag is set for the passed
file descriptors, to make sure they are not passed on to child processes.
If `FD_CLOEXEC` shall not be set, the caller needs to unset it after this
call for all file descriptors that are used.

See `sd_listen_fds(3)` for more information.
"""
function listen_fds(unset_environment::Bool=true)
    nfd = ccall((:sd_listen_fds, libsystemd), Cint, (Cint,), unset_environment)
    check_error(:sd_listen_fds, nfd)
    return Int(nfd)
end

"""
    listen_fds_with_names([unset_environment::Bool]) -> Int, Vector{String}

Like `Systemd.listen_fds` but also returns a list of names associated with the
file descriptors.

See `sd_listen_fds_with_names(3)` for more information.
"""
function listen_fds_with_names(unset_environment::Bool=true)
    ret = Ref{Ptr{Void}}(C_NULL)
    nfd = ccall((:sd_listen_fds_with_names, libsystemd),
                Cint, (Cint, Ptr{Ptr{Void}}), unset_environment, ret)
    check_error(:sd_listen_fds_with_names, nfd)
    names = Vector{String}(nfd)
    ptr = Ptr{Ptr{Cchar}}(ret[])
    for i in 1:nfd
        names[i] = unsafe_wrap(String, unsafe_load(ptr, i), true)
    end
    Libc.free(ptr)
    return Int(nfd), names
end

"""
    is_fifo(fd[, path]) -> Bool

Helper call for identifying a passed file descriptor. Returns `true` if
the file descriptor is a FIFO in the file system stored under the
specified `path`, `false` otherwise.
If `path` is not provided a path name check will not be done and the call only
verifies if the file descriptor refers to a FIFO.

Raise a `SystemError` on failure.

See `sd_is_fifo(3)` for more information.
"""
function is_fifo(fd, path=C_NULL)
    res = ccall((:sd_is_fifo, libsystemd), Cint, (Cint, Cstring), fd, path)
    check_error(:sd_is_fifo, res)
    return res != 0
end

"""
    is_special(fd[, path]) -> Bool

Helper call for identifying a passed file descriptor. Returns `true` if
the file descriptor is a special character device on the file
system stored under the specified `path`, `false` otherwise.
If `path` is not provided a path name check will not be done and the call
only verifies if the file descriptor refers to a special character.

Raise a `SystemError` on failure.

See `sd_is_special(3)` for more information.
"""
function is_special(fd, path=C_NULL)
    res = ccall((:sd_is_special, libsystemd), Cint, (Cint, Cstring), fd, path)
    check_error(:sd_is_special, res)
    return res != 0
end

"""
    is_socket(fd, [family, [type[, listening]]]) -> Bool

Helper call for identifying a passed file descriptor. Returns `true` if
the file descriptor is a socket of the specified family (`AF.INET`, ...)
and type (`SOCK.DGRAM`, `SOCK.STREAM`, ...), `false` otherwise. If
`family` is `0` a socket family check will not be done. If `type` is `0`
a socket type check will not be done and the call only verifies if
the file descriptor refers to a socket. If `listening` is `true` it is
verified that the socket is in listening mode. (i.e. `listen()` has
been called) If `listening` is `false` it is verified that the socket is
not in listening mode. If `listening` is missing or `nothing`
no listening mode check is done.

Raise a `SystemError` on failure.

See `sd_is_socket(3)` for more information.
"""
function is_socket(fd, family=0, typ=0, listening::Union{Void,Bool}=nothing)
    _listening = isa(listening, Void) ? -1 : (listening ? 1 : 0)
    res = ccall((:sd_is_socket, libsystemd), Cint, (Cint, Cint, Cint, Cint),
                fd, family, typ, _listening)
    check_error(:sd_is_socket, res)
    return res != 0
end

"""
    is_socket_inet(fd[, family[, type[, listening[, port]]]]) -> Bool

Helper call for identifying a passed file descriptor. Returns `true` if
the file descriptor is an Internet socket, of the specified `family`
(either `AF.INET` or `AF.INET6`) and the specified type (`SOCK.DGRAM`,
`SOCK.STREAM`, ...), `false` otherwise. If `version` is `0` a protocol version
check is not done. If `type` is `0` a socket type check will not be
done. If `port` is `0` a socket port check will not be done. The
`listening` flag is used the same way as in `is_socket`.

Raise a `SystemError` on failure.

See `sd_is_socket_inet(3)` for more information.
"""
function is_socket_inet(fd, family=0, typ=0,
                        listening::Union{Void,Bool}=nothing, port=0)
    _listening = isa(listening, Void) ? -1 : (listening ? 1 : 0)
    res = ccall((:sd_is_socket_inet, libsystemd), Cint,
                (Cint, Cint, Cint, Cint, UInt16),
                fd, family, typ, _listening, port)
    check_error(:sd_is_socket_inet, res)
    return res != 0
end
