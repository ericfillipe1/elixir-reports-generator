defmodule ReportsGenerator do
  def build(filename) do
    "reports/#{filename}"
    |> File.read()
    |> handler_file()
  end

  def handler_file({:ok, result}) do
    result
  end

  def handler_file({:error, _}) do
    "not found file"
  end
end
