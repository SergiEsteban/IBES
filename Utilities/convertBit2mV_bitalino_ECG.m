function bit2voltData=convertBit2mV_bitalino_ECG(data)
bit2voltData=1000*(data/(2^10)-0.5)*3.3/1100;