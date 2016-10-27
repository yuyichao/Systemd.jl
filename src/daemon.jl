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
listen_fds(unset_environment::Bool=true) =
    Int(@sdcall(sd_listen_fds, (Cint,), unset_environment))

"""
    listen_fds_with_names([unset_environment::Bool]) -> Int, Vector{String}

Like `Systemd.listen_fds` but also returns a list of names associated with the
file descriptors.

See `sd_listen_fds_with_names(3)` for more information.
"""
function listen_fds_with_names(unset_environment::Bool=true)
    ret = Ref{Ptr{Cchar}}(C_NULL)
    nfd = @sdcall(sd_listen_fds_with_names,
                  (Cint, Ptr{Ptr{Cchar}}), unset_environment, ret)
    return Int(nfd), consume_pstring(ret[], nfd)
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
is_fifo(fd, path=nothing) =
    @sdcall(sd_is_fifo, (Cint, Cstring), fd, _get_path(path)) != 0

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
is_special(fd, path=nothing) =
    @sdcall(sd_is_special, (Cint, Cstring), fd, _get_path(path)) != 0

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
    return @sdcall(sd_is_socket, (Cint, Cint, Cint, Cint),
                   fd, family, typ, _listening) != 0
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
    return @sdcall(sd_is_socket_inet, (Cint, Cint, Cint, Cint, UInt16),
                   fd, family, typ, _listening, port)
end

@inline _unix_path(s::Symbol) = s, Cint(0)
@inline _unix_path(s::Void) = C_NULL, 0
@inline _unix_path(s) = if s[1] == '\0'
    # TODO this might not handle non-NULL terminating arrays very well.
    s, length(s)
else
    s, 0
end

"""
    is_socket_unix(fd[, type[, listening[, path]]]) -> Bool

Helper call for identifying a passed file descriptor. Returns `true` if
the file descriptor is an `AF.UNIX` socket of the specified `type`
(`SOCK.DGRAM`, `SOCK.STREAM`, ...) and `path`, `false` otherwise.
If `type` is `0` a socket type check will not be done.
If `path` is `nothing` a socket path check will not be done.
The `listening` flag is used the same way as in `is_socket`.

Raise a `SystemError` on failure.

See `sd_is_socket_unix(3)` for more information.
"""
function is_socket_unix(fd, typ=0, listening::Union{Void,Bool}=nothing,
                        path=nothing)
    _listening = isa(listening, Void) ? -1 : (listening ? 1 : 0)
    _path, len = _unix_path(path)
    return @sdcall(sd_is_socket_unix, (Cint, Cint, Cint, Ptr{UInt8}, Csize_t),
                   fd, typ, _listening, _path, len) != 0
end

"""
    is_mq(fd[, name]) -> Bool

Helper call for identifying a passed file descriptor. Returns `true` if
the file descriptor is a POSIX Message Queue of the specified `name`,
`false` otherwise. If `name` is `nothing` a message queue name check is not
done.

Raise a `SystemError` on failure.

See `sd_is_mq(3)` for more information.
"""
is_mq(fd, path=nothing) =
    @sdcall(sd_is_mq, (Cint, Cstring), fd, _get_path(path)) != 0

"""
    notify(state[, pid::Integer][, fds::AbstractVector]
           [, unset_environment::Bool=false]) -> Bool

Informs systemd about changed daemon state. This takes a number of
newline separated environment-style variable assignments in a
string. The following variables are known:

* `READY=1`

    Tells systemd that daemon startup is finished
    (only relevant for services of `Type=notify`).
    The passed argument is a boolean `1` or `0`.
    Since there is little value in signaling non-readiness the only
    value daemons should send is `READY=1`.

* `STATUS=...`

    Passes a single-line status string back to systemd
    that describes the daemon state.
    This is free-form and can be used for various purposes:
    general state feedback, fsck-like programs could pass completion
    percentages and failing programs could pass a human
    readable error message.
    Example: `STATUS=Completed 66% of file system check...`

* `ERRNO=...`

    If a daemon fails, the errno-style error code,
    formatted as string. Example: `ERRNO=2` for `ENOENT`.

* `BUSERROR=...`

    If a daemon fails, the D-Bus error-style error code.
    Example: `BUSERROR=org.freedesktop.DBus.Error.TimedOut`

* `MAINPID=...`

    The main pid of a daemon,
    in case systemd did not fork off the process itself.
    Example: `MAINPID=4711`

* `WATCHDOG=1`

    Tells systemd to update the watchdog timestamp.
    Services using this feature should do this in regular intervals.
    A watchdog framework can use the timestamps to detect failed services.
    Also see `watchdog_enabled`.

* `FDSTORE=1`

    Store the file descriptors passed along with the message in the per-service
    file descriptor store, and pass them to the main process again on next
    invocation. This variable is only supported when `fds` is provided.

* `WATCHDOG_USEC=...`

    Reset `watchdog_usec` value during runtime.
    To reset `watchdog_usec` value, start the service again.
    Example: `WATCHDOG_USEC=20000000`

Daemons can choose to send additional variables. However, it is
recommended to prefix variable names not listed above with `X_`.

If `pid` is provided, the message is sent on behalf of another
process, if the appropriate permissions are available.

If `fds` is provided, also passes the specified fd array
to the service manager for storage.
This is particularly useful for `FDSTORE=1` messages.

Raise a `SystemError` on failure. Returns `true` if systemd could be notified,
`false` if it couldn't possibly because systemd is not running.

Example: When a daemon finished starting up, it could issue this
call to notify systemd about it:

    notify("READY=1")

See `sd_notify(3)` for more information.
"""
function notify(state, pid::Integer, fds::AbstractVector{Cint},
                unset_environment::Bool=false)
    @sdcall(sd_pid_notify_with_fds, (Cint, Cint, Cstring, Ptr{Cint}, Cuint),
            pid, unset_environment, state, fds, length(fds)) != 0
end
notify(state, pid::Integer, fds::AbstractVector, unset_environment::Bool=false) =
    notify(state, pid, convert(Vector{Cint}, fds), unset_environment)
notify(state, fds::AbstractVector, unset_environment::Bool=false) =
    notify(state, getpid(), fds, unset_environment)
notify(state, pid::Integer, unset_environment::Bool=false) =
    @sdcall(sd_pid_notify, (Cint, Cint, Cstring),
            pid, unset_environment, state) !=0
notify(state, unset_environment::Bool=false) =
    @sdcall(sd_notify, (Cint, Cstring), unset_environment, state) != 0

"""
    booted() -> Bool

Returns `true` if the system was booted with systemd.
Returns `false` if the system was not booted with systemd.
Raise a `SystemError` on failure.
Note that many functions above handle non-systemd boots just fine.
You should NOT protect them with a call to this function.
Also note that this function checks whether the system, not the user
session is controlled by systemd. However other functions work
for both user and system services.

See `sd_booted(3)` for more information.
"""
booted() = @sdcall(sd_booted, ()) != 0

"""
    watchdog_enabled([unset_environment::Bool=false]) -> UInt64

Returns `> 0` if the service manager expects watchdog keep-alive
events to be sent regularly via `notify("WATCHDOG=1")`.
Returns `0` if it does not expect this. The returned value
is the watchdog timeout in `µs` after which the service manager
will act on a process that has not sent a watchdog keep alive message.
This function is useful to implement services that recognize automatically
if they are being run under supervision of systemd with `WatchdogSec=` set.
It is recommended for clients to generate keep-alive pings via
`notify("WATCHDOG=1")` every half of the returned time.

See `sd_watchdog_enabled(3)` for more information.
"""
function watchdog_enabled(unset_environment::Bool)
    usec = Ref{UInt64}(0)
    return @sdcall(sd_watchdog_enabled, (Cint, Ptr{UInt64}),
                   unset_environment, usec) == 0 ? UInt64(0) : usec[]
end
