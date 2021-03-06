function avgfilter2d_setup(n, w = 3)
    xs = rand(SVector{w,UInt8}, n, n)
    ys = zero(xs)
    return (; ys, xs)
end

# Not sure if it's relevant but intel's benchmark convert `unsigned char` to
# `unsigned int` during the computation:
# https://github.com/neboat/cilkbench/blob/063cba43f2b6276c913d3ad87c7ad3257fd4f813/intel/AveragingFilter_01_07_15/src/AveragingFilter.cpp#L61
@inline u32(x::SVector{S}) where {S} = SVector{S,UInt32}(x)
@inline u8(x::SVector{S}) where {S} = x .% UInt8

#! format: off
@inline function avg3x3(xs0, i, j)
    @static if USE_ALIASSCOPE
        xs = Const(xs0)
    else
        xs = xs0
    end
    y = @inbounds (
        u32(xs[i-1,j-1]) .+ u32(xs[i,j-1]) .+ u32(xs[i+1,j-1]) .+
        u32(xs[i-1,j  ]) .+ u32(xs[i,j  ]) .+ u32(xs[i+1,j  ]) .+
        u32(xs[i-1,j+1]) .+ u32(xs[i,j+1]) .+ u32(xs[i+1,j+1])
    ) .÷ 9
    return u8(y)
end
#! format: on

function avgfilter2d_seq!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    @maybe_aliasscope begin
        for j0 in 0:m-1
            j = firstindex(xs, 2) + j0 + 1
            for i0 in 0:n-1
                i = firstindex(xs, 1) + i0 + 1
                @inbounds ys[i, j] = avg3x3(xs, i, j)
            end
        end
    end
    return ys
end

function avgfilter2d_threads!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    Threads.@threads for j0 in 0:m-1
        @maybe_aliasscope begin
            j = firstindex(xs, 2) + j0 + 1
            for i0 in 0:n-1
                i = firstindex(xs, 1) + i0 + 1
                @inbounds ys[i, j] = avg3x3(xs, i, j)
            end
        end
    end
    return ys
end

function avgfilter2d_tapir_dac!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    @maybe_aliasscope begin
        Tapir.@par dac for j0 in 0:m-1
            j = firstindex(xs, 2) + j0 + 1
            for i0 in 0:n-1
                i = firstindex(xs, 1) + i0 + 1
                @inbounds ys[i, j] = avg3x3(xs, i, j)
            end
            @grainsize 64
        end
    end
    return ys
end

function avgfilter2d_tapir_seq!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    @maybe_aliasscope begin
        Tapir.@par seq for j0 in 0:m-1
            j = firstindex(xs, 2) + j0 + 1
            for i0 in 0:n-1
                i = firstindex(xs, 1) + i0 + 1
                @inbounds ys[i, j] = avg3x3(xs, i, j)
            end
            @grainsize 64
        end
    end
    return ys
end
