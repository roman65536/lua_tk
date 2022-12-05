require "lxit"


function write_file(filename,data) 
file=io.open(filename,"a+")

file:write(data .. "\n")
file:flush()
file:close()
end


function sleep(n)
  os.execute("sleep ".. n)
  end






-- Describe this function...
function meassure()
  for volt = 1, 24, 0.2 do
    scpi(con2psu , "INST OUT1")
    scpi(con2psu,string.format( "VOLT %.3f\n",volt))
    sleep(.2)
    scpi(con2psu , "INST OUT2")
    write_file('/tmp/relay.txt',(table.concat({volt, ' ; ', tonumber(scpi(con2psu, "MEAS:VOLT?"))
    })))
  end
  for volt = 24, 1, -0.2 do
    scpi(con2psu , "INST OUT1")
    scpi(con2psu,string.format( "VOLT %.3f\n",volt))
    sleep(.2)
    scpi(con2psu , "INST OUT2")
    write_file('/tmp/relay.txt',(table.concat({volt, ' ; ', tonumber(scpi(con2psu, "MEAS:VOLT?"))
    })))
  end
end



con2psu = connectl('192.168.2.3' ,5025,"ints0",2000,"RAW" )

scpi(con2psu , "INST OUT2")
scpi(con2psu,string.format( "VOLT %.3f\n",1))
sleep(.2)
scpi(con2psu,string.format( "CURR %.3f\n",0.01))
sleep(.2)
scpi(con2psu , "INST OUT1")
scpi(con2psu, "OUTP:SEL ON")
scpi(con2psu , "INST OUT2")
scpi(con2psu,string.format( "CURR %.3f\n",0.01))
sleep(.2)
scpi(con2psu , "INST OUT1")
scpi(con2psu, "OUTP:SEL ON")
scpi(con2psu ,  "OUTP:GEN ON")
meassure()
