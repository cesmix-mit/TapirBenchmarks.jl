module TapirBenchmarks

export avgfilter1d_seq!,
    avgfilter1d_setup,
    avgfilter1d_constprop_seq!,
    avgfilter1d_constprop_setup,
    avgfilter1d_constprop_tapir_dac!,
    avgfilter1d_constprop_tapir_seq!,
    avgfilter1d_constprop_threads!,
    avgfilter1d_tapir_dac!,
    avgfilter1d_tapir_seq!,
    avgfilter1d_threads!,
    avgfilter2d_seq!,
    avgfilter2d_setup,
    avgfilter2d_tapir_dac!,
    avgfilter2d_tapir_seq!,
    avgfilter2d_threads!,
    divide_at_mean_seq,
    divide_at_mean_tapir,
    divide_at_mean_threads,
    meanvar_seq,
    meanvar_tapir,
    meanvar_threads

using Base: Tapir
using Base.Experimental: Const
using StaticArrays: SVector
using Statistics: mean, var

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

include("folds.jl")

include("avgfilter1d.jl")
include("avgfilter2d.jl")
include("avgfilter1d_constprop.jl")
include("meanvar.jl")
include("divide_at_mean.jl")
include("divide_at_mean_with_map.jl")

end
