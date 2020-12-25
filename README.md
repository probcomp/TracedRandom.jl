# TracedRandom.jl

Allows for the optional specification of traced addresses (i.e. variable names)
in calls to `rand` and other primitive functions in `Random`. Providing this
information allows ordinary Julia code to be "probabilistic-programming-ready".

```julia
julia> rand(:u, Float64, 10)
0.6807722985442752

julia> randn(:z, 3)
3-element Array{Float64,1}:
 -0.39256954974212915
 -0.8048893694012202
 -1.0272306373097992

julia> randperm(:perm)
4-element Array{Int64,1}:
 1
 3
 2
 4
```

In addition, a call to some `fn::Function` can be annotated with an address
by wrapping it in `rand` call:
```julia
julia> gaussian_mixture(μs) = randn(:z) + μs[rand(:k, 1:length(μs))]
julia> rand(:x, gaussian_mixture, [1, 10])
9.594800995267331
```

By default, the addresses (`:x`, `:z`, `:k` and `:perm` in the examples above)
are ignored, but they can be intercepted via meta-programming
(see [`Genify.jl`](https://github.com/probcomp/Genify.jl)) to support inference
in probabilistic programming systems such as [`Gen`](https://www.gen.dev/).
Addresses can be specified as `Symbol`s, or as pairs from symbols
to other types (`Pair{Symbol,<:Any}`).
