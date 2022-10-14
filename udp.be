#timer
def set_timer_every(delay,f)
    var now=tasmota.millis()
    tasmota.set_timer((now+delay/4+delay)/delay*delay-now, def() set_timer_every(delay,f) f() end)
end

var udp_OK=false
var u
#Send a message to remote sensors so it knows where to find us
def init_udp()
    u = udp()
    tasmota.yield()
    u.begin("", 2000)    # listen on all interfaces, port 2000
    tasmota.yield()
    if u.send("192.168.2.220", 2000, bytes("414243")) udp_OK=true print(udp_OK) end
end

#cannot start without WiFi, so check year > 2020
def check_wifi()
    if number(tasmota.time_dump(tasmota.rtc()['local'])['year'])<2020
        tasmota.set_timer(5000, check_wifi) #try again in 5 secs
        print("No WiFi")
    else
        tasmota.set_timer(1000,init_udp)
        print("Yes! WiFi")
    end
end
tasmota.set_timer(5000, check_wifi)

#read incoming message to sens_val_in
def read_remote_sensors()
    if udp_OK == true
        var uread = u.read()
        if uread
            var sensor1=string.split(uread.asstring(), ", ")
            for i:0..6
                sens_val_in[i+1]=number(sensor1[i])
            end
        end
    end
end

set_timer_every(1000, read_remote_sensors)