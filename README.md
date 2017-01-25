# tempalert
#
# check_temp.sh:
# You will need to substitute the email address(es) in the "engineers" variable that you want to receive the emails.  I've included
# an example of what multiple email addresses looks like, or you can just use one.  
#
# Also, depending on how you set up your mail relay, you will need to change the From: address in the script
# so that your email won't be rejected due to invalid sender domain.  It's best to test the email command before
# implementing it into an automated script so you know the alerts are coming through.
#
# get_temp.py:
# I'm using a DS18B20 temperature sensor connected to a raspberry pi zero to take my readings.  You can substitute
# whatever script or program that is responsible for sampling the temperature in your situation.  Just make sure the
# output consists of an integer.  My check_temp.sh script strips off anything after the decimal point.
#
#
# Enjoy!
#
#
# Eric Steed
