defmodule Day08 do
  @black "*"
  @white " "
  @transparent nil

  def get_layer_counts(input, width, height) do
    input
    |> to_layers(width, height)
    |> Enum.map(&get_counts/1)
  end

  def decode_image(input, width, height) do
    input
    |> to_layers(width, height)
    |> Enum.map(&to_printable_array/1)
    |> Enum.reduce(List.duplicate(nil, width * height), &overlay/2)
    |> print(width)
  end

  defp to_layers(input, width, height) do
    area = width * height

    input
    |> String.codepoints()
    |> Enum.chunk_every(area, area, :discard)
    |> Enum.map(&Enum.join/1)
  end

  defp get_counts(layer) do
    layer
    |> String.codepoints()
    |> Enum.reduce(%{}, &count_occurence/2)
  end

  defp count_occurence(codepoint, count_map) do
    Map.get_and_update(count_map, codepoint, fn
      nil -> {nil, 1}
      value -> {value, value + 1}
    end)
    |> elem(1)
  end

  defp to_printable_array(layer) do
    layer
    |> String.codepoints()
    |> Enum.map(&translate/1)
  end

  defp translate(codepoint) do
    case codepoint do
      "0" -> @black
      "1" -> @white
      _ -> @transparent
    end
  end

  defp overlay(next_layer, rendered_layers) do
    Enum.zip(next_layer, rendered_layers)
    |> Enum.map(fn {background, foreground} ->
      if is_nil(foreground), do: background, else: foreground
    end)
  end

  defp print(printable_array, width) do
    printable_array
    |> Enum.chunk_every(width)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end
end
