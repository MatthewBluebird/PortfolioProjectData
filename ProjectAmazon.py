#importing libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime
import pandas as pd



def send_mail():
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login('***********@gmail.com', '*************')  # Use the generated app password here

    subject = "The Shirt you want is below $15! Now is your chance to buy!"
    body = "This is the moment we have been waiting for. Now is your chance to pick up the shirt of your dreams. Don't mess it up!"

    msg = f"Subject: {subject}\n\n{body}"

    server.sendmail(
        '***********@gmail.com',  # Sender's email address
        '***********@gmail.com',  # Recipient's email address
        msg  # The message
    )

    server.quit()

def check_price():
    # Connecting to Website
    URL = 'https://www.amazon.com/Analyst-Graduate-Career-Professional-Spreadsheet/dp/B0C1M17KKT/ref=sr_1_1?crid=10UL4WF7CFOQ9&dib=eyJ2IjoiMSJ9.KEhZNoiS_9aZRnvUMTy2C26JZRiMC8bzx4SJEq-8rK2VujmSGAY0mv6VRinQ94aTwxsKIXEtv2WJ9Fcsgv6ydWz21x--r19C1-bUenBc2fNOfNcmLtihP3jGKWxm4bX4R5alwjg4d-_DyebHkpWerobcnTim6qj-SOACBQpuC_jgoO1fJqwNyHHWzpuDGkZiJAIWA4BeYAMFOGApg0GbBUPiXZMsSSzCGyH2vDd-ndDmT7oURnHrI--wAlnMdoP4niX2jHaDe9-mAIm1s4yamjY9gg1v77oSeZ-kn5OrniQ.1V0m1j3kl5DRAFavZiWfv2tMhDh6xKruYLeE0CUia2M&dib_tag=se&keywords=data%2Banalyst%2Btshirt&qid=1710975868&sprefix=data%2Banalyst%2Btshirt%2Caps%2C171&sr=8-1'

    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        'Accept-Encoding': 'gzip, deflate, br, zstd',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'DNT': '1', 'Connection': 'close', 'Upgrade-Insecure-Requests': '1'}
    #Settings
    page = requests.get(URL, headers=headers)

    soup1 = BeautifulSoup(page.content, 'html.parser')
    soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

    title = soup2.find(id='productTitle').get_text()

    price1 = soup2.find(class_='a-offscreen').get_text()
    price2 = soup2.find_all(class_='a-offscreen')[1].get_text()
    price = price1.strip() + ' - ' + price2.strip()
    price = price.replace('$', '')
    title = title.strip()


    today = datetime.date.today()

    import csv
    header = ['Title', 'Price', 'Date']
    data = [title, price, today]
    # Now we are appending data to the csv
    with open(r'C:\Users\Ndersonoff\Desktop\New folder (2)\New folder\AmazonWebScraper.csv', 'a+', newline='',
              encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)

    if (price < '30'):
        send_mail()

#Checker
while(True):
    check_price()
    time.sleep(30)
    df = pd.read_csv(r'C:\Users\Ndersonoff\Desktop\New folder (2)\New folder\AmazonWebScraper.csv')
    print(df)







