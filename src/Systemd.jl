#!/usr/bin/julia -f

__precompile__(true)

module Systemd

const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depfile)
    include(depfile)
else
    error("Systemd not properly installed. Please run Pkg.build(\"Systemd\")")
end

@noinline raise_system_error(func, err) =
    throw(Main.Base.SystemError(string(func), -err, nothing))
@inline check_error(func, err) = if err < 0
    raise_system_error(func, err)
end

macro sdcall(fname::Symbol, argtypes, args...)
    qfname = QuoteNode(fname)
    quote
        res = ccall(($qfname, libsystemd), Cint,
                    $(esc(argtypes)), $((esc(arg) for arg in args)...))
        check_error($qfname, res)
        res
    end
end

function consume_pstring(_ptr::Ptr, len)
    res = Vector{String}(len)
    ptr = Ptr{Ptr{Cchar}}(_ptr)
    @inbounds for i in 1:len
        res[i] = unsafe_wrap(String, unsafe_load(ptr, i), true)
    end
    Libc.free(ptr)
    res
end

include("daemon.jl")
include("login.jl")

end
