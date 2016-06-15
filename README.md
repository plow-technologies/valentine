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

All examples assume you have a function displayInt. This uses the ^{} interpolator for static text. The valentine parser is based of indentation and uses no closing tags. All of the expressions are ran through haskell-src-meta so the expression results should be accurate and support most expressions.

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

To parse a haskell expression of LiveVDom you use the !{} interpolator. Using displayInt you can make the value update.

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

This works the same as a LiveVDom expression but works on a JSString instead of LiveVDom

```haskell
displayChangingJSString :: STMEnvelope JSString -> LiveVDom
displayChangingJSString changingString = [valentine|
<div>
    A changing string
    #{changingString}
|]
```

### JSString Expression

To parse an expression with a static JSString there is a ^{} expression.

```haskell
displayStaticString :: JSString -> LiveVDom
displayStaticString staticString = [valentine|
<div>
    Static string
    ^{staticString}
|]
```
