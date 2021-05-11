defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @avariable_foods [
    "pizza",
    "açaí",
    "hambúrguer",
    "esfirra",
    "churrasco",
    "pastel",
    "prato_feito",
    "sushi"
  ]

  @options [
    "users",
    "foods"
  ]

  def build(filename) do
    filename
    |> Parser.parser_file()
    |> Enum.reduce(report_acc(), &sum_values(&1, &2))
  end

  def build_from_files(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, acc -> sum_reports(result, acc) end)
  end

  def sum_reports(%{"users" => users1, "foods" => foods1}, %{"users" => users2, "foods" => foods2}) do
    users = merge_maps(users1, users2)
    foods = merge_maps(foods1, foods2)
    build_reports(users, foods)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)
    build_reports(users, foods)
  end

  def fetch_hight_cost(report, option) when option in @options do
    [
      :ok,
      report[option]
      |> Enum.max_by(fn {_key, value} -> value end)
    ]
  end

  def fetch_hight_cost(_report, _option) do
    [
      :error,
      "invalid option"
    ]
  end

  defp report_acc() do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@avariable_foods, %{}, &{&1, 0})
    build_reports(users, foods)
  end

  defp build_reports(users, foods) do
    %{"users" => users, "foods" => foods}
  end
end
