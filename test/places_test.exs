##
# Importar fixture e testar com tudo
##
defmodule PlacesTest do
  use ExUnit.Case
  doctest Places

  setup_all do
    dataset = [
      %{
        "objectid" => "1569152",
        "applicant" => "Datam SF LLC dba Anzu To You",
        "facilitytype" => "Truck",
        "status" => "APPROVED",
        "fooditems" => "Asian Fusion - Japanese Sandwiches/Sliders/Misubi",
        "location" => %{
          "latitude" => "37.805885350100986",
          "longitude" => "-122.41594524663745"
        }
      },
      %{
        "objectid" => "1359707",
        "applicant" => "Union Square Business Improvement District",
        "facilitytype" => "Truck",
        "status" => "REQUESTED",
        "fooditems" =>
          "All types of food except for BBQ on site per fire safety. Partnership with Off the Grid and their fleet of MFF's",
        "location" => %{
          "latitude" => "0.0",
          "longitude" => "0.0"
        }
      }
    ]

    dataset_fixture = File.read!("./dataset.json") |> Poison.decode!()

    {:ok, dataset: dataset, dataset_fixture: dataset_fixture}
  end

  test "finds closest place", %{dataset: dataset} do
    params = %{
      "origin" => %{"applicant__start" => "Union Square"},
      "destination" => %{
        "facilitytype__eq" => "truck",
        "fooditems__cont" => "japanese",
        "status__eq" => "approved"
      }
    }

    assert Places.find_closest(dataset, params)["applicant"] == "Datam SF LLC dba Anzu To You"
  end

  test "returns nil when there is no match", %{dataset: dataset} do
    params = %{
      "origin" => %{"applicant__start" => "Union Square"},
      "destination" => %{
        "facilitytype__eq" => "truck",
        "fooditems__cont" => "japanese",
        "status__eq" => "expired"
      }
    }

    assert Places.find_closest(dataset, params) == nil
  end

  test "raises on missing keys", %{dataset: dataset} do
    [
      %{"destination" => %{}},
      %{"origin" => %{}}
    ]
    |> Enum.each(fn params ->
      assert_raise FunctionClauseError, fn -> Places.find_closest(dataset, params) end
    end)
  end

  test "[dataset fixture] returns matching record", %{dataset_fixture: dataset} do
    params = %{
      "origin" => %{"applicant__start" => "Union Square"},
      "destination" => %{
        "facilitytype__eq" => "truck",
        "fooditems__cont" => "japanese",
        "status__eq" => "approved"
      }
    }

    assert Places.find_closest(dataset, params)["applicant"] == "Datam SF LLC dba Anzu To You"
  end

  test "[dataset fixture] returns nil when there's no match", %{dataset_fixture: dataset} do
    params = %{
      "origin" => %{"applicant__start" => "Union Square"},
      "destination" => %{
        "facilitytype__eq" => "truck",
        "fooditems__cont" => "japanese",
        "status__eq" => "approved"
      }
    }

    assert Places.find_closest(dataset, params)["applicant"] == "Datam SF LLC dba Anzu To You"
  end
end
