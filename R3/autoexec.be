import persist
import json
import webserver
import string

var init = 1
var Days=['Monday','Tuesday','Wednesday','Thursday','Friday','Saterday','Sunday']
var Dayslist=['Monday','Tuesday','Wednesday','Thursday','Friday','Saterday','Sunday']
var Months=['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
var Monthlist=['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
var Yearslist=['2020','2021','2022']
var Day = 'Sun'
var Month = 'Jan'
var Year = '2022'

def set_timer_every(delay,f)
    var now=tasmota.millis()
    tasmota.set_timer((now+delay/4+delay)/delay*delay-now, def() set_timer_every(delay,f) f() end)
end

def Energy_monthly_data()   #read yesterdays energy and add it to month year 
    if tasmota.strftime("%H:%M", tasmota.rtc()['local']) == '00:00'  || init == 1   #at midnight store data or first time
        for i: 0..2
            Yearslist.remove(i)
            Yearslist.insert(i, string.format('%d',number(tasmota.strftime("%Y", tasmota.rtc()['local']))-i))    #yesterday first
        end
        if !persist.has(tasmota.strftime("%Y A", tasmota.rtc()['local']))   #create Year
            persist.(tasmota.strftime("%Y A", tasmota.rtc()['local'])) = 0
            persist.(tasmota.strftime("%Y B", tasmota.rtc()['local'])) = 0
        end
        if persist.has(tasmota.strftime("%B A", tasmota.rtc()['local'])) && (tasmota.strftime("%d", tasmota.rtc()['local']) =="1")  #if month exists and day is now 1 value must be 0
            persist.(tasmota.strftime("%B A", tasmota.rtc()['local'])) = 0
            persist.(tasmota.strftime("%B B", tasmota.rtc()['local'])) = 0
        end
        if !persist.has(tasmota.strftime("%B A", tasmota.rtc()['local']))    #create month if not exist
            persist.(tasmota.strftime("%B A", tasmota.rtc()['local'])) = 0
            persist.(tasmota.strftime("%B B", tasmota.rtc()['local'])) = 0
        end
        persist.save()
        #add yesterdays measurements to month year and year
        persist.(tasmota.strftime("%B A", tasmota.rtc()['local'])) = persist.find(tasmota.strftime("%B A", tasmota.rtc()['local']))+json.load(tasmota.read_sensors())['ENERGY']['Yesterday'][0]
        persist.(tasmota.strftime("%B B", tasmota.rtc()['local'])) = persist.find(tasmota.strftime("%B B", tasmota.rtc()['local']))+json.load(tasmota.read_sensors())['ENERGY']['Yesterday'][1]
        persist.(tasmota.strftime("%Y A", tasmota.rtc()['local'])) = persist.find(tasmota.strftime("%Y A", tasmota.rtc()['local']))+json.load(tasmota.read_sensors())['ENERGY']['Yesterday'][0]
        persist.(tasmota.strftime("%Y B", tasmota.rtc()['local'])) = persist.find(tasmota.strftime("%Y B", tasmota.rtc()['local']))+json.load(tasmota.read_sensors())['ENERGY']['Yesterday'][1]
        if Month != Months[(number(tasmota.strftime("%m", tasmota.rtc()['local']))-1)]  || init == 1 
            Month = Months[(number(tasmota.strftime("%m", tasmota.rtc()['local']))-1)]
            for i: 0..11
                Monthlist.remove(i)
                Monthlist.insert(i, Months[number(tasmota.strftime("%m", tasmota.rtc()['local']))-1-i])
            end
        end
        Day = Days[(number(tasmota.strftime("%u", tasmota.rtc()['local']))-1)]
        for i: 0..6
            Dayslist.remove(i)
            Dayslist.insert(i, Days[number(tasmota.strftime("%u", tasmota.rtc()['local']))-2-i])    #yesterday first
        end
        persist.(Dayslist[0]+" A") = json.load(tasmota.read_sensors())['ENERGY']['Yesterday'][0]
        persist.(Dayslist[0]+" B") = json.load(tasmota.read_sensors())['ENERGY']['Yesterday'][1]
        persist.save()
        init=0
    end
end


set_timer_every(10000, Energy_monthly_data) #every 10 secs check for day change


var showdata = 2    #not showing standard on open
class UserData : Driver
    def web_add_main_button()   #extra knop op de main pagina voor User Data
        webserver.content_send("<p></p><button onclick='la(\"&More_data=1\");'>More/Less data</button>")
    end

    def web_sensor()            #extra data
        if showdata==1
            var msg_months=string.format(
            '{s}Energy Total Started{m}%s{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}'..
            '{s}Energy %s: {m}%s {m}%s  kWh{e}',
            json.load(tasmota.read_sensors())['ENERGY']['TotalStartTime'],
            Dayslist[0], persist.find(Dayslist[0]+" A"), persist.find(Dayslist[0]+" B"),Dayslist[1], persist.find(Dayslist[1]+" A"), persist.find(Dayslist[1]+" B"),
            Dayslist[2], persist.find(Dayslist[2]+" A"), persist.find(Dayslist[2]+" B"),Dayslist[3], persist.find(Dayslist[3]+" A"), persist.find(Dayslist[3]+" B"),
            Dayslist[4], persist.find(Dayslist[4]+" A"), persist.find(Dayslist[4]+" B"),Dayslist[5], persist.find(Dayslist[5]+" A"), persist.find(Dayslist[5]+" B"),
            Dayslist[6], persist.find(Dayslist[6]+" A"), persist.find(Dayslist[6]+" B"),
            Monthlist[0], persist.find(Monthlist[0]+" A"), persist.find(Monthlist[0]+" B"),Monthlist[1], persist.find(Monthlist[1]+" A"), persist.find(Monthlist[1]+" B"),
            Monthlist[2], persist.find(Monthlist[2]+" A"), persist.find(Monthlist[2]+" B"),Monthlist[3], persist.find(Monthlist[3]+" A"), persist.find(Monthlist[3]+" B"),
            Monthlist[4], persist.find(Monthlist[4]+" A"), persist.find(Monthlist[4]+" B"),Monthlist[5], persist.find(Monthlist[5]+" A"), persist.find(Monthlist[5]+" B"),
            Monthlist[6], persist.find(Monthlist[6]+" A"), persist.find(Monthlist[6]+" B"),Monthlist[7], persist.find(Monthlist[7]+" A"), persist.find(Monthlist[7]+" B"),
            Monthlist[8], persist.find(Monthlist[8]+" A"), persist.find(Monthlist[8]+" B"),Monthlist[9], persist.find(Monthlist[9]+" A"), persist.find(Monthlist[9]+" B"),
            Monthlist[10], persist.find(Monthlist[10]+" A"), persist.find(Monthlist[10]+" B"),Monthlist[11], persist.find(Monthlist[11]+" A"), persist.find(Monthlist[11]+" B"),
            Yearslist[0], persist.find(Yearslist[0]+" A"), persist.find(Yearslist[0]+" B"),Yearslist[1], persist.find(Yearslist[1]+" A"), persist.find(Yearslist[1]+" B"),"g")
            var msg= msg_months
            tasmota.web_send_decimal(msg)
            tasmota.yield()
        end
            if webserver.has_arg("More_data")
                if showdata==1 showdata=2
                else if showdata!=1 showdata=1 end
                end
                print('showdata = ', showdata)
            end
    end
end

data1=UserData()

tasmota.add_driver(data1)



def handle_sensors()    #verbruik van verwarming waterbed, uitgang 2 van de R3
    tasmota.publish("Data/Energy_Waterbedden", json.dump(json.load(tasmota.read_sensors())["ENERGY"]["Total"][1]))
    tasmota.publish("Data/Energy_Waterbedden_Start", json.dump(json.load(tasmota.read_sensors())["ENERGY"]["TotalStartTime"]))
end

set_timer_every(15*60000, handle_sensors)   #every 15 minutes publish new energy total