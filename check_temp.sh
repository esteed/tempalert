#!/bin/bash

threshold=80
alert_file=/tmp/temp_alert_status
alert_status=`cat $alert_file`
current_temp=`/usr/local/bin/get_temp.py | head -1 | awk -F. '{print $1}'`
engineers="esteed@collier-it.com,fdaniels@collier-it.com,bprigge@collier-it.com,bbream@collier-it.com,mfowler@collier-it.com"
#engineers="esteed@collier-it.com,esteed@comcast.net"
subj_alert="HQ Server Room: Current temperature [$current_temp] is greater than threshold [$threshold].  Investigate immediately!"
subj_norm="HQ Server Room: Current temperature [$current_temp] is now lower than threshold [$threshold].  All Clear."
msg_file=/tmp/email_message.txt

#echo "Current Temp [$current_temp]"
#echo "Alert status [$alert_status]"
#echo "Threshold [$threshold]"

function send_mail(){
        ##
        ## Clear out the message file first
        ##
        > $msg_file

        ##
        ## Create the email message that we're going to pass to ssmtp.  $1 is the Subject line.
        ##
        echo "To: ${engineers}" >> $msg_file
        echo "From: esteed@comcast.net" >> $msg_file
        echo "Subject: $1" >> $msg_file
        echo " " >> $msg_file

        ##
        ## Send the email
        ##
        /usr/sbin/ssmtp $engineers < $msg_file
}

if [ $current_temp -gt $threshold ]
then
        if [ $alert_status -eq 0 ]
        then
                ##
                ## The current temperature is above the threshold for the first time.  Set the alert flag and
                ## notify via email.
                ##
                echo "Current temperature [$current_temp] is greater than threshold [$threshold].  Setting alert state."
                echo 1 > $alert_file
                send_mail "$subj_alert"
                exit
        else
                ##
                ## The current temperature is still above the threshold. Continue to monitor but do not
                ## notify via email.
                ##
                echo "Current temperature [$current_temp] is still greater than threshold [$threshold]."
                exit
        fi
else
        if [ $alert_status -eq 1 ]
        then
                ##
                ## The current temperature is below the threshold and the alert state was set.  Revert to non
                ## alert state and notify via email.
                ##
                echo "Temperature [$current_temp] is now below the threshold of [$threshold].  Resetting alert state."
                echo 0 > $alert_file
                send_mail "$subj_norm"
                exit
        fi
        ##
        ## If we got here, the temperature is below the threshold and the alert status was not set so don't do anything.
        ##
fi
