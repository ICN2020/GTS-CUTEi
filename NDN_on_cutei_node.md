# Installation of NDN on cutei nodes (ubuntu 14.04)

1) configure and build NDN softwares (at least ndn-cxx and NFD, ndn-tools also recommended)
```
./waf configure
./waf 
```

2) install in specific folder
```
./waf install --destdir=/home/gts/ndn_0.6.1_pack
```

3) create tar.gz file
```
cd /home/gts/ndn_0.6.1_pack
tar -zcvf ndn_0.6.1_pack.tar.gz *
```

4) create deb package
```
sudo alien -k ndn_0.6.1_pack.tar.gz
```

5) install with dpkg
```
sudo dpkg -i ndn-0.6.1-pack_1-1_all.deb
```

