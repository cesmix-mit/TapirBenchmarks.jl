module TapirBenchmarks

export
    avgfilter1d_seq!,
    avgfilter1d_setup,
    avgfilter1d_tapir_dac!,
    avgfilter1d_tapir_seq!,
    avgfilter1d_threads!

using Base: Tapir

macro grainsize(n::Integer)
    Expr(:loopinfo, (Symbol("tapir.loop.grainsize"), Int(n)))
end

include("avgfilter1d.jl")

end
