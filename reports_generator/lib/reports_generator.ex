defmodule ReportsGenerator do
  def build(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Enum.reduce(report_acc(), fn line, report ->
      [id, _name, price] = parser_line(line)
      Map.put(report, id, report[id] + price)
    end)
  end

  def parser_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end


  def report_acc() do
    Enum.into(1..30,%{},&{Integer.to_string(&1),0})
  end
end
