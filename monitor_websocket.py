#!/usr/bin/env python3

import websocket
import requests
import json

username = 'admin'
password = 'password'

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")

def on_open(ws):
    def run(*args):
        pass

def on_message(ws, raw_message):
    message = json.loads(raw_message)
    msg = message['content']
    #print('\nNew message:')
    #print(msg)

    for item in msg:
        if 'queue' in item:

            print("Queue: " + json.dumps(item['queue'], indent=4, sort_keys=True))
            
        for analysis in item['analyses']:
            if 'analysis' in analysis['analysis']:
                a_id = analysis['analysis']['id']
                a_status = analysis['analysis']['status']
                print(f'Analysis id ({a_id}): {a_status}')

            if 'updated_tasks' in analysis:
                for t_update in analysis['updated_tasks']:
                    print("Task update: " + json.dumps(t_update, indent=4, sort_keys=True))


if __name__ == "__main__":
    websocket.enableTrace(True)
    request_token = requests.post('http://localhost:8000/access_token/',
                                 json={"username": username, "password": password}
                                ).json()

    access_token = request_token['access_token']
    ws = websocket.WebSocketApp("ws://localhost:8000/ws/v1/queue-status/",
                              header={'AUTHORIZATION': f'Bearer {access_token}'},
                              on_message = on_message,
                              on_error = on_error)
    ws.run_forever()
