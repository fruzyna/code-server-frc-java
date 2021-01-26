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
                query[parts[0]] = parts[1]

            # determine next port
            process = subprocess.Popen(['docker', 'container', 'ls', '--format', '"{{.Ports}}"'], stdout=subprocess.PIPE)
            output, error = process.communicate()
            port_str = str(output)
            if ':' in port_str and '-' in port_str:
                ports = [ int(port[port.index(':')+1:port.index('-')]) for port in port_str.splitlines() ]
                port = max(ports) + 1
            else:
                port = MIN_PORT

            # check for correct parameters
            if port >= MIN_PORT and port <= MAX_PORT and \
                'name' in query and 'pass' in query and \
                'code' in query and query['code'] == PASSWORD:

                # launch
                subprocess.Popen(['./create-instance.sh', query['name'], query['pass'], str(port)])
                ip = socket.gethostbyname(socket.gethostname())
                url = 'http://{0}:{1}</a>'.format(ip, port)
                // use if using a reverse proxy
                // ip = 'code.mydomain.tld'
                // url = 'http://{0}/{1}</a>'.format(ip, query['name'])

                # send redirect page
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                self.wfile.write(str.encode('<meta http-equiv="refresh" content="10; URL={0}" /><h1>Redirecting to code-server in 10 seconds</h1><a href="{0}">{0}</a>'.format(url)))
                return

        return http.server.SimpleHTTPRequestHandler.do_GET(self)

# start HTTP server
Handler = ServerHandler
httpd = socketserver.TCPServer(('', PORT), Handler)
print('Serving at port: ', PORT)
httpd.serve_forever()