# elm-history

This library provides a data structure for managing the "History"
of some values. It is useful for making features that are along
the lines of undo and redo. 


```elm
import History exposing (History)
import Browser exposing (sandbox)
import Html exposing (text)

type alias Model = History Int
type alias Msg = Increment
               | Decrement
               | Redo
               | Undo

init : Model
init =
    History.new 0

update : Msg -> Model -> Html Msg
update msg model =
    case msg of
        Increment ->
            History.to ((History.current model) + 1) model
        Decrement ->
            History.to ((History.current model) - 1) model
        Undo ->
            History.back model
        Redo ->
            History.forward model
     
view = text (String.fromInt <| History.current model)

main = sandbox { init = init, update = update, view = view }
```