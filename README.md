
>[!CAUTION]
> **This repo was created in UNSW 2024 Term 3. Some of its content may be outdated. Please use at your own risk.**

# Guide: Deploying PostgreSQL on Windows™ PC

<a href="http://www.wtfpl.net/"><img
       src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-1.png"
       width="88" height="33" alt="WTFPL" /></a>
>[!IMPORTANT]
> This thread does not contain anything about the project itself. This is only about how to deploy PostgreSQL on a Windows PC. I am not violating UNSW's rules.

## 1 Introduction of WSL (Windows Subsystem for Linux)
In order to help you deploying Postgresql on your PC, I want to introduce a powerful tool named WSL (Windows Subsystem for Linux). WSL is a virtual machine platform integrated in Windows, featuring native Linux programs to be executed with windows environments. WSL can even run CUDA programs, which cannot be implemented with some VM platforms, for example, vmware worksation.

However, WSL can only be installed on Windows 11 and Windows 10 version 1903 or above. Please make sure that your windows version is up-to-date.

If you do not know what is the version of your windows, press Windows + R , enter winver and press Enter . You can check the version info in the window popped up.

## 2 Installation of WSL
Right click the Start menu button (i.e. the Windows logo button on the system tray bar), and select Terminal (终端 in Chinese versions of Windows), or Powershell in the menu popped up.

IF you cannot find Terminal or powershell in the menu, please right click the Start menu button (i.e. the Windows logo button on the system tray bar), and select Command Prompt (命令提示符 in Chinese versions of Windows) in the menu popped up, enter powershell in the black command line window, and press Enter .

Next, enter the following command in the black or blue command line window, and press Enter:

```powershell
PS> wsl --install
```
> [!TIP]
> Please don't copy the PS> symbol. It is a symbol telling you that this is a line of powershell command.

By default WSL will install Ubuntu on your computer. If you want other distributions installed, use the following command:

```powershell
PS> wsl --install -d <distro>
```
> [!TIP]
> Please note, <distro> indicates the distribution name. For example, the following command will install Debian, instead of ubuntu, on your computer:

```powershell
PS> wsl --install -d Debian
```
> [!TIP]
> If you do not understand what are those things above, please use the command right above to create a environment similar to CSE VMs. CSE VMs runs Debian.

Do not install Oracle Linux or SUSE-based linux, or you won't be able to use the instructions below. I know nothing about Oracle Linux and SUSE actually, so please do not ask me about it, haha.

You may need to grant administration access in this step. Just follow the instructions on your screen. Restart your computer when terminal asks you to do so.

When restarted, open Debian or Ubuntu in you Start menu as follow:

![image](https://github.com/user-attachments/assets/40d6b5be-a98e-4221-9c6f-7389f4110c78)

You need to create a Unix username and password for Linux.

Note, passwords are not visible when typed. Just put your password and press Enter.

As WSL can hardly be accessed without logging on to Windows, a weak password should be ok.

The following window indicates that WSL is deployed, in which you can find `username@computer:~$` .

![image](https://github.com/user-attachments/assets/4cadf611-5b87-46be-9673-afbc122d1f37)

## 3 Installation and Configuration of PostgreSQL
Run the following command in Ubuntu or Debian's shell to install PostgreSQL:

```bash
$ sudo apt update && sudo apt install postgresql -y
```
> [!TIP]
> Please don't copy the dollar symbol. It is a symbol telling you that this is a line of shell command.

When postgresql is installed, we need to start the service before it can be accessed.

```bash
$ sudo systemctl start postgresql
```

We need to create a role of you username before we can access PSQL, so remember who you are in the output:

```bash
$ whoami
```

We will mention it as <username> in the context below.

Next, execute psql in the name of the user 'postgres'.

```bash
$ sudo -u postgres psql
```
Next, execute following command inside PostgreSQL, to put your account into the table, please remember to change <username> to your Unix username, and <password> to your own password, which we will use in the ext steps:

```sql
PSQL> CREATE ROLE <username> LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD '<password>';
```
> [!TIP]
> Please don't copy the PSQL> symbol. It is a symbol telling you that this is a line of PostgresSQL command.

Next, create a database of your name:

```sql
PSQL> CREATE DATABASE <username>;
```
Then quit PostgreSQL by using following command, and you will return to your shell by doing so:

```sql
PSQL> \q
```
Now PostgreSQL is installed and configured. You can test it by using:

```sql
$ psql
```
## 4 A Usefull Script for Starting and Stopping 
We know that on CSE Database Server there are p0 and p1 commands to close and open PostgreSQL, however, we need type sudo systemctl start postgresql everytime we use WSL.

So, I write a small script which enables you to control PostgreSQL server in the similar way as on CSE Server. 

First, install curl:

```bash
$ sudo apt install curl -y
```
Then, you can use the following command to install the program pg on your computer.
```bash
$ bash <(curl -s https://raw.githubusercontent.com/1-hexene/install_pg/main/install_pg.sh)
```
You can access the pg program after using the following command, as mentioned in the shell:

```bash
$ source ~/.bashrc
```
The usage of pg is:

```bash
$ pg go # Starting PostgreSQL
```
and

```bash
$ pg stop # Stopping PostgreSQL
```
> [!TIP]
> Please don't copy the words after the symbol # , and the symbol itself. It is a symbol of comment.

### 4 and 1/2 Prepare the Database for Project 1
Make a directory for project 1

```bash
$ mkdir proj1 && cd proj1
```
Download sql files

```bash
$ curl -o proj1.sql https://webcms3.cse.unsw.edu.au/files/91d75bad7769f9851e55b492602e0d2fd3a313b2eb73104a658942b71518cd7f/attachment
$ curl -o check.sql https://webcms3.cse.unsw.edu.au/files/8785db234c69dd957242f3659bef1bd84275f262616c7f14cc69cbd188bf3b40/attachment
```
Download mymyunsw.dump, remember to replace zXXXXXXX with your own zid. Please do not forget the dot at the end, because it represents the current directory.

> [!IMPORTANT]
> THE FOLLOWING CMD LINE CONTAINS A PATH WHICH MIGHT BE DIFFRERNT FROM YOURS. PLEASE KINDLY USE THE PATH TO THE FILE OF YOUR COURSEWORK.**
```bash
$ scp zXXXXXXX@d.cse.unsw.edu.au:/home/cs9311/web/24T3/proj/mymyunsw.dump .
```

Create a database named proj1 and quit.

```bash
$ psql
PSQL> CREATE DATABASE proj1;
PSQL> \q
```
Recover the database with the dump file.

```bash
$ psql proj1 -f mymyunsw.dump
```

## 5 Connecting PostgreSQL via Visual Studio Code
VSCode is a powerful tool with its extensions. Meanwhile, we can connect to WSL using VSCode's integrated functions. This give us a efficient way of accessing PostgreSQL on WSL.

First, open VSCode on Windows, then, go to the very left bottom of the window. You will see a small blue (or some other colors) button there. like this:

![image](https://github.com/user-attachments/assets/2f4e2ab7-39ee-47d8-8bd0-26cb7a435505)


Click on this button, and select Connect to WSL (连接到WSL) in the menu popped up at the top of the window, like this:

![image](https://github.com/user-attachments/assets/95693a7e-a582-4e0a-8ecb-b91d2c6eb80d)

If you have multiple distros of WSL installed, then select Connect to WSL using Distro.

Now we have connected to our own PSQL server.

Next, go to VSCode's Extension, type 'Database Client', and install this extension.

![image](https://github.com/user-attachments/assets/c2cf20f2-df82-413c-96c7-dc4f8b7de5cb)

After installation, we can find two additional icons on VSCode's side bar. Click on this icon.

![image](https://github.com/user-attachments/assets/d59ea38d-fcda-44fa-9746-7b3d077db0b6)


Then click Create Connection, and select PostgreSQL in the window, and enter you username and password in Step 3, that is, the step when we create the user in postgres.

![image](https://github.com/user-attachments/assets/f4908d9f-9c4d-4f62-93a9-c0c1de11ac29)

Then, click + Connect. If successful, an elephant with a green dot will show on the panel on the left as follow. We can create databases, view databases, etc., via using this extension.

![image](https://github.com/user-attachments/assets/ae9daf6e-9cf8-4459-8ca3-1eb80d928f16)

If you want to access the files in WSL, you can click the Explorer(Files) icon on the side bar, and click the button Open a Folder, and select your target folder in the panel popped up.

![image](https://github.com/user-attachments/assets/9ecad7c2-6c77-409d-8e5b-28b2e676ce62)

That's all for today!

I hope you find this thread useful and have a nice flex week :)
