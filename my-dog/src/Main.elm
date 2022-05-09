module Main exposing (..)

-- import Element.Border as EB -> Aliasing
-- import Html (..) -> alles Expsoing -> nicht empfholen nur exposing was notwendig ist
-- am besten/klarsten exposing  pro modul und einzeln verwenden so wird der Code klar und es ist klar aus welchem modul welcher Befehl kommt (halt etwas mehr schreibarbeit eim import)

import Browser
import Element
    exposing
        ( Color
        , alignRight
        , centerX
        , column
        , fill
        , focusStyle
        , image
        , layoutWith
        , maximum
        , mouseOver
        , padding
        , paddingEach
        , paddingXY
        , paragraph
        , rgb255
        , text
        , width
        )
        
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = darkModeColors
        , view = viewLayout
        , update = update
        }


type alias Model =
    { primaryDark : Color
    , primaryLight : Color
    , secondaryLight : Color
    , secondaryDark : Color
    , secondary : Color
    , primary : Color
    , textOnPrimary : Color
    , textOnSecondary : Color
    }


type Msg
    = MsgChangeColorMode


update : Msg -> Model -> Model



-- _ bedeutet hier wäre eigentlich ein Argumdent, jedoch wird es im Block nicht verwendet und daher auch keinen Nutzen -> damit es nicht unterwellt ist (optische Kontrolle)


update _ model =
    if model.primary == darkModeColors.primary then
        lightModeColors

    else
        darkModeColors


viewLayout : Model -> Html Msg
viewLayout model =
    layoutWith
        { options =
            [ focusStyle
                { backgroundColor = Nothing
                , borderColor = Just model.primaryDark
                , shadow = Nothing
                }
            ]
        }
        [ Background.color model.primaryLight
        , padding 22
        ]
        (column []
            [ viewTitle model
            , buttonChangeColorMode model
            , viewSubtitle model
            , dogImage
            , viewContent model
            ]
        )



-- https://material.io


lightModeColors : Model
lightModeColors =
    { primary = rgb255 0x82 0xB1 0xFF
    , primaryLight = rgb255 0xB6 0xE3 0xFF
    , primaryDark = rgb255 0x4D 0x82 0xCB
    , secondary = rgb255 0xFF 0x8A 0x80
    , secondaryLight = rgb255 0xFF 0xBC 0xAF
    , secondaryDark = rgb255 0xC8 0x5A 0x54
    , textOnPrimary = rgb255 0x00 0x00 0x00
    , textOnSecondary = rgb255 0x00 0x00 0x00
    }


darkModeColors : Model
darkModeColors =
    { secondary = rgb255 0x82 0xB1 0xFF
    , secondaryLight = rgb255 0xB6 0xE3 0xFF
    , secondaryDark = rgb255 0x4D 0x82 0xCB
    , primary = rgb255 0xFF 0x8A 0x80
    , primaryLight = rgb255 0xFF 0xBC 0xAF
    , primaryDark = rgb255 0xC8 0x5A 0x54
    , textOnPrimary = rgb255 0x00 0x00 0x00
    , textOnSecondary = rgb255 0x00 0x00 0x00
    }



-- Element.Attribte Type bedeutet das es sich um einen Atrribute von ELM ui handelt welches in einem Element genutzt werden kann.
-- msg kann auch Signals enthalten (Messages z. B. onClick etc..)


fontTippa : Element.Attribute msg
fontTippa =
    Font.family [ Font.typeface "Tippa" ]


viewTitle : Model -> Element.Element msg
viewTitle model =
    paragraph
        [ Region.heading 1
        , Font.bold
        , Font.color model.primaryDark
        , fontTippa
        , Font.size 48
        ]
        [ text "My dog"
        ]


dogImage : Element.Element msg
dogImage =
    image
        [ width (maximum 300 fill)
        , centerX
        ]
        { src = "dog.png"
        , description = "picture of a dog"
        }


viewSubtitle : Model -> Element.Element msg
viewSubtitle model =
    paragraph
        [ Region.heading 2
        , Font.color model.primary
        , paddingXY 0 20
        ]
        [ text "a web page for my dog"
        ]


buttonChangeColorMode : Model -> Element.Element Msg
buttonChangeColorMode model =
    Input.button
        [ Background.color model.secondaryLight
        , padding 20
        , Border.rounded 8
        , alignRight
        , Font.bold
        , mouseOver
            [ Background.color model.secondaryDark
            ]
        ]
        { onPress = Just MsgChangeColorMode
        , label = text "Change Colors"
        }


text1 : String
text1 =
    "€I love muffin jelly gummies tootsie roll sweet roll bear claw carrot cake tart. Topping dessert chocolate gingerbread cotton candy danish cake. Toffee tart cupcake gingerbread danish candy canes I love pie. Pastry danish tart lemon drops gummies halvah biscuit sweet roll candy. Chupa chups toffee dessert dessert gummies. Cake toffee cupcake dessert sesame snaps I love gummi bears. Croissant ice cream jujubes bear claw cotton candy jelly beans chocolate bar jelly-o chupa chups. Toffee candy cotton candy lollipop jelly-o gummi bears gummi bears soufflé chocolate. Cake I love sugar plum tiramisu carrot cake sweet marshmallow lemon drops lollipop. Cake candy jelly bear claw I love wafer I love tootsie roll caramels. Candy canes croissant sweet roll cake cake cheesecake chupa chups. Tart croissant muffin dessert chocolate bar I love marshmallow lollipop croissant."


text2 : String
text2 =
    "Sweet roll sweet chocolate cookie chocolate cake. Halvah bear claw toffee chocolate bar I love chocolate bar dragée. Pie chocolate sweet biscuit croissant oat cake tootsie roll. Bear claw I love sugar plum icing icing icing. Danish I love marshmallow brownie oat cake I love I love. Marshmallow dragée toffee wafer pie. Gummi bears donut sweet roll dessert I love oat cake bonbon cheesecake. Sugar plum tart cake topping tiramisu I love. I love pie candy canes brownie dessert brownie cake. Apple pie sugar plum I love chocolate cake caramels jelly-o I love. Chocolate bar ice cream wafer biscuit marshmallow. Sweet I love oat cake powder oat cake sugar plum. Marshmallow shortbread tart jujubes chocolate I love tiramisu I love."


paddingTop : Int -> Element.Attribute msg
paddingTop size =
    paddingEach { top = size, right = 0, bottom = 0, left = 0 }


viewContent : Model -> Element.Element msg
viewContent model =
    column
        [ 
        Region.mainContent
        , padding 20
        , Font.size 12
        , paddingTop 20
        , Font.color model.textOnPrimary
        ]
        [ paragraph
            [ paddingXY 0 20
            ]
            [ text text1
            ]
        , paragraph
            [ paddingXY 0 20
            ]
            [ text text2
            ]
        ]
