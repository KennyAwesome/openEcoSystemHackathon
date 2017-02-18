#!/usr/bin/python
import paho.mqtt.client as paho
from time import time
from collections import deque
from os import system
import sys

SENSITIVITY = 3500
data = deque()

def analyze_data(arduino_data):
    #(x, y, z, x_a, y_a, z_a, timestamp) = map(int, data.strip().split(','))
    data_values = map(int, arduino_data.strip().split(','))
    data.appendleft(data_values)
    if len(data) > 5:
        (x_0, y_0, z_0, x_a_0, y_a_0, z_a_0, timestamp_0) = data.pop()
        while len(data) > 0:
            (x_n, y_n, z_n, x_a_n, y_a_n, z_a_n, timestamp_n) = data.pop()
        results = [_1 - _2 for (_1, _2) in zip((x_0, y_0, z_0), (x_n, y_n, z_n))]
        abs_results = map(abs, results)
        max_diff_index = abs_results.index(max(abs_results))
        if max_diff_index == 0:
            if results[0] < -SENSITIVITY:
                print "CLOCKWISE"
            elif results[0] > SENSITIVITY:
                print "ANTICLOCKWISE"
        elif max_diff_index == 1:
            if results[1] < -SENSITIVITY:
                print "UPWARDS"
            elif results[1] > SENSITIVITY:
                print "DOWNWARDS"
                # These values should be manually calibrated at the beginning
                if z_n < 0: # LIGHT
                    system('curl http://192.168.0.105/light3')
                elif z_n > 0: # SOAP
                    system('curl http://192.168.0.105/trigger')
        elif max_diff_index == 2:
            if results[2] < -SENSITIVITY:
                print "RIGHT"
            elif results[2] > SENSITIVITY:
                print "LEFT"

def on_connect(client, userdata, rc):
    print 'Connected with result code %d' % (rc)

def on_subscribe(client, userdata, mid, granted_qos):
    print 'Subscribed: %d %s' % (mid, granted_qos)
         
def on_message(client, userdata, msg):
    #print 'Time: %.3f Topic: %s\tQoS: %d\tPayload: %s' % (time(), msg.topic, msg.qos, msg.payload)
    analyze_data(msg.payload)

def main():
    client = paho.Client()
    client.on_connect = on_connect
    client.on_subscribe = on_subscribe
    client.on_message = on_message
    client.connect(host='192.168.0.100', port=1883, keepalive=60)
    client.subscribe('sensor/gyro')
    client.loop_forever()

if __name__ == '__main__':
    main()
