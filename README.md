# webcheck

Adding some notes like 'run it with ./webcheck &'

installed msmtp and mailutils
sudo nano /etc/msmtprc

echo 'message' | mail -s "raspi-buster" r---@gmail.com
echo 'your message' | msmtp r---@yahoo.co.uk

took some influence from
https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity
