# Mission 6, sample answers for the variance challenge

Do not distribute. This mission is open ended by design, so there's no
single correct answer. Below are two valid solutions and the minimum bar
to look for.

## The prompt, as a reminder

Design an EBNF rule for `Manifest`, a generic cargo container that takes
a type parameter with an optional covariance or contravariance modifier
at declaration time, and that can be instantiated with a concrete type
such as `Manifest[FuelUnit]` or `Manifest[+FuelUnit]`.

Then explain in three or four lines how the rule would extend to two type
parameters with different modifiers, the way `Transformer[-In,+Out]`
works in Snippet 3 of Project 1, without writing that rule out in full.

## Sample answer A, with a separate Variance nonterminal

```
Manifest ::= "Manifest" "[" TypeParam "]"
TypeParam ::= Variance? ID
Variance ::= "+" | "-"
```

## Sample answer B, with the variance folded inline

```
Manifest ::= "Manifest" "[" plus-or-minus? ID "]"
```

where plus-or-minus stands for a choice between "+" and "-".

Both are correct. B is more compact. A separates the idea of variance
into something reusable, which pays off once you need to declare more
than one parameter.

## The two parameter extension students should describe

The key idea to look for in their explanation is that the list of type
parameters becomes a comma separated sequence of individual type
parameters, each with its own independent optional modifier.

```
TypeParams ::= TypeParam, then zero or more of a comma followed by
TypeParam
```

Or, closer to Project 1's fixed two parameter shape with distinct roles,
as in `Transformer[-In,+Out]`:

```
Transformer ::= "Transformer" "[" TypeParam "," TypeParam "]"
```

## An insight worth using as a level three hint

In Snippet 1 of Project 1, the variance modifier shows up at declaration,
as in `object List[+A](val item: A)`, but not at the point of use, as in
`List[Dog]` with no plus sign. A correct design for `Manifest` should
reflect that same asymmetry: the rule for declaring a generic object
needs the optional modifier, while the rule for instantiating or using a
generic type usually only needs the concrete type, with no modifier. If a
group reuses the same rule for both declaration and use, that's not
necessarily a serious error for this mission, since they weren't
explicitly asked to separate the two, but it's worth raising during the
wrap up.

## Rubric specific to this mission

The variance modifier is optional, using `?` or an equivalent empty
alternative, not mandatory. There's a real choice between plus and minus,
not just one of the two hard coded. Instantiation with a concrete type is
represented in some form, even informally. The explanation of the two
parameter extension follows logically from their own one parameter rule
rather than inventing an unrelated structure. As a bonus, they notice or
come close to noticing the asymmetry between declaration and use.
