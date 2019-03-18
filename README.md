# elm-history

This library provides a data structure for managing the "History"
of some values. It is useful for making features that are along
the lines of undo and redo. 

[Try it on Ellie][1]

[1]: https://ellie-app.com/52ctv8T5Q2Sa1

```elm
module Main exposing (main)

import Browser exposing (sandbox)
import History exposing (History)
import Html exposing (Html, br, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    History Int


type Msg
    = Increment
    | Decrement
    | TimesFive
    | Redo
    | Undo


init : Model
init =
    History.new 0


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            History.to (History.current model + 1) model

        Decrement ->
            History.to (History.current model - 1) model

        TimesFive ->
            History.to (History.current model * 5) model

        Undo ->
            History.back model

        Redo ->
            History.forward model


view : Model -> Html Msg
view model =
    div []
        [ text (String.fromInt (History.current model))
        , br [] []
        , button [ onClick Increment ] [ text "Increment" ]
        , br [] []
        , button [ onClick Decrement ] [ text "Decrement" ]
        , br [] []
        , button [ onClick TimesFive ] [ text "Time Five" ]
        , br [] []
        , button [ onClick Redo ] [ text "Redo" ]
        , br [] []
        , button [ onClick Undo ] [ text "Undo" ]
        ]


main =
    sandbox { init = init, update = update, view = view }
```