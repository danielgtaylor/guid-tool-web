import base64
import cgi
import jinja2
import json
import uuid
import webapp2

from os.path import dirname, join

# Location of template files
TEMPLATE_PATH = join(dirname(__file__), 'templates')

# Setup the Jinja2 template environment
JINJA_ENV = jinja2.Environment(**{
    'loader': jinja2.FileSystemLoader(TEMPLATE_PATH)
})


class BaseHandler(webapp2.RequestHandler):
    def render(self, template, params=None):
        if params is None:
            params = {}

        t = JINJA_ENV.get_template(template)
        self.response.out.write(t.render(params))

    def render_json(self, value=None):
        self.response.headers['Content-Type'] = 'application/json'
        self.response.out.write(json.dumps(value))


class IndexHandler(BaseHandler):
    def get(self):
        self.render('index.html')


class GenerateHandler(BaseHandler):
    def post(self):
        # Enable CORS
        self.response.headers["Access-Control-Allow-Origin"] = "*"

        # Generate a UUID and return it
        self.render_json({
            'status': 'success',
            'guid': str(uuid.uuid4())
        })


class QueryHandler(BaseHandler):
    def post(self):
        # Enable CORS
        self.response.headers["Access-Control-Allow-Origin"] = "*"

        # Get and convert GUID input
        query = cgi.escape(self.request.get('guid'))

        status = 'success'
        try:
            if query.isdigit():
                guid = uuid.UUID(int=int(query))
            elif len(query) == 24:
                guid = uuid.UUID(bytes_le=base64.b64decode(query))
            else:
                guid = uuid.UUID(query)
        except:
            status = 'error'

        if status == 'success':
            response = {
                'status': status,
                'hex': str(guid),
                'int': str(guid.int),
                'b64': base64.b64encode(guid.bytes_le)
            }
        else:
            response = {
                'status': status
            }

        self.render_json(response)


urls = [
    ('/new', GenerateHandler),
    ('/query', QueryHandler),
    ('/', IndexHandler)
]

app = webapp2.WSGIApplication(urls)
