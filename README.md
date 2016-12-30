# Valentine

# Building
```bash
git submodule update --init --recursive
bash ./rebuildSandbox.sh
cabal build
```

# Use

The valentine quasiquoter parsers a hamlet like HTML structure. There is a single interpolater for haskell expressions that works on the ToDesc typeclass.

For examples of each of the interpolators, the quasiquoter, and the renderer, there is [an example todo-mvc](https://github.com/plow-technologies/live-vdom-todomvc).

## Expressions

All examples assume you have a function displayInt. This uses the interpolator for static text. The valentine parser is based of indentation and uses no closing tags. All of the expressions are ran through haskell-src-meta so the expression results should be accurate and support most expressions.

```haskell
import Data.JSString (pack)
import Valentine
import Desc Identity ()

displayInt :: Int -> Desc Identity ()
displayInt i = [valentine|
<p>
    ${pack $ show x}
|]
```

`displayInt 4` will produce dom looking like:
```html
<p>
    4
</p>
```


### STMEnvelope (Desc m ()) Expression

To parse a haskell expression of Desc Identity () you use the interpolator again. Using displayInt you can make the value update.

```haskell
displayChangingInt :: STMEnvelope Int -> Desc Identity ()
displayChangingInt x = [valentine|
<div>
    A changing int
    ${displayInt <$> x}
|]
```

Now, whenever the value of x changes, the dom changes to reflect that change.

This can be use a static expression with a live value through the functor and applicative instances.


### STMEnvelope JSString Expression

The interpolator works the same as a Desc Identity () expression but works on a JSString instead of Desc Identity ()

```haskell
displayChangingJSString :: STMEnvelope JSString -> Desc Identity ()
displayChangingJSString changingString = [valentine|
<div>
    A changing string
    ${changingString}
|]
```

### JSString Expression

To parse an expression with a static JSString there is a `^{}` expression.

```haskell
displayStaticString :: JSString -> Desc Identity ()
displayStaticString staticString = [valentine|
<div>
    Static string
    ^{staticString}
|]
```

### Embedded Static Desc Identity ()

Use the interpolator to parse Desc Identity () which does not have an STMEnvelope as a parameter.
```haskell
x :: Desc Identity ()
x = [valetine|
<div>
  ${y}
|]

y :: Desc Identity ()
y = [valentine|
<div>
  Hello World!
|]
```

### Iterate over dynamic sequence of elements

Three things are required: 
 - a `STMMailbox (S.Seq a)` which is collection/sequence/list of elements which may change
 - `&{forEach seq seqItemFunction}`
 - `seqItemFunction :: a -> (Maybe a -> Message ()) -> Desc Identity ()`

```haskell
data Foo = Foo {
  x :: Int
, y :: JSString
}

displayFoos :: STMMailbox (S.Seq Foo) -> Desc Identity ()
displayFoos fooMb = [valentine|
<div>
  Foos:
  &{forEach fooMb displayFoo}
|]

-- pay attention to the type signature
-- refer to forEach in Desc Identity ()
displayFoo :: Foo -> (Maybe Foo -> Message ()) -> Desc Identity ()
displayFoo foo _ = [valentine|
<div>
  <span>
    ${show $ x foo}
  <span>
    ${y foo}
|]
```

### Perform operations on STMMailbox as a single item (at the S.Seq level)

Three things are required: 
 - a `STMMailbox (S.Seq a)` which is collection/sequence/list of elements which may change
 - `!{withMailbox seq seqFunction}`
 - `seqFunction :: (S.Seq a) -> (S.Seq a -> Message ()) -> Desc Identity ()`

```haskell
import Data.JSString (pack)

data Foo = Foo {
  x :: Int
, y :: JSString
}

displayFoos :: STMMailbox (S.Seq Foo) -> Desc Identity ()
displayFoos fooMb = [valentine|
<div>
  Number of Foos:
  ${withMailbox fooMb getSize}
|]

-- pay attention to the type signature
-- refer to forEach in Desc Identity ()
getSize :: (S.Seq Foo) -> (S.Seq Foo -> Message ()) -> Desc Identity ()
getSize foos _ = [valentine|
<div>
  ${pack $ show $ S.length foos}
|]
```

