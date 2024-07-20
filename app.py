import mysql.connector
from mysql.connector import Error
import pandas as pd
import streamlit as st
import os
import google.generativeai as genai
key='your api key'
genai.configure(api_key=key)
#load Google Gemini and provide SQL Query as response
def get_gemini_response(question,prompt):
    model=genai.GenerativeModel('gemini-pro')
    response=model.generate_content([prompt[0],question])
    return response.text
##Function 
def connect_to_mysql():
    """
    Connect to a MySQL database and return the connection object.

    :param host: The hostname of the MySQL server.
    :param user: The username to access the MySQL server.
    :param password: The password to access the MySQL server.
    :param database: The database name to connect to.
    :return: Connection object or None if connection failed.
    """
    try:
        db_user=''
        db_password=''
        db_name='financialdb'
        db_host='localhost'

        connection = mysql.connector.connect(
                host=db_host,
               user=db_user,
               password=db_password,
               database=db_name
                )
        if connection.is_connected():
            print("Connection to MySQL database was successful")
            return connection
    except Error as e:
        print(f"Error: {e}")
        return None
def fetch_data_to_dataframe(connection, query):
    """
    Fetch data from MySQL database and return it as a pandas DataFrame.

    :param connection: The MySQL connection object.
    :param query: The SQL query to execute.
    :return: DataFrame containing the result of the query.
    """
    try:
        df = pd.read_sql(query, connection)
        return df
    except Error as e:
        print(f"Error: {e}")
        return None
prompt =[
    
    """
    You are an expert in converting English Questions to sql query!
    The MYSQL database has the name financialdb and has the Following Tables - accounts ,cards, customers, transactions
    accounts Table has following columns - account_id, customer_id, account_number, account_type, balance
    cards Table has following columns - card_id, customer_id ,card_number, card_type, expiration_date
    customers Table has following columns - customer_id, first_name, last_name, email , phone_number, address
    transactions Table has following columns - transactioin_id,account_id, card_id, amount, transaction_date,merchant,transaction_type
    Table accounts is connected with table customers with column customer_id ,table accounts is connected with table transactions with column account_id , table cards is connection with customers via column customer_id
    also the sql code should not have ''' in the beginning or end  and sql word in the output
    """
    
]


st.set_page_config(page_title='I can Retrieve Any SQL query')
st.header("Gemini App to Retrieve SQL Data")
question=st.text_input("Input: ", key="input")
submit=st.button("Ask the Question")
db=connect_to_mysql()
if submit:
    response=get_gemini_response(question,prompt)
    print(response)
    data=fetch_data_to_dataframe(db, response)
    st.subheader('The Response is')
    print(data)
    st.dataframe(data)