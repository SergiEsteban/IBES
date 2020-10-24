import os
import csv

dir = os.path.dirname(os.path.abspath(__file__))

for filename in os.listdir(dir):
    if filename.endswith(".csv"):
        with open(filename, newline='') as csvfile:
            print(filename)
            reader = csv.reader(csvfile,delimiter=',')
            data = []
            for row in reader:
                data = data+row                
        with open(filename,'w',newline='') as csvfile:
            writer = csv.writer(csvfile,delimiter=';')
            for row in data:
                writer.writerow([row])


