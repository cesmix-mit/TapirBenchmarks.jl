module BenchMeanVar
using Random
using BenchmarkTools
using TapirBenchmarks

Random.seed!(1234)

const SUITE = BenchmarkGroup()

for n in [2^20]
    SUITE[:n=>n] = s0 = BenchmarkGroup()
    xs = randn(n)
    s0[:impl=>:seq] = @benchmarkable meanvar_seq($xs)
    s0[:impl=>:threads] = @benchmarkable meanvar_threads($xs)
    s0[:impl=>:tapir] = @benchmarkable meanvar_tapir($xs)
end

end
BenchMeanVar.SUITE
