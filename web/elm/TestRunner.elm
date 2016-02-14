module TestRunner where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String exposing (concat, toLower)

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)

type Status = Pending | Running | Passed | Failed

updateTest : Test -> Test
updateTest test =
  { test | status = if test.id % 3 == 2 then "FAILED" else "PASSED" }

runAllTests : Model -> Model
runAllTests model =
  List.map updateTest model

runOneTest : Model -> Int -> Model
runOneTest model id =
  let
    runTest id test =
      if test.id == id then
        updateTest test
      else
        test
  in
    List.map (runTest id) model

-- MODEL

type alias Test =
  { id: Int
  , test: String
  , description: String
  , status: String
  }

type alias Model = List Test

init : (Model, Effects Action)
init =
  ([], Effects.none)

classify : String -> String
classify status =
  case status of
    "RUNNING" ->
      "warning"
    "PASSED" ->
      "success"
    "FAILED" ->
      "danger"
    _ ->
      ""

-- VIEW

pageHeader : Signal.Address Action -> Html
pageHeader address =
  div [ ]
    [ button
        [ class "btn btn-sm btn-warning pull-right", onClick address Reset ]
        [ text "Reset Tests" ]
    , button
        [ class "btn btn-sm btn-info pull-right", onClick address RunAllTests ]
        [ text "Run All Tests" ]
    ,  h1 [ ] [ text "Test Runner"]
    ]

testRow : Signal.Address Action -> Test -> Html
testRow address test =
  tr [ class (classify test.status) ]
    [
      td
        [ class "controls" ]
        [ button
            [ classList [
                ("btn btn-sm btn-info", True),
                ("disabled", (test.status == "RUNNING"))
              ]
            , onClick address (RunTest test.id)
            ]
            [ text "Run" ] ]
    , td [ class "description" ] [ text test.description ]
    , td [ class "test" ] [ text test.test ]
    , td [ class "status" ] [ text test.status ]
    ]

testRows : Signal.Address Action -> List Test -> List Html
testRows address tests =
  List.map (testRow address) tests

type alias Totals = { running: Int, failed: Int, passed: Int, pending: Int }

testTotals : List Test -> Totals
testTotals tests =
  let
    incrementTotals test totals =
      case test.status of
        "RUNNING" ->
          { totals | running = totals.running + 1 }
        "FAILED" ->
          { totals | failed = totals.failed + 1 }
        "PASSED" ->
          { totals | passed = totals.passed + 1 }
        _ ->
          { totals | pending = totals.pending + 1 }
  in
    List.foldl incrementTotals { running = 0, failed = 0, passed = 0, pending = 0 } tests

totalsFoot : List Test -> Html
totalsFoot tests =
  let
    totals = testTotals tests
  in
    tr
      [ class "totals" ]
      [ td
          [ colspan 4 ]
          [ span
              [ class "passed" ]
              [ text (concat ["Passed: ", (toString totals.passed)]) ]
          , span
              [ class "failed" ]
              [ text (concat ["Failed: ", (toString totals.failed)]) ]
          , span
              [ class "running" ]
              [ text (concat ["Running: ", (toString totals.running)]) ]
          , span
              [ class "pending" ]
              [ text (concat ["Pending: ", (toString totals.pending)]) ]
          ]
      ]

testTable : Signal.Address Action -> Model -> Html
testTable address model =
  table [ class "table table-striped table-bordered table-hover tests" ]
    [ thead
        [ ]
        [ tr
            [ ]
            [ th [ class "controls" ] [ ]
            , th [ class "description" ] [ text "Description" ]
            , th [ class "test" ] [ text "Test" ]
            , th [ class "status" ] [ text "Status" ]
            ]
        ]
    , tbody
        [ ]
        (testRows address model)
    , tfoot
        [ ]
        [ (totalsFoot model) ]
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "container" ]
    [ div
        [ class "row" ]
        [ div [ class "col-xs-12" ] [ (pageHeader address) ] ]
    , div
        [ class "row" ]
        [ div [ class "col-xs-12" ] [ (testTable address model) ] ]
    ]

-- UPDATE

type Action
  = NoOp
  | SetTests Model
  | RunTest Int
  | RunAllTests
  | Reset

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)

    SetTests model ->
      (model, Effects.none)

    RunTest id ->
      (runOneTest model id, Effects.none)

    RunAllTests ->
      (runAllTests model, Effects.none)

    Reset ->
      (fst init, Effects.none)

-- APP

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ incomingActions ]
    }

main : Signal Html
main =
  app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks

-- SIGNALS

port testLists : Signal Model

incomingActions: Signal Action
incomingActions =
  Signal.map SetTests testLists
