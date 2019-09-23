# importing the requests library
import requests
import json
import sys
import boto3
import xml.dom.minidom
import xml
import argparse

def Get_Target(tag, values):
    IP_array = []

    # GET PRIVATE IPS

    ec2client = boto3.client('ec2')
    response = ec2client.describe_instances(
    Filters=[
            {
                'Name': 'tag:' + tag,
                'Values': values
            },
        ]
    )
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            # This will print will output the value of the Dictionary key 'privateIP'
            private_IP = (instance["PrivateIpAddress"])
            IP_array.append(private_IP)

    print(IP_array)
    return(IP_array)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument("--api_token", help="API token")
    parser.add_argument("--base_api_url", help="Base API URL")
    parser.add_argument("--base_report_url", help="report URL")
    parser.add_argument("--job_id", help="Jon ID")
    parser.add_argument("--ip_addresses", help="IP Addresses")

    args = parser.parse_args()

    api_token = args.api_token
    base_api_url =   args.base_api_url
    base_report_url =   args.base_report_url
    job_id =   args.job_id
    addresses = args.ip_addresses
    api_url = base_api_url + str(job_id)
    tag = 'demo'
    values = ['scantest']

    print('Addresses before format: ' + str(addresses))
    headers = {'Authorization': "SAINTAPI " + api_token}

    if addresses is None:
        ip_addresses = Get_Target(tag, values)
    else:
        ip_addresses = addresses.split()

    print ('IP addresses:' + str(ip_addresses))
    sd = requests.get(base_report_url + 'scanjob/' + str(job_id),  headers=headers)
    ids = sd.json()['scanruns']
    print(ids)
    scanrun_id = ids[0]['id']
    for item in ids:
        if item['id'] > scanrun_id:
            scanrun_id = item['id']


    params = { "target_map": {
                    "local": ip_addresses
            }
        }
    print(params)
    # Check if Scan JOB exist
    r = requests.get(api_url, headers=headers)
    # extracting response text
    print(r.status_code)
    if r.status_code != 200:
        print('ERROR!')
        exit
    else:
    #update the scanjob with retrieve IP addreses
        #requests.put(api_url, data=params,  headers=headers)

    #RUN SCAN JOB
    #     ru = requests.post(api_url + '/scanrun',  headers= headers)

    #Get Scan job status. until status code is completed
        js_url = api_url + '/scanrun/' + str(scanrun_id)
        js = requests.get(js_url, headers=headers)
        completed = False
        while completed == False:
            js = js.json()['completed']
            if js == 1:
                completed = True
    # #if status code is 200
    # # get scan job report  if jib status code = 200
        base_report_url = base_report_url + 'report?job_id=' + str(job_id) + '&scanrun_id=' + str(scanrun_id) + '&format=7&type=full_scan&title=Wonderful_SAINT_API_Report'
        print(base_report_url)
        jr = requests.get(base_report_url, headers=headers)
        rj = (jr.content)
        xmlval = xml.dom.minidom.parseString(rj)
        xml_pretty_str = xmlval.toprettyxml()
        print(xml_pretty_str)
        #print(jr.content, file=open("output.xml", "a"))
