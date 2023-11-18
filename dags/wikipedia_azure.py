import os
import sys
import requests
import json
import pandas as pd
from bs4 import BeautifulSoup
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

# Set up the path for custom modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Constants
NO_IMAGE = 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/No-image-available.png/480px-No-image-available.png'
WIKIPEDIA_URL = "https://en.wikipedia.org/wiki/List_of_association_football_stadiums_by_capacity"

def get_and_process_wikipedia_data(**kwargs):
    url = kwargs['url']
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"An error occurred: {e}")
        return "Error"

    soup = BeautifulSoup(response.text, 'html.parser')
    table = soup.find("table", {"class": "wikitable sortable"})
    rows = table.find_all('tr')

    data = []
    for row in rows[1:]:
        tds = row.find_all('td')
        image_url = tds[5].find('img')['src'] if tds[5].find('img') else NO_IMAGE
        data.append({
            'rank': len(data) + 1,
            'stadium': clean_text(tds[0].text),
            'capacity': clean_text(tds[1].text).replace(',', '').replace('.', ''),
            'region': clean_text(tds[2].text),
            'country': clean_text(tds[3].text),
            'city': clean_text(tds[4].text),
            'images': 'https://' + image_url.split("//")[1] if image_url != NO_IMAGE else image_url,
            'home_team': clean_text(tds[6].text),
        })
    json_rows = json.dumps(data)
    kwargs['ti'].xcom_push(key='rows', value=json_rows)
    return data

def clean_text(text):
    text = str(text).strip().replace('&nbsp', '').replace('\n', '')
    stop_chars = [' ♦', '[', ' (formerly)']
    for char in stop_chars:
        text = text.split(char)[0]
    return text

def write_wikipedia_data(**kwargs):
    data = kwargs['ti'].xcom_pull(key='rows')
    data = pd.read_json(data)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    file_name = f'stadium_raw_{timestamp}.csv'
    file_path = f'abfs://footballdataanalytics@footballdataanaltics.dfs.core.windows.net/raw_data/{file_name}'

    data.to_csv(file_path, storage_options={'account_key': 'p8bYQVO2jIYq/BQH8wwjpMjF0hMzz3/dCjBOy/JerC1IfRGbB0h3KMxDLv8FDb400UokaVtEi6Lh+AStp4bRBg=='}, index=False)
    return "OK"

# DAG definition
dag = DAG(
    dag_id='wikipedia_extract',
    default_args={
        "owner": "Anish",
        "start_date": datetime(2023, 10, 1),
    },
    schedule_interval=None,
    catchup=False
)

# Task definitions
extract_data_task = PythonOperator(
    task_id="extract_data_from_wikipedia",
    python_callable=get_and_process_wikipedia_data,
    op_kwargs={"url": WIKIPEDIA_URL},
    dag=dag
)

write_data_task = PythonOperator(
    task_id='write_wikipedia_data',
    provide_context=True,
    python_callable=write_wikipedia_data,
    dag=dag
)

# Task sequence
extract_data_task >> write_data_task
