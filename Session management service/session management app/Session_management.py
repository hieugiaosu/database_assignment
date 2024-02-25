import mysql.connector
from config import *
import time
from tkinter import *
from tkinter import ttk
import tkinter as tk
import bcrypt
import re
import threading
COMPUTER_ID = 1
TIME_PERIOD = '60'
TEXT_CONFIG = {
    'font':("Helvetica", 12),
    'foreground':'#739072',
    'background':'#ECE3CE',
    'anchor':'w'
}
class Computer:
    def __init__(self,pcid):
        self.connection = mysql.connector.connect(**DATABASECONFIG)
        with self.connection.cursor() as cursor:
            cursor.execute(f'SELECT checkPCID({pcid})')
            exist = cursor.fetchone()[0]
            self.connection.close()
            assert exist, "the computer id not in database"
        self.pcid = pcid
        self.session = None
        self.account = None
    def signIn(self,account,password):
        try:
            self.connection = mysql.connector.connect(**DATABASECONFIG)
            with self.connection.cursor() as cursor:
                result = cursor.callproc('signIn',args=(account,password,self.pcid,True,0))
                self.connection.commit()
                if result[3]:
                    self.session = result[4]
                    self.account = account
                    return True
                else:
                    self.connection.close()
                    return False
        except Exception as err:
            print(err)
            print('cannot connect')
            self.connection.close()
            return False
    def signOut(self):
        assert self.session is not None,'have not sign in yet'
        with self.connection.cursor() as cursor:
            cursor.callproc('signOutBySessionID',(self.session,))
            self.connection.commit()
            self.account = None
            self.session = None
            self.connection.close()
    def getPrice(self):
        try:
            with self.connection.cursor() as cursor:
                cursor.callproc('getCostByPCid',args=(self.pcid,))
                self.connection.commit()
                for result in cursor.stored_results():
                    price = result.fetchone()
                return price
        except:
            return 0
class Account:
    def __init__(self,account,password):
        self.__account = account
        self.__password = password
        self.__connection = mysql.connector.connect(**DATABASECONFIG)
        self.__sessionID =  None
        self.__pcID = None
        try:
            with self.__connection.cursor() as cursor:
                a = cursor.callproc('getUserData',args=[account,password])
                self.__connection.commit()
                for result in cursor.stored_results():
                    data = result.fetchone()
                self.__connection.close()
        except Exception as e:
            self.__connection.close()
        assert data != None,'do not have this account'
        _, _, self.__name, self.__sdt, self.__email, self.__balance,self.__level = data
    def getInfo(self):
        return {
            'name':self.__name,
            'balance':self.__balance,
            'level':self.__level,
            'email':self.__email,
            'sdt':self.__sdt
        }     
    def getBalance(self):
        return self.__balance
    def checkBalance(self):
        return self.__balance > 0
    def refetchData(self):
        try:
            self.__connection = mysql.connector.connect(**DATABASECONFIG)
            with self.__connection.cursor() as cursor:
                cursor.callproc('getUserData',args=[self.__account,self.__password])
                self.__connection.commit()
                for result in cursor.stored_results():
                    data = result.fetchone()
                self.__connection.close()
                _, _, self.__name, self.__sdt, self.__email, self.__balance,self.__level = data
        except Exception as e:
            self.__connection.close()  
    def changeInfo(self,new_password=None,new_name=None, new_email=None,new_sdt=None,new_level=None):
        if new_email == None: new_email = self.__email
        if new_password == None: new_password = self.__password
        if new_name == None: new_name = self.__name
        if new_sdt == None: new_sdt = self.__sdt
        if new_level == None: new_level = self.__level
        try:
            self.__connection = mysql.connector.connect(**DATABASECONFIG)
            with self.__connection.cursor() as cursor:
                cursor.callproc('UpdateHoiVienRecord',args=[self.__account,self.__password,new_password,new_name,new_sdt,new_email,new_level])
                self.__connection.commit()
                self.__connection.close()
                self.__password = new_password
        except Exception as e:
            print(e)
            self.__connection.close()
class App:
    def __init__(self,pcid):
        self.pc = Computer(pcid)
        self.window = Tk()
        self.window.title('Dịch vụ internet')
        self.account = None
        self.semaphore = threading.Semaphore(1)
        self.timethread = None
        self.running = True
    def __signIn(self):
        account = self.accountEntry.get()
        password = self.passwordEntry.get()
        try:
            connection = mysql.connector.connect(**DATABASECONFIG)
            with connection.cursor() as cursor:
                cursor.callproc('getPassword',args=(account,))
                connection.commit()
                for result in cursor.stored_results():
                    db_password = result.fetchone()
                if db_password == None:
                    self.signInState.config(text="Sai tài khoản/mật khẩu hoặc số dư không đủ")
                    return
                password = bcrypt.hashpw(password.encode(),db_password[0].encode()).decode()
                connection.close()
            if not self.pc.signIn(account,password):
                self.signInState.config(text="Sai tài khoản/mật khẩu hoặc số dư không đủ")
            else:
                self.account = Account(account,password)
        except:
            self.signInState.config(text="Sai tài khoản/mật khẩu hoặc số dư không đủ")
        if self.account != None:
            self.mainApp()
    def createSignInUI(self):
        self.window.geometry('400x300')
        self.signInFrame = Frame(self.window,background='#ECE3CE')
        self.signInFrame.place(relheight=1,relwidth=1)
        title = Label(self.signInFrame,text="Quán 666\nĐăng nhập tài khoản hội viên",background='#ECE3CE',font=('Helvetica', 15, 'bold'),foreground='#739072')
        account = Label(self.signInFrame,text="Username:",background='#ECE3CE',font=('Helvetica',12,'bold'),foreground='#739072')
        self.accountEntry = Entry(self.signInFrame)
        password = Label(self.signInFrame,text="Password:",background='#ECE3CE',font=('Helvetica',12,'bold'),foreground='#739072')
        self.passwordEntry = Entry(self.signInFrame,show='*')
        self.signInState = Label(self.signInFrame,text='',background='#ECE3CE',font=('Helvetica',12,'bold'),foreground='red')
        self.signInButon = Button(
            self.signInFrame,
            text='Đăng nhập',
            background='#ECE3CE',
            font=('Helvetica',12,'bold'),
            foreground='#739072',
            command=self.__signIn
            )
        title.place(relwidth=1,relheight=0.2)
        account.place(rely=0.25,relx=0.2)
        self.accountEntry.place(rely=0.25, relx=0.43, relwidth= 0.4)
        password.place(rely=0.4,relx=0.2)
        self.passwordEntry.place(rely=0.4, relx=0.43, relwidth= 0.4)
        self.signInState.place(rely=0.5,relwidth=1)
        self.signInButon.place(rely=0.6,relx=0.4)
    def timing(self):
        start_time = time.time()
        period = 1
        while self.timeSpend < self.timeEstimate and self.account is not None:
            for i in range(period):
                time.sleep(1)
                with self.semaphore:
                    if self.account is None:
                        break
            with self.semaphore:
                if self.account is None:
                    break
            self.timeSpend = time.time() - start_time
            if self.timeSpend < 60:
                period = 1
            else:
                period = 1
            self.displayMain()
        if self.timeSpend - self.timeEstimate < 0: self.signOut()
        print('timing end')
    def mainApp(self):
        self.price = self.pc.getPrice()
        self.price = self.price[1]+self.price[2]
        self.timeEstimate = self.account.getBalance()*3600/self.price
        self.timeSpend = 0
        self.createMainUIFrame()
        self.displayMain()
        self.timethread = threading.Thread(target=self.timing)
        self.timethread.start()

    def createMainUIFrame(self):
        self.window.geometry("300x400")
        self.signInFrame.place_forget()
        self.mainFrame = Frame(self.window,background='#ECE3CE')
        self.mainFrame.place(relheight=1,relwidth=1)
    def displayMain(self):
        for widget in self.mainFrame.winfo_children():
            widget.place_forget()
        with self.semaphore:
            if self.account is None: return
            self.timeEstimate = self.account.getBalance()*3600/self.price
            user_info = self.account.getInfo()
        timeBalance = self.timeEstimate - self.timeSpend
        welcome_label = Label(self.mainFrame, text=f"Chào mừng, {user_info['name']}!", font=("Helvetica", 16),anchor='w',foreground='#739072',background='#ECE3CE')
        balance_label = Label(self.mainFrame, text=f"Số dư: {int(user_info['balance']-self.timeSpend*self.price/3600)} đồng", font=("Helvetica", 12),anchor='w',foreground='#739072',background='#ECE3CE')
        level_label = Label(self.mainFrame, text=f"Level: {user_info['level']}", font=("Helvetica", 12),anchor='w',foreground='#739072',background='#ECE3CE')
        email_label = Label(self.mainFrame, text=f"Email: {user_info['email']}", font=("Helvetica", 12),anchor='w',foreground='#739072',background='#ECE3CE')
        sdt_label = Label(self.mainFrame, text=f"SĐT: {user_info['sdt']}", font=("Helvetica", 12),anchor='w',foreground='#739072',background='#ECE3CE')
        pc_label = Label(self.mainFrame, text=f"Máy: {self.pc.pcid}", font=("Helvetica", 12),anchor='w',foreground='#739072',background='#ECE3CE')
        time_left = Label(self.mainFrame, text=f"Thời gian còn lại: {int(timeBalance/60)} p:{int(60*(timeBalance/60-int(timeBalance/60)))} s", font=("Helvetica", 12),anchor='w',foreground='#739072',background='#ECE3CE')
        welcome_label.place(relwidth=1)
        level_label.place(relwidth=1,rely=0.1)
        email_label.place(relwidth=1,rely=0.2)
        sdt_label.place(relwidth=1,rely=0.3)
        pc_label.place(relwidth=1,rely=0.4)
        balance_label.place(relwidth=1,rely=0.5)
        time_left.place(relwidth=1,rely=0.6)
        # Add Sign Out button
        signout_button = Button(self.mainFrame, text="Đăng xuất", command=self.signOut)

        # Add Change Info button
        change_info_button = Button(self.mainFrame, text="Thay đổi thông tin", command=self.openChangeInfoWindow)
        change_info_button.place(rely=0.8,relx=0.3,relwidth=0.4)
        signout_button.place(rely=0.9,relx=0.3,relwidth=0.4) 
    def signOut(self):
        try:
            self.pc.signOut()
        except:
            pass
        with self.semaphore:
            self.account = None
        if self.timethread:
            self.timethread = None
        if self.running:
            self.createSignInUI()

    def openChangeInfoWindow(self):
        def changeInfo():
            name = name_entry.get()
            email = email_entry.get()
            sdt = sdt_entry.get()
            new_password = new_password_entry.get() 
            if name == '': name=None
            email_pattern = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            if not email_pattern.match(email): email=None
            if not sdt.isnumeric(): sdt=None
            if new_password == '': new_password = None
            else:
                new_password= bcrypt.hashpw(new_password.encode(),bcrypt.gensalt(rounds=12)).decode()
            self.account.changeInfo(
                new_password=new_password,
                new_name=name,
                new_email=email,
                new_sdt=sdt
            )
            self.account.refetchData()
            self.displayMain()
            change_info_window.destroy()
        change_info_window = Toplevel(self.window,background='#ECE3CE')
        change_info_window.title("Change Information")
        change_info_window.geometry('300x400')
        name_label = Label(change_info_window,text="Tên",**TEXT_CONFIG)
        name_entry = Entry(change_info_window)
        email_label = Label(change_info_window,text="email",**TEXT_CONFIG)
        email_entry = Entry(change_info_window)
        sdt_label = Label(change_info_window,text="sđt",**TEXT_CONFIG)
        sdt_entry = Entry(change_info_window)
        new_password_label = Label(change_info_window,text="Đổi mật khẩu:",**TEXT_CONFIG)
        new_password_entry = Entry(change_info_window,show='*')
        name_label.place(relx=0.05,rely=0.1,relwidth=0.4)
        name_entry.place(relx=0.4,rely=0.1,relwidth=0.45)
        email_label.place(relx=0.05,rely=0.2,relwidth=0.4)
        email_entry.place(relx=0.4,rely=0.2,relwidth=0.45)
        sdt_label.place(relx=0.05,rely=0.3,relwidth=0.4)
        sdt_entry.place(relx=0.4,rely=0.3,relwidth=0.45)
        new_password_label.place(relx=0.05,rely=0.4,relwidth=0.4)
        new_password_entry.place(relx=0.4,rely=0.4,relwidth=0.45)
        submit = Button(change_info_window,text='Đổi thông tin',command=changeInfo)
        submit.place(relx=0.3,relwidth=0.4,rely=0.7)
    def run(self):
        self.createSignInUI()
        self.window.mainloop()
        self.running = False
        self.signOut()

a = App(COMPUTER_ID)
try:
    a.run()
except: 
    a.signOut()

