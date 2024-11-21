# remove many of the noto variants. Keep only some.

mkdir -p /tmp/fonts/noto/

cd /usr/share/fonts/truetype/noto/
for FONT in NotoColorEmoji.ttf NotoSans-Bold.ttf NotoSansDisplay-Regular.ttf NotoSansOgham-Regular.ttf NotoSansSymbols2-Regular.ttf NotoSerif-Bold.ttf NotoMono-Regular.ttf NotoSansDisplay-BoldItalic.ttf NotoSans-Italic.ttf NotoSansOldPersian-Regular.ttf NotoSansSymbols-Bold.ttf NotoSerif-Italic.ttf NotoMusic-Regular.ttf NotoSansDisplay-Bold.ttf NotoSansMono-Bold.ttf NotoSans-Regular.ttf NotoSansSymbols-Regular.ttf NotoSerif-Regular.ttf NotoSans-BoldItalic.ttf NotoSansDisplay-Italic.ttf NotoSansMono-Regular.ttf NotoSansRunic-Regular.ttf NotoSerif-BoldItalic.ttf

do 
	cp /usr/share/fonts/truetype/noto/${FONT} /tmp/fonts/noto/
done

rm -fr /usr/share/fonts/truetype/noto/*
cp -fr /tmp/fonts/noto/* /usr/share/fonts/truetype/noto/


# remove some exotic fonts

sudo apt remove  --yes --force-yes  fonts-lohit*
sudo apt remove  --yes --force-yes  fonts-smc*
sudo apt remove  --yes --force-yes  fonts-samyak*
sudo apt remove  --yes --force-yes  fonts-nanum*
sudo apt remove  --yes --force-yes  fonts-kacst*
sudo apt remove  --yes --force-yes  fonts-teluguv*
sudo apt remove  --yes --force-yes  fonts-gujr*
sudo apt remove  --yes --force-yes  fonts-guru*
sudo apt remove  --yes --force-yes  fonts-orya*
sudo apt remove  --yes --force-yes  fonts-telu*
sudo apt remove  --yes --force-yes  fonts-beng*
sudo apt remove  --yes --force-yes  fonts-deva*
sudo apt remove  --yes --force-yes  fonts-yrsa*
sudo apt remove  --yes --force-yes  fonts-khmeros*
sudo apt remove  --yes --force-yes  fonts-thai*
sudo apt remove  --yes --force-yes  fonts-gargi*
sudo apt remove  --yes --force-yes  fonts-navilu*
sudo apt remove  --yes --force-yes  fonts-kalapi*
sudo apt remove  --yes --force-yes  fonts-lao*
sudo apt remove  --yes --force-yes  fonts-konatu*
sudo apt remove  --yes --force-yes  fonts-nakula*
sudo apt remove  --yes --force-yes  fonts-sahadeva*
sudo apt remove  --yes --force-yes  fonts-pagul*
sudo apt remove  --yes --force-yes  fonts-tlwg*
sudo apt remove  --yes --force-yes fonts-lklug*

# clean few more things
sudo apt clean 
sudo apt autoclean 
apt-get -s autoremove

# check unused packages
apt install popularity-contest -y
popularity-contest > /var/log/popularity-contest

# usage: popcon-largest-unused


apt install deborphan -y
# usage: deborphan -a


sudo apt install bleachbit

# usage: bleachbit

