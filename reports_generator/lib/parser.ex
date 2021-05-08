defmodule ReportsGenerator.Parser do
  def from_file_name(filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line ->
      parser_line(line)
    end)
  end

  def parser_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end
end
