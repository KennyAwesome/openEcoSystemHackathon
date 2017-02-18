# openEcoSystemHackathon
For the Nokia Hackathon

<h3>MQTT installation and running</h3>

To install mosquitto (MQTT server) on a Mac with brew installed issue:
brew install mosquitto

To start the server: 
/usr/local/Cellar/mosquitto/1.4.10_1/sbin/mosquitto -c /usr/local/etc/mosquitto/mosquitto.conf

To listen to sensor values:
/usr/local/Cellar/mosquitto/1.4.10_1/bin/mosquitto_sub -t 'sensor/gyro' -v
