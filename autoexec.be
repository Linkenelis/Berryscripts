import string

lv.start()

hres = lv.get_hor_res()       # should be 320
vres = lv.get_ver_res()       # should be 480

scr = lv.scr_act()            # default screean object
f20 = lv.montserrat_font(20)  # load embedded Montserrat 20

#- Background black #000000 -#
scr.set_style_bg_color(lv.color(0x000000), lv.PART_MAIN | lv.STATE_DEFAULT)

#load stat_line
load("stat_line.be")


#- create a style for the canvas -#
canvas_style = lv.style()
canvas_style.set_bg_opa(lv.OPA_COVER)              # 100% backgrond opacity
if f20 != nil canvas_style.set_text_font(f20) end  # set font to Montserrat 20
canvas_style.set_bg_color(lv.color(0x000000))      # background color
canvas_style.set_border_color(lv.color(0x0000FF))  # border color #0000FF
canvas_style.set_text_color(lv.color(0xFFFFFF))    # text color white #FFFFFF

#timer
def set_timer_every(delay,f)
    var now=tasmota.millis()
    tasmota.set_timer((now+delay/4+delay)/delay*delay-now, def() set_timer_every(delay,f) f() end)
end

# DS18b20_temperatuur, bme_press, bme_temperatuur, bme_hum, bme_IAQ_acc, bme_IAQ, bme_CO2, bme_TVOC, winssen_CO2, NOVA_part2.5, NOVA_part10
var sens_val_in=[20.1, -1.9, 40, 1023, 1, 25, 400, 0.1, 515, 26, 138]    #deze word gevuld uit de sensoren
var sens_val_out=[2.8, 23, 80, 1024, 2, 26, 500, 0.2, 413, 25, 238] #table wants string; chart wants numbers



load("basic_table.be")

load("charts.be")
#- series waarden uit sens_val_in
 Tin
 Hin
 CO2in
 TGin
 P1in
 P25in
 P10in -#

load("buttons.be")

import webserver
class UserData : Driver
    def web_add_main_button()   #extra knop op de main pagina voor User Data
        webserver.content_send("<p></p><button onclick='la(\"&m_Mail_data=1\");'>Mail data nu</button>")
    end

    def web_sensor()            #Info op de main pagina
        var webmsg=string.format(
        '{s}Temperatuur:{m}%s °C{e}'..
        '{s}Hygro:{m}% .1f %%{e}'..
        '{s}Luchtdruk:{m}% .0f hPa{e}'..
        '{s}BME_CO2:{m}% .1f ppm{e}'..
        '{s}BME_TVOC:{m}% .1f ppm{e}'..
        '{s}IAQ:{m}% .0f {e}'..
        '{s}IAQ_accuracy: {m}%d {e}'..
        '{s}Particles 2.5:{m}%s µg/m³{e}'..
        '{s}Particles 10:{m}%s µg/m³{e}',
        sens_val_in[0], sens_val_in[2], sens_val_in[3], sens_val_in[6], sens_val_in[7], sens_val_in[5], sens_val_in[4], sens_val_in[9], sens_val_in[10])
        tasmota.web_send_decimal(webmsg)
        tasmota.yield()
        if webserver.has_arg("m_Mail_data")
            #something here for when button pressed
        end
    end
end

data1=UserData()

tasmota.add_driver(data1)

load("udp.be")  #need fixed ip of sending device

class MQTTDATA : Driver
    def mqtt_data(topic,idx,payload_s,payload_b)
        if topic == "cmnd/Luchtkwaliteit1/SDS0X125" #no need to subscribe to cmnd/ownname/#
            sens_val_in[9]=payload_s
            return true
        elif topic == "cmnd/Luchtkwaliteit1/SDS0X110"
            sens_val_in[10]=payload_s
            return true
        elif topic == "cmnd/Luchtkwaliteit1/DS18B20_1"
            sens_val_in[0]=payload_s
            return true
        else
            return false
        end
    end
end
tasmota.add_driver(MQTTDATA)