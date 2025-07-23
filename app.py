import streamlit as st
import csv
import pandas as pd
from streamlit_folium import st_folium
import folium
import requests
import calendar
import datetime
import altair as alt
import math



df = pd.read_csv('../python/arduino_data.csv', parse_dates=['Time'])
start_time = df['Time'].iloc[0]
df['Seconds'] = (df['Time'] - start_time).dt.total_seconds()

arduino_data = []
with open('../python/arduino_data.csv') as file:
    reader = csv.reader(file)
    for i, row in enumerate(reader):
        if i == 0:
            arduino_data.append(row)
        else:
            arduino_data.append([float(v) if i !=0 else v for i, v in enumerate(row)])

def get_weather_no_api(lat, lon):
    """Get weather from wttr.in using lat/lon without API key."""
    url = f"https://wttr.in/{lat},{lon}?format=j1"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        current = data["current_condition"][0]
        return {
            "description": current["weatherDesc"][0]["value"],
            "temperature": current["temp_C"],
            "humidity": current["humidity"],
            "wind_speed": current["windspeedKmph"]
        }
    else:
        return {"error": "Failed to fetch weather"}


# def detect_anomaly(data:list[float]):
#     alpha = 0.9
#     filtered = [0.0] * len(data) - 1
#     filtered[0] = data[0]  # start with first value (or zero)

#     for i in range(1, len(data)):
#         filtered[i] = alpha * (filtered[i - 1] + data[i] - data[i - 1])

#     return filtered


# def detect_anomalies(datas: list[list[float]]):
#     # filtered = [detect_anomaly(data_stream) for data_stream in datas[1:]]
#     array_names = ['Time', 'Pressure','Altitude','Sealevel','Real Altitude','Humidity','Temp-k','Potentiometer'][1:]
#     array = datas[1:]

#     anomalies = {}

#     for stream in array:
#         for i in range(2, len(stream)):
#             diff = abs((stream[i] - stream[i-1])/stream[i-1])
#             if diff > 0.01:
#                 # anomaly detected
#                 anomalies[array_names[i]] = datas[i][0]
#                 break

#     return anomalies   

# thresholds = {
#     "Pressure": 92000,
#     "Altitude": 850,
#     "Sealevel": 92000,
#     "Real Altitude": 850,
#     "Humidity": 70,
#     "Temp-k": 30,
#     "Potentiometer": 5
# }

thresholds = {
    "Pressure": 93200,
    "Altitude": 950,
    "Sealevel": 92800,
    "Real Altitude": 900,
    "Humidity": 86,
    "Temp-k": 32,
    "Potentiometer": 1000
}


def detect_anomalies():
    anomalies = {}
    for sensor, threshold in thresholds.items():
        for idx, row in df.iterrows():
            value = row[sensor]
            # status = check_anomaly(value, threshold)
            if value > threshold:
                # anomalies[sensor] = row["Time"]
                status = "CRITICAL" if value>(threshold+5) else "WARNING"
                st.write(f"Seconds: {row['Seconds']} | Sensor: {sensor} | Value: {value} | Status: {status}\n")
                # log_file.write(f"{row['Time']} | Sensor: {sensor} | Value: {value} | Status: {status}\n")
                # break
    return anomalies


def haversine_distance(lat1, lon1, lat2, lon2, in_km=True):
    """
    Calculate the distance between two lat/lon coordinates using the Haversine formula.

    Args:
        lat1, lon1: Latitude and Longitude of point 1 (in decimal degrees)
        lat2, lon2: Latitude and Longitude of point 2 (in decimal degrees)
        in_km (bool): If True, return distance in kilometers. Else, return in meters.

    Returns:
        float: Distance between the two points
    """
    R = 6371.0 if in_km else 6371000  # Radius of Earth in km or meters

    # Convert latitude and longitude from degrees to radians
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)

    # Haversine formula
    a = math.sin(delta_phi / 2) ** 2 + \
        math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2) ** 2

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    distance = R * c
    return distance          


st.title("Digital twin")

with st.sidebar:
    sim_mode=st.radio("Which simulation mode do you want to choose",["Dashboard","Digital Shadowing","Sims","Mission"],index=None)  

if sim_mode=="Dashboard":
    year=2025
    month=7
    col1,col2,col3=st.columns(3)

    col1.metric(label="Hours flown",value="1600 hours",delta="+3 hours",border=True)
    col2.metric(label="Critical alerts",value=81,delta="+1",border=True,delta_color="inverse")
    col3.metric(label="Months till repair",value="180 Days",delta="-10 days",border=True)
    st.metric(label="Highest temperature spike" ,value="650 °C",border=True)
    st.metric(label="Wear & Tear ratio", value="21",delta="-8%",border=True)
    
    cal_text = calendar.month(year, month)
    st.subheader(f"📅 Missions in {calendar.month_name[month]} {year}")
    st.code(cal_text)

if sim_mode=="Sims":
    st.subheader("Simulation")

if sim_mode=="Digital Shadowing":

    st.subheader("Active Shadowing")

    columns_to_plot = st.selectbox(
        "Select columns to plot against Time:",
        options=df.columns.drop(['Time', 'Seconds']),
    )

    if columns_to_plot:
        st.line_chart(df.set_index('Seconds')[columns_to_plot])
        anomalies = detect_anomalies()



        # col = columns_to_plot
        # chart = alt.Chart(df).mark_line().encode(
        #     x='Seconds:Q',
        #     y=alt.Y(f'{col}:Q', title=col)
        # ) 
        
        # print(anomalies)
        # print(col)
        # if anomalies.get(col):

        #     chart = chart + alt.Chart(df[df['Time'] == anomalies[col]]).mark_point(color='red', size=200).encode(
        #         x='Seconds:Q',
        #         y='Pressure:Q'
        #     )


        # st.altair_chart(chart, use_container_width=True)


    else:
        st.warning("Please select at least one column to display.")





if sim_mode=="Mission":
    st.subheader("Mission Sim")

    if "points" not in st.session_state:
        st.session_state.points = []
    m = folium.Map(location=[22.9734, 78.6569], zoom_start=5)

    # Add a click handler
    m.add_child(folium.LatLngPopup())

    # Display the map
    output = st_folium(m, height=500, width=700)

    # Capture click
    if output and output["last_clicked"]:
        point = output["last_clicked"]
        if len(st.session_state.points) < 2:
            st.session_state.points.append(point)

    # Display selected points
    if st.session_state.points:
        st.subheader("Selected Points:")
        for i, p in enumerate(st.session_state.points):
            st.write(f"Point {i+1}: Latitude: {p['lat']:0.3f}, Longitude: {p['lng']:0.3f}")
    
    if st.session_state.points:
        for i, p in enumerate(st.session_state.points):
            st.subheader(f"☀️ Weather at Point {i+1}")
            weather = get_weather_no_api(p["lat"], p["lng"])
            if "error" in weather:
             st.error(weather["error"])
            else:
                st.markdown(f"""
                **Description:** {weather['description']}  
                **Temperature:** {weather['temperature']}°C  
                **Humidity:** {weather['humidity']}%  
                **Wind Speed:** {weather['wind_speed']} km/h  
            """)

    # Reset option
    if st.button("Reset Points"):
        st.session_state.points = []
