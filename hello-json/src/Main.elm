module Main exposing (..)

import Browser
import Html
import Http
import Json.Decode
import RemoteData exposing (RemoteData)


main : Program () Model Msg
main =
    Browser.element
        { init = initModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initModel : () -> ( Model, Cmd Msg )
initModel _ =
    ( { result = RemoteData.NotAsked }, getTitle )


type alias Model =
    { result : RemoteData Http.Error String
    }


view : Model -> Html.Html msg
view model =
    case model.result of
        RemoteData.Failure error ->
            Html.text (getErrorMessage error)

        RemoteData.Success title ->
            Html.text title

        RemoteData.Loading ->
            Html.text "Loading.."

        RemoteData.NotAsked ->
            Html.text "where everything starts"


getErrorMessage : Http.Error -> String
getErrorMessage errorDetail =
    case errorDetail of
        Http.NetworkError ->
            "Connection Error"

        Http.BadStatus errorStatus ->
            "invalid server responese" ++ String.fromInt errorStatus

        Http.Timeout ->
            "Request time out"

        Http.BadUrl reasonError ->
            "Url is invalid" ++ reasonError

        Http.BadBody invalidData ->
            "invalid Data" ++ invalidData


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MsgGotTitle result ->
            ( { model | result = result }, Cmd.none )


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none


type Msg
    = MsgGotTitle (RemoteData Http.Error String)


getTitle : Cmd Msg
getTitle =
    Http.get
        { url = "https://my-json-server.typicode.com/typicode/demo/posts/1"
        , expect = Http.expectJson upgradeToRemoteData dataTitleDecoder
        }


upgradeToRemoteData : Result Http.Error String -> Msg
upgradeToRemoteData result =
    MsgGotTitle (RemoteData.fromResult result)


dataTitleDecoder : Json.Decode.Decoder String
dataTitleDecoder =
    Json.Decode.field "title" Json.Decode.string
