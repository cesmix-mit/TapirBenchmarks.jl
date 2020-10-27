module BenchAvgFilter2D

import Random
using BenchmarkTools
using TapirBenchmarks

Random.seed!(1234)

const SUITE = BenchmarkGroup()

for n in [2^13, 2^15]
    SUITE[:n=>n] = s0 = BenchmarkGroup()
    ys0, xs = avgfilter2d_setup(n)
    s0[:impl=>:seq] = @benchmarkable avgfilter2d_seq!($(copy(ys0)), $xs)
    s0[:impl=>:threads] = @benchmarkable avgfilter2d_threads!($(copy(ys0)), $xs)
    s0[:impl=>:tapir_dac] = @benchmarkable avgfilter2d_tapir_dac!($(copy(ys0)), $xs)
    # s0[:impl=>:tapir_seq] = @benchmarkable avgfilter2d_tapir_seq!($(copy(ys0)), $xs)
end

end
BenchAvgFilter2D.SUITE
