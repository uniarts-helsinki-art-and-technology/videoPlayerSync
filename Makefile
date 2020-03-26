asennuspolku = ~/Desktop/
configpolku = ~/.config/autostart/

src = playVideo_sync.sh
config_master = syncplayer-master.desktop
config_slave = syncplayer-slave.desktop

omxplayer_sync_polku = /usr/bin/omxplayer-sync
omxplayer_sync_src = https://github.com/turingmachine/omxplayer-sync/raw/master/omxplayer-sync

autostartpolku = /home/pi/.config/lxsession/LXDE-pi/autostart

all:
	slave

omxplayer_sync:
	wget -O $(omxplayer_sync_polku) $(omxplayer_sync_src)
	chmod 0755 $(omxplayer_sync_polku)

master: omxplayer_sync
	rm -f $(configpolku)/$(config_slave)
	cp config/$(config_master) $(configpolku)
	cp src/$(src) $(asennuspolku)
	chmod +x $(asennuspolku)/$(src)

slave: omxplayer_sync
	rm -f $(configpolku)/$(config_master)
	cp config/$(config_slave) $(configpolku)
	cp src/$(src) $(asennuspolku)
	chmod +x $(asennuspolku)/$(src)


uninstall:
	rm -f $(configpolku)/$(config_master)
	rm -f $(configpolku)/$(config_slave)
	rm -f $(asennuspolku)/$(src)
	rm -f $(omxplayer_sync_polku)
	
