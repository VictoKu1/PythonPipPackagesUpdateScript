import os
import sys
import fileinput
def change(file_name, string1, string2):
    with open(file_name,'r') as file:
        filedata = file.read()
    filedata = filedata.replace(string1, string2)
    with open(file_name, 'w') as file:
        file.write(filedata)





if __name__ == '__main__':
    change(sys.argv[1], sys.argv[2], sys.argv[3])