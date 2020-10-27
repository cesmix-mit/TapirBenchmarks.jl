module TestAvgFilter2D

using TapirBenchmarks
using Test

@testset for n in [3, 5, 100, 2^10]
    ys0, xs = avgfilter2d_setup(n)
    ys1 = avgfilter2d_seq!(copy(ys0), xs)
    @test avgfilter2d_threads!(copy(ys0), xs) == ys1
    @test avgfilter2d_tapir_dac!(copy(ys0), xs) == ys1
    @test avgfilter2d_tapir_seq!(copy(ys0), xs) == ys1
end

end
