function avgfilter2d_setup(n)
    xs = rand(UInt8, n, n)
    ys = zero(xs)
    return (; ys, xs)
end

#! format: off
@inline function avg3x3(xs0, i, j)
    # xs = Const(xs0)
    xs = xs0
    @inbounds (
        xs[i-1,j-1] + xs[i,j-1] + xs[i+1,j-1] +
        xs[i-1,j  ] + xs[i,j  ] + xs[i+1,j  ] +
        xs[i-1,j+1] + xs[i,j+1] + xs[i+1,j+1]
    ) ÷ 9
end
#! format: on

function avgfilter2d_seq!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    # @aliasscope begin
    begin
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
        # @aliasscope begin
        begin
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
    GC.@preserve ys xs begin  # TODO: don't use preserve
        # @aliasscope begin
        begin
            Tapir.@par dac for j0 in 0:m-1
                j = firstindex(xs, 2) + j0 + 1
                for i0 in 0:n-1
                    i = firstindex(xs, 1) + i0 + 1
                    @inbounds ys[i, j] = avg3x3(xs, i, j)
                end
                @grainsize 1024
            end
        end
    end
    return ys
end

function avgfilter2d_tapir_dac_nopreserve!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    begin
        # @aliasscope begin
        begin
            Tapir.@par dac for j0 in 0:m-1
                j = firstindex(xs, 2) + j0 + 1
                for i0 in 0:n-1
                    i = firstindex(xs, 1) + i0 + 1
                    @inbounds ys[i, j] = avg3x3(xs, i, j)
                end
                @grainsize 1024
            end
        end
    end
    return ys
end

function avgfilter2d_tapir_seq!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = size(xs)[1] - 2
    m = size(xs)[2] - 2
    GC.@preserve ys xs begin  # TODO: don't use preserve
        # @aliasscope begin
        begin
            Tapir.@par seq for j0 in 0:m-1
                j = firstindex(xs, 2) + j0 + 1
                for i0 in 0:n-1
                    i = firstindex(xs, 1) + i0 + 1
                    @inbounds ys[i, j] = avg3x3(xs, i, j)
                end
                @grainsize 1024
            end
        end
    end
    return ys
end
