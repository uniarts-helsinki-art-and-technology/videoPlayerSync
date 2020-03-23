asennuspolku = ~/Desktop/
configpolku = ~/.config/autostart/

src = playVideo_sync.sh
config_master = syncplayer-master.desktop
config_slave = syncplayer-slave.desktop

autostartpolku = /home/pi/.config/lxsession/LXDE-pi/autostart

master:
	rm -f $(configpolku)/$(config_slave)
	cp config/$(config_master) $(configpolku)
	cp src/$(src) $(asennuspolku)
	chmod +x $(asennuspolku)/$(src)

slave:
	rm -f $(configpolku)/$(config_master)
	cp config/$(config_slave) $(configpolku)
	cp src/$(src) $(asennuspolku)
	chmod +x $(asennuspolku)/$(src)

all:
	slave

uninstall:
	rm -f $(configpolku)/$(config_master)
	rm -f $(configpolku)/$(config_slave)
	rm -f $(asennuspolku)/$(src)
	
