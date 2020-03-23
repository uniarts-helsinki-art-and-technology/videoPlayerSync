# Synkronoitu videoplayer Raspberry Pi:lle

(english: see below)

Tämä on skripti, joka siirtää tiedoston USB-asemalta Raspberry Pi:n muistikortille ja käynnistää automaattisesti [omxplayer-syncin](https://github.com/turingmachine/omxplayer-sync).


# Asennus

## Asenna omxplayer-sync
[https://github.com/turingmachine/omxplayer-sync](https://github.com/turingmachine/omxplayer-sync)

## Pystytä verkko
Masterin pitää pystyä lähettämään broadcastilla käskyjä slavelle.

Helpoin tapa pystyttää verkko on kytkeä Raspberry Pi:t suoraan kaapelilla toisiinsa Ethernetin välityksellä.

Jos halutaan käyttää wifiä, on tehtävä masterille access point ja slaven on yhdistettävä siihen.
* [Access pointin luominen Raspberry Pi:llä](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md)
* [create_ap](https://github.com/oblique/create_ap): skripti access pointin pystyttämiseen

## Asenna skripti

Lataa ja mene kansioon videoPlayerSync-master

Asenna master:
	$ make master

Asenna slave:
	$ make

Poistaaksesi asennuksen:
	$ make uninstall


# Käyttö


## Videon tuottaminen

Suositeltu formaatti on:

* resoluutio: 	1920x1080 
* muoto: 	H.264 
* profiili: 	High 4.0
* frame rate: 	60 fps

Käytä esimerkiksi [Handbrake](https://handbrake.fr/)-ohjelmaa videon tuottamiseen näillä parametreilla.

Synkronoitavien videoiden tulee olla samanpituiset ja vähintään 60 s.


## Videon laittaminen Raspberry Pi:lle

1. Laita videotiedosto muistitikulle. Siellä ei pidä olla muita tiedostoja, ja tiedoston ei pidä olla kansion sisällä.
2. Liitä muistitikku Raspberry Pi:hin 
3. Käynnistä Raspberry Pi.
Video siirtyy Raspberry Pi:n muistikortille ja lähtee pyörimään.

Tämän jälkeen kun Raspberry Pi käynnistetään ilman muistitikkua, video lähtee automaattisesti pyörimään.

Laittaaksesi toisen videon toista sama menettely. Silloin aiemmin ladatut videot poistetaan.


## Käynnistys

Käynnistä ensin master ja heti perään slavet


## Lisätietoja

Jos muistitikulla on muita tiedostoja, käytetään aakkosjärjestyksessä ensimmäistä.

Jos tiedosto ei ole kelvollinen videotiedosto, se kopioidaan ja toistetaan silti. Jos toistaminen epäonnistuu, tarkista että oikea tiedosto ladattiin.

Muistitikku kannattaa varmuuden vuoksi irrottaa vasta, kun Raspberry Pi on sammutettu.

Jos videot ovat eripituisia, toisto saattaa onnistua muttei välttämättä palaudu alkuun saumattomasti slaven puolella. Video voi pysähdellä ja hyppiä.

*****************************************************************************************************

# Synchronized video player script for the Raspberry Pi

This script copies a video file from USB drive and runs [omxplayer-sync](https://github.com/turingmachine/omxplayer-sync) automatically.


# How to install

## Install omxplayer-sync
[https://github.com/turingmachine/omxplayer-sync](https://github.com/turingmachine/omxplayer-sync)

## Set up network 
The master needs to broadcast messages to the slaves

The simplest way is to connect the Raspberry Pis directly by cable via Ethernet.

If wifi is required, set up an access point on the master and connect to it on the slave.
* [How to create access point](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md)
* [create_ap](https://github.com/oblique/create_ap): a script to create the access point


## Install the script

Download and go to the videoPlayerSync-master folder

Install on master:
	$ make master

Install on slave:
	$ make slave

To remove installation:
	$ make uninstall


# How to use


## How to export a video


The recommended format is:
* Resolution:	1920x1080
* Format:		H.264
* Profile:	High 4.0
* Frame rate:	60 fps

Use, for example, [Handbrake](https://handbrake.fr/) to export video with these parameters.

The synchronized videos should have the same length. The length should be at least 60 s.


## How to load the video file to the Raspberry Pi

1. Put the file on a USB drive. There should be no other files, and it should not be inside a folder.
2. Insert the USB drive to the Raspberry Pi.
3. Turn the Raspberry Pi on. The video will be copied on the Raspberry Pi local storage, and start playing.

After this the video will play automatically when the Raspberry Pi is started with no USB drive attached. 

To load another video, repeat the same process. Any previously loaded files will be removed.


## Startup

First start the master and immediately after that start the slaves


## Additional information

If there are multiple files on the USB drive, the first file in alphanumeric order will be used.

Any file will be used whether or not it is a valid video file. If playing fails, make sure the right file was loaded.

The USB drive should be removed only after the Raspberry Pi is turned off, just to be sure.

If the videos have different lengths, they might play successfully, but fail to loop seamlessly. A lot of freezing and skipping is to be expected on the slave.

