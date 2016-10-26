#

type Bus
    ptr::Ptr{Void}
    function Bus()
        self = new()
        @sdcall(sd_bus_new, (Ref{Bus},), bus)
        finalizer(self, unref)
        return self
    end
    function Bus(::Void)
        self = new(C_NULL)
        finalizer(self, unref)
        return self
    end
end

Base.cconvert(::Type{Ptr{Void}}, bus::Bus) = bus
function Base.unsafe_convert(::Type{Ptr{Void}}, bus::Bus)
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

function bus_default()
    bus = Bus(nothing)
    @sdcall(sd_bus_default, (Ref{Bus},), bus)
    return bus
end

function bus_default_user()
    bus = Bus(nothing)
    @sdcall(sd_bus_default_user, (Ref{Bus},), bus)
    return bus
end

function bus_default_system()
    bus = Bus(nothing)
    @sdcall(sd_bus_default_system, (Ref{Bus},), bus)
    return bus
end

function bus_open()
    bus = Bus(nothing)
    @sdcall(sd_bus_open, (Ref{Bus},), bus)
    return bus
end

function bus_open_user()
    bus = Bus(nothing)
    @sdcall(sd_bus_open_user, (Ref{Bus},), bus)
    return bus
end

function bus_open_system()
    bus = Bus(nothing)
    @sdcall(sd_bus_open_system, (Ref{Bus},), bus)
    return bus
end

function bus_open_system_remote(host)
    bus = Bus(nothing)
    @sdcall(sd_bus_open_system_remote, (Ref{Bus}, Cstring), bus, host)
    return bus
end

function bus_open_system_machine(machine)
    bus = Bus(nothing)
    @sdcall(sd_bus_open_system_machine, (Ref{Bus}, Cstring), bus, machine)
    return bus
end

function bus_start(bus::Bus)
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
    return unsafe_wrap(String, address[], true)
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

function set_bus_client(bus::Bus, b::Bool)
    @sdcall(sd_bus_set_bus_client, (Ptr{Void}, Cint), bus, b)
    return
end
is_bus_client(bus::Bus) = @sdcall(sd_bus_is_bus_client, (Ptr{Void},), bus) != 0

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
    return unsafe_wrap(String, desc[], true)
end
