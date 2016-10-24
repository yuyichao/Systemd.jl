#

module Pid
import ..check_error, ..libsystemd

"""
    Pid.get_session(pid) -> String

Get session from PID. Note that 'shared' processes of a user are
not attached to a session, but only attached to a user. This will
throw an error for system processes and 'shared' processes of a
user.
"""
function get_session(pid)
    session = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_session, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, session)
    check_error(:sd_pid_get_session, res)
    return unsafe_wrap(String, session[], true)
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
    res = ccall((:sd_pid_get_owner_uid, libsystemd), Cint,
                (Cint, Ptr{Int32}), pid, uid)
    check_error(:sd_pid_get_owner_uid, res)
    return uid[]
end

"""
    Pid.get_unit(pid) -> String

Get systemd non-slice unit (i.e. service) name from PID, for system
services. This will throw an error for non-service processes.
"""
function get_unit(pid)
    unit = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_unit, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, unit)
    check_error(:sd_pid_get_unit, res)
    return unsafe_wrap(String, unit[], true)
end

"""
    Pid.get_user_unit(pid) -> String

Get systemd non-slice unit (i.e. service) name from PID, for user
services. This will return an error for non-user-service processes.
"""
function get_user_unit(pid)
    unit = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_user_unit, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, unit)
    check_error(:sd_pid_get_user_unit, res)
    return unsafe_wrap(String, unit[], true)
end

"""
    Pid.get_slice(pid) -> String

Get slice name from PID.
"""
function get_slice(pid)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_slice, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, slice)
    check_error(:sd_pid_get_slice, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Pid.get_user_slice(pid) -> String

Get user slice name from PID.
"""
function get_user_slice(pid)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_user_slice, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, slice)
    check_error(:sd_pid_get_user_slice, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Pid.get_machine_name(pid) -> String

Get machine name from PID, for processes assigned to a VM or
container. This will return an error for non-machine processes.
"""
function get_machine_name(pid)
    machine_name = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_machine_name, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, machine_name)
    check_error(:sd_pid_get_machine_name, res)
    return unsafe_wrap(String, machine_name[], true)
end

"""
    Pid.get_cgroup(pid) -> String

Get the control group from a PID, relative to the root of the
hierarchy.
"""
function get_cgroup(pid)
    cgroup = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_pid_get_cgroup, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), pid, cgroup)
    check_error(:sd_pid_get_cgroup, res)
    return unsafe_wrap(String, cgroup[], true)
end
end

module Peer
import ..check_error, ..libsystemd

"""
    Peer.get_session(fd) -> String

Similar to `Pid.get_session`, but retrieves data about the peer
of a connected `AF.UNIX` socket.
"""
function get_session(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_session, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    check_error(:sd_peer_get_session, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Peer.get_owner_uid(fd) -> Int32

Similar to `Pid.get_owner_uid`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_owner_uid(fd)
    uid = Ref{Int32}(0)
    res = ccall((:sd_peer_get_owner_uid, libsystemd), Cint,
                (Cint, Ptr{Int32}), fd, uid)
    check_error(:sd_peer_get_owner_uid, res)
    return uid[]
end

"""
    Peer.get_unit(fd) -> String

Similar to `Pid.get_unit`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_unit(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_unit, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    check_error(:sd_peer_get_unit, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Peer.get_user_unit(fd) -> String

Similar to `Pid.get_user_unit`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_user_unit(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_user_unit, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    check_error(:sd_peer_get_user_unit, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Peer.get_slice(fd) -> String

Similar to `Pid.get_slice, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_slice(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_slice, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    check_error(:sd_peer_get_slice, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Peer.get_user_slice(fd) -> String

Similar to `Pid.get_user_slice`, but retrieves data about the peer of
a connected `AF.UNIX` socket
"""
function get_user_slice(fd)
    slice = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_user_slice, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, slice)
    check_error(:sd_peer_get_user_slice, res)
    return unsafe_wrap(String, slice[], true)
end

"""
    Peer.get_machine_name(fd) -> String

Similar to `Pid.get_machine_name`, but retrieves data about the
peer of a connected `AF.UNIX` socket
"""
function get_machine_name(fd)
    machine_name = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_machine_name, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, machine_name)
    check_error(:sd_peer_get_machine_name, res)
    return unsafe_wrap(String, machine_name[], true)
end

"""
    Peer.get_cgroup(fd) -> String

Similar to `Pid.get_cgroup`, but retrieves data about the peer
of a connected `AF.UNIX` socket.
"""
function get_cgroup(fd)
    cgroup = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_peer_get_cgroup, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), fd, cgroup)
    check_error(:sd_peer_get_cgroup, res)
    return unsafe_wrap(String, cgroup[], true)
end
end

module Uid
import ..check_error, ..libsystemd

"""
    Uid.get_state(uid) -> String

Get state from UID. Possible states: offline, lingering, online, active, closing
"""
function get_state(uid)
    state = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_uid_get_state, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), uid, state)
    check_error(:sd_uid_get_state, res)
    return unsafe_wrap(String, state[], true)
end

"""
    Uid.get_display(uid) -> String

Return primary session of user, if there is any
"""
function get_display(uid)
    display = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_uid_get_display, libsystemd), Cint,
                (Cint, Ptr{Ptr{Cchar}}), uid, display)
    check_error(:sd_uid_get_display, res)
    return unsafe_wrap(String, display[], true)
end

"""
    Uid.is_on_seat(uid, seat[, require_active=false]) -> Bool

Return `true` if UID has session on seat.
If `require_active` is `true`, this will look for active sessions only.
"""
function is_on_seat(uid, seat, require_active::Bool=false)
    res = ccall((:sd_uid_is_on_seat, libsystemd), Cint,
                (Cint, Cint, Cstring), uid, require_active, seat)
    check_error(:sd_uid_is_on_seat, res)
    return res != 0
end

"""
    Uid.get_sessions(uid[, require_active=false]) -> Vector{String}

Return sessions of user. If `require_active` is `true`, this will look for
active sessions only.

Returns the number of sessions. If sessions is NULL, this will just return the number of sessions.
"""
function get_sessions(uid, require_active::Bool=false)
    ret = Ref{Ptr{Void}}(C_NULL)
    nsessions = ccall((:sd_uid_get_sessions, libsystemd),
                      Cint, (Cint, Cint, Ptr{Ptr{Void}}),
                      uid, require_active, ret)
    check_error(:sd_uid_get_sessions, nsessions)
    sessions = Vector{String}(nsessions)
    ptr = Ptr{Ptr{Cchar}}(ret[])
    for i in 1:nsessions
        sessions[i] = unsafe_wrap(String, unsafe_load(ptr, i), true)
    end
    Libc.free(ptr)
    return sessions
end

"""
Return seats of user is on. If require_active is true, this will look for
active seats only. Returns the number of seats.
If seats is NULL, this will just return the number of seats.
"""
function get_seats(uid, require_active::Bool=false)
    ret = Ref{Ptr{Void}}(C_NULL)
    nseats = ccall((:sd_uid_get_seats, libsystemd),
                   Cint, (Cint, Cint, Ptr{Ptr{Void}}),
                   uid, require_active, ret)
    check_error(:sd_uid_get_seats, nseats)
    seats = Vector{String}(nseats)
    ptr = Ptr{Ptr{Cchar}}(ret[])
    for i in 1:nseats
        seats[i] = unsafe_wrap(String, unsafe_load(ptr, i), true)
    end
    Libc.free(ptr)
    return seats
end
end

module Session
import ..check_error, ..libsystemd

"""
    Session.is_active(session) -> Bool

Return `true` if the `session` is active.
"""
function is_active(session)
    ret = ccall((:sd_session_is_active, libsystemd),
                Cint, (Cstring,), session)
    check_error(:sd_session_is_active, ret)
    return ret != 0
end

"""
    Session.is_remote(session) -> Bool

Return `true` if the `session` is remote.
"""
function is_remote(session)
    ret = ccall((:sd_session_is_remote, libsystemd),
                Cint, (Cstring,), session)
    check_error(:sd_session_is_remote, ret)
    return ret != 0
end

"""
    Session.get_state(session) -> String

Get state from `session`. Possible states: online, active, closing.
This function is a more generic version of `Session.is_active`.
"""
function get_state(session)
    state = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_state, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, state)
    check_error(:sd_session_get_state, res)
    return unsafe_wrap(String, state[], true)
end

"""
    Session.get_uid(session) -> Int32

Determine user ID of `session`
"""
function get_uid(session)
    uid = Ref{Int32}(0)
    res = ccall((:sd_session_get_uid, libsystemd), Cint,
                (Cstring, Ptr{Int32}), session, uid)
    check_error(:sd_session_get_uid, res)
    return uid[]
end

"""
    Session.get_seat(session) -> String

Determine seat of `session`
"""
function get_seat(session)
    seat = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_seat, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, seat)
    check_error(:sd_session_get_seat, res)
    return unsafe_wrap(String, seat[], true)
end

"""
    Session.get_service(session) -> String

Determine the (PAM) service name this `session` was registered by.
"""
function get_service(session)
    service = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_service, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, service)
    check_error(:sd_session_get_service, res)
    return unsafe_wrap(String, service[], true)
end

"""
    Session.get_type(session) -> String

Determine the type of this `session`, i.e. one of
"tty", "x11", "wayland", "mir" or "unspecified".
"""
function get_type(session)
    typ = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_type, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, typ)
    check_error(:sd_session_get_type, res)
    return unsafe_wrap(String, typ[], true)
end

"""
    Session.get_class(session) -> String

Determine the class of this `session`,
i.e. one of "user", "greeter" or "lock-screen".
"""
function get_class(session)
    class = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_class, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, class)
    check_error(:sd_session_get_class, res)
    return unsafe_wrap(String, class[], true)
end

"""
    Session.get_desktop(session) -> String

Determine the desktop brand of this `session`,
i.e. something like "GNOME", "KDE" or "systemd-console".
"""
function get_desktop(session)
    desktop = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_desktop, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, desktop)
    check_error(:sd_session_get_desktop, res)
    return unsafe_wrap(String, desktop[], true)
end

"""
    Session.get_display(session) -> String

Determine the X11 display of this `session`.
"""
function get_display(session)
    display = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_display, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, display)
    check_error(:sd_session_get_display, res)
    return unsafe_wrap(String, display[], true)
end

"""
    Session.get_remote_host(session) -> String

Determine the remote host of this `session`.
"""
function get_remote_host(session)
    remote_host = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_remote_host, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, remote_host)
    check_error(:sd_session_get_remote_host, res)
    return unsafe_wrap(String, remote_host[], true)
end

"""
    Session.get_remote_user(session) -> String

Determine the remote user of this `session` (if provided by PAM).
"""
function get_remote_user(session)
    remote_user = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_remote_user, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, remote_user)
    check_error(:sd_session_get_remote_user, res)
    return unsafe_wrap(String, remote_user[], true)
end

"""
    Session.get_tty(session) -> String

Determine the TTY of this `session`.
"""
function get_tty(session)
    tty = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_session_get_tty, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), session, tty)
    check_error(:sd_session_get_tty, res)
    return unsafe_wrap(String, tty[], true)
end

"""
    Session.get_vt(session) -> Int32

Determine the VT number of this `session`.
"""
function get_vt(session)
    vt = Ref{Int32}(0)
    res = ccall((:sd_session_get_vt, libsystemd), Cint,
                (Cstring, Ptr{Int32}), session, vt)
    check_error(:sd_session_get_vt, res)
    return vt[]
end
end

module Seat
import ..check_error, ..libsystemd

"""
    Seat.get_active(seat) -> String, Int32

Return active session and user of `seat`
"""
function get_active(seat)
    user = Ref{Int32}(0)
    session = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_seat_get_active, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}, Ptr{Int32}), seat, session, user)
    check_error(:sd_seat_get_active, res)
    return unsafe_wrap(String, session[], true), user[]
end

"""
    Seat.get_sessions(seat) -> Vector{String}, Vector{Int32}

Return sessions and users on `seat`.
"""
function get_sessions(seat)
    user = Ref{Ptr{Int32}}(C_NULL)
    session = Ref{Ptr{Ptr{Cchar}}}(C_NULL)
    nuser = Ref{Int32}(0)
    res = ccall((:sd_seat_get_sessions, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Ptr{Cchar}}}, Ptr{Ptr{Int32}},
                 Ptr{Int32}), seat, session, user, nuser)
    check_error(:sd_seat_get_sessions, res)
    user_vec = unsafe_wrap(Array, user[], nuser[], true)
    session_vec = Vector{String}(res)
    ptr = session[]
    for i in 1:res
        session_vec[i] = unsafe_wrap(String, unsafe_load(ptr, i), true)
    end
    Libc.free(ptr)
    return session_vec, user_vec
end

"""
    Seat.can_multi_session(seat) -> Bool

Return whether the `seat` is multi-session capable
"""
function can_multi_session(seat)
    ret = ccall((:sd_seat_can_multi_session, libsystemd),
                Cint, (Cstring,), seat)
    check_error(:sd_seat_can_multi_session, ret)
    return ret != 0
end

"""
    Seat.can_tty(seat) -> Bool

Return whether the `seat` is TTY capable, i.e. suitable for showing console UIs
"""
function can_tty(seat)
    ret = ccall((:sd_seat_can_tty, libsystemd),
                Cint, (Cstring,), seat)
    check_error(:sd_seat_can_tty, ret)
    return ret != 0
end

"""
    Seat.can_graphical(seat) -> Bool

Return whether the `seat` is graphics capable,
i.e. suitable for showing graphical UIs
"""
function can_graphical(seat)
    ret = ccall((:sd_seat_can_graphical, libsystemd),
                Cint, (Cstring,), seat)
    check_error(:sd_seat_can_graphical, ret)
    return ret != 0
end
end

module Machine
import ..check_error, ..libsystemd
"""
    get_class(machine) -> String

Return the class of `machine`
"""
function get_class(machine)
    class = Ref{Ptr{Cchar}}(C_NULL)
    res = ccall((:sd_machine_get_class, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), machine, class)
    check_error(:sd_machine_get_class, res)
    return unsafe_wrap(String, class[], true)
end

"""
    get_ifindices(machine) -> Vector{Int32}

Return the list if host-side network interface indices of a `machine`
"""
function get_ifindices(machine)
    ifindices = Ref{Ptr{Int32}}(C_NULL)
    res = ccall((:sd_machine_get_ifindices, libsystemd), Cint,
                (Cstring, Ptr{Ptr{Cchar}}), machine, ifindices)
    check_error(:sd_machine_get_ifindices, res)
    return unsafe_warp(Array, ifindices[], res, true)
end
end

# """
# Get all seats, store in *seats. Returns the number of seats. If
# seats is NULL, this only returns the number of seats.
# """
# # int sd_get_seats(char ***seats);

# """
# Get all sessions, store in *sessions. Returns the number of
# sessions. If sessions is NULL, this only returns the number of sessions.
# """
# # int sd_get_sessions(char ***sessions);

# """
# Get all logged in users, store in *users. Returns the number of
# users. If users is NULL, this only returns the number of users.
# """
# # int sd_get_uids(uid_t **users);

# """
# Get all running virtual machines/containers
# """
# # int sd_get_machine_names(char ***machines);

# """
# Monitor object
# """
# # typedef struct sd_login_monitor sd_login_monitor;

# """
# Create a new monitor. Category must be NULL, "seat", "session",
# "uid", or "machine" to get monitor events for the specific category
# (or all).
# """
# # int sd_login_monitor_new(const char *category, sd_login_monitor** ret);

# """
# Destroys the passed monitor. Returns NULL.
# """
# # sd_login_monitor* sd_login_monitor_unref(sd_login_monitor *m);

# """
# Flushes the monitor
# """
# # int sd_login_monitor_flush(sd_login_monitor *m);

# """
# Get FD from monitor
# """
# # int sd_login_monitor_get_fd(sd_login_monitor *m);

# """
# Get poll() mask to monitor
# """
# # int sd_login_monitor_get_events(sd_login_monitor *m);

# """
# Get timeout for poll(), as usec value relative to CLOCK_MONOTONIC's epoch
# """
# int sd_login_monitor_get_timeout(sd_login_monitor *m, uint64_t *timeout_usec);
