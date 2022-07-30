defmodule Distance do
  import Math

  @doc """
  Uses Haversine formula to calculate the distance between two points.

  Returns distance in km
  """
  def haversine(point_a, point_b) do
    {lat1, lon1} = point_a
    {lat2, lon2} = point_b

    r = 6371
    d_lat = deg2rad(lat2 - lat1)
    d_lon = deg2rad(lon2 - lon1)

    a =
      sin(d_lat / 2) * sin(d_lat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(d_lon / 2) *
          sin(d_lon / 2)

    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    r * c
  end
end
