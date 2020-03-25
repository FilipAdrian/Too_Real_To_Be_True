defmodule CWF.Forecast do
    use GenServer, restart: :transient

    def start_link(state) do
        GenServer.start_link(__MODULE__,[], state)
    end

    @impl true
    def init(data) do
        {:ok, data}
    end

    @impl true
    def handle_cast( {:process,data}, state ) do
        data_set = process_data(data)
        IO.inspect Map.to_list data_set
        # IO.inspect state.lenght ,label: "<--- List SIZE --->  "
        {:noreply, state}
    end

    defp process_data( data ) do
        {:ok, temp} = average(data["temperature_sensor_1"], data["temperature_sensor_1"])
        {:ok, light} = average(data["light_sensor_1"], data["light_sensor_2"])
        {:ok, athm} = average(data["atmo_pressure_sensor_1"], data["atmo_pressure_sensor_2"])
        {:ok, wind_speed} = average(data["wind_speed_sensor_1"], data["wind_speed_sensor_2"])
        {:ok, humidity} = average(data["humidity_sensor_1"], data["humidity_sensor_1"])
        {:ok, timestamp} = data["unix_timestamp_us"] |> (DateTime.from_unix :microsecond) 

        state = %{
            "wheather" => forecast(temp, light, athm, wind_speed, humidity),
            "temp" => temp,
            "light" => light,
            "athm_pressure" => athm,
            "wind_speed" => wind_speed,
            "humidity" => humidity,
            "time" => DateTime.to_string (timestamp)
        }
    end

    defp average( val_1, val_2 ) do
        avg = (val_1 + val_2) / 2
        {:ok, avg}
    end

    defp forecast(temp, light, athm ,wind , hum) do
        cond do
            temp < -2 && light < 128 && athm < 720  -> "SNOW"
            temp < -2 && light > 128 && athm < 680 -> "WET_SNOW"
            temp < -8 -> "SNOW"
            temp < -15 && wind > 45 -> "BLIZZARD"
            temp > 0 && athm < 710 && hum > 70 && wind < 20 -> "SLIGHT_RAIN"
            temp > 0 && athm < 690 && hum > 70 && wind > 20 -> "HEAVY_RAIN"
            temp > 30 && athm < 770 && hum > 80 && light > 192 -> "HOT"
            temp > 30 && athm < 770 && hum > 50 && light > 192 && wind > 35 -> "CONVECTION_OVEN"
            temp > 25 && athm < 750 && hum > 70 && light < 192 && wind < 10 -> "CONVECTION_OVEN"
            temp > 25 && athm < 750 && hum > 70 && light < 192 && wind > 10 -> "SLIGHT_BREEZE"
            light < 128 -> "CLOUDY"
            temp > 30 && athm < 660 && hum > 85 && wind > 45 -> "MONSOON"
            true -> "JUST_A_NORMAL_DAY"
        end
    end
end
