module History exposing
    ( History
    , new, fromList
    , forward, back, current, to
    , map
    )

{-| This library gives you a way to manage a series of values where you are only interested in one
value at a time and are interested in potentially revisiting previous values.

The provided data structure is referred to here as a "History", although it is more often referred to as
a ["Zip List"][2]. This is meant to provide you with a better idea of what you can effectively use this
library for. Namely, you can use this data structure to power any feature that fits the pattern of
"undo" and "redo".

A History behaves similarly to how a web browser's back and forward buttons work. If you click a link in a browser
(move the history "to" a new location), then the forward button will no longer work and you will only be able
to move back. If you don't click any links, you can go back and forward as much as you want and you wont affect
the overall "structure" of the History.

For more insights on why you might want to use this data structure, I highly recommend watching [this talk][1].

If you are here looking for a way to manage the actual history of a web browser, you should instead
be looking at the [elm/Browser][3] package.

[1]: https://www.youtube.com/watch?v=IcgmSRJHu_8
[2]: https://en.wikipedia.org/wiki/Zipper_(data_structure)
[3]: https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#pushUrl


# The Data Structure

@docs History


# Create

@docs new, fromList


# Maneuvering

@docs forward, back, current, to


# Transform

@docs map

-}


{-| A "History" of values.
-}
type History a
    = History
        { back : List a
        , forward : List a
        , current : a
        }


{-| Creates a new History, starting with the given value.
-}
new : a -> History a
new startWith =
    History { back = [], forward = [], current = startWith }


{-| Creates a history from a list. Treats the first element in the list as the present state
and all the other items as the states that occurred in the past. If the list is empty, then no History will be produced.
-}
fromList : List a -> Maybe (History a)
fromList list =
    case list of
        first :: rest ->
            Just (History { back = rest, forward = [], current = first })

        [] ->
            Nothing


{-| Moves forward in the history. If there are no values in the future
then there is no change. This is synonymous with a "redo" operation.
-}
forward : History a -> History a
forward (History store) =
    History <|
        case store.forward of
            first :: rest ->
                { back = store.current :: store.back
                , forward = rest
                , current = first
                }

            [] ->
                store


{-| Moves backward in the history. If there are no past values
then there is no change. This is synonymous with an "undo" operation.
-}
back : History a -> History a
back (History store) =
    History <|
        case store.back of
            first :: rest ->
                { back = rest
                , forward = store.current :: store.forward
                , current = first
                }

            [] ->
                store


{-| Gets the current value in the History.
-}
current : History a -> a
current (History store) =
    store.current


{-| Moves the History to a new value. This will erase anything in the future.
Think of it like time travel: If you go back in time and change what happens next,
all your knowledge of the future is now irrelevant.
-}
to : History a -> a -> History a
to (History store) next =
    History <|
        { back = store.current :: store.back
        , forward = []
        , current = next
        }


{-| Maps a function over all the values in the history.
-}
map : (a -> b) -> History a -> History b
map function (History store) =
    History <|
        { back = List.map function store.back
        , forward = List.map function store.forward
        , current = function store.current
        }
