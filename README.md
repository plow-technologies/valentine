# Valentine

# Building
```bash
git submodule update --init --recursive
bash ./rebuildSandbox.sh
cabal build
```

# Use

The valentine quasiquoter parsers a hamlet like HTML structure. In the quasiquoters there are expressions to parse different haskell expressions for LiveVDom, STMEnvelope LiveVDom, STMEnvelope (Seq LiveVDom), and

For examples of each of the interpolators, the quasiquoter, and the renderer, there is [an example todo-mvc](https://github.com/plow-technologies/live-vdom-todomvc).

## Expressions

All examples assume you have a function displayInt. This uses the `^{}` interpolator for static text. The valentine parser is based of indentation and uses no closing tags. All of the expressions are ran through haskell-src-meta so the expression results should be accurate and support most expressions.

```haskell
import Data.JSString (pack)
import Valentine
import LiveVDom

displayInt :: Int -> LiveVDom
displayInt i = [valentine|
<p>
    ^{pack $ show x}
|]
```

`displayInt 4` will produce dom looking like:
```html
<p>
    4
</p>
```


### STMEnvelope LiveVDom Expression

To parse a haskell expression of LiveVDom you use the `!{}` interpolator. Using displayInt you can make the value update.

```haskell
displayChangingInt :: STMEnvelope Int -> LiveVDom
displayChangingInt x = [valentine|
<div>
    A changing int
    !{displayInt <$> x}
|]
```

Now, whenever the value of x changes, the dom changes to reflect that change.

This can be use a static expression with a live value through the functor and applicative instances.


### STMEnvelope JSString Expression

`#{}` works the same as a LiveVDom expression but works on a JSString instead of LiveVDom

```haskell
displayChangingJSString :: STMEnvelope JSString -> LiveVDom
displayChangingJSString changingString = [valentine|
<div>
    A changing string
    #{changingString}
|]
```

### JSString Expression

To parse an expression with a static JSString there is a `^{}` expression.

```haskell
displayStaticString :: JSString -> LiveVDom
displayStaticString staticString = [valentine|
<div>
    Static string
    ^{staticString}
|]
```

### Embedded Static LiveVDom

Use `${}` to parse LiveVDom which does not have an STMEnvelope as a parameter.
```haskell
x :: LiveVDom
x = [valetine|
<div>
  ${y}
|]

y :: LiveVDom
y = [valentine|
<div>
  Hello World!
|]
```

### Iterate over dynamic sequence of elements

Three things are required: 
 - a `STMMailbox (S.Seq a)` which is collection/sequence/list of elements which may change
 - `&{forEach seq seqItemFunction}`
 - `seqItemFunction :: a -> (Maybe a -> Message ()) -> LiveVDom`
```
data Foo = Foo {
  x :: Int
, y :: JSString
}

displayFoos :: STMMailbox (S.Seq Foo) -> LiveVDom
displayFoos fooMb = [valentine|
<div>
  Foos:
  &{forEach fooMb displayFoo}
|]

-- pay attention to the type signature
-- refer to forEach in LiveVDom
displayFoo :: Foo -> (Maybe Foo -> Message ()) -> LiveVDom
displayFoo foo _ = [valentine|
<div>
  <span>
    ^{show $ x foo}
  <span>
    ^{y foo}
|]
```

### Perform operations on STMMailbox as a single item (at the S.Seq level)

Three things are required: 
 - a `STMMailbox (S.Seq a)` which is collection/sequence/list of elements which may change
 - `!{withMailbox seq seqFunction}`
 - `seqFunction :: (S.Seq a) -> (S.Seq a -> Message ()) -> LiveVDom`
```
import Data.JSString (pack)

data Foo = Foo {
  x :: Int
, y :: JSString
}

displayFoos :: STMMailbox (S.Seq Foo) -> LiveVDom
displayFoos fooMb = [valentine|
<div>
  Number of Foos:
  !{withMailbox fooMb getSize}
|]

-- pay attention to the type signature
-- refer to forEach in LiveVDom
getSize :: (S.Seq Foo) -> (S.Seq Foo -> Message ()) -> LiveVDom
getSize foos _ = [valentine|
<div>
  ^{pack $ show $ S.length foos}
|]
```

