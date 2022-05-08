module Main exposing (..)

import Browser
import Html
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)


initModel : Model
initModel =
    { message = "welcomoe"
    , firstname = Nothing
    , age = Nothing
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }


type Msg
    = MsgSurprise
    | MsgReset
    | MsgNewName String
    | MsgNewAgeAsString String


type alias Model =
    { message : String
    , firstname : Maybe String
    , age : Maybe Int
    }


maybeDefaultEmptyString : Maybe String -> String
maybeDefaultEmptyString maybeString =
    Maybe.withDefault "" maybeString


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ viewMessage model.message
        , viewFirstnameInput model.firstname
        , viewAgeInput model.age
        , viewSupriseButton
        , viewResetButton
        , viewLength model.firstname
        ]


viewMessage : String -> Html.Html Msg
viewMessage message =
    Html.text message


viewFirstnameInput : Maybe String -> Html.Html Msg
viewFirstnameInput firstname =
    Html.input [ onInput MsgNewName, placeholder "please input your name", value (maybeDefaultEmptyString firstname) ] []



viewAgeInput : Maybe Int -> Html.Html Msg
viewAgeInput age =
    Html.input [ onInput MsgNewAgeAsString, value (String.fromInt (Maybe.withDefault 0 age)) ] []


viewSupriseButton : Html.Html Msg
viewSupriseButton =
    Html.button [ onClick MsgSurprise ] [ Html.text "Suprise" ]


viewResetButton : Html.Html Msg
viewResetButton =
    Html.button [ onClick MsgReset ] [ Html.text "reset" ]


viewLength : Maybe String -> Html.Html msg
viewLength aString =
    Html.text (String.fromInt (String.length (maybeDefaultEmptyString aString)))


update : Msg -> Model -> Model
update msg model =
    case msg of
        MsgSurprise ->
            case model.age of
                Just aAge ->
                    case model.firstname of
                        Just aName ->
                            { model
                                | message = "Happy Birthday?" ++ " " ++ aName ++ " to age of " ++ String.fromInt aAge
                            }

                        Nothing ->
                            { model
                                | message = "Firstname is required"
                            }

                Nothing ->
                    { model
                        | message = "age is required"
                    }

        MsgReset ->
            initModel

        MsgNewName newName ->
            if String.trim newName == "" then
                { model
                    | firstname = Nothing
                }

            else
                { model
                    | firstname = Just newName
                }

        MsgNewAgeAsString newValue ->
            case String.toInt newValue of
                Just anInt ->
                    { model
                        | age = Just anInt
                    }

                Nothing ->
                    { model
                        | age = Nothing
                        , message = "invalid age"
                    }
