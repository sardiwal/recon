import smtplib
import sys
from os.path import isfile, exists
from datetime import datetime
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email import encoders


def send_alert_mail(msg,subject,file_paths):
        To = ['mukeshsardiwal1@gmail.com,anand@appsecure.in,manishasangwan47@gmail.com'] #update alerting emails here

        Username = "mukeshsardiwal1"
        Password = "manisha@123"
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(Username, Password)

        date = str(datetime.now()).split('.')[0]

#        Username = "Security News Updates<security-news@flipkart.com>" #update source email id here

        mssg = MIMEMultipart('alternative')
        mssg['Subject'] = subject + " - " + date
        mssg['From'] = Username
        mssg['To'] = ", ".join(To)

        for filename in file_paths:
                if(exists(filename)):
                        attachment = open(filename, "rb")
                        part = MIMEBase('application', 'octet-stream')
                        part.set_payload((attachment).read())
                        encoders.encode_base64(part)
                        part.add_header('Content-Disposition', "attachment; filename= %s" % filename)
                        mssg.attach(part)
 

        html = MIMEText(msg,'html')

        mssg.attach(html)
        try:
                sent = server.sendmail(Username, To, mssg.as_string())
                server.quit()
                print '[@] Alert mail sent'
                return True
        except Exception as ae:
                print ae
                print '[@] Alert mail failed to send'
                return False

subdomain_name = sys.argv[1]
port_file = sys.argv[2]
dir_file = sys.argv[3]
subject = sys.argv[5]
nikto_file = sys.argv4[]

send_alert_mail('message body',subject,[nikto_file,subdomain_name,port_file,dir_file])
