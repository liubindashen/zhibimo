# install gitbook and noto-cjk


```
npm install -g gitbook-cli
apt-get install xvfb calibre
wget http://www.google.com/get/noto/pkgs/NotoSansCJKSC-hinted.zip
unzip NotoSansCJKSC-hinted.zip
mv NotoSansCJK* /home/app/.fonts/
fc-cache -fv
fc-list | grep -i noto # to make sure the fonts installed correctly
```

# start sidekiq with user app

```
bundle exec sidekiq -q building,1 -q default,5 -e production -L log/sidekiq.log -d
```
