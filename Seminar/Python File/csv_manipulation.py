import streamlit as st
import pandas as pd
import base64
import numpy as np

# user can upload the csv
st.title("CSV Manipulation")
data_file = st.file_uploader("Please insert your csv file below", type="csv")

# read the csv file
if data_file is not None:
    df = pd.read_csv(data_file, sep=";")
    df = df.replace(r'^\s*$', np.nan, regex=True)
    df = df.dropna()

    # replace the "," with "." in each row in column "Erster", "Hoch", "Tief", "Schlusskurs"
    df["Erster"] = df["Erster"].str.replace(",", ".")
    df["Hoch"] = df["Hoch"].str.replace(",", ".")
    df["Tief"] = df["Tief"].str.replace(",", ".")
    df["Schlusskurs"] = df["Schlusskurs"].str.replace(",", ".")

    # delete decimal separator "." in each row in column "Stuecke" and "Volumen
    df["Stuecke"] = df["Stuecke"].str.replace(".", "")
    df["Volumen"] = df["Volumen"].str.replace(".", "")

    # add new column "Aktien_id" with user can choose the value one to ten
    df["Aktien_id"] = st.text_input("Insert Aktien_id")

    # change the index of column with "Aktien_id" is the first column, the rest is same.
    df = df[["Aktien_id", "Datum", "Erster", "Hoch", "Tief", "Schlusskurs", "Stuecke", "Volumen"]]

    # show the dataframe
    st.dataframe(df)

    # download the csv
    st.write("Download the csv")
    csv = df.to_csv(index=False, sep=";")
    selected_Aktien_id = df["Aktien_id"][0]
    csv_name = f"Tagespreis_{selected_Aktien_id}.csv"
    b64 = base64.b64encode(csv.encode()).decode()
    st.markdown(f'<a href="data:file/csv;base64,{b64}" download="{csv_name}">Download csv file</a>', unsafe_allow_html=True)
