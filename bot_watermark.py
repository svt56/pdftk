#!/usr/bin/python
import os
import telebot
import subprocess
# read allowed users ID's from list.txt
with open('list.txt', 'r') as f:
    allowed_users = f.read().splitlines()
# Variable contains the path to the file
path = "token.tk"
# The file is read and its data is stored
API_TOKEN = open(path, 'r').read()
# Replacing all occurrences of newline in data with ''
API_TOKEN = API_TOKEN.replace('\n', '')
# start bot
bot = telebot.TeleBot(API_TOKEN)
# user function
def answer(a,b):
    bot.send_message(b, a)
    return '222222'
## primeri
#        bot.reply_to(message, answer())
#       bot.send_message(message.chat.id, para[1])
## hendlers
# hendler start
@bot.message_handler(commands=['start'])
def start(message):
    if str(message.from_user.id) not in allowed_users:
        bot.reply_to(message, "Извините, вы не можете использовать этот бот.")
        return
    bot.send_message(message.chat.id, 'hi, send mi pdf')
#hendler resive document
@bot.message_handler(content_types=['document'])
def addfile(message):
    if str(message.from_user.id) not in allowed_users:
        bot.reply_to(message, "Извините, вы не можете использовать этот бот.")
        return
    file_name = message.document.file_name
    file_info = bot.get_file(message.document.file_id)
    downloaded_file = bot.download_file(file_info.file_path)
    with open(file_name, 'wb') as new_file:
        new_file.write(downloaded_file)
    params = message.caption
    if not params:
       bot.reply_to(message, "Параметр пустой")
       return
    para = params.split(' ')
    if len(para) == 2:
        # Запуск bash скрипта
        itogo = subprocess.run(['bash', 'jpg-pdf-water.sh', file_name, para[0], para[1]], check=True)
        # send pdf from output
        pdf = open('output/_cat_' + file_name, 'rb')
        bot.send_document(message.chat.id, pdf)
        # send jpg from jpg
        all_files_in_directory = os.listdir('jpg/') # list file from dir
        for i in all_files_in_directory:
           jpg = open('jpg/' + i, 'rb') #open file I
           bot.send_photo(message.chat.id, jpg) # send filt
        return
    if len(para) == 1:
        # Запуск bash скрипта
        subprocess.run(['bash', 'jpg-pdf-water.sh', file_name, para[0]], check=True)
        # send pdf from output
        pdf = open('output/_' + file_name, 'rb')
        bot.send_document(message.chat.id, pdf)
        # send jpg from jpg
        all_files_in_directory = os.listdir('jpg/') # list file from dir
        for i in all_files_in_directory:
           jpg = open('jpg/' + i, 'rb') #open file I
           bot.send_photo(message.chat.id, jpg) # send filt
        return

bot.infinity_polling(none_stop=True)
