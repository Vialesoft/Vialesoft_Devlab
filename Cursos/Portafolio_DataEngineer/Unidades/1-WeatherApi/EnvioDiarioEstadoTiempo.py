import os
from twilio.rest import Client
from _config import *
import time

from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

import pandas as pd
import requests
from bs4  import BeautifulSoup
from tqdm import tqdm

from datetime import datetime

# --------------------------------------------

fecha = ''

# --------------------------------------------

def generate_url():
    api_key = API_KEY_WAPI
    ciudad = CIUDAD
    dias = 1
    
    url_clima = "http://api.weatherapi.com/v1/forecast.json?key={0}&q={1}&days={2}&aqi=no&alerts=no".format(api_key,ciudad,dias)

    return url_clima

def get_Response_Clima():
    url_clima = generate_url()
    
    response = requests.get(url_clima).json()    
    return response

def get_forecast(response,i):
    fecha = response['forecast']['forecastday'][0]['hour'][i]['time'].split()[0]
    hora = int(response['forecast']['forecastday'][0]['hour'][i]['time'].split()[1].split(':')[0])
    condicion = response['forecast']['forecastday'][0]['hour'][i]['condition']['text']
    tempe = float(response['forecast']['forecastday'][0]['hour'][i]['temp_c'])
    rain = response['forecast']['forecastday'][0]['hour'][i]['will_it_rain']
    prob_rain = response['forecast']['forecastday'][0]['hour'][i]['chance_of_rain']

    return fecha, hora, condicion, tempe, rain, prob_rain


def get_InfoDelDiaOrdenada():
    datos = []
    clima = get_Response_Clima()

    for i in tqdm(range(len(clima['forecast']['forecastday'][0]['hour'])), colour = 'blue'):
        datos.append(get_forecast(clima,i))

    cols = ['Fecha','Hora','Condicion','Temperatura','Lluvia','prob_lluvia']
    retDF = pd.DataFrame(datos, columns=cols)
    retDF = retDF.sort_values(by = 'Hora', ascending = True)

    return retDF

def get_InfoHorasDeLluvia():
    dataOrdenada = get_InfoDelDiaOrdenada()

    df_rain =  dataOrdenada[(dataOrdenada['Lluvia'] == 1) & (dataOrdenada['Hora'] > 6) & (dataOrdenada['Hora'] < 22)]
    df_rain = df_rain[['Hora','Condicion']]
    df_rain.set_index('Hora', inplace = True)

    return df_rain

# MENSAJES CON TWILIO

def enviar_SMS(mensaje):
    time.sleep(2)
    account_sid = TWILIO_ACCOUNT_SID 
    auth_token = TWILIO_AUTH_TOKEN

    client = Client(account_sid, auth_token)

    message = client.messages \
                    .create(
                         body = mensaje,
                         from_ = PHONE_NUMBER,
                         to = '+598 95 351 882'
                     )

    print('Mensaje Enviado ' + message.sid)

def enviarWhatsapp(mensaje):
    account_sid = TWILIO_ACCOUNT_SID
    auth_token = TWILIO_AUTH_TOKEN
    client = Client(account_sid, auth_token)

    message = client.messages.create(
      from_ ='whatsapp:+14155238886',
      body = mensaje,
      to = 'whatsapp:+59895351882'
    )

    print(message.sid)

# --------------------------------------------

dataHorasDeLluvia = get_InfoHorasDeLluvia()
dataHorasDeLluvia

strMensaje = '\nHola! \n\n\n El pronostico del tiempo hoy en {0} es : \n\n\n {1}'.format(CIUDAD, dataHorasDeLluvia)

print(strMensaje)

enviarWhatsapp(strMensaje)
enviar_SMS(strMensaje)