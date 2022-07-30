defmodule Places do
  def find_closest(dataset, %{"origin" => origin_filters, "destination" => destination_filters}) do
    starting_point = dataset |> find_by(origin_filters) |> to_point()

    dataset
    |> filter(destination_filters)
    |> case do
      [] -> nil
      places -> places |> Enum.min_by(&Distance.haversine(starting_point, to_point(&1)))
    end
  end

  defp find_by(dataset, filters) do
    dataset
    |> Enum.find(&Filter.matches?(&1, filters))
  end

  defp filter(dataset, filters) do
    dataset
    |> Enum.filter(&Filter.matches?(&1, filters))
  end

  defp to_point(place) do
    {String.to_float(place["location"]["latitude"]),
     String.to_float(place["location"]["longitude"])}
  end
end
