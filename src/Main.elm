module Main exposing (..)

import Browser
import Form exposing (Form)
import Form.View
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src, start)



---- MODEL ----


type alias Model =
    Form.View.Model InputValues


type alias InputValues =
    { start : Maybe Float
    , end : Maybe Float
    }


type alias Interval =
    { start : Maybe Float
    , end : Maybe Float
    }


startField : Form { a | start : Maybe Float } (Maybe Float)
startField =
    Form.numberField
        { parser = Ok
        , value = .start
        , update = \value values -> { values | start = value }
        , attributes =
            { label = "Start"
            , placeholder = "0"
            , step = 1
            , min = Nothing
            , max = Nothing
            }
        }


endField : Form { a | end : Maybe Float } (Maybe Float)
endField =
    Form.numberField
        { parser = Ok
        , value = .end
        , update = \value values -> { values | end = value }
        , attributes =
            { label = "End"
            , placeholder = "0"
            , step = 1
            , min = Nothing
            , max = Nothing
            }
        }


form : Form InputValues Interval
form =
    Form.succeed
        (\start end ->
            Interval start end
        )
        |> Form.append startField
        |> Form.append endField


init : Form.View.Model { start : Maybe Float, end : Maybe Float }
init =
    Form.View.idle
        { start = Just 0
        , end = Just 0
        }



---- UPDATE ----


type Msg
    = FormChanged (Form.View.Model InputValues)
    | AddInterval Interval


update : Msg -> Model -> Model
update msg model =
    case msg of
        FormChanged newForm ->
            newForm

        AddInterval _ ->
            model



---- VIEW ----


view : Model -> Html Msg
view model =
    Form.View.asHtml
        { onChange = FormChanged
        , action = "Add Interval"
        , loading = "Adding Interval"
        , validation = Form.View.ValidateOnSubmit
        }
        (Form.map AddInterval form)
        model



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view
        , init = init
        , update = update
        }
