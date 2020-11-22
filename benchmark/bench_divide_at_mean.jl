module BenchDivideAtMean
using Random
using BenchmarkTools
using TapirBenchmarks

Random.seed!(1234)

const SUITE = BenchmarkGroup()

for n in [2^20]
    SUITE[:n=>n] = s0 = BenchmarkGroup()
    xs = rand(n)
    s0[:impl=>:seq] = @benchmarkable divide_at_mean_seq($xs)
    s0[:impl=>:threads] = @benchmarkable divide_at_mean_threads($xs)
    s0[:impl=>:tapir] = @benchmarkable divide_at_mean_tapir($xs)
end

end
BenchDivideAtMean.SUITE
