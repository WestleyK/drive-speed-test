## What is drive-speed-test:

`drive-speed-test.sh` test the read and write speed of your external drive through the Terminal. <br>
this is designed and tested on raspberry pi. <br>

<br>


## How to use:


#### Download and install:

Download if you did not already: <br>
`pi@raspberrypi:~ $ git clone https://github.com/WestleyK/drive-speed-test.git`<br>


Then put the `drive-speed-test-vX.X.sh` in your home directory, or whatever you want: <br>
`pi@raspberrypi:~ $ cp -i drive-speed-test/drive-speed-test-vX.X.sh ~/`<br>
<br>

#### How to test drives:

To run it, just do: <br>
`pi@raspberrypi:~ $ ./drive-speed-test-vX.X.sh`<br>
<br>

Then type the number that correspond with the drive you want to test.<br>
For example, you want to test `/dev/sda1`, then type `1`.<br>
Likewise, if you want to test `/dev/sdb1`, then type `2`.<br>

```
pi@raspberrypi:~ $ ./drive-speed-test-vX.X.sh 



1:/dev/sda1  *     8064 30277631 30269568 14.4G  c W95 FAT32 (LBA)
2:/dev/sdb1           2 126353407 126353406 60.3G  b W95 FAT32

what drive would you like to speed test?
```



