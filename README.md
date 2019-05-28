# Introduction
I got some idea of building a new crypto-system based on [Permutation Groups](https://en.wikipedia.org/wiki/Permutation_group), e.g. [`S₄`](https://en.wikiversity.org/wiki/Symmetric_group_S4), where 4 denotes the max integer in the group, yielding numbers in the `S = {1, 2, 3, 4}`.

For a given group `Sᵣ`, where `ᵣ` is the max integer, the *order* (number of elements, i.e. permutatins) of this group is `r!` (factorial).

# Private key
The private key is an element in the group `Sᵣ`, i.e. a permutation. To create this integer we could define

```math
r is the max integer of S_r
GenBits(x): safely generates a bit array of length x
ScalarInSet(i, S): returns scalar at index i, in the Sᵣ = { 1, ..., ᵣ}
KeyGen(): m := GenBits(r), m.forEach { if $0 == 0 { include } }
```