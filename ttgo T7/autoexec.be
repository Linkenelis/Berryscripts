
def handle_sensors()    #SDS011 sensor is only active just before tele
    import json
    tasmota.publish("Data/SDS0X125", json.dump(json.load(tasmota.read_sensors())["SDS0X1"]["PM2.5"]))
    tasmota.publish("cmnd/Luchtkwaliteit1/SDS0X125", json.dump(json.load(tasmota.read_sensors())["SDS0X1"]["PM2.5"]))
    tasmota.publish("Data/SDS0X110", json.dump(json.load(tasmota.read_sensors())["SDS0X1"]["PM10"]))
    tasmota.publish("cmnd/Luchtkwaliteit1/SDS0X110", json.dump(json.load(tasmota.read_sensors())["SDS0X1"]["PM10"]))
end

tasmota.add_rule("tele#SDS0X1", handle_sensors)

#timer
def set_timer_every(delay,f)
    var now=tasmota.millis()
    tasmota.set_timer((now+delay/4+delay)/delay*delay-now, def() set_timer_every(delay,f) f() end)
end

def handle_sensors()    #temperature and battery(ADC)
    import json
    tasmota.publish("Data/DS18B20_1", json.dump(json.load(tasmota.read_sensors())["DS18B20"]["Temperature"]))
    tasmota.publish("cmnd/Luchtkwaliteit1/DS18B20_1", json.dump(json.load(tasmota.read_sensors())["DS18B20"]["Temperature"]))
    tasmota.publish("Data/TTGO_T7_E46390_Battery", json.dump(json.load(tasmota.read_sensors())["ANALOG"]["Range1"]))
end

set_timer_every(10000, handle_sensors)