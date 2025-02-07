import pandas as pd
from geopy.distance import geodesic

# Function to calculate distances and filter cities within 10 miles
def find_nearby_cities(community_file, city_file, output_file, radius=10):
    # Read input files
    communities = pd.read_csv(community_file)
    all_cities = pd.read_csv(city_file)

    # Rename columns for consistency
    communities.columns = ['Community', 'Zipcode', 'Lat', 'Long']
    all_cities.columns = ['City', 'Lat', 'Long']

    # Ensure all values in Lat and Long columns are strings before cleaning
    communities['Lat'] = communities['Lat'].astype(str)
    communities['Long'] = communities['Long'].astype(str)
    all_cities['Lat'] = all_cities['Lat'].astype(str)
    all_cities['Long'] = all_cities['Long'].astype(str)

    # Clean and convert latitude and longitude to numeric
    communities['Lat'] = pd.to_numeric(communities['Lat'].str.replace(",", "").str.strip(), errors='coerce')
    communities['Long'] = pd.to_numeric(communities['Long'].str.replace(",", "").str.strip(), errors='coerce')
    all_cities['Lat'] = pd.to_numeric(all_cities['Lat'].str.replace(",", "").str.strip(), errors='coerce')
    all_cities['Long'] = pd.to_numeric(all_cities['Long'].str.replace(",", "").str.strip(), errors='coerce')

    # Drop rows with invalid latitude or longitude values
    communities.dropna(subset=['Lat', 'Long'], inplace=True)
    all_cities.dropna(subset=['Lat', 'Long'], inplace=True)

    # Ensure Zip Code column in both files is treated as string
    communities['Zipcode'] = communities['Zipcode'].astype(str)
    all_cities['City'] = all_cities['City'].astype(str)

    results = []

    # Iterate through each community
    for _, community_row in communities.iterrows():
        community_name = community_row['Community']
        community_latlong = (community_row['Lat'], community_row['Long'])

        # Find city zip codes within the specified radius
        for _, city_row in all_cities.iterrows():
            city_name = city_row['City']
            city_latlong = (city_row['Lat'], city_row['Long'])
            distance = geodesic(community_latlong, city_latlong).miles

            if distance <= radius:
                results.append({
                    'Community': community_name,
                    'Nearby City': city_name,
                    'Distance (miles)': distance
                })

    # Convert results to DataFrame and save to CSV
    results_df = pd.DataFrame(results)
    results_df.to_csv(output_file, index=False)

    print(f"Output saved to {output_file}")

# File paths
community_file = "I:/DS/WConContract/py_mods/communities_lat_long.csv"
city_file = "I:/DS/WConContract/py_mods/cities_lat_long.csv"
output_file = "I:/DS/WConContract/py_mods/nearby_cities_lat_long.csv"

# Run function
find_nearby_cities(community_file, city_file, output_file)
