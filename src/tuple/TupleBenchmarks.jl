module TupleBenchmarks

using ..BaseBenchmarks: SUITE
using ..RandUtils
using BenchmarkTools

###############
# issue #5274 #
###############

immutable TupleWrapper{N, T}
    data::NTuple{N, T}
end

Base.eltype{N,T}(::TupleWrapper{N,T}) = T
Base.length{N,T}(::TupleWrapper{N,T}) = N

function get_index(n::NTuple, i::Int)
    @inbounds v = n[i]
    return v
end

function get_index(n::TupleWrapper, i::Int)
    @inbounds v = n.data[i]
    return v
end

function sum_tuple{N, T}(n::Union{NTuple{N, T}, TupleWrapper{N, T}})
    s = zero(T)
    for i in 1:N
        s += get_index(n, i)
    end
    return s
end

const TUPLE_SUM_SIZES = (3, 8, 30, 60)
const TUPLE_SUM_TYPES = (Float32, Float64)

g = newgroup!(SUITE, "tuple indexing", ["tuple", "indexing", "sum"])

for s in TUPLE_SUM_SIZES, T in TUPLE_SUM_TYPES
    tup = tuple(samerand(T, s)...)
    tupwrap = TupleWrapper(tup)
    g["sumelt", "NTuple", s, T] = @benchmarkable sum_tuple($tup)
    g["sumelt", "TupleWrapper", s, T] = @benchmarkable sum_tuple($tupwrap)
end

end # module