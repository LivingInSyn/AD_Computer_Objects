#relevant imports
import web
import logging
import datetime
import subprocess

#create the logfile
logging.basicConfig(filename='web_add.log',format='%(asctime)s %(levelname)s:%(message)s',level=logging.INFO)
logging.info("Starting the server at "+str(datetime.datetime.now()))


#render = web.template.render('/templates/')
render = web.template.render("./templates/")

#define the handled URL's
#this will make the slash to a class named index
urls = (
	'/', 'index',
        '/add', 'add'
)

#This is the index "page" (class) and defines what we'll do when we receive a GET from a browswer
class index:
	def GET(self):
                i = web.input(name=None)
                return render.index(i.name)

class add:
        def POST(self):
		#values are computer, user and password and enabled (en_type)
                #en_type returnes $true or $false
                i = web.input()
                #because the html parser uses $ for variables like powershell, we need to transform the enabled values into strings for powershell
                if(i.en_type=="en"):
                        en_bool = "$true"
                else:
                        en_bool = "$false"
                #check all the strings for bad chars
                if(not check_comp(i.computer) and not check_password(i.password) and not check_name(i.password)):
                        #you may need to change the path here for the location of add_computers.ps1
                        subprocess.call(["powershell","c:\\web_AD\\add_computer.ps1","-name",i.computer,"-user",i.user,"-pass",i.password,"-enable",en_bool])
                        logging.info("Computer named "+i.computer+" added by "+i.user)
                else:
                        #add error reporting here
                        print "bad characters"
                        logging.warning("Bad characters input by "+i.user)
                #Right now, bring us back to home without any other output
                raise web.seeother('/')

def check_comp(to_check):
        badchars = "\/:*?<>\"<>|"
        #check against a blacklist. If there are any not allowed chars, return True
        return any(c in to_check for c in badchars)
def check_password(to_check):
        #check against a whitelist, if there are any not allowed chars, return True
        goodchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890+-_=.@?"
        for c in to_check:
                if(c not in goodchars):
                        return True
                else:
                        return False
def check_name(to_check):
        #check against a whitelist, if there are any not allowed chars, return True
        goodchars = "abcdefghijklmnopqrstuvwxyz123456789"
        for c in to_check:
                if(c not in goodchars):
                        return True
                else:
                        return False
        

if __name__ == "__main__":
        app = web.application(urls, globals())
        app.run()
