import pandas as pd
import numpy as np
import plotly.express as px
import streamlit as st
st.set_page_config(layout="wide")

df = pd.read_table('subject9.txt', na_values=['---'])

df['Time Computer'] = pd.to_datetime(df['Time Computer'])
mask = (df['Time Computer'].dt.time > pd.to_datetime('13:38:00').time()) & (df['Time Computer'].dt.time <pd.to_datetime('14:17:00').time())
df=df[mask].copy()

df['sample_value'] = df['Sample'].str.extract(r'Sample #(\d+)')

fig = px.line(df, x='Time Computer', y=['ETCO2', 'ScalcO2','Masimo  97/SpO2','RR','Nellcor/HR'])

for i,row in df.iterrows():
    if not pd.isnull(df['Sample'][i]):
        fig.add_annotation(
            x=df['Time Computer'][i],
            y=100,
            text=df['sample_value'][i]
        )

st.plotly_chart(fig, use_container_width=True)