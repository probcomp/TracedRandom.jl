# TracedRandom.jl

Allows for the optional specification of traced addresses (i.e. variable names)
in calls to `rand` and other primitive functions in `Random`:

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

By default, the addresses (`:x`, `:z` and `:perm` in the examples above)
are ignored, but they can be intercepted via meta-programming by
probabilistic programming systems such as [`Gen`](https://www.gen.dev/) and
[`Jaynes`](https://femtomc.github.io/Jaynes.jl/) in order to perform inference
over the addressed random variables. Addresses can be specified as `Symbol`s,
or as pairs from symbols to other types (`Pair{Symbol,<:Any}`).
