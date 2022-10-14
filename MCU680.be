ser = serial(21, 22, 9600, serial.SERIAL_8N1)   #RX=21, TX=22

def init_MCU680()
    ser.write(bytes("A5553F39"))
end
tasmota.set_timer(500, init_MCU680)

def set_oneshot()
    ser.write(bytes("A55601FC"))
end
tasmota.set_timer(1000, init_MCU680)
tasmota.set_timer(2000, ser.flush())



#msg = ser.read()   # read bytes from serial as bytes
#print(msg)   # print the message as string
#ser.flush()              #empty ser buffer
#ser.available()         #available in ser buffermust be 20 bytes
#msg = ser.read()        #read bytes from ser into msg
#print(msg[0])          #0 .. 19

if ser.available() == 20
    import string
    var msg=ser.read()
    if msg[0]==90 && msg[1]==90     #(90=h5A) -> OK, this is start of bytes needed
        temp=((msg[4]<<8|msg[5]))/100.0      #temp must be float (real) ->100.0
        print(temp)
        hum=((msg[6]<<8|msg[7]))/100.0
        print(hum)
        press=((msg[8]<<16)|(msg[9]<<8)|msg[10])/100.0
        print(press)
        IAQ_acc= (msg[11]&0xf0)>>4
        print(IAQ_acc)
        IAQ=((msg[11]&0x0F)<<8)|msg[12];
        print(IAQ)
        gas=(msg[13]<<24)|(msg[14]<<16)|(msg[15]<<8)|msg[16]
        print(gas)
        alt=(msg[17]<<8)|msg[18]
        print(alt)
    else
        #try again
    end
end



SDS0X1=string.split(string.split(string.split(string.split(tasmota.read_sensors(), "SDS0X1")[1], "}")[0], "{")[1], ",")
SDS0X125=string.split(SDS0X1[0], ":")[1]
SDS0X110=string.split(SDS0X1[1], ":")[1]


u = udp()
u.begin("", 2000)    # listen on all interfaces, port 2000
u.send("192.168.2.220", 2000, bytes("414243"))
var sens=u.read().asstring
print(sens)


def read_remote_sensors()
    var uread= u.read()
    if size(uread)>0 
        var sensor1=string.split(uread.asstring(), ", ")
        for i:0..6
            sens_val_in[i+1]=number(sensor1[i])
        end
    end
end


#Send a message to remote sensors so it knows where to find us
var u = udp()
tasmota.yield()
u.begin("", 2000)    # listen on all interfaces, port 2000
tasmota.yield()
u.send("192.168.2.220", 2000, bytes("414243"))