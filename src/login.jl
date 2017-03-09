#

module Pid
import ..@sdcall, ..consume_string

"""
    Pid.get_session(pid) -> String

Get session from PID. Note that 'shared' processes of a user are
not attached to a session, but only attached to a user. This will
throw an error for system processes and 'shared' processes of a
user.
"""
function get_session(pid)
    session = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_session, (Cint, Ptr{Ptr{Cchar}}), pid, session)
    return consume_string(session[])
end

"""
    Pid.get_owner_uid(pid) -> Int32

Get UID of the owner of the session of the PID (or in case the
process is a 'shared' user process, the UID of that user is
returned). This will not return the UID of the process, but rather
the UID of the owner of the cgroup that the process is in. This will
throw an error for system processes.
"""
function get_owner_uid(pid)
    uid = Ref{Int32}(0)
    @sdcall(sd_pid_get_owner_uid, (Cint, Ptr{Int32}), pid, uid)
    return uid[]
end

"""
    Pid.get_unit(pid) -> String

Get systemd non-slice unit (i.e. service) name from PID, for system
services. This will throw an error for non-service processes.
"""
function get_unit(pid)
    unit = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_unit, (Cint, Ptr{Ptr{Cchar}}), pid, unit)
    return consume_string(unit[])
end

"""
    Pid.get_user_unit(pid) -> String

Get systemd non-slice unit (i.e. service) name from PID, for user
services. This will return an error for non-user-service processes.
"""
function get_user_unit(pid)
    unit = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_user_unit, (Cint, Ptr{Ptr{Cchar}}), pid, unit)
    return consume_string(unit[])
end

"""
    Pid.get_slice(pid) -> String

Get slice name from PID.
"""
function get_slice(pid)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_slice, (Cint, Ptr{Ptr{Cchar}}), pid, slice)
    return consume_string(slice[])
end

"""
    Pid.get_user_slice(pid) -> String

Get user slice name from PID.
"""
function get_user_slice(pid)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_user_slice, (Cint, Ptr{Ptr{Cchar}}), pid, slice)
    return consume_string(slice[])
end

"""
    Pid.get_machine_name(pid) -> String

Get machine name from PID, for processes assigned to a VM or
container. This will return an error for non-machine processes.
"""
function get_machine_name(pid)
    machine_name = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_machine_name, (Cint, Ptr{Ptr{Cchar}}), pid, machine_name)
    return consume_string(machine_name[])
end

"""
    Pid.get_cgroup(pid) -> String

Get the control group from a PID, relative to the root of the
hierarchy.
"""
function get_cgroup(pid)
    cgroup = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_pid_get_cgroup, (Cint, Ptr{Ptr{Cchar}}), pid, cgroup)
    return consume_string(cgroup[])
end
end

module Peer
import ..@sdcall

"""
    Peer.get_session(fd) -> String

Similar to `Pid.get_session`, but retrieves data about the peer
of a connected `AF.UNIX` socket.
"""
function get_session(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_session, (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    return consume_string(slice[])
end

"""
    Peer.get_owner_uid(fd) -> Int32

Similar to `Pid.get_owner_uid`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_owner_uid(fd)
    uid = Ref{Int32}(0)
    @sdcall(sd_peer_get_owner_uid, (Cint, Ptr{Int32}), fd, uid)
    return uid[]
end

"""
    Peer.get_unit(fd) -> String

Similar to `Pid.get_unit`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_unit(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_unit, (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    return consume_string(slice[])
end

"""
    Peer.get_user_unit(fd) -> String

Similar to `Pid.get_user_unit`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_user_unit(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_user_unit, (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    return consume_string(slice[])
end

"""
    Peer.get_slice(fd) -> String

Similar to `Pid.get_slice, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_slice(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_slice, (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    return consume_string(slice[])
end

"""
    Peer.get_user_slice(fd) -> String

Similar to `Pid.get_user_slice`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_user_slice(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_user_slice, (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    return consume_string(slice[])
end

"""
    Peer.get_machine_name(fd) -> String

Similar to `Pid.get_machine_name`, but retrieves data about the
peer of a connected `AF.UNIX` socket
"""
function get_machine_name(fd)
    machine_name = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_machine_name, (Cint, Ptr{Ptr{Cchar}}), fd, machine_name)
    return consume_string(machine_name[])
end

"""
    Peer.get_cgroup(fd) -> String

Similar to `Pid.get_cgroup`, but retrieves data about the peer
of a connected `AF.UNIX` socket.
"""
function get_cgroup(fd)
    cgroup = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_peer_get_cgroup, (Cint, Ptr{Ptr{Cchar}}), fd, cgroup)
    return consume_string(cgroup[])
end
end

module Uid
import ..@sdcall, ..consume_pstring

"""
    Uid.get_state(uid) -> String

Get state from UID. Possible states: offline, lingering, online, active, closing
"""
function get_state(uid)
    state = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_uid_get_state, (Cint, Ptr{Ptr{Cchar}}), uid, state)
    return consume_string(state[])
end

"""
    Uid.get_display(uid) -> String

Return primary session of user, if there is any
"""
function get_display(uid)
    display = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_uid_get_display, (Cint, Ptr{Ptr{Cchar}}), uid, display)
    return consume_string(display[])
end

"""
    Uid.is_on_seat(uid, seat[, require_active=false]) -> Bool

Return `true` if UID has session on seat.
If `require_active` is `true`, this will look for active sessions only.
"""
is_on_seat(uid, seat, require_active::Bool=false) =
    @sdcall(sd_uid_is_on_seat, (Cint, Cint, Cstring),
            uid, require_active, seat) != 0

"""
    Uid.get_sessions(uid[, require_active=false]) -> Vector{String}

Return sessions of user. If `require_active` is `true`, this will look for
active sessions only.
"""
function get_sessions(uid, require_active::Bool=false)
    ret = Ref{Ptr{Cchar}}(C_NULL)
    nsessions = @sdcall(sd_uid_get_sessions, (Cint, Cint, Ptr{Ptr{Cchar}}),
                        uid, require_active, ret)
    return consume_pstring(ret[], nsessions)
end

"""
    Uid.get_seats(uid[, require_active=false]) -> Vector{String}

Return seats of user is on. If `require_active` is `true`, this will look for
active seats only.
"""
function get_seats(uid, require_active::Bool=false)
    ret = Ref{Ptr{Cchar}}(C_NULL)
    nseats = @sdcall(sd_uid_get_seats, (Cint, Cint, Ptr{Ptr{Cchar}}),
                     uid, require_active, ret)
    return consume_pstring(ret[], nseats)
end
end

module Session
import ..@sdcall

"""
    Session.is_active(session) -> Bool

Return `true` if the `session` is active.
"""
is_active(session) =
    @sdcall(sd_session_is_active, (Cstring,), session) != 0

"""
    Session.is_remote(session) -> Bool

Return `true` if the `session` is remote.
"""
is_remote(session) =
    @sdcall(sd_session_is_remote, (Cstring,), session) != 0

"""
    Session.get_state(session) -> String

Get state from `session`. Possible states: online, active, closing.
This function is a more generic version of `Session.is_active`.
"""
function get_state(session)
    state = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_state, (Cstring, Ptr{Ptr{Cchar}}), session, state)
    return consume_string(state[])
end

"""
    Session.get_uid(session) -> Int32

Determine user ID of `session`
"""
function get_uid(session)
    uid = Ref{Int32}(0)
    @sdcall(sd_session_get_uid, (Cstring, Ptr{Int32}), session, uid)
    return uid[]
end

"""
    Session.get_seat(session) -> String

Determine seat of `session`
"""
function get_seat(session)
    seat = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_seat, (Cstring, Ptr{Ptr{Cchar}}), session, seat)
    return consume_string(seat[])
end

"""
    Session.get_service(session) -> String

Determine the (PAM) service name this `session` was registered by.
"""
function get_service(session)
    service = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_service, (Cstring, Ptr{Ptr{Cchar}}), session, service)
    return consume_string(service[])
end

"""
    Session.get_type(session) -> String

Determine the type of this `session`, i.e. one of
"tty", "x11", "wayland", "mir" or "unspecified".
"""
function get_type(session)
    typ = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_type, (Cstring, Ptr{Ptr{Cchar}}), session, typ)
    return consume_string(typ[])
end

"""
    Session.get_class(session) -> String

Determine the class of this `session`,
i.e. one of "user", "greeter" or "lock-screen".
"""
function get_class(session)
    class = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_class, (Cstring, Ptr{Ptr{Cchar}}), session, class)
    return consume_string(class[])
end

"""
    Session.get_desktop(session) -> String

Determine the desktop brand of this `session`,
i.e. something like "GNOME", "KDE" or "systemd-console".
"""
function get_desktop(session)
    desktop = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_desktop, (Cstring, Ptr{Ptr{Cchar}}), session, desktop)
    return consume_string(desktop[])
end

"""
    Session.get_display(session) -> String

Determine the X11 display of this `session`.
"""
function get_display(session)
    display = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_display, (Cstring, Ptr{Ptr{Cchar}}), session, display)
    return consume_string(display[])
end

"""
    Session.get_remote_host(session) -> String

Determine the remote host of this `session`.
"""
function get_remote_host(session)
    remote_host = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_remote_host, (Cstring, Ptr{Ptr{Cchar}}),
            session, remote_host)
    return consume_string(remote_host[])
end

"""
    Session.get_remote_user(session) -> String

Determine the remote user of this `session` (if provided by PAM).
"""
function get_remote_user(session)
    remote_user = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_remote_user, (Cstring, Ptr{Ptr{Cchar}}),
            session, remote_user)
    return consume_string(remote_user[])
end

"""
    Session.get_tty(session) -> String

Determine the TTY of this `session`.
"""
function get_tty(session)
    tty = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_session_get_tty, (Cstring, Ptr{Ptr{Cchar}}), session, tty)
    return consume_string(tty[])
end

"""
    Session.get_vt(session) -> Int32

Determine the VT number of this `session`.
"""
function get_vt(session)
    vt = Ref{Int32}(0)
    @sdcall(sd_session_get_vt, (Cstring, Ptr{Int32}), session, vt)
    return vt[]
end
end

module Seat
import ..@sdcall, ..consume_pstring

"""
    Seat.get_active(seat) -> String, Int32

Return active session and user of `seat`
"""
function get_active(seat)
    user = Ref{Int32}(0)
    session = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_seat_get_active, (Cstring, Ptr{Ptr{Cchar}}, Ptr{Int32}),
            seat, session, user)
    return consume_string(session[]), user[]
end

"""
    Seat.get_sessions(seat) -> Vector{String}, Vector{Int32}

Return sessions and users on `seat`.
"""
function get_sessions(seat)
    user = Ref{Ptr{Int32}}(C_NULL)
    session = Ref{Ptr{Ptr{Cchar}}}(C_NULL)
    nuser = Ref{Int32}(0)
    res = @sdcall(sd_seat_get_sessions,
                  (Cstring, Ptr{Ptr{Ptr{Cchar}}}, Ptr{Ptr{Int32}}, Ptr{Int32}),
                  seat, session, user, nuser)
    return (consume_pstring(session[], res),
            unsafe_wrap(Array, user[], nuser[], true))
end

"""
    Seat.can_multi_session(seat) -> Bool

Return whether the `seat` is multi-session capable
"""
can_multi_session(seat) =
    @sdcall(sd_seat_can_multi_session, (Cstring,), seat) != 0

"""
    Seat.can_tty(seat) -> Bool

Return whether the `seat` is TTY capable, i.e. suitable for showing console UIs
"""
can_tty(seat) = @sdcall(sd_seat_can_tty, (Cstring,), seat) != 0

"""
    Seat.can_graphical(seat) -> Bool

Return whether the `seat` is graphics capable,
i.e. suitable for showing graphical UIs
"""
can_graphical(seat) = @sdcall(sd_seat_can_graphical, (Cstring,), seat) != 0
end

module Machine
import ..@sdcall
import ..check_error, ..libsystemd

"""
    get_class(machine) -> String

Return the class of `machine`
"""
function get_class(machine)
    class = Ref{Ptr{Cchar}}(C_NULL)
    @sdcall(sd_machine_get_class, (Cstring, Ptr{Ptr{Cchar}}), machine, class)
    return consume_string(class[])
end

"""
    get_ifindices(machine) -> Vector{Int32}

Return the list if host-side network interface indices of a `machine`
"""
function get_ifindices(machine)
    ifindices = Ref{Ptr{Int32}}(C_NULL)
    res = @sdcall(sd_machine_get_ifindices, (Cstring, Ptr{Ptr{Cchar}}),
                  machine, ifindices)
    return unsafe_warp(Array, ifindices[], res, true)
end
end

"""
    get_seats() -> Vector{String}

Get all seats.
"""
function get_seats()
    seats = Ref{Ptr{Ptr{Cchar}}}(C_NULL)
    nseats = @sdcall(sd_get_seats, (Ptr{Ptr{Ptr{Cchar}}},), seats)
    return consume_pstring(seats[], nseats)
end

"""
    get_sessions() -> Vector{String}

Get all sessions.
"""
function get_sessions()
    sessions = Ref{Ptr{Ptr{Cchar}}}(C_NULL)
    nsessions = @sdcall(sd_get_sessions, (Ptr{Ptr{Ptr{Cchar}}},), sessions)
    return consume_pstring(sessions[], nsessions)
end

"""
    get_uids() -> Vector{Int32}

Get all logged in users.
"""
function get_uids()
    uids = Ref{Ptr{Int32}}(C_NULL)
    nuids = @sdcall(sd_get_uids, (Ptr{Ptr{Int32}},), uids)
    return unsafe_wrap(Array, uids[], nuids, true)
end

"""
    get_machine_names() -> Vector{String}

Get all running virtual machines/containers
"""
function get_machine_names()
    machine_names = Ref{Ptr{Ptr{Cchar}}}(C_NULL)
    nmachine_names = @sdcall(sd_get_machine_names, (Ptr{Ptr{Ptr{Cchar}}},),
                             machine_names)
    return consume_pstring(machine_names[], nmachine_names)
end

type LoginMonitor
    ptr::Ptr{Void}
    """
        LoginMonitor([category])

    Create a new monitor. Category must be `nothing`, "seat", "session",
    "uid", or "machine" to get monitor events for the specific category
    (or all).
    """
    function LoginMonitor(category=nothing)
        self = new(C_NULL)
        @sdcall(sd_login_monitor_new, (Cstring, Ref{LoginMonitor}),
                _get_path(category), self)
        finalizer(self, close)
        return self
    end
end

"""
    close(monitor::LoginMonitor)

Destroys the passed `monitor`.
"""
function Base.close(monitor::LoginMonitor)
    ptr = monitor.ptr
    ptr == C_NULL && return
    monitor.ptr = C_NULL
    ccall((:sd_login_monitor_unref, libsystemd), Ptr{Void}, (Ptr{Void},), ptr)
    return
end

Base.cconvert(::Type{Ptr{Void}}, monitor::LoginMonitor) = monitor
function Base.unsafe_convert(::Type{Ptr{Void}}, monitor::LoginMonitor)
    ptr = monitor.ptr
    ptr == C_NULL && throw(UndefRefError())
    ptr
end

"""
    flush(monitor::LoginMonitor)

Flushes the `monitor`
"""
function Base.flush(monitor::LoginMonitor)
    @sdcall(sd_login_monitor_flush, (Ptr{Void},), monitor)
    return
end

"""
    get_fd(monitor::LoginMonitor) -> Int32

Get FD from `monitor`
"""
get_fd(monitor::LoginMonitor) =
    @sdcall(sd_login_monitor_get_fd, (Ptr{Void},), monitor)

"""
    get_events(monitor::LoginMonitor) -> Int32

Get `poll()` mask to `monitor`
"""
get_events(monitor::LoginMonitor) =
    @sdcall(sd_login_monitor_get_events, (Ptr{Void},), monitor)

"""
    get_timeout(monitor::LoginMonitor) -> UInt64

Get timeout for `poll()`, as usec value relative to `CLOCK_MONOTONIC`'s epoch.
"""
function get_timeout(monitor::LoginMonitor)
    timeout = Ref{UInt64}(0)
    @sdcall(sd_login_monitor_get_timeout, (Ptr{Void}, Ptr{UInt64}),
            monitor, timeout)
    return timeout[]
end

"""
    get_timeout(monitor::LoginMonitor, timeout_s::Real=-1) -> Bool

Wait until a login event happens or times out. Returns if any events happens.
"""
function Base.wait(monitor::LoginMonitor, timeout_s::Real=-1)
    rfd = RawFD(get_fd(monitor))
    timeout = get_timeout(monitor)
    if timeout != -1 % UInt64
        timeout_s = min(timeout_s, timeout / 1e6)
    end
    rd, wr = event_to_rw(get_events(monitor))
    res = poll_fd(rfd, timeout_s, readable=rd, writable=wr)
    flush(monitor)
    return res.readable || res.writable
end
