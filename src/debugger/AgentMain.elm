module AgentMain where

import Html exposing (..)
import Html.Attributes exposing (..)

import StartApp
import Effects exposing (Effects, Never)

-- MODEL

type Model
  = ShowingSwapError SwapError
  | ShowingImportSessionError ImportSessionError
  | Running


type alias SwapError =
  ()


type alias ImportSessionError =
  ()


-- UPDATE

type Action
  = SwapError SwapError
  | ImportSessionError ImportSessionError
  | ClearErrors


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    SwapError swapError ->
      ( ShowingSwapError swapError
      , Effects.none
      )

    ImportSessionError importSessionError ->
      ( ShowingImportSessionError importSessionError
      , Effects.none
      )

    ClearErrors ->
      ( Running
      , Effects.none
      )


-- VIEW

view : Signal.Address Action -> Model -> Html
view addr model =
  case model of
    ShowingSwapError swapError ->
      p [] [ text "swap error!" ]

    ShowingImportSessionError importSessionError ->
      p [] [ text "import error!" ]

    Running ->
      span [] []

-- WIRING

-- TODO: actual errors
port swapErrors : Signal SwapError


-- TODO: some explanation
port importSessionErrors : Signal ImportSessionError


config : StartApp.Config Model Action
config =
  { init = (Running, Effects.none)
  , update = update
  , view = view
  , inputs =
      [ Signal.map SwapError swapErrors
      , Signal.map ImportSessionError importSessionErrors
      ]
  }


app : StartApp.App Model
app =
  StartApp.start config


main : Signal Html
main =
  app.html
