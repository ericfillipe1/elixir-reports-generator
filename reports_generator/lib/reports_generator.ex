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
    "foods",
  ]

  def build(filename) do
    "reports/#{filename}"
    |> Parser.from_file_name()
    |> Enum.reduce(report_acc(), &sum_values(&1, &2))
  end

  def sum_values([id, food_name, price], %{"users" => users, "foods" => foods} = reports) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)
    %{reports | "users" => users, "foods" => foods}
  end

  def fetch_hight_cost(report , option) when option in @options do
    [
      :ok,
      report[option]
        |> Enum.max_by(fn {_key, value} -> value end)
    ]
  end

  def fetch_hight_cost(_report , _option)  do
    [
      :error,
      "invalid option"
    ]
  end

  def report_acc() do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@avariable_foods, %{}, &{&1, 0})

    %{"users" => users, "foods" => foods}
  end
end
