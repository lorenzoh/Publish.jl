# # Cells in Literate Julia
#
# The `{:cell}` syntax for [executable cells](#) is not limited to just
# markdown files. It will work the same across other source types as well.
# This page illustrates this using literate Julia.
#
# To use cells in a Julia file just add `{:cell}` at the end of a comment block
# before the code that you would like to be evaluated. Like so:
#
# {:cell}

f(x) = x + 1
f(1)

# The cells behave the same across all source types and so you will need to
# provide named cells to be able to share values between cells.
#
# {cell=example}

f(x::Integer) = x - 1
length(methods(f))

# As we can see above the function `f` only has 1 method defined since it does
# not know about the previous cell. Below we will define another cell but use
# the same name as before so that we can access it's definitions.
#
# {cell=example}

f(1)

# When the resulting value is all that you care about when writing a cell use
# can just discard the output stream and the cell itself using a little CSS
# by adding a `style="display: none"` to the cell. For example below we use
# the attributes `{cell=example output=false style="display: none"}` to hide
# all but the result. The cell content below is `methods(f)`:
#
# {cell=example output=false style="display: none"}

methods(f)

# Finally, we can also create types that have a `show` method defined for
# `text/markdown`. This allows us to embed arbitrary generated markdown
# within a parent document.
#
# {cell=embedded}

struct Boldify
    x
end

Base.show(io::IO, ::MIME"text/markdown", b::Boldify) = print(io, "**", b.x, "**")

Boldify("This text will appear in bold.")

# {cell=embedded style="display: none"}

using Markdown

# Inline cells are also possible. The source that produces them will not be
# displayed though, only the resulting value. `stdout` and `stderr` will not
# show either. If the resulting value can be displayed as `text/markdown` it's
# AST will be embedded, like above with the block cells, otherwise it will
# appear as a ```md"`text/plain`"```{cell=embedded} wrapped in inline code. The
# previous `text/plain` was embedded in the resulting AST using an inline cell
# that evaluted the expression ```Markdown.md"`text/plain`"```. Values, such as
# `1+2`{:cell} or `pi`{:cell}, will just display as inline code.
