module TestRunner where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String exposing (concat, toLower)

import StartApp.Simple as StartApp

type Status = Pending | Running | Passed | Failed

updateTest : Test -> Test
updateTest test =
  { test | status = if test.id % 3 == 2 then Failed else Passed }

runAllTests : Model -> Model
runAllTests model =
  { model | tests = (List.map updateTest model.tests) }

runOneTest : Model -> Int -> Model
runOneTest model id =
  let
    runTest id test =
      if test.id == id then
        updateTest test
      else
        test
  in
    { model | tests = (List.map (runTest id) model.tests) }

-- MODEL

type alias Test =
  { id: Int,
    status: Status,
    description: String
  }

type alias Model =
  {
    tests: List Test
  }

initialModel : Model
initialModel =
  { tests =
    [
      { id = 1, status = Pending, description = "commas are rotated properly" },
      { id = 2, status = Pending, description = "exclamation points stand up straight" },
      { id = 3, status = Pending, description = "run-on sentences don't run forever" },
      { id = 4, status = Pending, description = "question marks curl down, not up" },
      { id = 5, status = Pending, description = "semicolons are adequately waterproof" },
      { id = 6, status = Pending, description = "capital letters can do yoga" }
    ]
  }

classify : Status -> String
classify status =
  case status of
    Running ->
      "warning"
    Passed ->
      "success"
    Failed ->
      "danger"
    Pending ->
      ""

-- VIEW

pageHeader : Signal.Address Action -> Html
pageHeader address =
  div [ ]
    [ button
        [ class "btn btn-sm btn-warning pull-right", onClick address Reset ]
        [ text "Reset Tests" ],
      button
        [ class "btn btn-sm btn-info pull-right", onClick address RunAllTests ]
        [ text "Run All Tests" ],
      h1 [ ] [ text "Test Runner"]
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
                ("disabled", (test.status == Running))
              ],
              onClick address (RunTest test.id)
            ]
            [ text "Run" ] ],
      td [ class "description" ] [ text test.description ],
      td [ class "status" ] [ text (toString test.status) ]
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
        Running ->
          { totals | running = totals.running + 1 }
        Failed ->
          { totals | failed = totals.failed + 1 }
        Passed ->
          { totals | passed = totals.passed + 1 }
        Pending ->
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
          [ colspan 3 ]
          [ span
              [ class "passed" ]
              [ text (concat ["Passed: ", (toString totals.passed)]) ],
            span
              [ class "failed" ]
              [ text (concat ["Failed: ", (toString totals.failed)]) ],
            span
              [ class "running" ]
              [ text (concat ["Running: ", (toString totals.running)]) ],
            span
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
            [ th [ class "controls" ] [ ],
              th [ class "description" ] [ text "Test" ],
              th [ class "status" ] [ text "Status" ]
            ]
        ],
      tbody
        [ ]
        (testRows address model.tests),
      tfoot
        [ ]
        [ (totalsFoot model.tests) ]
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "container" ]
    [ div
        [ class "row" ]
        [ div [ class "col-xs-12" ] [ (pageHeader address) ] ],
      div
        [ class "row" ]
        [ div [ class "col-xs-12" ] [ (testTable address model) ] ]
    ]

-- UPDATE

type Action
  = NoOp
  | RunTest Int
  | RunAllTests
  | Reset

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    RunTest id ->
      runOneTest model id

    RunAllTests ->
      runAllTests model

    Reset ->
      initialModel

main : Signal Html
main =
  StartApp.start
    { model = initialModel,
      view = view,
      update = update
    }
