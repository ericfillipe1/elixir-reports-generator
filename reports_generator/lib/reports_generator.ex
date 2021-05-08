defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  def build(filename) do
    "reports/#{filename}"
    |> Parser.from_file_name()
    |> Enum.reduce(report_acc(), &sum_values(&1, &2))
  end

  def sum_values([id, _name, price], report) do
    Map.put(report, id, report[id] + price)
  end

  def fetch_hight_cost(report) do
    report
    |> Enum.max_by(fn {_key, value} -> value end)
  end

  def report_acc() do
    Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
  end
end
