import socketserver, http.server, subprocess, socket

PORT = 8000
MIN_PORT = 8110
MAX_PORT = 8119
PASSWORD = [PASSWORD STRING]

class ServerHandler(http.server.SimpleHTTPRequestHandler):

    # default response
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):

        if self.path.startswith('/createInstance'):
            # process query
            queries = self.path.split('?')[1].split('&')
            query = {}
            for q in queries:
                parts = q.split('=')
                query[parts[0]] = parts[1].lower()

            # determine next port
            port_str = str(subprocess.check_output(['docker', 'container', 'ls', '--format', '{{.Ports}}', '--filter', 'name=code-server-*']))[2:-1]
            ports = [ int(port[port.index(':')+1:port.index('-')]) for port in port_str.split('\\n') if ':' in port and '-' in port ]
            if len(ports) > 0:
                port = max(ports) + 1
            else:
                port = MIN_PORT

            # determine taken names
            name_str = str(subprocess.check_output(['docker', 'container', 'ls', '--format', '{{.Names}}', '--filter', 'name=code-server-*']))[2:-1]
            names = [ name.split('-')[2] for name in name_str.split('\\n') if '-' in name ]

            # check for correct parameters
            if port >= MIN_PORT and port <= MAX_PORT:
                if 'name' in query and query['name'].isalnum() and query['name'] not in names:
                    if 'pass' in query and query['pass'].isalnum():
                        if 'code' in query and query['code'] == PASSWORD:
                            # launch
                            subprocess.Popen(['./create-instance.sh', query['name'], query['pass'], str(port)])
                            ip = socket.gethostbyname(socket.gethostname())
                            url = 'http://{0}:{1}</a>'.format(ip, port)
                            # use if using a reverse proxy
                            #ip = 'code.mydomain.tld'
                            #url = 'http://{0}/{1}</a>'.format(ip, query['name'])

                            # send redirect page
                            self.send_response(200)
                            self.send_header('Content-type', 'text/html')
                            self.end_headers()
                            self.wfile.write(str.encode('<meta http-equiv="refresh" content="10; URL={0}" /><h1>Redirecting to code-server in 10 seconds</h1><a href="{0}">{0}</a>'.format(url)))
                            return
                        else:
                            self.send_response(200)
                            self.send_header('Content-type', 'text/html')
                            self.end_headers()
                            self.wfile.write(str.encode('<h1>Invalid access code</h1>'))
                            return
                    else:
                        self.send_response(200)
                        self.send_header('Content-type', 'text/html')
                        self.end_headers()
                        self.wfile.write(str.encode('<h1>Invalid password</h1>'))
                        return
                else:
                    self.send_response(200)
                    self.send_header('Content-type', 'text/html')
                    self.end_headers()
                    self.wfile.write(str.encode('<h1>Invalid name</h1>'))
                    return
            else:
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                self.wfile.write(str.encode('<h1>Error assigning port</h1>'))
                return

        return http.server.SimpleHTTPRequestHandler.do_GET(self)

# start HTTP server
Handler = ServerHandler
httpd = socketserver.TCPServer(('', PORT), Handler)
print('Serving at port: ', PORT)
httpd.serve_forever()