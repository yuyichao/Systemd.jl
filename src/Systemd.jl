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

include("daemon.jl")
include("login.jl")

end
