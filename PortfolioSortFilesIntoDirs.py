import os, shutil
path = r"C:/Users/Ndersonoff/Desktop/Python project1/"
file_name = os.listdir(path)

folder_names = ['csv_files', 'image_files', 'text_files']


for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
           os.makedirs((path + folder_names[loop]))

for file in file_name:
    if ".csv" in file and not os.path.exists(path + "csv_files/" + file):
        shutil.move(path + file, path + "csv_files/" + file)
    elif ".txt" in file and not os.path.exists(path + "text_files/" + file):
        shutil.move(path + file, path + "text_files/" + file)
    elif ".jpg" in file and not os.path.exists(path + "image_files/" + file):
        shutil.move(path + file, path + "image_files/" + file)

#os.listdir(path)
