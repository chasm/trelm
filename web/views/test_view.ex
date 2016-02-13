defmodule Trelm.TestView do
  use Trelm.Web, :view

  def render("index.json", %{tests: tests}) do
    %{data: render_many(tests, Trelm.TestView, "test.json")}
  end

  def render("show.json", %{test: test}) do
    %{data: render_one(test, Trelm.TestView, "test.json")}
  end

  def render("test.json", %{test: test}) do
    %{id: test.id,
      description: test.description,
      test: test.test}
  end
end
