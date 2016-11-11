Testing Methodology
---
1. PSA Bandwidth Control Image at: https://vm-images.secured-fp7.eu/images/priv/PSA-bwcontrol.img

2. Login credentials:
    * username: root
    * password: secured
3. Use the NED local files to enable support of the bwcon user that uses the PSA Bandwidth Control. The [default configuration](NED_files/psaConfigs/bwcontrol/bwcontrol) has the following default rate settings:
   * download rate: 500KB/s
   * upload rate: 250KB/s
   * upload burst: 15K
   * upload latency: 25ms
   * download burst: 15K
   * download latency: 25ms
   * You can change the rate limit values (and appropriately chnage burst and latency as specifid in the configuration file) each time before logging in to test different rate limits. Also you can use the tbf.sh script inside the PSA after logging in to interactively set a new limit and test it without having to
     logout and log-in again. This is described in step 5.

4. After logging in to the NED using the bwcon account you can test that the limits you specified have taken effect:
    * speedetest.com: perform a speedtest to assess whether the download/upload rate is as specified
    * You can try and download large ISO files:
        - http://releases.ubuntu.com/14.04/ubuntu-14.04.3-desktop-amd64.iso
        - http://releases.ubuntu.com/15.10/ubuntu-15.10-desktop-amd64.iso
    * try to SCP an image file to test upload or download rate without having interfence from traffic on the Internet 
    * use iperf without having interfence from traffic on the Internet 
5. If you want to interactively test different rate limits without having to log-out, change the psaconf and then log-in again:
    * After logging-in navigate to /home/tests inside the PSA. 
    * [tbf.sh](tests/tbf.sh): you can use this script to change the rate of a specific interface. To apply a new limit:
        - For download: bash [tbf.sh](tests/tbf.sh) eth0 \[rate\] \[burst\] \[latency\] i.e. bash [tbf.sh](tests/tbf.sh) eth0 500kbps 15K 25ms
        - For upload: bash [tbf.sh](tests/tbf.sh) eth1 \[rate\] \[burst\] \[latency\] i.e. bash [tbf.sh](tests/tbf.sh) eth1 100kbps 15K 25ms
        - The rate should be in thr form of: \[rate\]\[order of rate\] with no spaces i.e. 1mbps for 1 MB/s. tc uses the following notations for order of rate:
            * kbps -> KB/s
            * mbps -> MB/s
            * kbit -> Kb/s
            * mbit -> Mb/s
        - from our tests the following should be used for burst and latency:
            * if rate is less than 2MB/s then burst=15K else burst=30K
            * if rate is less than 2MB/s then latency=25ms else latency=30ms
6. After applying a limit using tbf.sh you can repeat step 4 and test the results. You can change rate by re-executing the script, no need to logout and login, change in rate is interactive.
7. You can monitor the queue by using the show\_limits.sh: bash [show_limits.sh](tests/show_limits.sh) \[interface\] i.e. bash [show_limits.sh](tests/show_limits.sh) eth0
8. If you simply want to clear the limit without applying a new one: bash [clear_limits.sh](tests/clear_limits.sh) \[interface\] i.e. bash [clear_limits.sh](tests/clear_limits.sh) eth0. This way you can get back full rate on the interface.
