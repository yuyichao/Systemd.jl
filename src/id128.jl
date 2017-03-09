#
# 128-bit ID APIs. See `sd-id128(3)` for more information.

const STRING_MAX = 33

struct ID128
    v1::Int64
    v2::Int64
    ID128(v1, v2) = new(v1, v2)
    function ID128(str::AbstractString)
        ref = Ref{ID128}()
        @sdcall(sd_id128_from_string, (Cstring, Ptr{ID128}),
                str, ref)
        return ref[]
    end
end

const ID128_NULL = ID128(0, 0)

function Base.show(io::IO, id128::ID128)
    s = Vector{Int8}(STRING_MAX - 1)
    ccall((:sd_id128_to_string, libsystemd), Ptr{Void},
          (ID128, Ptr{Int8}), id128, s)
    write(io, s)
end

function Base.rand(::Type{ID128})
    ref = Ref{ID128}()
    @sdcall(sd_id128_randomize, (Ptr{ID128},), ref)
    return ref[]
end

function get_machine()
    ref = Ref{ID128}()
    @sdcall(sd_id128_get_machine, (Ptr{ID128},), ref)
    return ref[]
end

function get_boot()
    ref = Ref{ID128}()
    @sdcall(sd_id128_get_boot, (Ptr{ID128},), ref)
    return ref[]
end
