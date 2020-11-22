module DummyTapir
using Base.Threads: @spawn
const Output = Ref{Any}
end

module TapirFolds
using Base: Tapir
include("folds_impl.jl")
end

module ThreadsFolds
using ..TapirBenchmarks: DummyTapir
const Tapir = DummyTapir
include("folds_impl.jl")
end
