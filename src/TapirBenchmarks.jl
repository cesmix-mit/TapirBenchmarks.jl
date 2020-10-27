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
using Base.Experimental: Const
using StaticArrays: SVector

macro grainsize(n::Integer)
    Expr(:loopinfo, (Symbol("tapir.loop.grainsize"), Int(n)))
end

let configpath = joinpath(@__DIR__, "config.jl"),
    defaultpath = joinpath(@__DIR__, "default-config.jl")

    if !isfile(configpath)
        cp(defaultpath, configpath)
    end
end
include("config.jl")

if USE_ALIASSCOPE
    const var"@maybe_aliasscope" = Base.Experimental.var"@aliasscope"
else
    macro maybe_aliasscope(ex)
        esc(ex)
    end
end

include("avgfilter1d.jl")
include("avgfilter2d.jl")

end
