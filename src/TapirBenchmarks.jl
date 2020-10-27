module TapirBenchmarks

export avgfilter1d_seq!,
    avgfilter1d_setup,
    avgfilter1d_tapir_dac!,
    avgfilter1d_tapir_seq!,
    avgfilter1d_threads!,
    avgfilter2d_seq!,
    avgfilter2d_setup,
    avgfilter2d_tapir_dac!,
    avgfilter2d_tapir_seq!,
    avgfilter2d_threads!

using Base: Tapir
using Base.Experimental: Const, @aliasscope
using StaticArrays: SVector

macro grainsize(n::Integer)
    Expr(:loopinfo, (Symbol("tapir.loop.grainsize"), Int(n)))
end

include("avgfilter1d.jl")
include("avgfilter2d.jl")

end
